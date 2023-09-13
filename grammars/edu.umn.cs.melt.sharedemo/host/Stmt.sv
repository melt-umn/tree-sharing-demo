grammar edu:umn:cs:melt:sharedemo:host;

tracked nonterminal Stmt with pp, freeVars, env, defs, errors;
propagate defs, errors on Stmt;
propagate env on Stmt excluding seq;

production seq
top::Stmt ::= s1::Stmt s2::Stmt
{
  top.pp = cat(s1.pp, cat(line(), s2.pp));
  top.freeVars = s1.freeVars ++ removeAll(map(fst, s1.defs), s2.freeVars);

  s1.env = top.env;
  s2.env = addEnv(s1.defs, s1.env);
}

production empty_
top::Stmt ::=
{
  top.pp = pp"";
  top.freeVars = [];
}

production decl
top::Stmt ::= id::Name ty::Type e::Expr
{
  top.pp = pp"var ${id} : ${ty} = ${e};";
  top.freeVars = e.freeVars;
  top.defs <- [(id.name, new(ty))];
  top.errors <-
    if e.type == new(ty) then []
    else [errFromOrigin(e, s"Declaration expected ${show(80, ty)} but found ${show(80, e.type)}")];
}

production assign
top::Stmt ::= id::Name e::Expr
{
  top.pp = pp"${id} := ${e};";
  top.freeVars = e.freeVars;
  top.errors <- id.lookupErrors;
  top.errors <-
    if e.type == id.type then []
    else [errFromOrigin(e, s"Assignment expected ${show(80, id.type)} but found ${show(80, e.type)}")];
}

production ifThenElse
top::Stmt ::= c::Expr t::Stmt e::Stmt
{
  top.pp = pp"if (${c}) {${groupnestlines(2, t.pp)}} else {${groupnestlines(2, e.pp)}}";
  top.freeVars = c.freeVars ++ t.freeVars ++ e.freeVars;
  top.errors <- checkBool(c, "condition");
}

production while
top::Stmt ::= c::Expr body::Stmt
{
  top.pp = pp"while (${c}) {${groupnestlines(2, body.pp)}}";
  top.freeVars = c.freeVars ++ body.freeVars;
  top.errors <- checkBool(c, "condition");
}

production printInt
top::Stmt ::= e::Expr
{
  top.pp = pp"print(${e})";
  top.freeVars = e.freeVars;
  top.errors <- checkInt(e, "print argument");
}