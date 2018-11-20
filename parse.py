from arpeggio import *

_ = RegExMatch

def comment():
    return [_(r'\*.*'), _(r'/\*.*\*/')], OneOrMore('\n')

def var():
    return Not('if'), _(r'[a-zA-Z_.][\w.#]*')

def num():
    return [_(r'\d+(\.\d+)?'), _(r'[-]?\.\d+')]

def atom():
    return [var, num, _(r'"[^"]*"'), ('(', atom, ')')]

def varlist():
    return OneOrMore([(var, '=', atom), atom])

def relational_op():
    return atom, '==', atom

def logical_op():
    return relational_op, ZeroOrMore('&', relational_op)

def function():
    return var, '(', OneOrMore([logical_op, function, atom]), ')'

def exp():
    return [logical_op, function]

def if_():
    return 'if', exp

def weight():
    return '[', var, '=', var, ']'

def options():
    return ',', OneOrMore([function, var])

def command():
    return Optional(var, ':'), var, Optional(varlist), Optional(if_), Optional(weight), Optional(options), OneOrMore('\n')

def stata():
    return OneOrMore(command), EOF

parser = ParserPython(stata, comment, ws='\t\r ')
parse = parser.parse
