fs = require 'fs'
coffee = require 'coffee-script'


text_to_node = (text) ->
    raw_node = coffee.nodes text
    return MakeNode raw_node

nodes_to_scope = (node) ->
    return node.generate_scope()

load = (filename) -> fs.readFileSync filename, {encoding: 'utf8'}


#utility for printing out nested tabs
class StringBuilder
    constructor: (@tabs) ->
        @pieces = []
    
    write: (str) -> @pieces.push str
    
    sub: -> 
        s = new StringBuilder @tabs + 1
        @pieces.push s
        return s
    
    get: ->
        handle = (p) =>
            if typeof(p) is 'string'
                return '\n' + Array(@tabs * 4 + 1).join(' ') + p
            else
                return p.get()
        return (handle piece for piece in @pieces).join ''
        
   
class Scope
    constructor: ->
        @variables = []

    toString: -> 
        s = new StringBuilder 0
        @print s
        return s.get()
        
    print: (string_builder) ->
        string_builder.write 'Scope'
        s = string_builder.sub()
        v.print s for v in @variables
    
    get: (var_name) ->
        #right now we look for the first variable... we can make this more sophisticated
        #by allowing multiple variables with the same name down the line
        for v in @variables
            if v.name is var_name
                return v
               
        v = new Variable var_name
        @variables.push v 
        return v
        
    

class Variable
    constructor: (@name) ->
        @interface = null
        @uses = []
        @assignments = []
        
    print: (string_builder) ->
        string_builder.write 'Variable: ' + @name
        s = string_builder.sub()
        @interface?.print s
        ass.print s for ass in @assignments
        use.print s for use in @uses
        


MakeNode = (raw_node) -> 
    if not nodes[raw_node.constructor.name]
        throw new Error 'unrecognized node: ' + raw_node.constructor.name
    new nodes[raw_node.constructor.name] raw_node
       
class Node
    constructor: (@raw) ->
        
    generate_scope: -> 
        scope = new Scope()
        @process scope            
        return scope
        
    children: ->
        res = []
        for name in @raw.children
            res.push MakeNode(n) for n in @raw[name]
        return res
        
    process: ->
        console.log 'warning: node ' + @constructor.name + ' does not yet have a process(scope) function'
            
        

nodes = {}

nodes.Block = class Block extends Node
    process: (scope) ->
        for child in @children()
            child.process scope
            
            
nodes.Class = class Class extends Node
    process: (scope) ->
        #first, add the class itself to the scope
        name = @raw.determineName()
        v = scope.get name
        
        console.log 'warning: not done with class!'
        
        
nodes.Comment = class Comment extends Node
        
nodes.Assign = class Assign extends Node

nodes.Call = class Call extends Node




#The thing:
scope = nodes_to_scope text_to_node load 'sample.coffee'
console.log scope + ''

process.exit()











##OLD BELOW THIS LINE


## Traversing

no_filter = (x) -> true

mk_filter = (filter) ->
    if typeof(filter) is 'string'
        return (x) -> x.constructor.name is filter
    else
        filter
        
filter_array = (filter, array) ->
    filter = mk_filter filter
    return (x for x in array when filter x)

# Returns a flat list of child nodes
children = (node, filter = no_filter) ->
    res = []
    for attr in node.children ? []
        if node[attr]
            res = res.concat node[attr]
    return filter_array filter, res
    
    
# Returns a flat list of all children recursively
find = (node, filter = identity) ->
    filter = mk_filter filter
    
    res = []
    for child in children node
        if filter child
            res.push child
        res = res.concat find child, filter
    
    return res


### (Filename) -> File ###
load = (filename) -> fs.readFileSync filename, {encoding: 'utf8'}

### (File) -> Node ###
parse = (file) -> coffee.nodes file


class Interface
    constructor: (@name, @fns) ->


class_to_interface = (node) ->
    name = cls.determineName()
    fns = cls.body

find_interfaces = (node) -> 
     classes = find node, 'Class'
     return (cls.determineName() for cls in classes)
    
    
    
console.log  find_interfaces (parse load 'sample.coffee')
    

#file -> interfaces
#    should return Thingy: eat -> Any, pray -> Number, love -> String
    
    


#Semantic description of code instead of types

#disconnect from underlying type system .

#search for functions from getting to one type of another

#Generating browsable documentation.  With a search bar.  One page doc.