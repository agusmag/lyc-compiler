
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     DIM = 258,
     OP_LESS = 259,
     OP_MORE = 260,
     OP_DIFF = 261,
     OP_SUM = 262,
     OP_MUL = 263,
     OP_RES = 264,
     OP_DIV = 265,
     OP_AND = 266,
     OP_EQQ = 267,
     OP_MOQ = 268,
     OP_ASIG = 269,
     OP_ASIG_CONS = 270,
     ID = 271,
     CONST = 272,
     CONST_REAL = 273,
     COMA = 274,
     CONST_INT = 275,
     AS = 276,
     FLOAT = 277,
     INTEGER = 278,
     PUT = 279,
     CAR_COMILLAS = 280,
     CONST_STR = 281,
     PUNTO_Y_COMA = 282,
     PUNTO = 283,
     GET = 284,
     WHILE = 285,
     PARENTESIS = 286,
     END_PARENTESIS = 287,
     OP_LEQ = 288,
     LLAVE = 289,
     END_LLAVE = 290,
     COMENTARIO_SIMPLE = 291,
     IF = 292,
     ELSE = 293,
     CORCHETE = 294,
     END_CORCHETE = 295,
     CONTAR = 296,
     COMILLA_ABRE = 297,
     COMILLA_CIERRA = 298,
     LISTA_CONTAR = 299
   };
#endif
/* Tokens.  */
#define DIM 258
#define OP_LESS 259
#define OP_MORE 260
#define OP_DIFF 261
#define OP_SUM 262
#define OP_MUL 263
#define OP_RES 264
#define OP_DIV 265
#define OP_AND 266
#define OP_EQQ 267
#define OP_MOQ 268
#define OP_ASIG 269
#define OP_ASIG_CONS 270
#define ID 271
#define CONST 272
#define CONST_REAL 273
#define COMA 274
#define CONST_INT 275
#define AS 276
#define FLOAT 277
#define INTEGER 278
#define PUT 279
#define CAR_COMILLAS 280
#define CONST_STR 281
#define PUNTO_Y_COMA 282
#define PUNTO 283
#define GET 284
#define WHILE 285
#define PARENTESIS 286
#define END_PARENTESIS 287
#define OP_LEQ 288
#define LLAVE 289
#define END_LLAVE 290
#define COMENTARIO_SIMPLE 291
#define IF 292
#define ELSE 293
#define CORCHETE 294
#define END_CORCHETE 295
#define CONTAR 296
#define COMILLA_ABRE 297
#define COMILLA_CIERRA 298
#define LISTA_CONTAR 299




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 67 "Sintactico.y"

int tipo_int;
double tipo_double;
char* tipo_str;
char* tipo_cmp;



/* Line 1676 of yacc.c  */
#line 149 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif

extern YYLTYPE yylloc;

