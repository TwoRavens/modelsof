import collections
import  json
import re
import sys

last_token = None

def match(s, name, pattern):
    m = re.match(pattern, s)
    if m:
        return name, m.end()

def bracket_left(s):
    return match(s, 'bracket left', r'\[')

def bracket_right(s):
    return match(s, 'bracket right', r'\]')

def comment(s):
    m = match(s, 'comment', r'(##|\/\/|\*\*).*|$')
    if m and (not last_token or '\n' in last_token.value):
        return m
    m = match(s, 'comment', r'\s?[*].*|$')
    if m and '\n' in last_token.value:
        return m

def curly_left(s):
    return match(s, 'curly left', r'{')

def curly_right(s):
    return match(s, 'curly right', r'}')

def id(s):
    return match(s, 'id', r"[a-zA-Z`'_\*.]+[\w`'_\*.]*")

def number(s):
    return match(s, 'number', r'-?\d*\.?\d+')

def operator(s):
    return match(s, 'operator', r'[%*\-+!=~/<>&|:,]+')

def paren_left(s):
    return match(s, 'paren left', r'\(')

def paren_right(s):
    return match(s, 'paren right', r'\)')

def string(s):
    m = s.startswith('"') and re.search(r'[^\\]"', s, 1)
    if m:
        return 'string', m.end() 

def whitespace(s):
    return match(s, 'space', r'\s+')

lexers = [
    bracket_left, 
    bracket_right, 
    curly_left,
    curly_right,
    paren_left,
    paren_right,
    number, 
    comment,
    operator, 
    id, 
    string, 
    whitespace
]

Token = collections.namedtuple('Token', 'type value position')

def lex(input):
    pos = 0
    while input: 
        tkn = None
        for lxr in lexers:
            tkn = lxr(input)
            if tkn:
                type_, len_ = tkn
                if type_:
                    yield Token(type_, input[:len_], pos)

                pos += len_ 
                input = input[len_:]
                break
            
        if input and not tkn:
            raise NameError(pos)

tokens = []

with open(sys.argv[1]) as f:
    for x in lex(f.read()):
        last_token = x
        if x.type != 'space':
            tokens.append(dict(type=x.type, value=x.value, position=x.position))

with open('test.json', 'w') as f:
    json.dump(tokens, f, indent=2)
