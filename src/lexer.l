%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%

"flux"      { return FLUX; }
"path"      { return PATH; }
"divert"    { return DIVERT; }
"orbit"     { return ORBIT; }
"spin"      { return SPIN; }
"beam"      { return BEAM; }
"absorb"    { return ABSORB; }

"=="        { return EQ; }
"!="        { return NEQ; }
">"         { return GT; }
"<"         { return LT; }

[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
[0-9]+                 { yylval.num = atoi(yytext); return NUMBER; }
\"(\\.|[^"\\])*\"      { yylval.str = strdup(yytext); return STRING; }

[={}()+\-*/%;] { return yytext[0]; }

[ \t\n\r]+  { /* হোয়াইটস্পেস এবং নতুন লাইন ইগনোর করবে */ }

.           { printf("Unknown character: %s\n", yytext); }

%%