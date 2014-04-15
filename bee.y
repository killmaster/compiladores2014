%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
extern int yylineno;
%}

%union {
 double i;
}

%token IF THEN ELSE WHILE EXTRN FOR SWITCH CASE BREAK AUTO GOTO
%token LE GE NEQ INC DEC
%token<i> INTEGER INTEGER_L

%nonassoc ifx ELSE '(' ')' '[' ']'  EQ NEQ '&' '-'
%left '*' '/' '%' '+'  LSHIFT RSHIFT  '^' '|'
%right INC DEC '=' '!' '~'

%%
program : '{' definition '}'

parameter : name
          ;

parameter_list  : parameter
                | parameter ',' parameter_list
                |
                ;

definition  : name ';'
            | name ival ';'
            | name '[' ']' ';'
            | name '[' literal ']' ';'
            | name '[' ']' ival ';'
            | name '[' literal ']' ival ';'
            | name '(' parameter_list ')' statement
            ;

definition_list : definition
                | definition ',' definition_list;

ival : literal
     | name;

statement : AUTO statement_list ';' statement
          | EXTRN statement_list ';' statement
          | name ':' statement
          | CASE literal ':' statement
          | '{' statement '}'
          | '{' '}' 
          | IF '(' rvalue ')' statement else_aux
          | WHILE '(' rvalue ')' statement
          | SWITCH '(' rvalue ')' statement
          | GOTO rvalue ';'
          | BREAK ';'
          | RETURN '(' rvalue ')' ';'
          | RETURN ';'
          ;

rvalue  : '(' rvalue ')'
        | lvalue
        | literal
        | lvalue assign rvalue
        | inc-dec lvalue
        | lvalue inc-dec
        | unary rvalue
        | & lvalue
        | rvalue binary rvalue
        | rvalue ? rvalue : rvalue
        | rvalue '(' rvalue ',' rvalue ')'  /*errado, mas vai ficar por enquanto TODO*/
        ;

assign  : '='
        ;

inc-dec : INC
        | DEC
        ;

unary : '-'
      | '!'
      | '~'
      ;

binary  : '|'
        | '^'
        | '&'
        | EQ
        | NEQ
        | '<'
        | '>'
        | GE
        | LE
        | LSHIFT
        | RSHIFT
        | '-'
        | '+'
        | '%'
        | '*'
        | '/'
        ;

lvalue  : name
        | '*' lvalue
        | lvalue '[' rvalue ']'
        ;

literal : 

else_aux  : ELSE statement
          | %prec ifx
          ;

statement_aux : name 
              | name '[' ']' 
              | name '[' literal ']'
              ;

literal : INTEGER
        | INTEGER_L
        | '-' INTEGER
        | '-' INTEGER_L
        | CHAR
        | STRING_L
        ;

statement_list  : statement_aux  
                | statement_aux ',' statement_list;

%%

char **yynames =
#if YYDEBUG > 0
                 (char**)yyname;
#else
                 0;
#endif
