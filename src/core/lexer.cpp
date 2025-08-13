#include "global.h"
#include <cctype>
#include <cstdio>
#include <string>

// return the next token from standard input.
int gettok() {
    static int LastChar = ' ';

    while (std::isspace(LastChar)) {
        LastChar = getchar();
    }

    if (std::isalpha(LastChar)) {
        GlobIdentifierStr = LastChar;
        while (std::isalnum((LastChar = getchar())) != 0) {
            GlobIdentifierStr += LastChar;
        }

        if (GlobIdentifierStr == "def") {
            return tok_def;
        } else if (GlobIdentifierStr == "extern") {
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
        GlobNumVal = strtod(Numstr.c_str(), 0);
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

int getNextToken() { return GlobCurTok = gettok(); };