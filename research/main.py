"""
This script allows you to blur the background of an image where a
person is present. It uses pretrained DeepLabV3 model with a ResNet-101
backbone.
"""

import torch
from PIL import Image
from torchvision import transforms
import numpy as np
import cv2
import argparse


def load_model():
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = torch.hub.load('pytorch/vision:v0.6.0', 'deeplabv3_resnet101',
                           pretrained=True)
    model.to(device).eval()
    return model


def predict(model, input_image):
    preprocess = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225])
    ])
    input_tensor = preprocess(input_image)
    input_batch = input_tensor.unsqueeze(0)
    if torch.cuda.is_available():
        input_batch = input_batch.to('cuda')
        model.to('cuda')
    with torch.no_grad():
        output = model(input_batch)['out'][0]
    return output.argmax(0)


def blur(image, output_prediction):
    w, h = image.size
    max_size = max(w, h)
    blurred_image = np.array(image.copy())
    ksize = 49
    mask = output_prediction.numpy() != 15
    # (True for background pixels, False for person class)
    mask = np.repeat(mask[:, :, np.newaxis], 3, axis=2).astype(int)
    mask = cv2.resize(mask, (max_size, max_size),
                      interpolation=cv2.INTER_NEAREST)
    mask = np.array(mask)[:h, :w, :].astype(bool)
    background_blurred = cv2.GaussianBlur(blurred_image, (ksize, ksize), 0)
    blurred_image[mask] = background_blurred[mask]
    return Image.fromarray(blurred_image)


def square(image, new_size, fill_color=(0, 0, 0, 0)):
    w, h = image.size
    max_size = max(w, h)
    squared_image = Image.new('RGB', (max_size, max_size), fill_color)
    squared_image.paste(image, (0, 0))
    squared_image = squared_image.resize((new_size, new_size))
    return squared_image


def show_difference(image1, image2):
    Image.fromarray(np.hstack((np.array(image1), np.array(image2)))).show()


def process(from_dir, to_dir, process_size):
    input_image = Image.open(from_dir)
    w, h = input_image.size
    print(f"input image size: {input_image.size}")
    squared_image = square(input_image, min(process_size, w, h))
    print(f"squared image size: {squared_image.size}")
    model = load_model()
    output_predictions = predict(model, squared_image)
    blurred_image = blur(input_image, output_predictions)
    blurred_image.save(to_dir)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("from_dir", help="The directory of the input file.",
                        type=str)
    parser.add_argument("to_dir", help="The directory of the output file.",
                        type=str)
    parser.add_argument("-s", "--size", help="Maximum image size to process.",
                        type=int, default=512)
    args = parser.parse_args()
    process(args.from_dir, args.to_dir, args.size)


if __name__ == "__main__":
    main()
