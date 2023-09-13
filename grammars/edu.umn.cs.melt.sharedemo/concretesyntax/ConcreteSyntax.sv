grammar edu:umn:cs:melt:sharedemo:concretesyntax;

imports silver:langutil;
imports edu:umn:cs:melt:sharedemo:host;

ignore terminal WhiteSpace_t /[\n\r\t\ ]+/;
ignore terminal Comment_t /--.*/;

terminal Identifier_t /[A-Za-z_][A-Za-z0-9_]*/;
terminal Constant_t /[0-9]+/;

terminal Or_t '||' association = left, precedence = 0;
terminal And_t '&&' association = left, precedence = 1;
terminal Lt_t '<' association = none, precedence = 2;
terminal Eq_t '==' association = none, precedence = 2;
terminal Plus_t '+' association = left, precedence = 3;
terminal Minus_t '-' association = left, precedence = 3;
terminal Neg_t '~' precedence = 4;

terminal LParen_t '(';
terminal RParen_t ')';
terminal LBrace_t '{';
terminal RBrace_t '}';
terminal Decl_t '=';
terminal Assign_t ':=';
terminal Colon_t ':';
terminal Semi_t ';';
terminal Comma_t ',';

lexer class Reserved dominates Identifier_t;

terminal Var_t 'var' lexer classes {Reserved};
terminal Let_t 'let' lexer classes {Reserved};
terminal In_t 'in' lexer classes {Reserved};
terminal End_t 'end' lexer classes {Reserved};
terminal If_t 'if' lexer classes {Reserved};
terminal Else_t 'else' lexer classes {Reserved};
terminal While_t 'while' lexer classes {Reserved};
terminal Print_t 'print' lexer classes {Reserved};
terminal True_t 'true' lexer classes {Reserved};
terminal False_t 'false' lexer classes {Reserved};
terminal Int_t 'int';
terminal Bool_t 'bool';

tracked nonterminal Root_c with ast<Root>;
concrete production root_c
top::Root_c ::= ss::Stmts_c
{ abstract root; }

tracked nonterminal Stmts_c with ast<Stmt>;
concrete productions top::Stmts_c
| h::Stmt_c t::Stmts_c
  { abstract seq; }
| s::Stmt_c
  { top.ast = s.ast; }

tracked nonterminal Stmt_c with ast<Stmt>;
concrete productions top::Stmt_c
| 'var' id::Name_c ':' ty::Type_c '=' e::Expr_c ';'
  { abstract decl; }
| id::Name_c ':=' e::Expr_c ';'
  { abstract assign; }
| 'if' '(' c::Expr_c ')' '{' t::Stmts_c '}' 'else' '{' e::Stmts_c '}'
  { abstract ifThenElse; }
| 'if' '(' c::Expr_c ')' '{' t::Stmts_c '}'
  { top.ast = ifThenElse(c.ast, t.ast, empty_()); }
| 'while' '(' c::Expr_c ')' '{' body::Stmts_c '}'
  { abstract while; }
| 'print' '(' c::Expr_c ')' ';'
  { abstract printInt; }

tracked nonterminal Expr_c with ast<Expr>;
concrete productions top::Expr_c
| e1::Expr_c '+' e2::Expr_c
  { abstract addInt; }
| e1::Expr_c '-' e2::Expr_c
  { abstract subInt; }
| e1::Expr_c '&&' e2::Expr_c
  { abstract andOp; }
| e1::Expr_c '||' e2::Expr_c
  { abstract orOp; }
| e1::Expr_c '<' e2::Expr_c
  { abstract ltInt; }
| e1::Expr_c '==' e2::Expr_c
  { abstract eqOp; }
| '~' e::Expr_c
  { abstract neg; }
| i::Constant_t
  { top.ast = intConst(toInteger(i.lexeme)); }
| 'true'
  { abstract trueConst; }
| 'false'
  { abstract falseConst; }
| 'let' id::Name_c '=' e::Expr_c 'in' body::Expr_c 'end'
  { abstract let_; }
| id::Name_c
  { abstract var; }
| '(' e::Expr_c ')'
  { top.ast = e.ast; }

tracked nonterminal Exprs_c with ast<Exprs>;
concrete productions top::Exprs_c
| h::Expr_c ',' t::Exprs_c
  { abstract consExpr; }
| h::Expr_c
  { top.ast = consExpr(h.ast, nilExpr()); }
|
  { abstract nilExpr; }

tracked nonterminal Name_c with ast<Name>;
concrete productions top::Name_c
| id::Identifier_t
  { top.ast = name(id.lexeme); }

tracked nonterminal Type_c with ast<Type>;
concrete productions top::Type_c
| 'int'
  { abstract intType; }
| 'bool'
  { abstract boolType; }
