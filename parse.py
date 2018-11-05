import re, sys

from lark import Lark

l = Lark(r"""
    start: WS? commands
    commands: ((comment | command) "\n"+)+
    comment: /#.+/ | "//" /.+/ | WS? /\*.*/ | "/*" /[^\*\/]+/ "*/"
    command: (by? name varlist? ("=" exp)? ("if" exp)? ("in" range)? weight? | name exp*) ("," options)?
    by: name* ":"
    varlist: name+
    exp: name | number | ESCAPED_STRING | name "==" number
    range: number "/" number
    weight: "[" name "=" exp "]"
    block: "{" "\n"* commands "}"
    if: "if" exp
    options: name | opt+
    opt: name "(" exp ")"
    ?name: "*"? /[a-zA-Z_.]+[0-9a-zA-Z_.]*/ "*"?
    ?number: "%"? SIGNED_NUMBER

    %import common (ESCAPED_STRING, SIGNED_NUMBER, WORD, WS)
    WS1: " "|"\t"
    %ignore WS1
""")

def parse(path):
    with open(path) as f:
        data = f.read()
        d = re.findall(r'#delimit(\s*;|\s+cr)', data)
        if not d:
            l.parse(data)
