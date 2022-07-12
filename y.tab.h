/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    COLON = 258,
    ASSIGNMENT = 259,
    OR = 260,
    AND = 261,
    NOT = 262,
    LT = 263,
    LTE = 264,
    GT = 265,
    GTE = 266,
    EQ = 267,
    NEQ = 268,
    PLUS = 269,
    MINUS = 270,
    MULT = 271,
    DIV = 272,
    MOD = 273,
    UMINUS = 274,
    L_BRACKET = 275,
    R_BRACKET = 276,
    L_PAREN = 277,
    R_PAREN = 278,
    SEMICOLON = 279,
    COMMA = 280,
    IDENTIFIER = 281,
    BEGINPARAMS = 282,
    ENDPARAMS = 283,
    FUNCTION = 284,
    ENDLOCALS = 285,
    BEGINLOCALS = 286,
    BEGINBODY = 287,
    ENDBODY = 288,
    ENUM = 289,
    NUMBER = 290,
    ARRAY = 291,
    OF = 292,
    INTEGER = 293,
    THEN = 294,
    ELSE = 295,
    IF = 296,
    ENDIF = 297,
    DO = 298,
    BEGINLOOP = 299,
    ENDLOOP = 300,
    WHILE = 301,
    READ = 302,
    WRITE = 303,
    CONTINUE = 304,
    RETURN = 305,
    TRUETOKEN = 306,
    FALSETOKEN = 307,
    F_SLASH = 308,
    B_SLASH = 309,
    IDENT = 310
  };
#endif

/* Value type.  */

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
