/* cs152-miniL phase3 */


%{
#define YY_NO_UNPUT
#include <stdio.h>
#include <map>
#include <string.h>
#include <set>

int tempCount = 0;
int labelCount = 0;
extern char* = yytext;
extern int currPos;
std::map<std::string, std::string> varTemp;
std::map<std::string, int> arrSize;
bool mainFunc = false;
std::set<std::string> funcs;
std::set<std::string> reserved {"ASSIGN", "FOR", "COLON", "OR", "AND", "NOT", "LT", "LTE", "GT", "GTE", "EQ", "NEQ", "PLUS", "MINUS", "MULT", "DIV", "MOD", "UMINUS", "L_SQUARE_BRACKET", "R_SQUARE_BRACKET", "L_PAREN", "R_PAREN", "SEMICOLON", "COMMA",
"BEGINPARAMS", "ENDPARAMS", "FUNCTION", "ENDLOCALS", "BEGINLOCALS", "BEGINBODY", "ENDBODY", "NUM", "ARRAY", "OF", "INTEGER", "THEN", "ELSE", "IF", "ENDIF", "DO", "BEGINLOOP", "ENDLOOP", "WHILE", "READ", "WRITE", "CONTINUE", "RETURN", "TRUETOKEN", "FALSETOKEN", "IDENTIFIER", "NUMBER",
"functions", "function", "declarations", "statements", "declaration", "declaration2", "identifiers", "statement", "stateVar", "stateIf", "stateElse", "stateWhile", "stateDo", "stateRead", "vars", "stateWrite", "stateContinue", "stateReturn", "boolexpr", "relationAndExpr", "relationExpr", "relationExpr2", "relationExpression", "relationParentheses", "relationParentheses", "comp", "expression", "multiplicativeExpr", "term", "term1", "term2", "expressions", "var", "number", "identifier"
};
void yyerror(const char *msg);
int yylex();
std::string new_temp();
std::string new_label();

#include "lib.h"

%}

%union {
  int num_val;
  char* id_val;
  struct S {
      char* code;
  } statement;
  struct E {
      char* place;
      char* code;
      bool arr;
  } expression;
}

%error-verbose


%start program

%token <num_val> NUMBER
%token <id_val> IDENTIFIER
%type <expression> prog_start functions function declarations declaration declaration2 identifiers statement stateVar stateIf stateElse stateWhile stateDo stateRead
%type <expression> vars stateWrite stateContinue stateReturn boolexpr relationAndExpr relationExpr relationExpr2 relationExpression relationParentheses
%type <expression> comp expression multiplicativeExpr term term1 term2 expressions var number identifier
%type <statement> Statements Statement



%token ASSIGN FOR COLON OR AND NOT LT LTE GT GTE EQ NEQ PLUS MINUS MULT DIV MOD UMINUS L_SQUARE_BRACKET R_SQUARE_BRACKET L_PAREN R_PAREN SEMICOLON COMMA
%token BEGINPARAMS ENDPARAMS FUNCTION ENDLOCALS BEGINLOCALS BEGINBODY ENDBODY ENUM ARRAY OF INTEGER THEN ELSE IF ENDIF
%token DO BEGINLOOP ENDLOOP WHILE READ WRITE CONTINUE RETURN TRUETOKEN FALSETOKEN
%right ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left PLUS MINUS
%left MULT DIV MOD
%right UMINUS
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN
%%

  /* write your rules here */


%%

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
  extern int yylineno;
  extern char *yytext;

  printf("%s on line %d at char %d at symbol \"%s\"\n", s, yylineno, currpos, yytext);
  exit(1);
}

std::string new_temp() {
  std::string t = "t" + std::to_string(tempCount);
  tempCount++;
  return t;
}

std::string new_label() {
   std::string l = "L" + std::to_string(labelCount);
   labelCount++;
   return l;
}
