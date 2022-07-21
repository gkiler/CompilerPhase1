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
        if (!mainFunc) {
                printf("No main function detected!\n");
        }
        }
        | function prog_start
        {

        }
        ;

function: FUNCTION funcidentifier SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY
        {
        std::string temp = "func ";
        temp.append($2.place);
        temp.append("\n");
        std::string s = $2.place;
        if (s == "main") {
                mainFunc = true;
        }
        temp.append($5.code);
        std::string decs = $5.code;
        int decNum = 0;
        while (decs.find(".") != std::string::npos) {
                int pos = decs.find(".");
                decs.replace(pos, 1, "=");
                std::string part = ", $" + std::to_string(decNum) + "\n";
                decNum++;
                decs.replace(decs.find("\n",pos),1,part);
        }
        temp.append(decs);
        temp.append($8.code);
        std::string statements = $11.code;
        if (statements.find("continue") != std:;string::npos) {
                printf("ERROR: Continue outside loop in function %s\n", $2.place);
        }
        temp.append(statements);
        temp.append("endfunc\n\n");
        printf(temp.c_str());
        }
        ;

declarations: declaration SEMICOLON declarations
        {
        std::string temp;
        temp.append($1.code);
        temp.append($3.code);
        $$.code = strdup(temp.c_str());
        $$.place = strdup("");
        }
        |
        {
        $$.place = strdup("");
        $$.code = strdup("");
        }
        ;

declaration: identifiers COLON INTEGER
        {
        int left = 0;
        int right = 0;
        std::string parse($1.place);
        std::string temp;
        bool ex = false;
        while (!ex) {
                right = parse.find("|",left);
                temp.append(". ");
                if (right == std::string::npos) {
                        std::string ident = parse.substr(left, right);
                        if (reserved.find(ident) != reserved.end()) {
                                printf("Identifier %s's name is a reserved word.\n", ident.c_str());
                        }
                        if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
                                printf("Identifier %s is previously declared.\n", ident.c_str());
                        } else {
                                varTemp[ident] = ident;
                                arrSize[ident] = 1;
                        }
                        temp.append(ident);
                        ex = true;
                } else {
                        std::string ident = parse.substr(left, right-left);
                        if (reserved.find(ident != reserved.end())) {
                                printf("Identifier %s's name is a reserved word.\n", ident.c_str());
                        }
                        if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
                                printf("Identifier %s is previously declared.\n", ident.c_str());
                        } else {
                                varTemp[ident] = ident;
                                arrSize[ident] = 1;
                        }
                        temp.append(ident);
                        ex = true;
                }
                left = right;
        }
        $$.place = strdup(parse.c_str());
        $$.code = strdup(temp.c_str());
        }
        | identifiers COLON ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF INTEGER
        {
        int left = 0;
        int right = 0;
        std::string parse($1.place);
        std::string temp;
        bool ex = false;
        while (!ex) {
                right = parse.find("|",left);
                temp.append(".[] ");
                if (right == std::string::npos) {
                        std::string ident = parse.substr(left, right);
                        if (reserved.find(ident) != reserved.end()) {
                                printf("Identifier %s's name is a reserved word.\n", ident.c_str());
                        }
                        if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
                                printf("Identifier %s is previously declared.\n", ident.c_str());
                        } else {
                                varTemp[ident] = ident;
                                arrSize[ident] = $5.place;
                        }
                        temp.append(ident);
                        ex = true;
                } else {
                        std::string ident = parse.substr(left, right-left);
                        if (reserved.find(ident != reserved.end())) {
                                printf("Identifier %s's name is a reserved word.\n", ident.c_str());
                        }
                        if (funcs.find(ident) != funcs.end() || varTemp.find(ident) != varTemp.end()) {
                                printf("Identifier %s is previously declared.\n", ident.c_str());
                        } else {
                                varTemp[ident] = ident;
                                arrSize[ident] = $5.place;
                        }
                        temp.append(ident);
                        ex = true;
                }
                left = right;
        }
        $$.place = strdup(parse.c_str());
        $$.code = strdup(temp.c_str());
        }
        ;

identifiers: identifier COMMA  identifiers
        {
        std::string temp;
        temp.append($1.place);
        temp.append("|");
        temp.append($3.place);
        $$.place = strdup(temp.c_str());
        $$.code = strdup("");
        }
        | identifier
        {
        $$.code = strdup("");
        $$.place = strdup($1.place);
        }
        ;

funcidentifier: IDENTIFIER
        {
                if (funcs.find($1) != funcs.end()) {
                        printf("function name %s already declared.\n", $1);
                } else {
                        funcs.insert($1);
                }
        $$.place = strdup($1);
        $$.code = strdup("");
        }
        ;

statement: stateVar
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateIf
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateWhile
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateDo
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateRead
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateWrite
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateContinue
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | stateReturn
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        ;

stateVar: var ASSIGN expression
        {
                std::string temp;
            temp.append($1.code);
            temp.append($3.code);
            std::string intermediate = $3.place;

            //check arary
            if ($1.arr && $3.arr) {
                  intermediate = new_temp();
                  temp.append(". ");
                  temp.append(intermediate);
                  temp.append("\n");
                  temp.append("=[] ");
                  temp.append(intermediate);
                  temp.append(", ");
                  temp.append($3.place);
                  temp.append("\n");
                  temp.append("[]= ");
            }
            else if ($1.arr) {
                  temp.append("[]= ");
            }
            else if ($3.arr) {
                  temp.append("=[] ");
            }
            else {
                  temp.append("= ");
            }
            temp.append($1.place);
            temp.append(", ");
            temp.append(intermediate);
            temp.append("\n");

            $$.code = strdup(temp.c_str());

        }
        ;

stateIf: IF boolexpr THEN statements stateElse ENDIF
        {
        std::string then_ = new_label();
        std::string end_ = new_label();
        std::string temp;

        // if 
        temp.append($2.code);
        temp.append("?:= ");
        temp.appen(then_);
        temp.appen(", ");
        temp.appen($2.place);
        temp.appen("\n");
        //else
        temp.appen($6.code);
        temp.appen(":= ");
        temp.appen(end_);
        temp.appen("\n");
        //then
        temp.appen(": ");
        temp.appen(then_);
        temp.appen("\n");
        temp.appen($4.code);
        //end
        temp.appen(": ");
        temp.appen(end_);
        temp.appen("\n");

        $$.code = strdup(temp.c_str());
        }
        ;

stateElse: ELSE statements
        {
        std::string then_ = new_label(); 
            std::string end_ = new_label();
            std::string temp; 

            temp.append($2.code);
            // if true
            temp.append("?:= ");
            temp.append(then_);
            temp.append(", ");
            temp.append($2.place);
            temp.append("\n");
            // else code
            temp.append($6.code);
            temp.append(":= ");
            temp.append(end_);
            temp.append("\n");
            // then_ label
            temp.append(": ");
            temp.append(then_);
            temp.append("\n");
            temp.append($4.code);
            // end_ label
            temp.append(": ");
            temp.append(end_);
            temp.append("\n");
            
            $$.code = strdup(temp.c_str());
        }
        |
        {

        }
        ;

stateWhile: WHILE boolexpr BEGINLOOP statements ENDLOOP
        {
        std::string temp;
            std::string beginWhile = new_label();
            std::string beginLoop = new_label();
            std::string endLoop = new_label();

            std::string state = $4.code;
            std::string jump;
            jump.append(":= ");
            jump.append(beginWhile);
            while (state.find("continue") != std::string::npos) {
                  state.replace(state.find("continue"), 8, jump);
            }

            //start the expression
            //print the while label
            temp.append(": ");
            temp.append(beginWhile);
            temp.append("\n");

            //write the bool expression
            //print the loop label
            temp.append($2.code);
            temp.append("?:= ");
            temp.append(beginLoop);
            temp.append(", ");
            temp.append($2.place);
            temp.append("\n");
            temp.append(":= ");
            temp.append(endLoop);
            temp.append("\n");
            temp.append(": ");
            temp.append(beginLoop);
            temp.append("\n");
            temp.append(state);
            temp.append(":= ");
            temp.append(beginWhile);
            temp.append("\n");
            temp.append(": ");
            temp.append(endLoop);
            temp.append("\n");

            $$.code = strdup(temp.c_str());
        }
        ;

stateDo: DO BEGINLOOP statements ENDLOOP WHILE boolexpr
        {
        std::string temp;
            std::string beginLoop = new_label();
            std::string beginWhile = new_label();
            std::string state = $3.code;
            std::string jump;
            jump.append(":= ");
            jump.append(beginWhile);
            
            while (state.find("continue") != std::string::npos) {
                  state.replace(state.find("continue"), 8, jump);
            }

            temp.append(": ");
            temp.append(beginLoop);
            temp.append("\n");
            temp.append(state);
            temp.append(": ");
            temp.append(beginWhile);
            temp.append("\n");
            temp.append($6.code);
            temp.append("?:= ");
            temp.append(beginLoop);
            temp.append(", ");
            temp.append($6.place);
            temp.append("\n");

            $$.code = strdup(temp.c_str());
        }
        ;

stateRead: READ vars
        {
        std::string temp;
        temp.append($2.code);
        size_t pos = temp.find("|", 0);
        while (pos != std:;string::npos) {
                temp.replace(pos, 1, "<");
                pos = temp.find("|", pos);
        }
        $$.code = strdup(temp.c_str());
        }
        ;

vars: var  vars
        {
        std::string temp;
        temp.append($1.code);
        if ($1.arr) {
                temp.append(".[]| ");
        } else {
                temp.append(". | ");
        }
        temp.append($1.place);
        temp.append("\n");
        temp.append($3.code);
        $$.code = strdup(temp.c_str());
        $$.place = strdup("");
        }
        | var
        {
        std::string temp;
        temp.append($1.code);
        if ($1.arr) {
                temp.append(".[]| ");
        } else {
                temp.append(". | ");
        }
        temp.append($1.place);
        temp.append("\n");
        $$.code = strdup(temp.c_str());
        $$.place = strdup("");
        }
        ;

stateWrite: WRITE vars
        {
        std::string temp;
        temp.append($2.code);
        size_t pos = temp.find("|", 0);
        while (pos != std::string::npos) {
                temp.replace(pos,1,">");
                pos = temp.find("|", pos);
        }
        $$.code = strdup(temp.c_str());
        }
        ;

stateContinue: CONTINUE
        {
        $$.code = strdup("continue\n");
        }
        ;

stateReturn: RETURN expression
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($2.code);
        temp += "ret " + dst + "\n";
        temp.append($2.place);
        temp.append("\n");
        $$.code = strdup(temp.c_str());
        }
        ;

boolexpr: boolexpr OR relationAndExpr
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($1.code);
        temp.append($2.code);
        temp += ". " + dst + "\n";
        temp += "|| " + dst + ", ";
        temp.append($1.place);
        temp.append(", ");
        temp.append($3.place);
        temp.append("\n");
        $$.code = strdup(temp.c_str());
        $$.place = strdup(dst.c_str());

        }
        | relationAndExpr
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
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
        $$.code=strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | relationExpr
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
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
        $$.place= strdup($1.place);
        }
        ;

relationExpr2: relationExpression
        {
        $$.code = strdup($1.code)
        $$.place = strdup($1.place);
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
        $$.code=strdup($1.code);
        $$.place=strdup($1.place);
        }
        ;

relationExpression: expression  expression
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($1.code);
        temp.append($3.code);
        temp.append(". ");
        temp.append(dst);
        temp.append("\n");
        temp.append($2.place); //idk if this is right
        temp += dst + ", ";
        temp.append($1.place);
        temp +=", ";
        temp.append($3.place);
        temp += "\n";
        $$.code = strdup(temp.c_str());
        $$.place = strdup(dst.c_str());
        }
        ;

relationParentheses: L_PAREN boolexpr R_PAREN
        {
        $$.code = strdup($2.code);
        $$.place = strdup($2.place);
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
         std::string temp;
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
        std::string temp;
        std::string dst = new_temp();
        temp.append($1.code);
        temp.append($3.code);
        temp.append(". ");
        temp.append(dst);
        temp.append("\n");
        temp += "/ " + dst + ", ";
        temp.append($1.place);
        temp += ",";
        temp.append($3.place);
        temp += "\n";
        $$.code=strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | term MOD multiplicativeExpr
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($1.code);
        temp.append($3.code);
        temp.append(". ");
        temp.append(dst);
        temp.append("\n");
        temp += "% " + dst + ", ";
        temp.append($1.place);
        temp += ",";
        temp.append($3.place);
        temp += "\n";
        $$.code=strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        | term
        {
        std::string temp;
        std::string dst = new_temp();
        temp.append($1.code);
        temp.append(". ");
        temp.append(dst);
        temp.append("\n");
        temp.append($1.place);
        temp += "\n";
        $$.code = strdup(temp.c_str());
        $$.place=strdup(dst.c_str());
        }
        ;

term: UMINUS term1
        {

        }
        | term1
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | term2
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        ;

term1:  var
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | number
        {
        $$.code = strdup($1.code);
        $$.place = strdup($1.place);
        }
        | L_PAREN expression R_PAREN
        {
        $$.code = strdup($2.code);
        $$.place = strdup($2.place);
        }
        ;

term2: identifier L_PAREN expressions R_PAREN
        {
        std::string temp; 
            temp.append($3.code);
            temp.append("* ");
            temp.append($3.place);
            temp.append(", ");
            temp.append($3.place);
            temp.append(", -1\n");
            $$.code = strdup(temp.c_str());
            $$.place = strdup($3.place);
        }
        ;

expressions: expression COMMA  expressions
        {
        std::string temp;
        temp.append($1.code);
        temp.append("param");
        temp.append($1.place);
        temp.append("\n");
        temp.append($3.code);
        $$.code=strdup(temp.c_str());
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
        std::string temp;
        std::string identifier = $1.place;
        if (funcs.find(identifier) == funcs.end() && varTemp.find(identifier) == varTemp.end()) {
                printf("Identifier %s is not declared.\n", identifier.c_str());
        } else if (arrSize[ident] == 1) {
                printf("Provided index for non-array Identifier %s.\n", identifier.c_str());
        }
        $$.code = strdup("");
        $$.place = strdup(identifier.c_str());
        $$.arr = false;
        }
        | identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET
        {
        std::string temp;
        std::string identifier = $1.place;
        if (funcs.find(identifier) == funcs.end() && varTemp.find(identifier) == varTemp.end()) {
                printf("Identifier %s is not declared.\n", identifier.c_str());
        } else if (arrSize[identifier] == 1) {
                printf("Provided index for non-array Identifier %s.\n", identifier.c_str());
        }
        temp.append($1.place);
        temp.append(", ");
        temp.append($3.place);
        $$.code = strdup($3.code)
        $$.place = strdup(temp.c_str());
        $$.arr = true;
        }
        ;

statements: statement SEMICOLON statements
        {
        std::string temp;
        temp.append($1.code);
        temp.append($3.code);
        $$.code = strdup(temp.c_str());
        }
        | statement SEMICOLON
        {
        $$.code = strdup($1.code);
        }
        ;

number: NUMBER
        {
        $$.place = $1.place;
        $$.code = ("");
        }
        ;

identifier: IDENTIFIER
        {
        $$.place = $1.place;
        $$.code = ("");
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
