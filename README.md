# Blurster

Blurster is an iOS app for blurring the background in portrait images using DeepLabV3 – 
image segmentation model from CoreML. Below you can see a demonstration 
of the app.
![Demo](/media/demo.gif)

Here is an example of how the PyTorch DeepLabV3 model with a ResNet-101 
backbone works with an image when it's pre-resized to 1024-by-2014 pixels.
![Image before and after blur](/media/diff.jpg)
