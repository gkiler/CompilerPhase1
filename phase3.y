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
prog_start: functions
        {

        }
        ;

functions:
        {

        }
        | function functions
        {

        }
        ;

function: FUNCTION identifier SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY
        {

        }
        ;

declaration: identifiers COLON declaration2
        {

        }
        ;

declaration2: ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF INTEGER
        {

        }
        | ENUM L_PAREN identifiers R_PAREN
        {

        }
        | INTEGER
        {

        }
        ;

identifiers: identifier COMMA identifiers
        {

        }
        | identifier
        {

        }
        ;

statement: stateVar
        {

        }
        | stateIf
        {

        }
        | stateWhile
        {

        }
        | stateDo
        {

        }
        | stateRead
        {

        }
        | stateWrite
        {

        }
        | stateContinue
        {

        }
        | stateReturn
        {

        }
        ;

stateVar: var ASSIGN expression
        {

        }
        ;

stateIf: IF boolexpr THEN statements stateElse ENDIF
        {

        }
        ;

stateElse: ELSE statements
        {

        }
        |
        {

        }
        ;

stateWhile: WHILE boolexpr BEGINLOOP statements ENDLOOP
        {

        }
        ;

stateDo: DO BEGINLOOP statements ENDLOOP WHILE boolexpr
        {

        }
        ;

stateRead: READ vars
        {

        }
        ;

vars: var COMMA vars
        {

        }
        | var
        {

        }
        ;

stateWrite: WRITE vars
        {

        }
        ;

stateContinue: CONTINUE
        {

        }
        ;

stateReturn: RETURN expression
        {

        }
        ;

boolexpr: boolexpr OR relationAndExpr
        {

        }
        | relationAndExpr
        {

        }
        ;

relationAndExpr: relationExpr AND relationAndExpr
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($1.code);
        temp.append($3.code);
        temp += ". " + dst + "\n";
        temp += "&& " + dst + ", ";
        temp.append($1.place);
        temp.append(", ");
        temp.append($3.place);
        temp.append("\n");
        $$.code strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | relationExpr
        {

        }
        ;

relationExpr: NOT relationExpr2
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($2.code);
        temp += ". " + dst + "\n";
        temp += "! " + dst + ", ";
        temp.append($2.place);
        temp.append("\n");
        $$.code strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | relationExpr2
        {
        $$.code=strdup($1.code);
        $$.place strdup($1.place);   
        }
        ;

relationExpr2: relationExpression
        {
        std :: string dst new_temp();
        std :: string temp;
        temp.append($1.code);
        temp.append($3.code);
        temp=temp"."+dst+"\n"+$2.place+dst+", " + $1.place + ", " + $3.place
        $$.code strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | TRUETOKEN
        {
        std::string temp;
        temp.append("1");
        $$.code=strdup("");
        $$.place=strdup(temp.c_str());
        }
        | FALSETOKEN
        {
        std :: string temp;
        temp.append("0");
        $$.code=strdup("");
        $$.place=strdup(temp.c_str());
        }
        | relationParentheses
        {
        $$.code=strdup($2.code);
        $$.place=strdup($2.place);
        }
        ;

relationExpression: expression comp expression
        {

        }
        ;

relationParentheses: L_PAREN boolexpr R_PAREN
        {

        }
        ;

comp: EQ
        {
        $$.code=strdup("");
        $$.place=strdup("==");
        }
        | NEQ
        {
        $$.code=strdup("");
        $$.place=strdup("!=");
        }
        | LT
        {
        $$.code=strdup("");
        $$.place=strdup("<");
        }
        | GT
        {
        $$.code=strdup("");
        $$.place=strdup(">");
        }
        | LTE
        {
        $$.code=strdup("");
        $$.place=strdup("<=");
        }
        | GTE
        {
        $$.code=strdup("");
        $$.place strdup(">=");
        }
        ;

expression: multiplicativeExpr PLUS expression
        {
        std :: string temp;
        std :: string dst=new_temp();
        temp.append($1.code);
        temp.append($3.code);
        temp+="."+dst+"\n";
        temp+="+"+dst+
        temp.append($1.place);
        temp+=11
        temp.append($3.place);
        temp+"\n";
        $$.code=strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | multiplicativeExpr MINUS expression
        {
        
        std :: string temp;
        std :: string dst=new_temp();
        temp.append($1.code);
        temp.append($3.code);
        temp += ". " + dst + "\n";
        temp += "- " + dst + ", ";
        temp.append($1.place);
        temp+=", ";
        temp.append($3.place);
        temp+="\n";
        $$.code=strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | multiplicativeExpr
        {
        $$.code=strdup($1.code);
        $$.place strdup($1.place);       
        }
        ;

multiplicativeExpr: term MULT multiplicativeExpr
        {
         std::string temp
         std::string dst = new_temp();
         temp.append($1.code);
         temp.append($3.code);
         temp.append(". ");
         temp.append(dst);
         temp.append("\n");
         temp += "* " + dst + ", ";
         temp.append($1.place);
         temp += ",";
         temp.append($3.place);
         temp += "\n";
         $$.code=strdup(temp.c_str());
         $$.place=strdup(dst.c_str());       

        }
        | term DIV multiplicativeExpr
        {

        }
        | term MOD multiplicativeExpr
        {

        }
        | term
        {

        }
        ;

term: UMINUS term1
        {

        }
        | term1
        {

        }
        | term2
        {

        }
        ;

term1:  var
        {

        }
        | number
        {

        }
        | L_PAREN expression R_PAREN
        {

        }
        ;

term2: identifier L_PAREN expressions R_PAREN
        {

        }
        ;

expressions: expression COMMA expressions
        {
        std::string temp;
        temp.append($1.code);
        temp.append("param");
        temp.append($1.place);
        temp.append("\n");
        temp.append($3.code);
        $$.code=strdup(temp.c_str());$$.code
        $$.place=strdup("");
        }
        | expression
        {
        std :: string temp;
        temp.append($1.code);
        temp.append("param");
        temp.append($1.place);
        temp.append("\n");
        $$.code = strdup(temp.c_str());
        $$.place=strdup("");
        }
        ;

var: identifier
        {

        }
        | identifier L_SQURE_BRACKET expression R_SQUARE_BRACKET
        {

        }
        ;

number: NUMBER
        {

        }
        ;

identifier: IDENTIFIER
        {

        }
        ;


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
