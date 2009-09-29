import render
import stopiccot

render.loadTexture("engine_256", r"D:\code\stopiccot\engine\engine.png")

#class DerivedSprite(stopiccot.Sprite):
#    xxx = 10
#
#    def __init__(self):
#        stopiccot.Sprite.__init__(self, texture = "engine_256", width = 32.0, height = 32.0)
#        print "DerivedSprite"
#
#    def onclick(self):
#        print "onclick"
#
#    def pythonMethod(self):
#        self.left = 500.0
#        self.top  = 500.0
#        self.pivot_x = 300.0
#        self.pivot_y = 333.0
#        print xxx

def f():
    sprite = stopiccot.Sprite(texture = "engine_256", width = 32.0, height = 32.0)
    sprite.method()

#def f2():
#    derivedSprite = DerivedSprite()
#    derivedSprite.method()
#    derivedSprite.pythonMethod()

f()
#f2()

