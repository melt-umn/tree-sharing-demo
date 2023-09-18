grammar edu:umn:cs:melt:sharedemo:exts:condtable:concretesyntax;

imports silver:langutil;
imports edu:umn:cs:melt:sharedemo:host:concretesyntax;
imports edu:umn:cs:melt:sharedemo:exts:condtable:abstractsyntax;

marking terminal For_t 'table' lexer classes {Reserved};
terminal Colon_t ':';

terminal T_t 'T';
terminal F_t 'F';
terminal Star_t '*';

concrete productions top::Expr_c
| 'table' '{' rows::TRows_c '}'
  layout {WhiteSpace_t, BlockComment_t, LineComment_t}
  { abstract condTable; }

tracked nonterminal TRows_c
  with ast<TRows>;
concrete productions top::TRows_c
| h::TRow_c Newline_t t::TRows_c
  { top.ast = h.ast(t.ast); }
| h::TRow_c
  { top.ast = h.ast(nilRow()); }
|
  { abstract nilRow; }

tracked nonterminal TRow_c with ast<(TRows ::= TRows)>;
concrete productions top::TRow_c
| e::Expr_c ':' tf::TruthFlags_c
  { top.ast = consRow(e.ast, tf.ast, _); }

tracked nonterminal TruthFlags_c with ast<TruthFlags>;
concrete productions top::TruthFlags_c
| h::TruthFlag_c t::TruthFlags_c
  { abstract consTruthFlag; }
|
  { abstract nilTruthFlag; }

tracked nonterminal TruthFlag_c with ast<TruthFlag>;
concrete productions top::TruthFlag_c
| 'T'
  { abstract trueFlag; }
| 'F'
  { abstract falseFlag; }
| '*'
  { abstract starFlag; }
