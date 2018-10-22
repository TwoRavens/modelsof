import sys

from lark import Lark

l = Lark(r"""
    start: commands 
    commands: command | (command "\n"+)*
    command: by? name varlist? block? if? options?
    by: name* ":"
    varlist: value* vars?
    vars: "[" var* "]"
    var: name "=" value*
    block: "{" "\n"* commands "}"
    if: "if" value*
    options: "," value*
    ?value: ESCAPED_STRING
        | name 
        | "`" name "'"
        | number
        | operator
        | call
    operator: ("="|"/"|"-"|"&"|"<"|">"|"+"|"*"|"!"|"|"|":,")*
    call: name? "(" value* ")"
    ?name: "*"? /[a-zA-Z_.]+[0-9a-zA-Z_.]*/ "*"?
    ?number: "%"? SIGNED_NUMBER

    %import common (ESCAPED_STRING, SIGNED_NUMBER, WORD)

    COMMENT: /#.*/ "\n"+ | "//" /.*/ "\n"+ | "\n"+ WS* /\*.*/
    WS: " "|"\t"
    %ignore COMMENT 
    %ignore WS 
""")


with open(sys.argv[1]) as f:
    print(l.parse(f.read()).pretty())
