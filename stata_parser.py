import glob
import sys

from stata import Lexer

# http://effbot.org/zone/simple-top-down-parsing.htm

symbols = {}

class Symbol(object):
    id = None
    value = None
    first = second = third = None

    def nud(self):
        raise SyntaxError("Syntax error (%r)." % self.id)

    def led(self, left):
        raise SyntaxError("Unknown operator (%r)." % self.id)

    def __repr__(self):
        if self.id == "(name)" or self.id == "(literal)":
            return "(%s %s)" % (self.id[1:-1], self.value)
        out = [self.id, self.first, self.second, self.third]
        out = map(str, filter(None, out))
        return "(" + " ".join(out) + ")"

def symbol(id, bp=0):
    try:
        s = symbols[id]
    except KeyError:
        class s(Symbol):
            pass
        s.__name__ = "symbol-" + id # for debugging
        s.id = id
        s.value = None
        s.lbp = bp
        symbols[id] = s
    else:
        s.lbp = max(bp, s.lbp)
    return s

def infix(id, bp):
    def led(self, left):
        self.first = left
        self.second = expression(bp)
        return self
    symbol(id, bp).led = led

def infix_r(id, bp):
    def led(self, left):
        self.first = left
        self.second = expression(bp-1)
        return self
    symbol(id, bp).led = led

def prefix(id, bp):
    def nud(self):
        self.first = expression(bp)
        return self
    symbol(id).nud = nud

def advance(id=None):
    global token
    if id and token.id != id:
        raise SyntaxError("Expected %r" % id)
    token = nxt()

def method(s):
    assert issubclass(s, Symbol)
    def bind(fn):
        setattr(s, fn.__name__, fn)
    return bind

infix('\n', 100)

symbol("(name)").nud = lambda self: self
symbol("(literal)").nud = lambda self: self

symbol("(end)")

"""
symbol(")")
@method(symbol("("))
def nud(self):
    expr = expression()
    advance(")")
    return expr

symbol("]")

@method(symbol("["))
def led(self, left):
    self.first = left
    self.second = expression()
    advance("]")
    return self
"""

def tokenize(lexer):
    for token in lexer:
        if token.type in ('comment', 'number', 'string'):
            symbol = symbols['(literal)']
            s = symbol()
            s.value = token.value 
        else:
            symbol = symbols.get(token.value)
            if symbol:
                s = symbol()
            elif token.type == 'identifier':
                symbol = symbols['(name)']
                s = symbol()
                s.value = token.value 
            else:
                raise SyntaxError("Unknown operator (%r)" % token.type)
        yield s

def expression(rbp=0):
    global token
    t = token
    token = nxt()
    left = t.nud()
    while rbp < token.lbp:
        t = token
        token = nxt()
        left = t.led(left)
    return left

def run(file):
    print(file)
    try:
        with open(file) as f:
            lexer = Lexer(f.read())
    except UnicodeError:
        with open(file, encoding='cp1252') as f:
           lexer = Lexer(f.read())

    global token, nxt
    nxt = lambda: next(tokenize(lexer))
    token = nxt()
    return expression()

if __name__ == '__main__':
    for file in glob.glob(sys.argv[1], recursive=True):
        print(run(file))
        break
