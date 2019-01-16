import collections
import glob
import json
import os, os.path
import sys

Token = collections.namedtuple('Token', 'id value line column')

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

        if ch in "\n\\,(){}[]<>|&+-:%;'^" or ord(ch) > 127:
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
                if self.input[pos:pos + 8] == '#delimit':
                    while self.position < pos + 8:
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
        while not self.peek_char() in '\n\0':
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
        return repr(self.value)

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
        next(self)

    def __iter__(self):
        return self

    def __next__(self):
        try:
            t = next(self.lexer)
        except StopIteration:
            self.token = End()
        else:
            Node = dict(
            ).get(t.id, Literal)
            self.token = Node(t)
        return self.token

    def expression(self, rbp=0):
        t = self.token
        left = t.null(next(self))
        while rbp < self.token.lbp:
            t = self.token
            left = t.left(left, next(self))
        return left

    def statements(self):
        statements = []
        while 1:
            if isinstance(self.token, End) or self.token.value == '}':
                next(self)
                break
            statement = self.statement()
            if statement:
                statements.append(statement)
        return statements

    def statement(self):
        statement = []
        while 1:
            if isinstance(self.token, End) or self.token.value == '\n':
                next(self)
                if statement and statement[-1].value == '///':
                    statement.pop()
                else:
                    break
            statement.append(self.expression())
        return statement

def parse(lexer):
    return Parser(lexer).statements()

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
    os.makedirs('out/' + os.path.dirname(file), exist_ok=True)
    with open(f'out/{file}.json', 'w') as f:
       json.dump(commands, f, indent=2, cls=Encoder)

    with open('categories.json') as f:
        categories = json.load(f)
    with open(f'ajps_commands.json', 'w') as f:
        obj = dict(path=file, len=len(commands), len_comments=0, len_other=0, other={})
        for cat in categories:
            obj[cat] = {}
            obj[f'len_{cat}'] = 0

        for command in commands: 
            command = command[0]
            if command.id == 'comment':
                obj['len_comments'] += 1
                continue
            cmd = command.value 
            other = True
            for cat, cmds in categories.items():
                if cmd in cmds:
                    obj[f'len_{cat}'] += 1
                    other = False
            if other:
                obj['len_other'] += 1
                if not obj['other'].get(cmd):
                    obj['other'][cmd] = {} 

        json.dump({k: v for k, v in obj.items() if v}, f, indent=2)


if __name__ == '__main__':
    for file in glob.glob(sys.argv[1], recursive=True):
        run(file)
        break
