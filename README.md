# Blurster

Blurster is an iOS app for blurring the background in portrait images using DeepLabV3 – 
image segmentation model from CoreML. Below you can see a demonstration 
of the app.

<img src="/media/demo.gif" width="250"/>

Here is an example of how the PyTorch DeepLabV3 model with a ResNet-101 
backbone works with an image when it's pre-resized to 1024-by-1024 pixels.

<img src="/media/diff.jpg" width="800"/>

As you can see, there is a better result in the second case, since we used a higher
image resolution: 1024x1024 instead of 513x513. We can improve the performance by 
using a larger input array.
