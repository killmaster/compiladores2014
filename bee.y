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

%nonassoc ifx
%nonassoc ELSE

program : '{' definition '}'

parameter : name
          ;

parameter_list  : parameter
                | parameter ',' parameter_list
                |
                ;

definition : name '[' literal ']' ival ';'
           | name '[' ']' ival ';'
           | name '[' literal ']' ival ';'
           | name '[' ']' ival ';'
           | name '[' literal ']' ';'
           | name '[' ']' ';'
           | name ival ';'
           | name ';'
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

statement_aux : name '[' literal ']'
              | name '[' ']' 
              | name
              ;

literal : '-' INTEGER
        | '-' INTEGER_L
        | INTEGER
        | INTEGER_L
        | '\'' CHAR CHAR CHAR CHAR '\''
        | '\'' CHAR CHAR CHAR '\''
        | '\'' CHAR CHAR '\''
        | '\'' CHAR '\''
        | '"' STRING_L '"'
        ;

statement_list  : statement_aux  
                | statement_aux ',' statement_list;
