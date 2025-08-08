#include <cctype>
#include <cstdio>
#include <string>

enum token
{
    tok_eof        = -1,
    tok_def        = -2,
    tok_extern     = -3,
    tok_identifier = -4,
    tok_number     = -5,
};

static std::string IdentifierStr;
static double NumVal;

// return the next token from standard input.
static auto gettok() -> int {
    static int LastChar = ' ';

    while (std::isspace(LastChar)) {
        LastChar = getchar();
    }

    if (std::isalnum(LastChar)) {
        IdentifierStr = LastChar;
        while (std::isalnum((LastChar = getchar())) != 0) {
            IdentifierStr += LastChar;
        }
        
        if (IdentifierStr == "def") {
            return tok_def;
        } else if (IdentifierStr == "extern") {
            return tok_extern;
        }
        return tok_identifier;
    }

    if (std::isdigit(LastChar) || LastChar == '.') {
        std::string Numstr{};
        do {
            Numstr += LastChar;
            LastChar = getchar();
        } while (std::isdigit(LastChar) || LastChar == '.');
        NumVal = strtod(Numstr.c_str(), 0);
        return tok_number;
    }

    if (LastChar == '#') {
        do {
            LastChar = getchar();
        } while (LastChar != EOF && LastChar != '\n' && LastChar != '\r');

        if (LastChar != EOF) {
            return gettok();
        }
    }

    if (LastChar == EOF) {
        return tok_eof;
    }

    // Otherwise, just return the character as its ascii value.
    int ThisChar = LastChar;
    LastChar = getchar();
    return ThisChar;
}

int Gettok() {
    return gettok();
}