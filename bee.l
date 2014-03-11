%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "y.tab.h"
void yyerror(char *s);

%} 
int nesting=0;

%x com_ext delimitador com_int
%%


"if" return IF;
"then" return THEN;
"else" return ELSE;
"while" return WHILE;
"extrn" return EXTRN;
"for" return FOR;
"switch" return SWITCH;
"case" return CASE;
"break" return BREAK;
"auto" return AUTO;



"+"  return '+';
"-"  return '-';
"*"  return '*';
"/"  return '/';
"%"  return '%';
"<="  return LE;
">="  return GE;
"<"  return '<';
">"  return '>';
"<>"  return DIFF;
"++"  return INC;
"--"  return DEC;
"!"  return '!';
"&"  return '&';
"|"  return '|';
"~"  return '~';
"="  return '=';
"["  return '[';
"]"  return ']';
"("  return '(';
")"  return ')';
";"  return ';';
"{"  return '{';
"}"  return '}';
","  return ',';
"?"  retunr '?';
":"  retunr ':';


[1-9][0-9]* { yylval.i = strtol(yytext, 0, 10);
       if(errno == EOVERFLOW) {
        yyerror("Warning: Integer overflow");
        errno = 0;
       } 
      return INTEGER;} /*decimal*/

0[0-9]+|0   {yylval.i = strtol(yytext, 0, 8);
       if(errno == EOVERFLOW) {
        yyerror("Warning: Integer overflow");
        errno = 0;
       } 
      return INTEGER_L;} /*octal*/

\"([^"]|\\.)*\"   {yytext[yyleng-1] = 0; yylval.s = strdup(yytext+1);return STRING_L;}

"/*"  BEGIN com_ext;nesting++;
<com_ext>"/*" {nesting++;}
<com_ext>"*/" {if(--nesting<=0) BEGIN INITIAL;}
<com_ext>.|\n  ;

"\n"  {if (yytext[yyleng-1]!=';'){ return ';';}}

[ \t\ \r]+  ;
.  yyerror("caracter desconhecido");
%%

int yywrap() {
 return 1;
}
char *getyytext() { 
return yytext; }
