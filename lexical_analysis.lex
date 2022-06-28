   /* cs152-miniL phase1 */
%{
   int currLine = 0, currPos = 0;
   /* write your C code here for definitions of variables and including headers */
   //fprintf(yyout, "text", str)
extern FILE *yyin, *yyout;
#include <stdio.h>
%}

   /* some common rules */
letter = [a-zA-Z]
digit = [0-9]
identifier = letter(letter|digit|_)*(letter|digit)*

%%

   /* specific lexer rules in regex */
"function"      {fprintf(yyout, "FUNCTION\n"); currPos += yyleng;}
"beginparams"   {fprintf(yyout, "BEGIN_PARAMS\n"); currPos += yyleng;}
"endparams"     {fprintf(yyout, "END_PARAMS\n"); currPos += yyleng;}
"beginlocals"   {fprintf(yyout, "BEGIN_LOCALS\n"); currPos += yyleng;}
"endlocals"     {fprintf(yyout, "END_LOCALS\n"); currPos += yyleng;}
"beginbody"     {fprintf(yyout, "BEGIN_BODY\n"); currPos += yyleng;}
"endbody"       {fprintf(yyout, "END_BODY\n"); currPos += yyleng;}
"integer"       {fprintf(yyout, "INTEGER\n"); currPos += yyleng;}
"array"         {fprintf(yyout, "ARRAY\n"); currPos += yyleng;}
"enum"          {fprintf(yyout, "ENUM\n"); currPos += yyleng;}
"of"            {fprintf(yyout, "OF\n"); currPos += yyleng;}
"if"            {fprintf(yyout, "IF\n"); currPos += yyleng;}
"then"          {fprintf(yyout, "THEN\n"); currPos += yyleng;}
"endif"         {fprintf(yyout, "ENDIF\n"); currPos += yyleng;}
"else"          {fprintf(yyout, "ELSE\n"); currPos += yyleng;}
"for"           {fprintf(yyout, "FOR\n"); currPos += yyleng;}
"while"         {fprintf(yyout, "WHILE\n"); currPos += yyleng;}
"do"            {fprintf(yyout, "DO\n"); currPos += yyleng;}
"beginloop"     {fprintf(yyout, "BEGINLOOP\n"); currPos += yyleng;}
"endloop"       {fprintf(yyout, "ENDLOOP\n"); currPos += yyleng;}
"continue"      {fprintf(yyout, "CONTINUE\n"); currPos += yyleng;}
"read"          {fprintf(yyout, "READ\n"); currPos += yyleng;}
"write"         {fprintf(yyout, "WRITE\n"); currPos += yyleng;}
"and"           {fprintf(yyout, "AND\n"); currPos += yyleng;}
"or"            {fprintf(yyout, "OR\n"); currPos += yyleng;}
"not"           {fprintf(yyout, "NOT\n"); currPos += yyleng;}
"true"          {fprintf(yyout, "TRUE\n"); currPos += yyleng;}
"false"         {fprintf(yyout, "FALSE\n"); currPos += yyleng;}
"return"        {fprintf(yyout, "RETURN\n"); currPos += yyleng;}
"-"             {fprintf(yyout, "SUB\n"); currPos += yyleng;}
"+"             {fprintf(yyout, "ADD\n"); currPos += yyleng;}
"*"             {fprintf(yyout, "MULT\n"); currPos += yyleng;}
"/"             {fprintf(yyout, "DIV\n"); currPos += yyleng;}
"%"             {fprintf(yyout, "MOD\n"); currPos += yyleng;}
"=="            {fprintf(yyout, "EQ\n"); currPos += yyleng;}
"<>"            {fprintf(yyout, "NEQ\n"); currPos += yyleng;}
"<"             {fprintf(yyout, "LT\n"); currPos += yyleng;}
">"             {fprintf(yyout, "GT\n"); currPos += yyleng;}
"<="            {fprintf(yyout, "LTE\n"); currPos += yyleng;}
">="            {fprintf(yyout, "GTE\n"); currPos += yyleng;}
";"             {fprintf(yyout, "SEMICOLON\n"); currPos += yyleng;}
":"             {fprintf(yyout, "COLON\n"); currPos += yyleng;}
","             {fprintf(yyout, "COMMA\n"); currPos += yyleng;}
"("             {fprintf(yyout, "L_PAREN\n"); currPos += yyleng;}
")"             {fprintf(yyout, "R_PAREN\n"); currPos += yyleng;}
"["             {fprintf(yyout, "L_SQUARE_BRACKET\n"); currPos += yyleng;}
"]"             {fprintf(yyout, "R_SQUARE_BRACKET\n"); currPos += yyleng;}
":="            {fprintf(yyout, "ASSIGN\n"); currPos += yyleng;}
([0-9]+)        {fprintf(yyout, "NUMBER %s\n", yytext); currPos += yyleng;}

[##].* {currLine++; currPos = 1;}

([a-zA-Z]([a-zA-Z]|[0-9]|_)*([a-zA-Z]|[0-9]*))    {fprintf(yyout, "IDENTIFIER %s\n", yytext); currPos += yyleng;}

[0-9_][a-zA-Z0-9_]*[a-zA-Z0-9_] {printf("There is an error on line %d, at column %d: the identifier \"%s\" it must begin with a letter\n", currPos, currLine, yytext); exit(0);}
[a-zA-Z0-9_]*[_] {printf("There is an error on line %d, at column %d: the identifier \"%s\" it cannot end with an underscore\n", currPos, currLine, yytext); exit(0);}

[ ] {currPos += yyleng;}
[\t] {currPos += yyleng;}
"\n" {currLine++; currPos = 1;}
. {printf("There is an error on line %d. At column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%
        /* C functions used in lexer */

int main(int argc, char ** argv)
{

    yyin = fopen(argv[1], "r"); //input file to read
    yyout = fopen(argv[2], "w"); //output file to write
    if (!yyin || !yyout)
    {
        printf("Read/Write error\n");
        return -1;
    }
    yylex();

    

    fclose(yyin);
    fclose(yyout);

    return 0;

}
