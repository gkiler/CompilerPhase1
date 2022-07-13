   /* cs152-miniL phase1 */
%{
   #include <stdio.h>
   #include "y.tab.h"
   int currLine = 1, currPos = 1;
   /* write your C code here for definitions of variables and including headers */
   //fprintf(yyout, "text", str)

extern FILE *yyin, *yyout;


%}

   /* some common rules */
LETTER          [a-zA-Z]
DIGIT           [0-9]
IDENTIFIER      [{LETTER}](_?[{LETTER}{NUMBER}]+)*

%%

   /* specific lexer rules in regex */
function           {currPos += yyleng; return FUNCTION;}
beginparams     {currPos += yyleng; return BEGINPARAMS;}
endparams          {currPos += yyleng; return ENDPARAMS;}
beginlocals     {currPos += yyleng; return BEGINLOCALS;}
endlocals       {currPos += yyleng; return ENDLOCALS;}
beginbody          {currPos += yyleng; return BEGINBODY;}
endbody               {currPos += yyleng; return ENDBODY;}
integer               {currPos += yyleng; return INTEGER;}
array              {currPos += yyleng; return ARRAY;}
of                    {currPos += yyleng; return OF;}
if                    {currPos += yyleng; return IF;}
then                  {currPos += yyleng; return THEN;}
endif              {currPos += yyleng; return ENDIF;}
else                  {currPos += yyleng; return ELSE;}
while           {currPos += yyleng; return WHILE;}
do                    {currPos += yyleng; return DO;}
for                   {currPos += yyleng; return FOR;}
beginloop       {currPos += yyleng; return BEGINLOOP;}
endloop               {currPos += yyleng; return ENDLOOP;}
continue           {currPos += yyleng; return CONTINUE;}
read                  {currPos += yyleng; return READ;}
write              {currPos += yyleng; return WRITE;}
and                   {currPos += yyleng; return AND;}
or                    {currPos += yyleng; return OR;}
not                   {currPos += yyleng; return NOT;}
true                  {currPos += yyleng; return TRUETOKEN;}
false              {currPos += yyleng; return FALSETOKEN;}
return             {currPos += yyleng; return RETURN;}

"-"              {currPos += yyleng; return MINUS;}
"+"              {currPos += yyleng; return PLUS;}
"*"              {currPos += yyleng; return MULT;}
"/"              {currPos += yyleng; return DIV;}
"("             {currPos += yyleng; return L_PAREN;}
")"              {currPos += yyleng; return R_PAREN;}
":="             {currPos += yyleng; return ASSIGN;}
":"             {currPos += yyleng; return COLON;}
";"             {currPos += yyleng; return SEMICOLON;}
"["             {currPos += yyleng; return L_SQUARE_BRACKET;}
"]"             {currPos += yyleng; return R_SQUARE_BRACKET;}
","             {currPos += yyleng; return COMMA;}
"<"              {currPos += yyleng; return LT;}
"<="             {currPos += yyleng; return LTE;}
">"             {currPos += yyleng; return GT;}
">="             {currPos += yyleng; return GTE;}
"=="             {currPos += yyleng; return EQ;}
"<>"             {currPos += yyleng; return NEQ;}
"%"             {currPos += yyleng; return MOD;}
[0-9]+ {currPos += yyleng; yylval.num_val = atoi(yytext); return NUMBER;}


[##].* {currLine++; currPos = 1;}

[a-zA-Z0-9_]*[a-zA-Z0-9]* {currPos += yyleng; yylval.id_val = yytext; return IDENTIFIER;}



[ ] {currPos += yyleng;}
[\t] {currPos += yyleng;}
"\n" {currLine++; currPos = 1;}


%%
