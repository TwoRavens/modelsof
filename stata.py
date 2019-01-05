import collections
import glob
import json
import os, os.path
import sys

Token = collections.namedtuple('Token', 'type value line column')

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
                pos, line, col = self.get_current()
                while self.input[self.position - 1:self.position + 1] != '*/':
                    self.read_char()
                    if self.ch == '\0':
                        raise InputError(ch, line, col, self.input[pos - col + 1:pos + 10]) 
                tok = self.token('comment', self.input[pos:self.position + 1], line, col) 
            elif self.peek_char() == '/':
                pos, line, col = self.get_current()
                while True:
                    self.read_char()
                    if self.ch in '\n\0':
                        break
                tok = self.token('comment', self.input[pos:self.position], line, col)
        elif ch == '*':
            tok = self.token() 
            if not self.last_token or self.last_token.type == '\n':
                pos, line, col = self.get_current()
                while not self.peek_char() in '\n\0':
                    self.read_char()
                tok = self.token('comment', self.input[pos:self.position + 1], line, col) 
        elif ch == '#':
            pos, line, col = self.get_current()
            while not self.peek_char() in '\n\0':
                self.read_char()
            tok = self.token('comment', self.input[pos:self.position + 1], line, col) 
        elif ch == '~':
            tok = self.token() 
            if self.peek_char() == '=':
                pos, line, col = self.get_current()
                self.read_char()
                tok = self.token('~=', self.input[pos:self.position + 1], line, col) 
        elif ch == '!':
            tok = self.token() 
            if self.peek_char() == '=':
                pos, line, col = self.get_current()
                self.read_char()
                tok = self.token('!=', self.input[pos:self.position + 1], line, col) 
        elif ch == '=':
            tok = self.token() 
            if self.peek_char() == '=':
                pos, line, col = self.get_current()
                self.read_char()
                tok = self.token('==', self.input[pos:self.position + 1], line, col) 
        elif ch == '"':
            pos, line, col = self.get_current()
            pos += 1
            while True:
                self.read_char()
                if self.ch == '"':
                    break
                elif self.ch == '\0':
                    raise InputError(ch, line, col, self.input[pos - col + 1:pos + 10]) 
            tok = self.token('string', self.input[pos:self.position], line, col) 
        elif ch == '`':
            if self.peek_char() == '"':
                pos, line, col = self.get_current()
                while self.input[self.position - 1:self.position + 1] != '"\'':
                    self.read_char()
                    if self.ch == '\0':
                        raise InputError(ch, line, col, self.input[pos - col + 1:pos + 10]) 
                tok = self.token('string', self.input[pos:self.position + 1], line, col) 
            else:
                pos, line, col = self.get_current()
                pos += 1
                while True:
                    self.read_char()
                    if self.ch == "'":
                        break
                    elif self.ch == '\0':
                        raise InputError(ch, line, col, self.input[pos - col + 1:pos + 10]) 
                tok = self.token("`'", self.input[pos:self.position], line, col) 
        elif self.is_letter():
            pos, line, col = self.get_current()
            while self.is_letter() or self.ch == '.' or '0' <= self.ch <= '9':
                self.read_char()
            return self.token('identifier', self.input[pos:self.position], line, col) 
        elif self.is_digit():
            pos, line, col = self.get_current()
            while self.is_digit(first=False):
                self.read_char()
            return self.token('number', self.input[pos:self.position], line, col) 
        else:
            raise InputError(ch, self.line, self.column, self.input[self.position - self.column + 1:self.position + 10]) 

        self.read_char()
        self.last_token = tok
        return tok

    def skip_whitespace(self):
        while self.ch in ' \t':
            self.read_char()

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

    def is_letter(self):
        return 'A' <= self.ch <= 'Z' or 'a' <= self.ch <= 'z' or self.ch in '@_$'

    def is_digit(self, first=True):
        ch = self.ch
        return '0' <= ch <= '9' or ch in '.' or not first and 'a' <= ch <= 'z'

    def token(self, type='', value='', line=0, column=0):
        return Token(type or self.ch, value or self.ch, line or self.line, column or self.column) 

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
        if tok.type == '\n':
            line and lines.append(line)
            line = []
        else:
            tok1 = dict(type=tok.type, line=tok.line, column=tok.column)
            if tok.type != tok.value:
                tok1['value'] = tok.value
            line.append(tok1)

    os.makedirs('out/' + os.path.dirname(file), exist_ok=True)
    with open(f'out/{file}.json', 'w') as f:
       json.dump(lines, f, indent=2)

if __name__ == '__main__':
    for file in glob.glob(sys.argv[1], recursive=True):
        run(file)
