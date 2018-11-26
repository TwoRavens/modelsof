from arpeggio import *

_ = RegExMatch

def var():
    return _(r'[$a-zA-Z_.][\w.#]*')
    return Not('if'), _(r'[$a-zA-Z_.][\w.#]*')

def num():
    return [_(r'%?\d+(\.\d+)?f?'), _(r'\.\d+')]

def atom():
    return [var, num, _(r'"[^"]*"'), _(r"'[^']*'"), _(r"`[^']*'"), ('(', atom, ')')]

def operation():
    res = Optional(_(r'[!-]')), atom
    for op in '/ - != < > >= == &'.split():
        res = res, ZeroOrMore(op, res)
    return res 

def function():
    return var, '(', OneOrMore(Optional(','), [function, operation]), ')'

def varlist():
    val = [function, operation], Optional('=', operation)
    return OneOrMore([val, ('(', val, ')')])

def exp():
    return [function, operation]

def weight():
    return '[', var, '=', var, ']'

def options():
    return ',', ZeroOrMore([function, var])

def stuff():
    return [atom] + '* / - + != < > >= == & | = , ( ) ! ^ [ ]'.split()

def command():
    return Optional(var, ZeroOrMore(Optional(','), var), ':'), Optional('!'), atom, ZeroOrMore(stuff, _(r'(///\n)?')), OneOrMore('\n')
    #return Optional(var, ZeroOrMore(Optional(','), var), ':'), Optional('!'), var, Optional(varlist), Optional('if', exp), Optional(weight), Optional(options), OneOrMore('\n')

def foreach():
    return 'foreach', OneOrMore(stuff), '{', ZeroOrMore('\n'), OneOrMore([foreach, if_, command]), OneOrMore('\n')

def if_():
    return 'if', OneOrMore(stuff), '{', ZeroOrMore('\n'), OneOrMore([foreach, if_, command]), '}', ZeroOrMore('\n'), Optional('else', '{', ZeroOrMore('\n'), OneOrMore([foreach, if_, command]), '}'), OneOrMore('\n')

def stata():
    return OneOrMore([foreach, if_, command]), EOF

def comment():
    return [_(r'\*.*'), _(r'/\*.*\*/')], OneOrMore('\n')

parser = ParserPython(stata, comment, ws='\t\r ')
