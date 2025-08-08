#include <catch2/catch_test_macros.hpp>

enum token
{
    tok_eof        = -1,
    tok_def        = -2,
    tok_extern     = -3,
    tok_identifier = -4,
    tok_number     = -5,
};


TEST_CASE( "gettok", "[lexer]" ) {
    extern int Gettok();
    REQUIRE( Gettok() == -2 );
    // REQUIRE( Factorial(2) == 2 );
    // REQUIRE( Factorial(3) == 6 );
    // REQUIRE( Factorial(10) == 3628800 );
}
