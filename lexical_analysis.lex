   /* cs152-miniL phase1 */
%{
   /* write your C code here for definitions of variables and including headers */
   //fprintf(yyout, "text", str)
extern FILE *yyin, *yyout;
#include <stdio.h>
%}

   /* some common rules */
letter = [a-zA-Z]
digit = [0-9]
identifier = letter(letter|digit|_)*(letter|digit)*
number = digit+
%%
   /* specific lexer rules in regex */
"function"      {fprintf(yyout, "FUNCTION\n");}
"beginparams"   {fprintf(yyout, "BEGIN_PARAMS\n");}
"endparams"     {fprintf(yyout, "END_PARAMS\n");}
"beginlocals"   {fprintf(yyout, "BEGIN_LOCALS\n");}
"endlocals"     {fprintf(yyout, "END_LOCALS\n");}
"beginbody"     {fprintf(yyout, "BEGIN_BODY\n");}
"endbody"       {fprintf(yyout, "END_BODY\n");}
"integer"       {fprintf(yyout, "INTEGER\n");}
"array"         {fprintf(yyout, "ARRAY\n");}
"enum"          {fprintf(yyout, "ENUM\n");}
"of"            {fprintf(yyout, "OF\n");}
"if"            {fprintf(yyout, "IF\n");}
"then"          {fprintf(yyout, "THEN\n");}
"endif"         {fprintf(yyout, "ENDIF\n");}
"else"          {fprintf(yyout, "ELSE\n");}
"for"           {fprintf(yyout, "FOR\n");}
"while"         {fprintf(yyout, "WHILE\n");}
"do"            {fprintf(yyout, "DO\n");}
"beginloop"     {fprintf(yyout, "BEGINLOOP\n");}
"endloop"       {fprintf(yyout, "ENDLOOP\n");}
"continue"      {fprintf(yyout, "CONTINUE\n");}
"read"          {fprintf(yyout, "READ\n");}
"write"         {fprintf(yyout, "WRITE\n");}
"and"           {fprintf(yyout, "AND\n");}
"or"            {fprintf(yyout, "OR\n");}
"not"           {fprintf(yyout, "NOT\n");}
"true"          {fprintf(yyout, "TRUE\n");}
"false"         {fprintf(yyout, "FALSE\n");}
"return"        {fprintf(yyout, "RETURN\n");}
"-"             {fprintf(yyout, "SUB\n");}
"+"             {fprintf(yyout, "ADD\n");}
"*"             {fprintf(yyout, "MULT\n");}
"/"             {fprintf(yyout, "DIV\n");}
"%"             {fprintf(yyout, "MOD\n");}
"=="            {fprintf(yyout, "EQ\n");}
"<>"            {fprintf(yyout, "NEQ\n");}
[<^>]           {fprintf(yyout, "LT\n");}
[>^<]           {fprintf(yyout, "GT\n");}
"<="            {fprintf(yyout, "LTE\n");}
">="            {fprintf(yyout, "GTE\n");}
";"             {fprintf(yyout, "SEMICOLON\n");}
[:^=]           {fprintf(yyout, "COLON\n");}
","             {fprintf(yyout, "COMMA\n");}
"("             {fprintf(yyout, "L_PAREN\n");}
")"             {fprintf(yyout, "R_PAREN\n");}
"["             {fprintf(yyout, "L_SQUARE_BRACKET\n");}
"]"             {fprintf(yyout, "R_SQUARE_BRACKET\n");}
":="            {fprintf(yyout, "ASSIGN\n");}
number          {fprintf(yyout, "NUMBER %s\n", yytext);}
identifier      {fprintf(yyout, "IDENTIFIER %s\n", yytext);}
.               ;

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
