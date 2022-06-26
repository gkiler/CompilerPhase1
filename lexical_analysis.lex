   /* cs152-miniL phase1 */
%{
   /* write your C code here for definitions of variables and including headers */
   //fprintf(yyout, "text", str)
extern FILE *yyin, *yyout;
#include <stdio.h>
%}

   /* some common rules */

%%
   /* specific lexer rules in regex */
"hello world"   {fprintf(yyout, "hello");}
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
