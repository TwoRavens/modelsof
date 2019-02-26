from collections import Counter, namedtuple
import glob
import json
import os, os.path
import sys

with open('categories.json') as f:
    categories = json.load(f)

Token = namedtuple('Token', 'id value line column')

class InputError(Exception):
    def __init__(self, char, line, column, text):
        self.char = char
        self.line = line
        self.column = column
        self.text = text 

class Lexer:
    def __init__(self, input):
        self.input = input
        self.position = 0
        self.read_position = 0
        self.ch = '\0' 
        self.line = 1
        self.column = 0
        self.last_token = Token('', '', 0, 0)
        self.read_char()

    def __iter__(self):
        return self

    def __next__(self):
        self.skip_whitespace()
        ch = self.ch
        if ch == '\0':
            raise StopIteration

        if ch == '\n':
            pos, line, col = self.get_current()
            while self.peek_char() == ' ':
                self.read_char()
            tok = self.token('\n', '\n', line, col) 
        elif ch in "\\,(){}[]<>|&+-:%;'^" or ord(ch) > 127:
            tok = self.token() 
        elif ch == '/':
            tok = self.token() 
            if self.peek_char() == '*':
                tok = self.read_until('*/', 'comment', ch)
            elif self.peek_char() == '/':
                cur = self.get_current()
                self.read_char()
                if self.peek_char() == '/' and self.last_token.id != '\n':
                    tok = self.read_to_end('///', cur) 
                else:
                    tok = self.read_to_end('comment', cur) 
        elif ch == '*':
            tok = self.token() 
            if self.last_token.id in ' \n':
                tok = self.read_to_end('comment') 
        elif ch == '#':
                pos, line, col = self.get_current()
                if self.input[pos + 1:].lstrip(' \t').startswith('delimit'):
                    while self.position < pos + self.input[pos:].index('delimit') + 6:
                        self.read_char()
                        tok = self.token('#delimit', '#delimit', line, col) 
                else:
                    tok = self.read_to_end('comment') 
        elif ch == '~':
            tok = self.maybe('~=') 
        elif ch == '!':
            tok = self.maybe('!=') 
        elif ch == '=':
            tok = self.maybe('==') 
        elif ch == '"':
            tok = self.read_until('"', 'string')
        elif ch == '`':
            if self.peek_char() == '"':
                tok = self.read_until('"\'', 'string', ch)
            else:
                tok = self.read_until("'", "`'")
        elif self.is_identifier():
            if ch == '.' and '0' <= self.peek_char() <= '9':
                return self.get_item('number', self.is_number) 
            return self.get_item('identifier', self.is_identifier) 
        elif self.is_number():
            return self.get_item('number', self.is_number) 
        else:
            raise InputError(ch, self.line, self.column, self.input[self.position - self.column + 1:self.position + 10]) 

        self.read_char()
        self.last_token = tok
        if tok.id == '\n':
            self.line += 1
            self.column = 1
        return tok

    def skip_whitespace(self):
        while self.ch in ' \t':
            self.read_char()

    def read_until(self, end, id, ch=None):
        pos, line, col = self.get_current()
        while not ch or self.input[self.position - 1:self.position + 1] != end:
            self.read_char()
            if not ch and self.ch == end:
                break
            if self.ch == '\0':
                raise InputError(ch, line, col, self.input[pos - col + 1:pos + 10]) 
        return self.token(id, self.input[pos:self.position + 1], line, col)

    def read_to_end(self, id, current=None):
        pos, line, col = current or self.get_current()
        while not self.peek_char() in '\n\0' or (id == 'comment' and self.input[self.position - 2:self.position + 1] == '///'):
            self.read_char()
        return self.token(id, self.input[pos:self.position + 1], line, col)

    def maybe(self, chars):
        tok = self.token() 
        if self.peek_char() == chars[1]: 
            pos, line, col = self.get_current()
            self.read_char()
            tok = self.token(chars, self.input[pos:pos + 2], line, col) 
        return tok

    def read_char(self):
        self.ch = self.peek_char() 
        self.position = self.read_position
        self.read_position += 1
        self.column += 1
        return self.ch

    def peek_char(self):
        return '\0' if self.read_position >= len(self.input) else self.input[self.read_position]

    def get_current(self):
        return self.position, self.line, self.column

    def is_identifier(self, second=False):
        match = 'A' <= self.ch <= 'Z' or 'a' <= self.ch <= 'z' or self.ch in '@_$.'
        return match or second and (self.ch == '#' or '0' <= self.ch <= '9')

    def is_number(self, second=False):
        return '0' <= self.ch <= '9' or self.ch in '.' or (second and 'a' <= self.ch <= 'z')

    def get_item(self, id, method):
        pos, line, col = self.get_current()
        while method(True):
            self.read_char()
        self.last_token = self.token(id, self.input[pos:self.position], line, col) 
        return self.last_token

    def token(self, id='', value='', line=0, column=0):
        return Token(id or self.ch, value or self.ch, line or self.line, column or self.column) 

class Node(object):
    lbp = 0 

    def __init__(self, token):
        self.id = token.id
        self.value = token.value
        self.line = token.line
        self.column = token.column

class End(Node):
    def __init__(self):
        pass 

class Literal(Node):
    def __repr__(self):
        return f'{self.value}'

    def null(self, parser):
        return self

class Operator(Node):
    lbp = 20

    def __init__(self, token):
        super().__init__(token)
        if self.value in '*/%':
            self.lbp = 21
        elif self.value == '&&':
            self.lbp = 22
        elif self.value == '||':
            self.lbp = 23

    def null(self, parser):
        return parser.expression()

    def left(self, left, parser):
        self.args = [left, parser.expression(self.lbp)]
        return self

class Id(Node):
    lbp = 30 

    def null(self, parser):
        self.args = ['self']
        return self

    def left(self, left, parser):
        self.args = [left]
        return self

class Parser(object):
    def __init__(self, lexer):
        self.lexer = lexer
        self.delimiter = '\n'
        next(self)

    def __iter__(self):
        return self

    def __next__(self):
        try:
            t = next(self.lexer)
        except StopIteration:
            self.token = End()
        else:
            Node = dict().get(t.id, Literal)
            self.token = Node(t)
        return self.token

    def expression(self, rbp=0):
        t = self.token
        left = t.null(next(self))
        while rbp < self.token.lbp:
            t = self.token
            left = t.left(left, next(self))
        return left

    def commands(self):
        cap, n, qui, vers = 'capture noisily quietly version'.split()
        prefix = []
        for pre, ln in ((cap, 3), (n, 1), (qui, 3), (vers, 4)):
            prefix += [pre[:i] for i in range(ln, len(pre) + 1)]

        commands = []
        while 1:
            if isinstance(self.token, End) or self.token.value == '}':
                next(self)
                break
            command = self.command()
            if command and command[-1].id == 'comment':
                commands.append(command.pop())
            if command:
                pre = []
                while command[0].value in prefix + list(categories['prefix']):
                    head = command[0].value
                    if head in prefix:
                        pre.append(self.parse_command(command[:1]))
                        if command[1] and command[1].value == ':':
                            del command[1]
                        command = command[1:]
                        continue
                    if head in categories['prefix']:
                        buf = []
                        for i, x in enumerate(command):
                            if x.value != ':':
                                buf.append(x)
                            else:
                                break
                        if buf == command:
                            break
                        pre.append(self.parse_command(buf))
                        command = command[i + 1:]
                        continue
                command = self.parse_command(command)
                if pre:
                    command['pre'] = pre
                commands.append(command)
        return commands

    def command(self):
        command = []
        while 1:
            if isinstance(self.token, End) or self.token.value == self.delimiter and not (command and command[0].id == '#delimit'):
                next(self)
                if command and command[-1].id == '///':
                    command.pop()
                else:
                    break

            if self.token.id == '\n' and self.delimiter != '\n':
                next(self)
                continue
            else:
                command.append(self.expression())

            if command[-1].id == 'comment' and not '\n' in command[-1].value:
                break

            if len(command) == 2 and command[0].id == '#delimit':
                self.delimiter = ';' if command[1].id == ';' else '\n'
                break

        if len(command) == 1 and command[0].id == '#delimit':
            self.delimiter = '\n'
        return command

    def parse_command(self, command):
        res = dict(command=command[0])
        varlist, if_, eq, in_, weight, options = [], [], [], [], [], []
        cur = varlist 
        parens = 0
        for token in command[1:]:
            if token.id == '(':
                parens += 1
            if token.id == ')':
                parens -= 1
            if not parens and token.value == '=':
                cur = eq
                continue
            if not parens and token.value == 'if':
                cur = if_ 
                continue
            if not parens and token.value == 'in':
                cur = in_ 
                continue
            if not parens and token.value == '[':
                cur = weight 
                continue
            if not parens and token.value == ',':
                cur = options 
                continue
            cur.append(token)
        if varlist:
            res['varlist'] = varlist
        if eq:
            res['='] = eq
        if if_:
            res['if'] = if_
        if in_:
            res['in'] = in_
        if weight:
            res['weight'] = weight
        if options:
            res['options'] = options
        return res 

def parse(lexer):
    return Parser(lexer).commands()

class Encoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Node):
            return dict(id=obj.id, value=obj.value, line=obj.line, column=obj.column)
        return json.JSONEncoder.default(self, obj)

def run(file):
    print(file)
    try:
        with open(file) as f:
            lexer = Lexer(f.read())
    except UnicodeError:
        with open(file, encoding='cp1252') as f:
            lexer = Lexer(f.read())

    commands = parse(lexer)
    os.makedirs(f'out/{os.path.dirname(file)}', exist_ok=True)
    with open(f'out/{file}.json', 'w') as f:
       json.dump(commands, f, indent=2, cls=Encoder)

    obj = dict(path=file, len=len(commands), len_comments=0, len_other=0, other=Counter(), regressions=Counter())
    for cat in categories:
        obj[cat] = {}
        obj[f'len_{cat}'] = 0

    for command in commands: 
        if isinstance(command, Literal) and command.id == 'comment':
            obj['len_comments'] += 1
            continue
        pre = [p['command'] for p in command.get('pre', [])]
        command = command['command']
        val = command.value
        if val in categories['regression']:
            key = ':'.join(sorted(x.value for x in pre) + [val]) if pre else val
            obj['regressions'][key] += 1
        for cmd in [command] + pre:
            if cmd.id != 'identifier':
                continue
            else:
                cmd = cmd.value
            other = True
            for cat, cmds in categories.items():
                if cat == 'no category':
                    continue
                if cmd in cmds:
                    obj[f'len_{cat}'] += 1
                    other = False
            if other:
                obj['len_other'] += 1
                obj['other'][cmd] += 1
    return obj

if __name__ == '__main__':
    stats, regs, others = [], Counter(), Counter()
    for file in glob.glob(sys.argv[1], recursive=True):
        stat = run(file)
        stats.append(stat)
        regs.update(stat.get('regressions'))
        others.update(stat.get('other'))
    with open(f'stats.json', 'w') as f:
        json.dump([dict(regs.most_common())] + [{k: v for k, v in s.items() if v} for s in stats], f, indent=2)

    categories['no category'] = others.most_common()
    with open('categories.json', 'w') as f:
        json.dump(categories, f, indent=2)

