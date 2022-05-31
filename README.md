# UALL-E

<img src="https://raw.githubusercontent.com/josepmdc/UALL-E/main/img/design.png" align="right" width="500" alt="header pic"/>

# Table of Contents
   * [What is this?](#what-is-this)
   * [Requirements](#requirements)
   * [Electronic components](#electronic-components)
   * [Hardware schematics](#hardware-schematics)
   * [Software Architecture](#software-architecture)
   * [3D printed and laser cut parts](#3d-printed-and-laser-cut-parts)
   * [Amazing contributions](#amazing-contributions)
   * [Video Demo](#video-demo)
   * [Authors](#authors)

# What is this?

This is a robot that integrates computer vision, autonomous movement, 
neural networks and a hardware object lifting module to achieve its goal. 
This robot will start at a point on the beach, for example, and will start 
moving autonomously through it searching for trash objects, that will be 
determined by the neural network; picking them up with a lifting shovel 
and dropping them in an integrated trash can for them to be accumulated. 
In order to filter the sand that gets into the shovel when the robot picks 
up an item, both the shovel and the trash can will have holes to let the 
sand out.

# Requirements

Python 3 with the following libraries need to be installed in order to run the project:

- [NumPy](https://numpy.org/)
 
- [OpenCV](https://opencv.org/)
 
- [Adafruit Servokit](https://github.com/adafruit/Adafruit_CircuitPython_ServoKit)

- [DRV8835 motor driver](https://github.com/pololu/drv8835-motor-driver-rpi)
 
- [pandas](https://pandas.pydata.org/)

- [Pytorch](https://pytorch.org/)



# How to use
1. Clone this repo 
> git clone https://github.com/josepmdc/UALL-E.git
2. Install requirements
> pip install -r requirements.txt
3. Execute main.py
> python src/main.py

# Electronic components

This is the list of the used components:
- DC Motor x2
- DC Motor Controller
- Servo Motor x2
- Servo Controller
- Raspberry Pi 4
- Webcam
- Battery holder 6V
- Powerbank

# Hardware schematics
![circuit](https://raw.githubusercontent.com/josepmdc/UALL-E/main/img/circuit.png)

# Software Architecture
![Software](https://raw.githubusercontent.com/josepmdc/UALL-E/main/img/software.png)

- **Trash recognition**: the module that integrates computer vision and neural networks to detect trash objects in the environment. We trained two different models using two different algorithms. 
    - **Mask R-CNN**: Uses a convolutional neural network in order to detect objects. It gives 
                      object detection, classification and segmentation. It’s the state of the 
                      art when it comes to objective detection and classification, but it is 
                      resource heavy, and considering we are using a raspberry pi, it was laggy.

    - **Yolo v5**: It’s a simpler model and thus a little lighter on resources than Mask R-
                   CNN. On the other hand, it offers worse detection and it mis- classifies 
                   objects sometimes. This is the model we ended up using because, 
                   unfortunately our resources are limited and the Mask R-CNN was a bit too 
                    resource hungry.
                    ![Detection](https://raw.githubusercontent.com/josepmdc/UALL-E/main/img/Detection.png)
    - **Data Augmentation**: To make our dataset bigger we have used horizontal flip. You can see an example in the following image.
              ![dataAug](https://raw.githubusercontent.com/josepmdc/UALL-E/main/img/dataAug.png)

- **Movement**: The module that controls the wheels and movement of the robot 
tracing two kinds of routes: the continuous route inside the working boundaries 
of the robot and the route to the trash object when one is detected. Receives 
input from the Trash Recognition module with the position of the trash 
object.

- **Actuators control**: Module that controls the movement of the actuator 
(shovel) of the robot when it is in position to pick up a trash object. Receives
input from the autonomous movement module in the form of a signal that notifies 
that the robot is in position to pick up an object.

In order to detect if we are close enough to pick up the trash we use the 
bounding box of the object detection. We defined a line in the image which 
is where the shovel lies. When the bottom line of the bounding box crosses 
that line, it means that the trash is touching the shovel. The broom then 
gets activated and pushes the trash into the shovel. Finally, the broom 
moves back and the shovel gets lifted, leaving the trash inside the main 
container.

![Distance](https://raw.githubusercontent.com/josepmdc/UALL-E/main/img/distance.png)

# 3D printed and laser cut parts
You can find all the stl (for 3D printing) and svg (for laser cutting) files on 
the 3D directory.

# Amazing contributions

Unlike the previous projects that have tried something similar to this one, this project has some unique amazing contributions:

- Has a front view of its surroundings with a camera, which allows it to move autonomously through a terrain and search the litter at the same time and using only one sensor (the camera).
- Uses a neural network to detect litter, which allows it to point it out of a fixed sized space and go directly to it, without the need to go through all the area of the space.
- It’s a simple and cheap design to tackle this problem, so we could build an array of these units to clean the environment with very little cost and it would be very effective.

This said, we think that if this idea is successfully implemented the project should have a mark of 10. Because comparing it to the previously done projects it achieves the same results in a more simple, cheap and elegant way; applying knowledge from other areas of study apart from Robotics like Computer Vision and Artificial Intelligence.

As a group, we are aware that the idea is not very original and it's something that has been done before and in a vast amount of different approaches, but we are taking our approach as an opportunity to apply the knowledge we’re acquiring in this and other courses to solve the Litter Picking Robot Problem in a way that doesn’t require many complex sensors or electronics and solves the problem in a very efficient and elegant way.

# Video Demo
Here you can find the video of our robot in action.

[![Video of UALL-E in action](https://img.youtube.com/vi/Be-CDXhjkHY/0.jpg)](https://www.youtube.com/watch?v=Be-CDXhjkHY)


# Authors
Jorge Gutiérrez Cordero

Gerard Burgués Llavall

Martin Kaplan

Josep Maria Domingo Catafal
