

class Thingy
    eat: ->
    
    pray: -> 5
    
    love: -> 'hello'
    
###
@arg Thingy m    
###
make_the_thingy = (m) ->
    m.eat()
    m.pray() + 7
    m.love() + 'world'
    m.fail()
    
    
x = new Thingy()

make_the_thingy 5
