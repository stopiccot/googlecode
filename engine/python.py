import render
import stopiccot

render.loadTexture("engine_256", r"D:\code\stopiccot\engine\engine.png")
render.loadTexture("engine_256_2", r"D:\code\stopiccot\engine\engine2.png")

class DerivedSprite(stopiccot.Sprite):
    xxx = 10

    def __init__(self):
        stopiccot.Sprite.__init__(self, texture = "engine_256_2", width = 32.0, height = 32.0)
        print "DerivedSprite"

    def onclick(self):
        print "onclick"

    def pythonMethod(self):
        self.left = 123.0
        self.top  = 456.0
        self.pivot_x = 200.0
        self.pivot_y = 200.0
        print xxx

sprite = stopiccot.Sprite(texture = "engine_256", width = 32.0, height = 32.0)
sprite.method()

derivedSprite = DerivedSprite()
derivedSprite.method()
derivedSprite.pythonMethod()