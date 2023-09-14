grammar edu:umn:cs:melt:sharedemo:exts:forloop:concretesyntax;

imports silver:langutil;
imports edu:umn:cs:melt:sharedemo:host:concretesyntax;
imports edu:umn:cs:melt:sharedemo:exts:forloop:abstractsyntax;

marking terminal For_t 'for' lexer classes {Reserved};
terminal To_t 'to';

concrete productions top::Stmt_c
| 'for' iVar::Name_c 'in' l::Expr_c 'to' u::Expr_c  '{' body::Stmts_c '}'
  { abstract forLoop; }
