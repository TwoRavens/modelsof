from collections import Counter, namedtuple, OrderedDict
import glob
import json
import os, os.path
import sys

with open('categories.json') as f:
    categories = json.load(f)

prefix_commands, command_aliases = [], dict()
for cat, commands in categories.items():
    for cmd, opts in commands.items():
        aliases = opts.get('synonyms', []) 
        if opts.get('abbrev'):
            aliases += [cmd[:i] for i in range(opts['abbrev'], len(cmd) + 1)]
        if opts.get('prefix'):
            prefix_commands += aliases
        for alias in aliases:
            command_aliases[alias] = cmd

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
            if not ch and self.ch == end and not (end == "'" and self.peek_char() == '"'):
                break
            if self.ch == '\0':
                raise InputError(ch or f'no closing {end}', line, col, self.input[pos - col + 1:pos + 10])
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
        match = 'A' <= self.ch <= 'Z' or 'a' <= self.ch <= 'z' or self.ch in '@_$.?'
        return match or (second and (self.ch == '#' or '0' <= self.ch <= '9'))

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
        commands = []
        while 1:
            if isinstance(self.token, End):
                next(self)
                break
            if self.token.value == '}':
                next(self)

            command = self.command()
            if command and command[-1].id == 'comment':
                commands.append(command.pop())
            if command:
                pre = []
                while len(command) > 1 and command[0].value in prefix_commands:
                    head = command[0].value
                    if head in prefix_commands:
                        pre.append(self.parse_command(command[:1]))
                        if command[1] and command[1].value == ':':
                            del command[1]
                        command = command[1:]
                        continue
                    if head in prefix_commands:
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
                varlist = command.get('varlist', [])
                cmd = OrderedDict(command=command['command'])
                val = command['command'].value
                alias = command_aliases.get(val, val)
                if len(varlist) > 1 and (alias in categories['regression/linear'] or alias in categories['regression/nonlinear']):
                    cmd['meta'] = dict(predictors=len(varlist) - 1)
                if pre:
                    cmd['pre'] = pre
                for key in 'varlist = if in weight options'.split():
                    if command.get(key):
                        cmd[key] = command[key]
                commands.append(cmd)
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
            is_cur = lambda v: not parens and token.value == v
            if token.id == '(':
                parens += 1
            elif token.id == ')':
                parens -= 1
            elif is_cur('='):
                cur = eq
            elif is_cur('if'):
                cur = if_
            elif is_cur('in'):
                cur = in_
            elif is_cur('['):
                cur = weight
            elif is_cur(','):
                cur = options
            else:
                cur.append(token)
        for (lst, k) in [(varlist, 'varlist'), (eq, '='), (if_, 'if'), (in_, 'in'), (weight, 'weight'), (options, 'options')]:
            if lst:
                res[k] = lst
        return res

def parse(lexer):
    return Parser(lexer).commands()

def run(file):
    print(file)
    try:
        with open(file, encoding='utf8') as f:
            lexer = Lexer(f.read())
    except UnicodeError:
        with open(file, encoding='cp1252') as f:
            lexer = Lexer(f.read())
    commands = parse(lexer)
    file1 = file.replace('\\', '/').replace('/downloads/', '/results/')
    os.makedirs(os.path.dirname(file1), exist_ok=True)
    with open(f'{file1}.json', 'w') as f:
       json.dump(commands, f, indent=2, cls=Encoder)

    obj = dict(path=file, len=len(commands), len_comments=0, len_prefix=0, len_other=0, other=Counter(), linear_regressions=Counter(), nonlinear_regressions=Counter())
    for cat in categories:
        obj[cat] = {}
        obj[f'len_{cat}'] = 0
    cmd_cnt = Counter()

    for command in commands:
        if isinstance(command, Literal) and command.id == 'comment':
            obj['len_comments'] += 1
            continue
            
        pre = [p['command'] for p in command.get('pre', [])]
        command = command['command']
        cmds = [x.value for x in pre + [command] if x.id == 'identifier']
        cmd_str = ':'.join(command_aliases.get(cmd, cmd) for cmd in cmds)
        for cmd in 'by bysort capture eststo noisily mi quietly xi'.split():
            cmd_str = cmd_str.replace(f'{cmd}:', '')
        if not cmd_str or '.' in cmd_str:
            continue

        cmd_cnt[cmd_str] += 1
        for kind in 'linear nonlinear'.split():
            if command_aliases.get(command.value, command.value) in categories['regression/' + kind]:
                obj[kind + '_regressions'][cmd_str] += 1
        for cmd in [command] + pre:
            if cmd.id != 'identifier':
                continue
            else:
                cmd = cmd.value
            other = True
            for cat, cmds in categories.items():
                if cat == 'no category':
                    continue
                if command_aliases.get(cmd, cmd) in cmds:
                    obj['len_prefix' if pre else f'len_{cat}'] += 1
                    other = False
            if other:
                obj['len_other'] += 1
                obj['other'][cmd] += 1
    return obj, cmd_cnt

class Encoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Node):
            return dict(id=obj.id, value=obj.value, line=obj.line, column=obj.column)
        return json.JSONEncoder.default(self, obj)

if __name__ == '__main__':
    journal = sys.argv[1]
    pattern = f'out/{journal}/**/*'
    cmds, stats, regs, others = Counter(), [], Counter(), Counter()
    for file in glob.glob(f'{pattern}.do', recursive=True):
        try:
            stat, cmd_cnt = run(file)
            cmds.update(cmd_cnt)
        except Exception as e:
            print('error:', e)
            input('ENTER TO CONTINUE')
            stat = dict(file=file, error=str(e))
        stats.append(stat)
        regs.update(stat.get('linear_regressions', []))
        regs.update(stat.get('nonlinear_regressions', []))
        others.update(stat.get('other', []))

    with open(f'out/{journal}/stats.json', 'w') as f:
        json.dump([dict(cmds.most_common())] + [dict(regs.most_common())] + [{k: v for k, v in s.items() if v} for s in stats], f, indent=2)

    categories['no category'] = dict({k: dict(num=v) for k, v in others.most_common()})
    with open('categories.json', 'w') as f:
        json.dump(categories, f, indent=2)
