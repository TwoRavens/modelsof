from arpeggio import *

_ = RegExMatch

def comment():
    return [_(r'\*.*'), _(r'/\*.*\*/')], OneOrMore("\n")

def var():
    return _(r'[\w.]+')

def num():
    return _(r'\d+')

def weight():
    return "[", var, "=", var, "]"

def varlist():
    return OneOrMore(var)

def option():
    return var, "(", OneOrMore([var, num]), ")"

def options():
    return ",", OneOrMore([option, var])

def command():
    return Optional((var, ":")), var, Optional(varlist), Optional(weight), Optional(options), OneOrMore("\n")

def stata():
    return OneOrMore(command), EOF

parser = ParserPython(stata, comment, ws='\t\r ')
parse = parser.parse
