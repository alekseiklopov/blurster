# Blurster

> "Learning is an active process. We learn by doing. ... Only knowledge 
> that is used sticks in your mind." – Dale Carnegie.

**Blurster** is an iOS app for blurring the background in portrait images. 

## SwiftUI

This app uses DeepLabV3 – a pretrained image segmentation model from CoreML. 
Below you can see a demonstration of the app.

<img src="/media/demo.gif" width="250"/>

All iOS code is [here](https://github.com/alekseiklopov/blurster/tree/main/Blurster).

## PyTorch

Here is an example of how the PyTorch DeepLabV3 model with a ResNet-101 
backbone works with an image when it's pre-resized to the same size as 
CoreML model (513-by-513 pixels).

<img src="/media/demo_unite_pytorch.jpg" width="800"/>

All Python code is [here](https://github.com/alekseiklopov/blurster/tree/main/research).

### Installation
```bash
pip install -r requirements.txt
```

### Usage
```bash
# Convert data/1.jpg to data/2.jpg with a segmentation mask 513x513
python main.py data/1.jpg data/2.jpg -s 513
```
