from PIL import ImageTk
class ModelImage:
    def __init__(self, name:str, image:ImageTk.PhotoImage) -> None:
        self.name = name
        self.image = image