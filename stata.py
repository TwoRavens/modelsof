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
        self.last_token = None
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
                if self.peek_char() == '/' and self.last_token and self.last_token.id != '\n':
                    tok = self.read_to_end('///', cur) 
                else:
                    tok = self.read_to_end('comment', cur) 
        elif ch == '*':
            tok = self.token() 
            if not self.last_token or self.last_token.id == '\n':
                tok = self.read_to_end('comment') 
        elif ch == '#':
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
            tok = self.token(chars, self.input[pos:pos + 1], line, col) 
        return tok

    def read_char(self):
        self.ch = self.peek_char() 
        self.position = self.read_position
        self.read_position += 1
        self.column += 1
        if self.ch == '\n':
            self.line += 1
            self.column = 0
        return self.ch

    def peek_char(self):
        return '\0' if self.read_position >= len(self.input) else self.input[self.read_position]

    def get_current(self):
        return self.position, self.line, self.column

    def is_identifier(self, second=False):
        match = 'A' <= self.ch <= 'Z' or 'a' <= self.ch <= 'z' or self.ch in '@_$'
        return match or second and (self.ch == '.' or '0' <= self.ch <= '9')

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

def run(file):
    print(file)
    try:
        with open(file) as f:
            lexer = Lexer(f.read())
    except UnicodeError:
        with open(file, encoding='cp1252') as f:
            lexer = Lexer(f.read())

    lines, line = [], []
    for tok in lexer:
        if tok.id == '\n':
            line and lines.append(line)
            line = []
            continue
        if tok.id == '///':
            while True:
                tok = next(lexer)
                if tok.id != '\n':
                    break

        tok1 = dict(id=tok.id, line=tok.line, column=tok.column)
        if tok.id != tok.value:
            tok1['value'] = tok.value
        line.append(tok1)

    os.makedirs('out/' + os.path.dirname(file), exist_ok=True)
    with open(f'out/{file}.json', 'w') as f:
       json.dump(lines, f, indent=2)

if __name__ == '__main__':
    for file in glob.glob(sys.argv[1], recursive=True):
        run(file)
