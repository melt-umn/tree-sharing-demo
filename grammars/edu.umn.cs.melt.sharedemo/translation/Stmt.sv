grammar edu:umn:cs:melt:sharedemo:translation;

attribute ctrans occurs on Stmt;

aspect production seq
top::Stmt ::= s1::Stmt s2::Stmt
{
  top.ctrans = cat(s1.ctrans, cat(line(), s2.ctrans));
}

aspect production empty_
top::Stmt ::=
{
  top.ctrans = pp"";
}

aspect production decl
top::Stmt ::= id::Name ty::Type e::Expr
{
  top.ctrans = pp"${ty.ctrans} ${id} = ${e.ctrans};";
}

aspect production assign
top::Stmt ::= id::Name e::Expr
{
  top.ctrans = pp"${id} = ${e.ctrans};";
}

aspect production ifThenElse
top::Stmt ::= c::Expr t::Stmt e::Stmt
{
  top.ctrans = pp"if (${c.ctrans}) {${groupnestlines(2, t.ctrans)}} else {${groupnestlines(2, e.ctrans)}}";
}

aspect production while
top::Stmt ::= c::Expr body::Stmt
{
  top.ctrans = pp"while (${c.ctrans}) {${groupnestlines(2, body.ctrans)}}";
}

aspect production printInt
top::Stmt ::= e::Expr
{
  top.ctrans = pp"""printf("%d\n", ${e.ctrans});""";
}

aspect production block
top::Stmt ::= s::Stmt
{
  top.ctrans = braces(groupnestlines(2, s.ctrans));
}

aspect production errorStmt
top::Stmt ::= msg::[Message]
{
  top.ctrans = pp"/*err*/";
}
