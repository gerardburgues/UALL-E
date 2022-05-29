import cv2
import time
import torch
import keyboard
import RPi.GPIO as GPIO
from adafruit_servokit import ServoKit

DEBUG = False

DC_A_IN1 = 17
DC_A_IN2 = 22
DC_B_IN1 = 23
DC_B_IN2 = 24

def main():
    keyboard.add_hotkey('w', lambda: forward())
    keyboard.add_hotkey('a', lambda: left())
    keyboard.add_hotkey('s', lambda: reverse())
    keyboard.add_hotkey('d', lambda: right())
    keyboard.add_hotkey('b', lambda: toggle_broom())
    keyboard.add_hotkey('space', lambda: toggle_shovel())
    keyboard.wait()
    # use_object_detection()

def forward_test():
    print("forward")

def reverse_test():
    print("reverse")

def toggle_shovel():
    kit = ServoKit(channels=8)
    kit.servo[7].angle = 70
    time.sleep(5)
    kit.servo[7].angle = 0

def init_dc_motors():
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(DC_A_IN1, GPIO.OUT)
    GPIO.setup(DC_A_IN2, GPIO.OUT)
    GPIO.setup(DC_B_IN1, GPIO.OUT)
    GPIO.setup(DC_B_IN2, GPIO.OUT)

def forward(duration=0):
    print("Forward")
    init_dc_motors()
    GPIO.output(DC_A_IN1, GPIO.HIGH)
    GPIO.output(DC_A_IN2, GPIO.LOW)
    GPIO.output(DC_B_IN1, GPIO.HIGH)
    GPIO.output(DC_B_IN2, GPIO.LOW)
    time.sleep(duration)
    GPIO.cleanup()

def reverse(duration=0):
    print("Reverse")
    init_dc_motors()
    GPIO.output(DC_A_IN1, GPIO.LOW)
    GPIO.output(DC_A_IN2, GPIO.HIGH)
    GPIO.output(DC_B_IN1, GPIO.LOW)
    GPIO.output(DC_B_IN2, GPIO.HIGH)
    time.sleep(duration)
    GPIO.cleanup()

def right(duration=0):
    print("Right")
    init_dc_motors()
    GPIO.output(DC_A_IN1, GPIO.HIGH)
    GPIO.output(DC_A_IN2, GPIO.LOW)
    GPIO.output(DC_B_IN1, GPIO.LOW)
    GPIO.output(DC_B_IN2, GPIO.HIGH)
    time.sleep(duration)
    GPIO.cleanup()

def left(duration=0):
    print("Left")
    init_dc_motors()
    GPIO.output(DC_A_IN1, GPIO.LOW)
    GPIO.output(DC_A_IN2, GPIO.HIGH)
    GPIO.output(DC_B_IN1, GPIO.HIGH)
    GPIO.output(DC_B_IN2, GPIO.LOW)
    time.sleep(duration)
    GPIO.cleanup()

def toggle_broom():
    kit = ServoKit(channels=8)
    kit.servo[6].angle = 90
    time.sleep(10)
    kit.servo[6].angle = 0

def use_object_detection():
    threshold = 2506
    model = load_model()
    print("Model loaded")
    cap = cv2.VideoCapture(-1)
    if not cap.isOpened(): 
      print("Error opening video stream")
      return

    while cap.isOpened():
      ret, frame = cap.read()
      center = len(frame)/2
      if ret:
        results = model(frame)

        df = results.pandas().xyxy[0]

        if not df.empty:
            if DEBUG:
                cv2.rectangle(frame, 
                        (int(df['xmin'][0]), int(df['ymin'][0])),
                        (int(df['xmax'][0]), int(df['ymax'][0])),
                        (255,0,0), 5
                )

            if df['ymin'][0] >= threshold:
                toggle_shovel()
            elif df['xmin'][0] <= center - 5000:
                right()
            elif df['xmax'][0] >= center + 5000:
                left()
            else:
                forward()

        if DEBUG:
            cv2.imshow('Frame', frame)
            if cv2.waitKey(25) & 0xFF == ord('q'):
              print("bye!")
              break
      else: 
        break

    cap.release()
    cv2.destroyAllWindows()

def load_model():
    return torch.hub.load(
            'ultralytics/yolov5',
            'custom',
            path='yolov5/runs/train/exp9/weights/best.pt',
            force_reload=False) 


if __name__=="__main__":
    main()
