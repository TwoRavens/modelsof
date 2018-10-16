import json, re, sys

last_token = None

def match(s, name, pattern):
    m = re.match(pattern, s)
    if m:
        return name, m.end()

def bracket_l(s):
    return match(s, 'bracket left', r'\[')

def bracket_r(s):
    return match(s, 'bracket right', r'\]')

def comment(s):
    m = match(s, 'comment', r'(##|\/\/|\*\*).*|$')
    if m and (not last_token or '\n' in last_token['value']):
        return m
    m = match(s, 'comment', r'\s?[*].*|$')
    if m and last_token and '\n' in last_token['value']:
        return m

def curly_l(s):
    return match(s, 'curly left', r'{')

def curly_r(s):
    return match(s, 'curly right', r'}')

def id(s):
    pattern = r"[a-zA-Z_.]+[\w_.]*"
    return match(s, 'id', pattern) or match(s, 'id', '`' + pattern + "'")

def number(s):
    return match(s, 'number', r'-?\d*\.?\d+')

def operator(s):
    return match(s, 'operator', r'[%*\-+!=~/<>&|:,]+')

def paren_l(s):
    return match(s, 'paren left', r'\(')

def paren_r(s):
    return match(s, 'paren right', r'\)')

def space(s):
    m = match(s, 'space', r'\s+')
    if m:
        idx = s[:m[1]].rfind('\n')
        if idx != -1:
            return 'newline', idx+1
        return m

def string(s):
    m = s.startswith('"') and re.search(r'[^\\]"', s, 1)
    if m:
        return 'string', m.end() 

lexers = [
    bracket_l, 
    bracket_r, 
    curly_l,
    curly_r,
    paren_l,
    paren_r,
    number, 
    comment,
    id, 
    operator, 
    string, 
    space
]

def lex(input):
    pos = 0 
    while input: 
        global last_token
        tkn = None
        for lxr in lexers:
            tkn = lxr(input)
            if tkn:
                type_, ln = tkn
                if type_:
                    last_token = dict(type=type_, value=input[:ln], len=ln)
                    yield last_token

                pos += ln 
                input = input[ln:]
                break
            
        if input and not tkn:
            raise NameError(input[pos:pos+10])

def split_lines(tokens):
    line = []
    line_n = 1
    with open(sys.argv[1]) as f:
        for x in lex(f.read()):
            newlines = x['value'].count('\n')
            if x['type'] == 'comment':
                line_n += newlines
            elif x['type'] == 'newline':
                if line:
                    yield line, line_n
                    line = []
                line_n += newlines
            else:
                line.append(x)

with open('test.json', 'w') as f:
    lines = []
    for [line, num] in list(split_lines(lex(input))):
        col = 1
        cur = []
        by = []
        varlist = []
        opts = []
        for tkn in line:
            tkn['line'] = num
            tkn['col'] = col
            col += tkn['len']
            del tkn['len']
            if tkn['type'] == 'space':
                continue
            if tkn['value'] == ':':
                by = cur 
                cur = []
            elif tkn['value'] == ',':
                varlist = cur 
                cur = []
            else:
                cur.append(tkn)

        vlist = varlist if varlist else cur
        res = {'command': vlist[0]}
        if by:
            res['by'] = by
        if vlist[1:]: 
            res['varlist'] = vlist[1:]
        if varlist:
            res['opts'] = cur
        lines.append(res)

    json.dump(lines, f, indent=2)
