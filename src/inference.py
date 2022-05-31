import cv2 # per algun motiu només funciona si fas import de cv2
import torch


def load_model():
    return torch.hub.load(
            'ultralytics/yolov5',
            'custom',
            path='yolov5/runs/train/exp9/weights/best.pt',
            force_reload=False) 

def inference():
    model = load_model()
    print("Model loaded")
    cap = cv2.VideoCapture(-1)
    
    if not cap.isOpened(): 
      print("Error opening video stream")
      return

    width= int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height= int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    writer= cv2.VideoWriter('basicvideo.mp4', cv2.VideoWriter_fourcc(*'DIVX'), 20, (width,height))

    while cap.isOpened():
      ret, frame = cap.read()
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

        if DEBUG:
            cv2.imshow("Framw", frame)
            writer.write(frame)
            if cv2.waitKey(25) & 0xFF == ord('q'):
              print("bye!")
              break
      else: 
        break

    cap.release()
    writer.release()
    cv2.destroyAllWindows()

