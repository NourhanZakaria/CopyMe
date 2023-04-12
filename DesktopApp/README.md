**_To execute the (main.py) file , you need libraries:_**

    1- install Pillow version 7.0.0
  
    2-Tensorflow version 2.0.0.a0
    In Converting from keras model to tensorflowlite we need version 1.13.2

    3-Keras version 2.3.1
  
    4-tkinter platform to handle the DesktopApp GUI
  
    5-install numpy and open cv

**_Steps to run the software:_**

    You can use pycharm or vscode to run our app in your desktop(we used pycharm)
    
    to run the project , click (main.py) file
    
    first, you will see 7 photos for our important expressions to make the child try them by clicking on "capture" button to open your web cam
    
    second, the cam will start to detect child's face expression and compare it with the photos he chose
    
    third, on clicking on "result" button your result will appear  (if right the score will increase,
    
    if wrong the score will stay the same and a text "Wrong Expression" will show up)
    
    fourth, by the buttons"next" and "back", the user will choose which expression he wanna try
   
    fifth, you can click the button "Exit" to end the program 
   
    (Note: You can't click the button if your cam is open, you should click (Q) first to close the cam and then click the exit button )

**_Methodology:_**

    -We used class ModelImage to connect the apearing label photos with text to be able to compare it with the text coming from the model
    
    -We used Tkinter to handle app GUI
