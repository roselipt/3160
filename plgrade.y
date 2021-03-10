/*  Reverse Poish Notation Calculator */

%{
 #include<stdio.h>  //  I think a single space is required by Bison
 #include<math.h> 
 int yylex (void);
 void yyerror (char const *);
%}

%define api.value.type {double}
%token NUM

%% /* Grammar rules and actions follow. */

input:
  %empty  /* This could be blank or comment /*empty but %empty directive by convention*/
| input line
;

line:
  '\n'
| exp '\n' {printf ("%.10g\n", $1); }

exp:
  NUM
| exp exp '+' { $$ = $1 + $2; }
| exp exp '-' { $$ = $1 - $2; }
| exp exp '/' { $$ = $1 / $2; }
| exp exp '*' { $$ = $1 * $2; }

//  This line read a letter, representing an assignment category instead of an operator
| exp exp 'R' { $$ = $1 + $2; }

//  but I haven't figured out why I get "reduce conflict" errors as soon
//  as I alter order or number of args

//| exp exp exp 'R' {$$ = $1 + $2 +3}

/* ...  Other functions may be added to the calculator here.*/

;

%% /* Bison punctuation separating Grammar Rules from Epilogue*/

/* The lexical analyzer returns a double floating point number
   on the stack and the token NUM, or the numeric code of the 
   character read in not the number. It skips all blanks and 
   tabs, and returns 0 for end-of-input. */
#include <ctype.h>
#include <stdlib.h>

int
yylex (void)
{
  int c = getchar ();
  /* Skip white space. */
  while(c==' ' || c=='\t')
    c = getchar();
  /* Process numbers. */
  if (c=='.' || isdigit(c) )
    {
      ungetc(c, stdin);
      if (scanf ("%lf", &yylval) != 1)
        abort();
      return NUM;
}
  /* Return end-of-input */
  else if (c==EOF)
    return YYEOF;
  /* Return a single char. */
  else
    return c;
}

int
main (void)
{
  return yyparse ();
}

#include <stdio.h>

/* Called by yyparse on error. */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

