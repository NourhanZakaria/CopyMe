import cv2

cam = cv2.VideoCapture(0, cv2.CAP_DSHOW)
cascade = cv2.CascadeClassifier("cascade.xml")
cv2.namedWindow("RECO")
while True:
    frame, image = cam.read()
    faces = cascade.detectMultiScale(image, 1.3, 5)
    perCounter = 1
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x + w, y + h), (0, 0, 0), 2)
        cv2.putText(image, f'Person: {perCounter}', (x + 10, y - 10), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 0), 3)
        perCounter += 1

    cv2.putText(image, f'Total Persons : {perCounter - 1}', (10, 470), cv2.FONT_HERSHEY_COMPLEX, 1, (255, 255, 255), 3)
    cv2.imshow('RECO', image)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cam.release()
cv2.destroyAllWindows()
