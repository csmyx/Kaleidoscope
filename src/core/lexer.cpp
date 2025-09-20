#include "fmt/core.h"
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
        } else if (GlobIdentifierStr == "if") {
            return tok_if;
        } else if (GlobIdentifierStr == "else") {
            return tok_else;
        } else if (GlobIdentifierStr == "for") {
            return tok_for;
        } else if (GlobIdentifierStr == "unary") {
            return tok_unary;
        } else if (GlobIdentifierStr == "binary") {
            return tok_binary;
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

    if (LastChar == '\'') {
        LastChar = getchar();

        if (LastChar == EOF) {
            GlobTokErrorInfo = "got EOF when single quotation is not paired";
            return tok_error;
        } else if (LastChar == '\\') {
            LastChar = getchar();
            switch (LastChar) {
            case 'n':
                GlobCharLiteral = '\n';
                break;
            case 'r':
                GlobCharLiteral = '\r';
                break;
            case 't':
                GlobCharLiteral = '\t';
                break;
            case '\\':
                GlobCharLiteral = '\\';
                break;
            case '\'':
                GlobCharLiteral = '\'';
                break;
            default:
                GlobTokErrorInfo = "invalid escape character";
                return tok_error;
            }
        } else {
            GlobCharLiteral = LastChar;
        }
        LastChar = getchar();
        if (LastChar != '\'') {
            GlobTokErrorInfo = "single quotation is not paired";
            return tok_error;
        }
        LastChar = getchar(); // eat '\''
        return tok_char_literal;
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

[[maybe_unused]] int getNextToken() {
    GlobCurTok = gettok();
    if (GlobCurTok == tok_error) {
        fmt::print(stderr, "Error in GetNextToken: {}\n", GlobTokErrorInfo);
        exit(1);
    }
    return GlobCurTok;
};

int GetCurTokPrecedence() {
    auto iter = BinopPrecedence.find(GlobCurTok);
    if (iter != BinopPrecedence.end()) {
        return iter->second;
    }
    return INVALID_TOK_PREC;
}
