
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 1



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 3 "Sintactico.y"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
#define YYERROR_VERBOSE 1
#define ES_CONST_NOMBRE 1
#define NO_ES_CONST_NOMBRE 0
FILE  *yyin;

//char vecAux[35];

/* --- Tabla de simbolos --- */
typedef struct
{
        char *nombre;
        char *tipo;
        union Valor{
                int valor_int;
                double valor_double;
                char *valor_str;
        }valor;
        int longitud;
}t_data;

typedef struct s_simbolo
{
        t_data data;
        struct s_simbolo *next;
}t_simbolo;


typedef struct
{
        t_simbolo *primero;
}t_tabla;

void crearTablaTS();
int insertarTS(const char*, const char*, const char*, int, double, int);
t_data* crearDatos(const char*, const char*, const char*, int, double, int);
void guardarTS();
void limpiarConstanteString();
t_tabla tablaTS;

char idvec[50][50];
int cantid = 0, i=0, cant_aux=0;
char vecAux[50];
char* punt;
char pos[2];
char* separador1;
char nombre[50];
char tipo_dato[50];

int j=0;

/* --- Validaciones --- */
int existeID(const char*);
int esNumero(const char*,char*);
char mensajes[100];



/* Line 189 of yacc.c  */
#line 136 "y.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


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

/* Line 214 of yacc.c  */
#line 67 "Sintactico.y"

int tipo_int;
double tipo_double;
char* tipo_str;
char* tipo_cmp;



/* Line 214 of yacc.c  */
#line 269 "y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

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


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 294 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
	     && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   125

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  45
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  38
/* YYNRULES -- Number of rules.  */
#define YYNRULES  71
/* YYNRULES -- Number of states.  */
#define YYNSTATES  122

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   299

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint8 yyprhs[] =
{
       0,     0,     3,     4,     7,     8,    11,    14,    16,    18,
      20,    23,    25,    28,    33,    38,    43,    45,    46,    47,
      53,    54,    63,    65,    69,    73,    75,    76,    81,    82,
      87,    89,    90,    95,    96,   101,   103,   107,   109,   111,
     113,   115,   119,   128,   130,   132,   134,   136,   138,   140,
     141,   147,   151,   153,   154,   155,   161,   163,   167,   169,
     171,   173,   177,   185,   186,   199,   205,   206,   210,   211,
     215,   216
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      46,     0,    -1,    -1,    47,    48,    -1,    -1,    49,    50,
      -1,    50,    51,    -1,    51,    -1,    56,    -1,    68,    -1,
      52,    27,    -1,    77,    -1,    79,    27,    -1,    17,    16,
      15,    18,    -1,    17,    16,    15,    20,    -1,    17,    16,
      15,    26,    -1,    53,    -1,    -1,    -1,    16,    54,    14,
      55,    60,    -1,    -1,    30,    57,    31,    58,    32,    34,
      50,    35,    -1,    59,    -1,    59,    11,    59,    -1,    60,
      67,    60,    -1,    60,    -1,    -1,    60,     7,    61,    63,
      -1,    -1,    60,     9,    62,    63,    -1,    63,    -1,    -1,
      63,     8,    64,    66,    -1,    -1,    63,    10,    65,    66,
      -1,    66,    -1,    63,    19,    66,    -1,    16,    -1,    20,
      -1,    18,    -1,    26,    -1,    31,    60,    32,    -1,    41,
      31,    60,    27,    39,    60,    40,    32,    -1,    33,    -1,
      13,    -1,    12,    -1,     6,    -1,     4,    -1,     5,    -1,
      -1,     3,    69,    70,    21,    76,    -1,     4,    71,     5,
      -1,    16,    -1,    -1,    -1,    16,    72,    19,    73,    71,
      -1,    75,    -1,    75,    19,    74,    -1,    23,    -1,    22,
      -1,    26,    -1,     4,    74,     5,    -1,    37,    31,    58,
      32,    34,    50,    35,    -1,    -1,    37,    31,    58,    32,
      34,    50,    35,    38,    78,    35,    50,    35,    -1,    37,
      31,    58,    32,    51,    -1,    -1,    29,    80,    16,    -1,
      -1,    24,    81,    16,    -1,    -1,    24,    82,    26,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   126,   126,   126,   135,   135,   141,   142,   146,   147,
     148,   149,   150,   154,   160,   166,   172,   176,   178,   176,
     193,   193,   201,   202,   206,   207,   211,   211,   214,   214,
     217,   221,   221,   224,   224,   227,   228,   232,   235,   236,
     237,   238,   241,   248,   251,   254,   257,   260,   263,   269,
     269,   290,   293,   300,   302,   300,   314,   315,   318,   321,
     325,   328,   331,   332,   332,   337,   342,   342,   346,   346,
     350,   350
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "DIM", "OP_LESS", "OP_MORE", "OP_DIFF",
  "OP_SUM", "OP_MUL", "OP_RES", "OP_DIV", "OP_AND", "OP_EQQ", "OP_MOQ",
  "OP_ASIG", "OP_ASIG_CONS", "ID", "CONST", "CONST_REAL", "COMA",
  "CONST_INT", "AS", "FLOAT", "INTEGER", "PUT", "CAR_COMILLAS",
  "CONST_STR", "PUNTO_Y_COMA", "PUNTO", "GET", "WHILE", "PARENTESIS",
  "END_PARENTESIS", "OP_LEQ", "LLAVE", "END_LLAVE", "COMENTARIO_SIMPLE",
  "IF", "ELSE", "CORCHETE", "END_CORCHETE", "CONTAR", "COMILLA_ABRE",
  "COMILLA_CIERRA", "LISTA_CONTAR", "$accept", "PROGRAMA", "$@1",
  "algoritmo", "$@2", "bloque", "sentencia", "est_asignacion",
  "asignacion", "@3", "$@4", "ciclo", "$@5", "condicion", "comparacion",
  "expresion", "$@6", "$@7", "termino", "$@8", "$@9", "factor",
  "lista_comparadores", "est_declaracion", "$@10", "est_variables",
  "lista_variables", "@11", "$@12", "lista_tipos", "tipo", "est_tipos",
  "seleccion", "$@13", "entrada_salida", "$@14", "$@15", "$@16", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    45,    47,    46,    49,    48,    50,    50,    51,    51,
      51,    51,    51,    52,    52,    52,    52,    54,    55,    53,
      57,    56,    58,    58,    59,    59,    61,    60,    62,    60,
      60,    64,    63,    65,    63,    63,    63,    66,    66,    66,
      66,    66,    66,    67,    67,    67,    67,    67,    67,    69,
      68,    70,    71,    72,    73,    71,    74,    74,    75,    75,
      75,    76,    77,    78,    77,    77,    80,    79,    81,    79,
      82,    79
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     0,     2,     2,     1,     1,     1,
       2,     1,     2,     4,     4,     4,     1,     0,     0,     5,
       0,     8,     1,     3,     3,     1,     0,     4,     0,     4,
       1,     0,     4,     0,     4,     1,     3,     1,     1,     1,
       1,     3,     8,     1,     1,     1,     1,     1,     1,     0,
       5,     3,     1,     0,     0,     5,     1,     3,     1,     1,
       1,     3,     7,     0,    12,     5,     0,     3,     0,     3,
       0,     3
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     4,     1,     3,     0,    49,    17,     0,    68,
      66,    20,     0,     5,     7,     0,    16,     8,     9,    11,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     6,
      10,    12,     0,     0,    18,     0,    69,    71,    67,     0,
      37,    39,    38,    40,     0,     0,     0,    22,    25,    30,
      35,    52,     0,     0,     0,    13,    14,    15,     0,     0,
       0,     0,     0,    47,    48,    46,    26,    28,    45,    44,
      43,     0,    31,    33,     0,     0,    51,     0,    50,    19,
       0,    41,     0,     0,    65,    23,     0,     0,    24,     0,
       0,    36,    54,    59,    58,    60,     0,    56,     0,     0,
       0,    27,    29,    32,    34,     0,    61,     0,     0,     0,
      62,    55,    57,    21,     0,    63,     0,     0,    42,     0,
       0,    64
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     1,     2,     4,     5,    13,    14,    15,    16,    22,
      54,    17,    27,    46,    47,    48,    86,    87,    49,    89,
      90,    50,    71,    18,    21,    33,    52,    75,   105,    96,
      97,    78,    19,   117,    20,    26,    24,    25
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -81
static const yytype_int8 yypact[] =
{
     -81,    12,   -81,   -81,   -81,    52,   -81,   -81,    -1,    -5,
     -81,   -81,    11,    52,   -81,     2,   -81,   -81,   -81,   -81,
      20,    21,    39,    46,    59,    38,    61,    62,    78,   -81,
     -81,   -81,    63,    76,   -81,    36,   -81,   -81,   -81,    78,
     -81,   -81,   -81,   -81,    78,    68,    69,    89,    79,    -6,
     -81,    83,    98,   104,    78,   -81,   -81,   -81,    81,    17,
      78,     3,    78,   -81,   -81,   -81,   -81,   -81,   -81,   -81,
     -81,    78,   -81,   -81,    78,    91,   -81,    48,   -81,     1,
      77,   -81,     7,    52,   -81,   -81,    78,    78,     1,    78,
      78,   -81,   -81,   -81,   -81,   -81,   109,    96,    52,    82,
       6,    -6,    -6,   -81,   -81,    63,   -81,    48,    28,    78,
      80,   -81,   -81,   -81,    -2,   -81,    84,    85,   -81,    52,
      43,   -81
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -81,   -81,   -81,   -81,   -81,   -80,   -13,   -81,   -81,   -81,
     -81,   -81,   -81,    86,    55,   -43,   -81,   -81,   -36,   -81,
     -81,    16,   -81,   -81,   -81,   -81,    18,   -81,   -81,    15,
     -81,   -81,   -81,   -81,   -81,   -81,   -81,   -81
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -71
static const yytype_int8 yytable[] =
{
      29,    59,    72,   100,    73,    66,     6,    67,    66,     6,
      67,    79,     3,    74,    66,    23,    67,    82,   108,     7,
       8,   -70,     7,     8,    66,    32,    67,     9,    88,    30,
       9,     6,    10,    11,    99,    10,    11,    83,   116,   120,
      12,   110,    28,    12,     7,     8,     6,    31,    84,    81,
     101,   102,     9,    34,    55,     6,    56,    10,    11,     7,
       8,    35,    57,   113,    37,    12,   114,     9,     7,     8,
      93,    94,    10,    11,    95,    36,     9,    38,   121,    51,
      12,    10,    11,    63,    64,    65,    66,    29,    67,    12,
      91,    68,    69,    39,    40,    29,    41,    53,    42,    60,
      62,    61,   -53,    76,    43,   103,   104,    29,    77,    44,
      92,    98,    70,    80,   106,   107,   118,    85,   115,    45,
     119,   109,   112,   111,     0,    58
};

static const yytype_int8 yycheck[] =
{
      13,    44,     8,    83,    10,     7,     3,     9,     7,     3,
       9,    54,     0,    19,     7,    16,     9,    60,    98,    16,
      17,    26,    16,    17,     7,     4,     9,    24,    71,    27,
      24,     3,    29,    30,    27,    29,    30,    34,    40,   119,
      37,    35,    31,    37,    16,    17,     3,    27,    61,    32,
      86,    87,    24,    14,    18,     3,    20,    29,    30,    16,
      17,    15,    26,    35,    26,    37,   109,    24,    16,    17,
      22,    23,    29,    30,    26,    16,    24,    16,    35,    16,
      37,    29,    30,     4,     5,     6,     7,   100,     9,    37,
      74,    12,    13,    31,    16,   108,    18,    21,    20,    31,
      11,    32,    19,     5,    26,    89,    90,   120,     4,    31,
      19,    34,    33,    32,     5,    19,    32,    62,    38,    41,
      35,    39,   107,   105,    -1,    39
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    46,    47,     0,    48,    49,     3,    16,    17,    24,
      29,    30,    37,    50,    51,    52,    53,    56,    68,    77,
      79,    69,    54,    16,    81,    82,    80,    57,    31,    51,
      27,    27,     4,    70,    14,    15,    16,    26,    16,    31,
      16,    18,    20,    26,    31,    41,    58,    59,    60,    63,
      66,    16,    71,    21,    55,    18,    20,    26,    58,    60,
      31,    32,    11,     4,     5,     6,     7,     9,    12,    13,
      33,    67,     8,    10,    19,    72,     5,     4,    76,    60,
      32,    32,    60,    34,    51,    59,    61,    62,    60,    64,
      65,    66,    19,    22,    23,    26,    74,    75,    34,    27,
      50,    63,    63,    66,    66,    73,     5,    19,    50,    39,
      35,    71,    74,    35,    60,    38,    40,    78,    32,    35,
      50,    35
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (yylocationp);
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yylsp, yyrule)
    YYSTYPE *yyvsp;
    YYLTYPE *yylsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       , &(yylsp[(yyi + 1) - (yynrhs)])		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, yylsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, yylocationp)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    YYLTYPE *yylocationp;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Location data for the lookahead symbol.  */
YYLTYPE yylloc;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.
       `yyls': related to locations.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[2];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;
  yylsp = yyls;

#if YYLTYPE_IS_TRIVIAL
  /* Initialize the default location before parsing starts.  */
  yylloc.first_line   = yylloc.last_line   = 1;
  yylloc.first_column = yylloc.last_column = 1;
#endif

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;
	YYLTYPE *yyls1 = yyls;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);

	yyls = yyls1;
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
	YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 126 "Sintactico.y"
    {
    printf("\n\nInicia el COMPILADOR\n\n");
}
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 130 "Sintactico.y"
    {
	{ guardarTS(); printf("\nCompilacion OK.\n");} 
}
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 135 "Sintactico.y"
    {
    printf("\tCOMIENZO de BLOQUES\n");
}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 154 "Sintactico.y"
    {  
        printf("\t\t CONST %s : $f\n", (yyvsp[(2) - (4)].tipo_str), (yyvsp[(4) - (4)].tipo_double));
        strcpy((yyval.tipo_str), (yyvsp[(2) - (4)].tipo_str));
        (yyval.tipo_double) = (yyvsp[(4) - (4)].tipo_double);
        insertarTS((yyval.tipo_str), "CONST_REAL", "", 0, yylval.tipo_double, ES_CONST_NOMBRE);
    }
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 160 "Sintactico.y"
    { 
        printf("\t\t CONST %s : $d\n", (yyvsp[(2) - (4)].tipo_str), (yyvsp[(4) - (4)].tipo_int));
        strcpy((yyval.tipo_str), (yyvsp[(2) - (4)].tipo_str));
        (yyval.tipo_int) = (yyvsp[(4) - (4)].tipo_int);
        insertarTS("nombre", "CONST_INT", "", 80, 0, ES_CONST_NOMBRE);
    }
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 166 "Sintactico.y"
    { 
        printf("\t\t CONST %s : $s\n", (yyvsp[(2) - (4)].tipo_str), (yyvsp[(4) - (4)].tipo_str));
        strcpy((yyval.tipo_str), (yyvsp[(2) - (4)].tipo_str));
        strcpy((yyval.tipo_str), (yyvsp[(4) - (4)].tipo_str));
        insertarTS((yyvsp[(2) - (4)].tipo_str), "CONST_STR", (yyval.tipo_str), 0, 0, 1);
    }
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 176 "Sintactico.y"
    {
        printf("\t\t %s\n", (yyval.tipo_str));
    }
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 178 "Sintactico.y"
    {
        printf("Inicio Asignacion.\n");
    }
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 180 "Sintactico.y"
    {
        printf("Fin Asignacion.\n");
        strcpy(vecAux, (yyvsp[(1) - (5)].tipo_str)); /*en $1 esta el valor de ID*/
        punt = strtok(vecAux," +-*/[](){}:=,\n"); /*porque puede venir de cualquier lado, pero ver si funciona solo con el =*/
        if(!existeID(punt)) /*No existe: entonces no esta declarada*/
        {
            sprintf(mensajes, "%s%s%s", "Error: no se declaro la variable '", punt, "'");
            yyerror(mensajes, (yylsp[(1) - (5)]).first_line, (yylsp[(1) - (5)]).first_column, (yylsp[(1) - (5)]).last_column);
        }
    }
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 193 "Sintactico.y"
    {
         printf("Inicio While.\n");
    }
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 195 "Sintactico.y"
    {
        printf("Fin While.\n");
    }
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 211 "Sintactico.y"
    {
        printf("\t\t + ");
    }
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 214 "Sintactico.y"
    {
        printf("\t\t - ");
    }
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 221 "Sintactico.y"
    {
        printf("\t\t * ");
    }
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 224 "Sintactico.y"
    {
        printf("\t\t / ");
    }
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 232 "Sintactico.y"
    {
        (yyval.tipo_str) = (yyvsp[(1) - (1)].tipo_str); printf("\t\t %s\n", (yyval.tipo_str));
    }
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 235 "Sintactico.y"
    {(yyval.tipo_int) = (yyvsp[(1) - (1)].tipo_int); printf("\t\t %d\n", (yyval.tipo_int));}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 236 "Sintactico.y"
    {(yyval.tipo_double) = (yyvsp[(1) - (1)].tipo_double); printf("\t\t %f\n", (yyval.tipo_double));}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 238 "Sintactico.y"
    {
        printf("\t\t(expresion)\n");
    }
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 241 "Sintactico.y"
    {
        printf("\tContar()\n");
    }
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 248 "Sintactico.y"
    {
        printf("\t\t <= ");
    }
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 251 "Sintactico.y"
    {
        printf("\t\t >= ");
    }
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 254 "Sintactico.y"
    {
        printf("\t\t == ");
    }
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 257 "Sintactico.y"
    {
        printf("\t\t <> ");
    }
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 260 "Sintactico.y"
    {
        printf("\t\t < ");
    }
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 263 "Sintactico.y"
    {
        printf("\t\t > ");
    }
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 269 "Sintactico.y"
    {
        printf("Inicio declaracion multiple\n");
    }
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 271 "Sintactico.y"
    {  
        for(i=0;i<cant_aux;i++) /*vamos agregando todos los ids que leyo*/
        {
            separador1 = strtok(idvec[i],";");
            strcpy(nombre,separador1);
            separador1 = strtok(NULL, ";");

            if(insertarTS(nombre, separador1, "", 0, 0, NO_ES_CONST_NOMBRE) != 0) //no lo guarda porque ya existe
            {
                sprintf(mensajes, "%s%s%s", "Error: la variable '", idvec[i], "' ya fue declarada");
                yyerror(mensajes, (yylsp[(3) - (5)]).first_line, (yylsp[(3) - (5)]).first_column, (yylsp[(3) - (5)]).last_column);
            }
        }
        cantid=0;
        printf("Fin declaracion multiple\n");
    }
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 293 "Sintactico.y"
    {
        printf("\t\t %s\n", (yyval.tipo_str));
        strcpy(vecAux, (yyvsp[(1) - (1)].tipo_str)); /*tomamos el nombre de la variable*/
        punt = strtok(vecAux, ">"); /*eliminamos extras*/
        strcpy(idvec[cantid], punt); /*copiamos al array de ids*/
        cantid++;
    }
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 300 "Sintactico.y"
    {
        printf("\t\t %s\n", (yyval.tipo_str));
    }
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 302 "Sintactico.y"
    {
        printf("\t\t ,\n");
    }
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 304 "Sintactico.y"
    {
        strcpy(vecAux, (yyvsp[(1) - (5)].tipo_str)); /*tomamos el nombre de la variable*/
        punt = strtok(vecAux, ","); /*eliminamos extras*/
        strcpy(idvec[cantid], punt); /*copiamos al array de ids*/
        cantid++;
        cant_aux = cantid;
    }
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 318 "Sintactico.y"
    {           strcat(idvec[cantid-1],";");
                        strcat(idvec[cantid-1],"INTEGER");
                        cantid--;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 321 "Sintactico.y"
    {
                        strcat(idvec[cantid-1],";");
                        strcat(idvec[cantid-1],"FLOAT");
                        cantid--;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 332 "Sintactico.y"
    {
            printf("Inicio Else.\n");
        }
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 334 "Sintactico.y"
    {
            printf("Fin Else.\n");
        }
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 337 "Sintactico.y"
    {printf("IF Sin llave.\n");}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 342 "Sintactico.y"
    {
        printf("\t\tGET: "); 
    }
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 344 "Sintactico.y"
    {
        printf("%s\n", yylval.tipo_str);}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 346 "Sintactico.y"
    {
        printf("\t\tPUT: ");
    }
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 348 "Sintactico.y"
    {
        printf("%s\n", yylval.tipo_str);}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 350 "Sintactico.y"
    {
        printf("\t\tPUT: ");
    }
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 352 "Sintactico.y"
    {
        strcpy(vecAux, yylval.tipo_str);
        printf("%s\n", vecAux);
    }
    break;



/* Line 1455 of yacc.c  */
#line 2061 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }

  yyerror_range[0] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, &yylloc);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[0] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      yyerror_range[0] = *yylsp;
      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;

  yyerror_range[1] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, (yyerror_range - 1), 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, &yylloc);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 358 "Sintactico.y"


/*---- 4. Código ----*/

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\r\n", argv[1]);
        return -1;
    }
    else
    { 
        crearTablaTS();//tablaTS.primero = NULL;
        yyparse();
        fclose(yyin);
        system("Pause"); /*Esta pausa la puse para ver lo que hace via mensajes*/
        return 0;
    }
}

int insertarTS(const char *nombre, const char *tipo, const char* valString, int valInt, double valDouble, int esConstNombre)
{
    t_simbolo *tabla = tablaTS.primero;
    char nombreCTE[50] = "_";
    strcat(nombreCTE, nombre);
    
    
    while(tabla)
    {
        if(strcmp(tabla->data.nombre, nombre) == 0 || strcmp(tabla->data.nombre, nombreCTE) == 0)
        {
            return 1;
        }
        
        if(tabla->next == NULL)
        {
            break;
        }
        tabla = tabla->next;
    }

    t_data *data = (t_data*)malloc(sizeof(t_data));
    data = crearDatos(nombre, tipo, valString, valInt, valDouble, esConstNombre);

    if(data == NULL)
    {
        return 1;
    }

    t_simbolo* nuevo = (t_simbolo*)malloc(sizeof(t_simbolo));

    if(nuevo == NULL)
    {
        return 2;
    }

    nuevo->data = *data;
    nuevo->next = NULL;

    if(tablaTS.primero == NULL)
    {
        tablaTS.primero = nuevo;
    }
    else
    {
        tabla->next = nuevo;
    }

    return 0;
}

t_data* crearDatos(const char *nombre, const char *tipo, const char* valString, int valInt, double valDouble, int esConstNombre)
{
    char full[50] = "_";
    char aux[20];

    t_data *data = (t_data*)calloc(1, sizeof(t_data));
    if(data == NULL)
    {
        return NULL;
    }

    data->tipo = (char*)malloc(sizeof(char) * (strlen(tipo) + 1));
    strcpy(data->tipo, tipo);

    //Si es una variable
    if((strcmp(tipo, "STRING") == 0 || strcmp(tipo, "INTEGER") == 0 || strcmp(tipo, "FLOAT") == 0) && esConstNombre == 0)
    {
        //Al nombre lo dejo aca porque no lleva _
        data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
        strcpy(data->nombre, nombre);
        return data;
    }
    else
    { 
        if(esConstNombre == ES_CONST_NOMBRE)
        {
            data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
            strcpy(data->nombre, nombre);
        }

         //Son constantes: tenemos que agregarlos a la tabla con "_" al comienzo del nombre, hay que agregarle el valor
        if(strcmp(tipo, "CONST_STR") == 0)
        {
            data->valor.valor_str = (char*)malloc(sizeof(char) * strlen(valString) +1);
            strcpy(data->valor.valor_str, valString);
            
            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
            }
            else
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(valString) + 1));
                strcat(full, valString);
                strcpy(data->nombre, full);    
            }

        }
        if(strcmp(tipo, "CONST_REAL") == 0)
        {
            data->valor.valor_double = valDouble;

            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
            }
            else
            {
                sprintf(aux, "%g", valDouble);
                strcat(full, aux);
                data->nombre = (char*)malloc(sizeof(char) * strlen(full));
                strcpy(data->nombre, full);
            }

        }
        if(strcmp(tipo, "CONST_INT") == 0)
        {
            data->valor.valor_int = valInt;

            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
            }
            else
            {
                sprintf(aux, "%d", valInt);
                strcat(full, aux);
                data->nombre = (char*)malloc(sizeof(char) * strlen(full));
                strcpy(data->nombre, full);
            }
        }
        return data;

    }
    return NULL;
}


void guardarTS()
{
    FILE* arch;
    if((arch = fopen("ts.txt", "wt")) == NULL)
    {
            printf("\nNo se pudo crear la tabla de simbolos.\n\n");
            return;
    }
    else if(tablaTS.primero == NULL)
            return;
    
    fprintf(arch, "%-50s%-25s%-50s%-30s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");

    t_simbolo *aux;
    t_simbolo *tabla = tablaTS.primero;
    char linea[160];

    while(tabla)
    {
        aux = tabla;
        tabla = tabla->next;
        
        if(strcmp(aux->data.tipo, "INTEGER") == 0) //variable int
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_INT") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50d%-d\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_int, strlen(aux->data.nombre) -1);
        }
        else if(strcmp(aux->data.tipo, "FLOAT") ==0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_REAL") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50g%-d\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_double, strlen(aux->data.nombre) -1);
        }
        else if(strcmp(aux->data.tipo, "STRING") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_STR") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_str, strlen(aux->data.nombre) -1);
        }
        fprintf(arch, "%s", linea);
        free(aux);
    }
    fclose(arch); 
}

void crearTablaTS()
{
    tablaTS.primero = NULL;
}

int existeID(const char* id) //y hasta diria que es igual para existeCTE
{
    //tengo que ver el tema del _ en el nombre de las cte
    t_simbolo *tabla = tablaTS.primero;
    char nombreCTE[50] = "_";
    strcat(nombreCTE, id);
    int b1 = 0;
    int b2 = 0;
    int j =0;
    
    while(j<cant_aux)
    {
        b1 = strcmp(idvec[j], id);
        //b2 = strcmp(tabla->data.nombre, nombreCTE);
        if(b1 == 0)
        {
                return 1;
        }
        j++;
    }
    return 0;
}

int esNumero(const char* id,char* error)
{
    t_simbolo *tabla = tablaTS.primero;
    char nombreCTE[50] = "_";
    strcat(nombreCTE, id);

    while(tabla)
    {
        if(strcmp(tabla->data.nombre, id) == 0 || strcmp(tabla->data.nombre, nombreCTE) == 0)
        {
            if(strcmp(tabla->data.tipo, "INT")==0 || strcmp(tabla->data.tipo, "FLOAT")==0)
            {
                return 1;
            }
            else
            {
                strcpy(error,"Tipo de dato incorrecto");
                sprintf(error,"%s%s%s","Error: tipo de dato de la variable '",id,"' incorrecto. Tipos permitidos: int y float");
                return 0;
            }
        }
        tabla = tabla->next;
    }
    sprintf(error, "%s%s%s", "Error: no se declaro la variable '", id, "'");
    return 0;
}

