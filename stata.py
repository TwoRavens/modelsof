import collections
import json
import os, os.path
import sys

Token = collections.namedtuple('Token', 'type value line column')

class InputError(Exception):
    def __init__(self, char, line, column):
        self.char = char
        self.line = line
        self.column = column

class Lexer:
    def __init__(self, input):
        self.input = input
        self.position = 0
        self.read_position = 0
        self.ch = '\0' 
        self.line = 1
        self.column = 0
        self.read_char()

    def __iter__(self):
        return self

    def __next__(self):
        self.skip_whitespace()
        ch = self.ch
        if ch == '\0':
            raise StopIteration

        if ch in '\n\\,(){}[]<>|&+-:%':
            tok = self.token() 
        elif ch == '/':
            tok = self.token() 
            if self.peek_char() == '*':
                pos, line, col = self.position, self.line, self.column
                while self.input[self.position - 1:self.position + 1] != '*/':
                    self.read_char()
                tok = self.token('comment', self.input[pos:self.position + 1], line, col) 
            elif self.peek_char() == '/':
                pos, line, col = self.position, self.line, self.column
                while True:
                    self.read_char()
                    if self.ch == '\n' or self.ch == '\0':
                        break
                tok = self.token('///', self.input[pos:self.position], line, col) 
        elif ch == '!':
            tok = self.token() 
            if self.peek_char() == '=':
                pos, line, col = self.position, self.line, self.column
                self.read_char()
                tok = self.token('!=', self.input[pos:self.position + 1], line, col) 
        elif ch == '=':
            tok = self.token() 
            if self.peek_char() == '=':
                pos, line, col = self.position, self.line, self.column
                self.read_char()
                tok = self.token('==', self.input[pos:self.position + 1], line, col) 
        elif ch == '*':
            tok = self.token() 
            if self.column == 1:
                pos, line, col = self.position, self.line, self.column
                while self.peek_char() != '\n':
                    self.read_char()
                tok = self.token('comment', self.input[pos:self.position + 1], line, col) 
        elif ch == '#':
            pos, line, col = self.position, self.line, self.column
            while self.peek_char() != '\n':
                self.read_char()
            tok = self.token('comment', self.input[pos:self.position + 1], line, col) 
        elif ch == '"':
            pos, line, col = self.position + 1, self.line, self.column
            while True:
                self.read_char()
                if self.ch == '"' or self.ch == '\0':
                    break
            tok = self.token('string', self.input[pos:self.position], line, col) 
        elif ch == '`':
            pos, line, col = self.position + 1, self.line, self.column
            while True:
                self.read_char()
                if self.ch == "'" or self.ch == '\0':
                    break
            tok = self.token("`'", self.input[pos:self.position], line, col) 
        elif self.is_letter():
            pos, line, col = self.position, self.line, self.column
            while self.is_letter(first=False):
                self.read_char()
            return self.token('identifier', self.input[pos:self.position], line, col) 
        elif self.is_digit():
            pos, line, col = self.position, self.line, self.column
            while self.is_digit(first=False):
                self.read_char()
            return self.token('number', self.input[pos:self.position], line, col) 
        else:
            raise InputError(ch, self.line, self.column) 

        self.read_char()
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

    def is_letter(self, first=True):
        ch = self.ch
        return 'A' <= ch <= 'Z' or 'a' <= ch <= 'z' or ch in '_' or not first and (ch in '.' or '0' <= ch <= '9')

    def is_digit(self, first=True):
        ch = self.ch
        return '0' <= ch <= '9' or ch in '.' or not first and 'a' <= ch <= 'z'

    def token(self, type='', value='', line=0, column=0):
         return Token(type or self.ch, value or self.ch, line or self.line, column or self.column) 

if __name__ == '__main__':
    file = sys.argv[1]
    with open(file) as f:
        lexer = Lexer(f.read())

    lines, line = [], []
    for tok in lexer:
        if tok.type == '\n':
            line and lines.append(line)
            line = []
        else:
            line.append(dict(type=tok.type, value=tok.value, line=tok.line, column=tok.column))

    os.makedirs('out/' + os.path.dirname(file), exist_ok=True)
    with open(f'out/{file}.json', 'w') as f:
        json.dump(lines, f, indent=2)
