%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char *msg);
    extern int currLine;
    extern int currPos;
    FILE *yyin;


%}

%union{
 int num_val;
 char* id_val;
}
%error-verbose
%locations
%start prog_start
%token ASSIGN FOR COLON OR AND NOT LT LTE GT GTE EQ NEQ PLUS MINUS MULT DIV MOD UMINUS L_SQUARE_BRACKET R_SQUARE_BRACKET L_PAREN R_PAREN SEMICOLON COMMA
%token BEGINPARAMS ENDPARAMS FUNCTION ENDLOCALS BEGINLOCALS BEGINBODY ENDBODY ENUM ARRAY OF INTEGER THEN ELSE IF ENDIF
%token DO BEGINLOOP ENDLOOP WHILE READ WRITE CONTINUE RETURN TRUETOKEN FALSETOKEN
%token <id_val> IDENTIFIER
%token <num_val> NUMBER
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

prog_start: functions   { printf("prog_start -> functions\n");  }
        |   error {yyerrok; yyclearin;}
        ;

functions:              { printf("functions -> epsilon\n");}
        |   function functions {printf("functions -> function functions\n");}
        ;

function:        FUNCTION identifier SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY {printf("function -> FUNCTION identifier SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY\n");}
        ;

declarations:       declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
        |           {printf("declarations -> epsilon\n");}
        |           declaration error {yyerrok;}

        ;

statements:         statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
        |           {printf("statements -> epsilon\n");}
        |           statement error {yyerrok;}
        ;

declaration:        identifiers COLON  declaration2 {printf("declaration -> identifiers COLON declarations2\n");}
        ;

declaration2:       ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF INTEGER {printf("declaration2 -> ARRAY L_BRACKET number R_BRACKET OF INTEGER\n");}
        |           ENUM L_PAREN identifiers R_PAREN {printf("declaration2 -> ENUM L_PAREN identifiers R_PAREN\n");}
        |           INTEGER {printf("declaration2 -> INTEGER\n");}
        ;

identifiers:        identifier COMMA identifiers {printf("identifiers -> IDENTIFIER COMMA identifiers\n");}
        |           identifier {printf("identifiers -> identifier\n");}
        ;

statement:         stateVar {printf("statement -> stateVar\n");}
        |           stateIf {printf("statement -> StateIf\n");}
        |           stateWhile {printf("statement -> stateWhile\n");}
        |           stateDo {printf("statement -> stateDo\n");}
        |           stateRead {printf("statement -> stateRead\n");}
        |           stateWrite {printf("statement -> stateWrite\n");}
        |           stateContinue {printf("statement -> stateContinue\n");}
        |           stateReturn {printf("statement -> stateReturn\n");}
        ;

stateVar:           var ASSIGN expression {printf("stateVar -> var ASSIGNMENT expression\n");}
        ;

stateIf:            IF boolexpr THEN statements stateElse ENDIF {printf("stateIf -> IF boolexpr THEN statements stateElse ENDIF\n");}
        ;

stateElse:          ELSE statements {printf("stateElse -> ELSE statements\n");}
        |           {printf("stateElse -> epsilon\n");}
        ;

stateWhile:         WHILE boolexpr BEGINLOOP statements ENDLOOP {printf("stateWhile -> WHILE boolexpr BEGINLOOP statements ENDLOOP\n");}
        ;

stateDo:            DO BEGINLOOP statements ENDLOOP WHILE boolexpr {printf("stateDo -> DO BEGINLOOP statements ENDLOOP WHILE boolexpr\n");}
        ;

stateRead:          READ vars {printf("stateRead -> READ vars\n");}
        ;

vars:               var COMMA vars {printf("vars -> var COMMA vars\n");}
        |           var {printf("vars -> var\n");}
        ;

stateWrite:         WRITE vars {printf("stateWrite -> WRITE vars\n");}
        ;

stateContinue:      CONTINUE {printf("stateContinue -> CONTINUE\n");}
        ;

stateReturn:        RETURN expression {printf("stateReturn -> RETURN expression\n");}
        ;

boolexpr:           boolexpr OR relationAndExpr {printf("boolexpr -> relationAndExpr OR boolexpr\n");}
        |           relationAndExpr {printf("boolexpr -> relationAndExpr\n");}
        ;

relationAndExpr:    relationExpr AND relationAndExpr {printf("relationAndExpr -> relationAnd\n");}
        |           relationExpr {printf("relationAndExpr -> relationExpr\n");}
        ;

relationExpr:       NOT relationExpr2 {printf("relationExpr -> relationExpr2\n");}
        |           relationExpr2 {printf("relationExpr -> relationExpr2\n");}
        ;

relationExpr2:      relationExpression {printf("relationExpr2 -> relationExpression\n");}
        |           TRUETOKEN {printf("relationExpr2 -> TRUETOKEN\n");}
        |           FALSETOKEN {printf("relationExpr2 -> FALSETOKEN\n");}
        |           relationParentheses {printf("relationExpr2 -> relationParentheses\n");}
        ;

relationExpression: expression comp expression {printf("relationExpression -> expression comp expression\n");}
        ;

relationParentheses: L_PAREN boolexpr R_PAREN {printf("relationParentheses -> L_PAREN boolexpr R_PAREN\n");}
        ;

comp:               EQ {printf("comp -> EQ\n");}
        |           NEQ {printf("comp -> NEQ\n");}
        |           LT {printf("comp -> LT\n");}
        |           GT {printf("comp -> GT\n");}
        |           LTE {printf("comp -> LTE\n");}
        |           GTE {printf("comp -> GTE\n");}
        ;

expression:         multiplicativeExpr PLUS expression {printf("expression -> multiplicativeExpr PLUS expression\n");}
        |           multiplicativeExpr MINUS expression {printf("expression -> multiplicativeExpr MINUS expression\n");}
        |           multiplicativeExpr {printf("expression -> multiplicativeExpr\n");}
        | error {yyerrok;}
        ;

multiplicativeExpr: term MULT multiplicativeExpr {printf("multiplicativeExpr -> term MULT multiplicativeExpr\n");}
        |           term DIV multiplicativeExpr {printf("multiplicativeExpr -> term DIV multiplicativeExpr\n");}
        |           term MOD multiplicativeExpr {printf("multiplicativeExpr -> term MOD multiplicativeExpr\n");}
        |           term {printf("multiplicativeExpr -> term\n");}
        ;

term:               UMINUS term1 {printf("term -> term1\n");}
        |           term1 {printf("term -> term1\n");}
        |           term2 {printf("term -> term2\n");}
        ;

term1:              var {printf("term1 -> var\n");}
        |           number {printf("term1 -> number\n");}
        |           L_PAREN expression R_PAREN {printf("term1 -> L_PAREN expression R_PAREN\n");}
        ;

term2:              identifier L_PAREN expressions R_PAREN {printf("term2 -> identifier L_PAREN expressions R_PAREN\n");}
        ;

expressions:        expression COMMA expressions {printf("expressions -> expression COMMA expressions\n");}
        |           expression {printf("expressions -> expression\n");}
        ;

var:                identifier {printf("var -> identifier\n");}
        |           identifier L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> identifier L_BRACKET expression R_BRACKET\n");}
        ;

number:             NUMBER {printf("number -> NUMBER %d", $1);}
        ;

identifier:         IDENTIFIER {printf("identifier -> IDENTIFIER %s",$1);}
        ;
%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}
void yyerror(const char *msg){
        printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
}
