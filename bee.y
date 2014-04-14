%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
extern int yylineno;
%}

%union {
 double i;
}

%token IF THEN ELSE WHILE EXTRN FOR SWITCH CASE BREAK AUTO
%token LE GE DIFF INC DEC
%token<i> INTEGER INTEGER_L

%nonassoc ifx
%nonassoc ELSE

program : '{' definition '}'

definition : name '[' literal ']' ival ',' ival ';'
           | name '[' ']' ival ',' ival ';'
           | name '[' literal ']' ival ';'
           | name '[' ']' ival ';'
           | name '[' literal ']' ';'
           | name '[' ']' ';'
           | name ival ';'
           | name ';'
           | name '(' name ',' name ')' statement
           | name '(' name ')' statement
           | name '(' ')' statement

ival : literal
     | name

statement : AUTO name 