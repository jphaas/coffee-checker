fs = require 'fs'
coffee = require 'coffee-script'

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
    fns = cls.body.

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