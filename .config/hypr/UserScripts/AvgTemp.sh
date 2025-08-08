#!/bin/nu

sensors -j
| complete
| get stdout
| from json -s
| get "coretemp-isa-0000"
| values
| skip 1
| each {
    |v| $v
    | columns
    | filter {|k| $k =~ ".*_input$" }
    | each {|k| $v | get $k }
}
| flatten | math avg | into int
| into string | echo $" ($in)°C"
