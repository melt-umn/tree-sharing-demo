grammar edu:umn:cs:melt:sharedemo:host:abstractsyntax;

tracked nonterminal Root with pp, errors;

production root
top::Root ::= s::Stmt
{
  top.pp = s.pp;
  propagate errors;

  s.env = emptyEnv;
}
