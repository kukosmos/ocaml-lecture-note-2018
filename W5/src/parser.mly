%token <int> NUM
%token <string> ID
%token TRUE FALSE
%token REF
%token EXCMARK
%token PLUS MINUS STAR SLASH
%token LPAREN RPAREN
%token EQEQ
%token LESS
%token NOT
%token IF
%token THEN
%token ELSE
%token LET
%token EQUAL
%token IN
%token COLEQ
%token LBRACK RBRACK
%token SEMI
%token EOF

%left IN
%left PLUS MINUS
%left STAR SLASH
%left EXCMARK
%left SEMI

%start file
%type <Calc.file> file
%%

file:
  exp EOF { $1 }
  ;

exp:
    LPAREN RPAREN { Calc.UNIT }
  | NUM { Calc.NUM $1 }
  | TRUE { Calc.TRUE }
  | FALSE { Calc.FALSE }
  | ID { Calc.VAR $1 }
  | REF exp { Calc.NEW $2 }
  | EXCMARK exp { Calc.REF $2 }
  | LPAREN exp RPAREN { $2 }
  | exp PLUS exp { Calc.ADD ($1, $3) }
  | exp MINUS exp { Calc.SUB ($1, $3) }
  | exp STAR exp { Calc.MUL ($1, $3) }
  | exp SLASH exp { Calc.DIV ($1, $3) }
  | exp EQEQ exp { Calc.EQUAL ($1, $3) }
  | exp LESS exp { Calc.LESS ($1, $3) }
  | NOT exp { Calc.NOT ($2) }
  | IF exp THEN exp ELSE exp { Calc.IF ($2, $4, $6) }
  | LET ID EQUAL exp IN exp { Calc.VDECL ($2, $4, $6) }
  | LET ID LPAREN ID RPAREN EQUAL exp IN exp { Calc.FDECL ($2, $4, $7, $9) }
  | ID COLEQ exp IN exp { Calc.ASSIGN ($1, $3, $5) }
  | exp LPAREN exp RPAREN { Calc.FCALL ($1, $3) }
  | exp SEMI exp { Calc.SEQ ($1, $3) }

%%

let parser_error s = print_endline s
