import render
import stopiccot

render.loadTexture("engine_256", r"D:\code\stopiccot\engine\engine.png")

class DerivedSprite(stopiccot.Sprite):
    def __init__(self):
        stopiccot.Sprite.__init__(self, texture = "engine_256", width = 32.0, height = 32.0)
        print "DerivedSprite"

    def onclick(self):
        print "onclick"

sprite = stopiccot.Sprite(texture = "engine_256", width = 256.0, height = 256.0)
sprite.method()

#derivedSprite = DerivedSprite()
#derivedSprite.method()


