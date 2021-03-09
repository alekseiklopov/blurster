import torch
from torchvision.transforms import transforms


def resnet101():
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


def save_model(model, model_dir):
    scriptedm = torch.jit.script(model)
    torch.jit.save(scriptedm, model_dir)


def main():
    model = resnet101()
    save_model(model, "models/deeplabv3_resnet101_scripted.pt")


if __name__ == "__main__":
    main()
