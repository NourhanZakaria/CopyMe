from tkinter import *
from tkinter.ttk import *
import cv2
from PIL import ImageTk, Image
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import img_to_array
import numpy as np
from array import *
from ModelImage import ModelImage

root = Tk()
root.title("COPY ME ")
Grid.rowconfigure(root, 0)
Grid.columnconfigure(root, 0)
root.geometry('1000x800')
root.iconbitmap("expression/bitmap.ico")

face_classifier = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
classifier = load_model('exp7.h5')
#facial expressions in dataset
class_labels = ['Angry', 'Disgust', 'Fear', 'Happy', 'Neutral', 'Sad', 'Surprise']
label = Label()
player_score = 0
score_text = StringVar()
score_text.set("score = " + str(player_score))


def on_resize(event):
    # resize the background image to the size of label
    image = bgimg.resize((event.width, event.height), Image.ANTIALIAS)
    # update the image of the label
    l.image = ImageTk.PhotoImage(image)
    l.config(image=l.image)

bgimg = Image.open('expression/background4.png') # load the background image
l = Label(root)
l.place(x=0, y=0, relwidth=1, relheight=1) # make label l to fit the parent window always
l.bind('<Configure>', on_resize) # on_resize will be executed whenever label l is resized

#function for next button
def forward(image_num):
    global cur_img_label
    global button_next
    global button_back
    cur_img_label.grid_forget()
    cur_img_label = Label(text=img_list[image_num - 1].name, image=img_list[image_num - 1].image)
    button_next = Button(root, text="Next", command=lambda: forward(image_num + 1))
    button_back = Button(root, text="Back", command=lambda: back(image_num - 1))
    if image_num == len(img_list):
        button_next = Button(root, text="Next", state=DISABLED)

    cur_img_label.grid(row=0, column=1, columnspan=2, )
    score_label.grid(row=1, column=1, columnspan=2, sticky="NSEW")
    button_back.grid(row=2, column=1, sticky="NSEW")
    button_next.grid(row=2, column=2, sticky="NSEW")
    button_capture.grid(row=3, column=1, columnspan=2, sticky="NSEW")
    button_score.grid(row=4, column=1, columnspan=2, sticky="NSEW")
    button_exit.grid(row=5, column=1, columnspan=2, sticky="NSEW")

#function for back button
def back(image_num):
    global cur_img_label
    global button_next
    global button_back
    cur_img_label.grid_forget()
    cur_img_label = Label(text=img_list[image_num - 1].name, image=img_list[image_num - 1].image)
    button_next = Button(root, text="Next", command=lambda: forward(image_num + 1))
    button_back = Button(root, text="Back", command=lambda: back(image_num - 1))
    if image_num == 1:
        button_back = Button(root, text="Back", state=DISABLED)

    cur_img_label.grid(row=0, column=1, columnspan=2, )
    score_label.grid(row=1, column=1, columnspan=2, sticky="NSEW")
    button_back.grid(row=2, column=1, sticky="NSEW")
    button_next.grid(row=2, column=2, sticky="NSEW")
    button_capture.grid(row=3, column=1, columnspan=2, sticky="NSEW")
    button_score.grid(row=4, column=1, columnspan=2, sticky="NSEW")
    button_exit.grid(row=5, column=1, columnspan=2, sticky="NSEW")

#open webcam and run the model function
def capture_cam():
    global label
    cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)
    while True:
        ret, frame = cap.read()
        labels = []
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_classifier.detectMultiScale(gray, 1.3, 5)

        for (x, y, w, h) in faces:
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 0), 2)
            roi_gray = gray[y:y + h, x:x + w]
            roi_gray = cv2.resize(roi_gray, (48, 48), interpolation=cv2.INTER_AREA)

            if np.sum([roi_gray]) != 0:
                roi = roi_gray.astype('float') / 255.0
                roi = img_to_array(roi)
                roi = np.expand_dims(roi, axis=0)

                preds = classifier.predict(roi)[0]
                label = class_labels[preds.argmax()]
                cv2.putText(frame, label, (x, y), cv2.FONT_HERSHEY_COMPLEX, 2, (255, 255, 255), 3)

        cv2.imshow('Emotion Detector', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        root.update()

    cap.release()
    cv2.destroyAllWindows()

#get the player score
def get_score():
    global player_score
    global score_text
    global label
    if label == cur_img_label.cget("text"):
        player_score = player_score + 1
        score_text.set(str(player_score))
        print("Success " + label)
        print("score = " + player_score)

    else:
        print("fail")
        score_text.set(str(player_score) + " wrong expression")
        print(player_score)


#list of presented images using class ModelImage
img_list = []
img_list.append(ModelImage("Angry", ImageTk.PhotoImage(Image.open("expression/angry.jpeg").resize((500, 450)))))
img_list.append(ModelImage("Happy", ImageTk.PhotoImage(Image.open("expression/happy.jpeg").resize((500, 450)))))
img_list.append(ModelImage("Neutral", ImageTk.PhotoImage(Image.open("expression/neutral.jpeg").resize((500, 450)))))
img_list.append(ModelImage("Sad", ImageTk.PhotoImage(Image.open("expression/sad.jpeg").resize((500, 450)))))
img_list.append(ModelImage("Surprise", ImageTk.PhotoImage(Image.open("expression/surprise.jpeg").resize((500, 450)))))
img_list.append(ModelImage("Disgust", ImageTk.PhotoImage(Image.open("expression/disgust.jpeg").resize((500, 450)))))
img_list.append(ModelImage("Fear", ImageTk.PhotoImage(Image.open("expression/fear.jpeg").resize((500, 450)))))

score_label = Label(root, textvariable=score_text)     #label for show score for user
score_label.config(anchor="center")
cur_img_label = Label(text=img_list[0].name, image=img_list[0].image)


style = Style()

# Will add style to every available button
# even though we are not passing style
# to every button widget.
style.configure('TButton', font=('calibri', 10, 'bold', 'underline'),foreground='black')

button_score = Button(root, text="Result", command=get_score, style='TButton')
button_back = Button(root, text="Back", command=back, style='TButton')
button_exit = Button(root, text="Exit", command=root.quit, style='TButton')   # must click "Q" to exit the video live before click the exit buttton
button_next = Button(root, text="Next", command=lambda: forward(2), style='TButton')
button_capture = Button(root, text="Capture", command=capture_cam, style='TButton')


cur_img_label.grid(row=0, column=1, columnspan=2,)
score_label.grid(row=1, column=1, columnspan=2, sticky="NSEW")
button_back.grid(row=2, column=1, sticky="NSEW")
button_next.grid(row=2, column=2, sticky="NSEW")
button_capture.grid(row=3, column=1, columnspan=2, sticky="NSEW")
button_score.grid(row=4, column=1, columnspan=2, sticky="NSEW")
button_exit.grid(row=5, column=1, columnspan=2, sticky="NSEW")


root.mainloop()
