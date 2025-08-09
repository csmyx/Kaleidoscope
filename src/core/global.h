#pragma once

#include <string>

enum token
{
    tok_eof        = -1,
    tok_def        = -2,
    tok_extern     = -3,
    tok_identifier = -4,
    tok_number     = -5,
};
extern std::string GlobIdentifierStr;
extern double GlobNumVal;
extern int GlobCurTok;
int getNextToken();

// parser
void ParseMainLoop();
