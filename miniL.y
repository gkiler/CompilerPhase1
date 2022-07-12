%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char *msg)
    extern int currLine;
    extern int currPos;
    FILE * yyin;
%}

%error-verbose
%locations
%start prog_start
%token COLON ASSIGNMENT OR AND NOT LT LTE GT GTE EQ NEQ PLUS MINUS MULT DIV MOD UMINUS L_BRACKET R_BRACKET L_PAREN R_PAREN SEMICOLON COMMA
%token IDENTIFIER BEGINPARAMS ENDPARAMS FUNCTION ENDLOCALS BEGINLOCALS BEGINBODY ENDBODY ENUM NUMBER ARRAY OF INTEGER THEN ELSE IF ENDIF
%token DO BEGINLOOP ENDLOOP WHILE READ WRITE CONTINUE RETURN TRUETOKEN FALSETOKEN F_SLASH B_SLASH
%token <id_val> IDENT

%right ASSIGNMENT
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left PLUS MINUS
%left MULT DIV MOD
%right UMINUS
%left L_BRACKET R_BRACKET
%left L_PAREN R_PAREN

%%
prog_start: functions   { printf("prog_start -> functions\n");  }
        ;

functions:              { printf("functions -> epsilon\n")}
        |   function functions {printf("functions -> function functions\n");}
        ;

function:        FUNCTION IDENTIFIER SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY {printf("function -> FUNCTION IDENTIFIER SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY\n")}
        ;

declarations:       declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n")}
        |           {printf("declarations -> epsilon\n")}
        ;

statements:         statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n")}
        |           {printf("statements -> epsilon\n")}
        ;

declaration:        identifiers COLON  declaration2 {printf("declaration -> identifiers COLON declarations2\n")}
        ;

declaration2:       ARRAY L_BRACKET NUMBER R_BRACKET OF INTEGER {printf("declaration2 -> ARRAY L_BRACKET NUMBER R_BRACKET OF INTEGER\n")}
        |           ENUM L_PAREN identifiers R_PAREN {printf("declaration2 -> ENUM L_PAREN identifiers R_PAREN\n")}
        |           INTEGER {printf("declaration2 -> INTEGER\n")}
        ;

identifiers:        IDENTIFIER COMMA identifiers {printf("identifiers -> IDENTIFIER COMMA identifiers\n")}
        |           IDENTIFIER {printf("identifiers -> IDENTIFIER\n")}
        ;

statements:         stateVar {printf("statements -> stateVar\n")}
        |           stateIf {printf("statements -> StateIf\n")}
        |           stateWhile {printf("statements -> stateWhile\n")}
        |           stateDo {printf("statements -> stateDo\n")}
        |           stateRead {printf("statements -> stateRead\n")}
        |           stateWrite {printf("statements -> stateWrite\n")}
        |           stateContinue {printf("statements -> stateContinue\n")}
        |           stateReturn {printf("statements -> stateReturn\n")}
        ;

stateVar:           var ASSIGNMENT expression {printf("stateVar -> var ASSIGNMENT expression\n")}
        ;

stateIf:            IF boolexpr THEN statements stateElse ENDIF {printf("stateIf -> IF boolexpr THEN statements stateElse ENDIF\n")}
        ;

stateElse:          ELSE statements {printf("stateElse -> ELSE statements\n")}
        |           {printf("stateElse -> epsilon\n")}
        ;

stateWhile:         WHILE boolexpr BEGINLOOP statements ENDLOOP {printf("stateWhile -> WHILE boolexpr BEGINLOOP statements ENDLOOP\n")}
        ;

stateDo:            DO BEGINLOOP statements ENDLOOP WHILE boolexpr {printf("stateDo -> DO BEGINLOOP statements ENDLOOP WHILE boolexpr\n")}
        ;

stateRead:          READ vars {printf("stateRead -> READ vars\n")}
        ;

vars:               var COMMA vars {printf("vars -> var COMMA vars\n")}
        |           var {printf("vars -> var\n")}
        ;

stateWrite:         WRITE vars {printf("stateWrite -> WRITE vars\n")}
        ;

stateContinue:      CONTINUE {printf("stateContinue -> CONTINUE\n")}
        ;

stateReturn:        RETURN expression {printf("stateReturn -> RETURN expression\n")}
        ;

boolexpr:           boolexpr OR relationAndExpr {printf("boolexpr -> relationAndExpr OR boolexpr\n")}
        |           relationAndExpr {printf("boolexpr -> relationAndExpr\n")}
        ;

relationAndExpr:    relationExpr AND relationAndExpr {printf("relationAndExpr -> relationAnd\n")}
        |           relationExpr {printf("relationAndExpr -> relationExpr\n")}
        ;

relationExpr:       NOT relationExpr2 {printf("relationExpr -> relationExpr2\n")}
        |           relationExpr2 {printf("relationExpr -> relationExpr2\n")}
        ;

relationExpr2:      relationExpression {printf("relationExpr2 -> relationExpression\n")}
        |           TOKENTRUE {printf("relationExpr2 -> TOKENTRUE\n")}
        |           TOKENFALSE {printf("relationExpr2 -> TOKENFALSE\n")}
        |           relationParentheses {printf("relationExpr2 -> relationParentheses\n")}
        ;

relationExpression: expression comp expression {printf("relationExpression -> expression comp expression\n")}
        ;

relationParentheses: L_PAREN boolexpr R_PAREN {printf("relationParentheses -> L_PAREN boolexpr R_PAREN\n")}
        ;

comp:               EQ {printf("comp -> EQ\n")}
        |           NEQ {printf("comp -> NEQ\n")}
        |           LT {printf("comp -> LT\n")}
        |           GT {printf("comp -> GT\n")}
        |           LTE {printf("comp -> LTE\n")}
        |           GTE {printf("comp -> GTE\n")}
        ;

expression:         multiplicativeExpr PLUS expression {printf("expression -> multiplicativeExpr PLUS expression\n")}
        |           multiplicativeExpr MINUS expression {printf("expression -> multiplicativeExpr MINUS expression\n")}
        |           multiplicativeExpr {printf("expression -> multiplicativeExpr\n")}
        ;

multiplicativeExpr: term MULT multiplicativeExpr {printf("multiplicativeExpr -> term MULT multiplicativeExpr\n")}
        |           term F_SLASH multiplicativeExpr {printf("multiplicativeExpr -> term F_SLASH multiplicativeExpr\n")}
        |           term MOD multiplicativeExpr {printf("multiplicativeExpr -> term MOD multiplicativeExpr\n")}
        |           term {printf("multiplicativeExpr -> term\n")}
        ;

term:               UMINUS term1 {printf("term -> term1\n")}
        |           term1 {printf("term -> term1\n")}
        |           term2 {printf("term -> term2\n")}
        ;

term1:              var {printf("term1 -> var\n")}
        |           NUMBER {printf("term1 -> NUMBER\n")}
        |           L_PAREN expression R_PAREN {printf("term1 -> L_PAREN expression R_PAREN\n")}
        ;

term2:              IDENTIFIER L_PAREN expressions R_PAREN {printf("term2 -> IDENTIFIER L_PAREN expressions R_PAREN\n")}
        ;

expressions:        expression COMMA expressions {printf("expressions -> expression COMMA expressions\n")}
        |           expression {printf("expressions -> expression\n")}
        ;

var:                IDENTIFIER {printf("var -> IDENTIFIER\n")}
        |           IDENTIFIER L_BRACKET expression R_BRACKET {printf("var -> IDENTIFIER L_BRACKET expression R_BRACKET\n")}
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

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}
            