grammar edu:umn:cs:melt:sharedemo:host:abstractsyntax;

synthesized attribute freeVars::[String];
synthesized attribute type::Type;

synthesized attribute wrapPP::Document;
tracked nonterminal Expr with pp, wrapPP, freeVars, env, type, errors;
flowtype Expr = decorate {env}, pp {}, wrapPP {}, freeVars {decorate}, type {decorate}, errors {decorate};
propagate env on Expr excluding let_;
propagate errors on Expr;

aspect default production
top::Expr ::=
{
  top.wrapPP = parens(top.pp);
}

production addInt
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} + ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = intType();
  top.errors <- checkInt(e1, "left operand to +");
  top.errors <- checkInt(e2, "right operand to +");
}

production subInt
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} - ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = intType();
  top.errors <- checkInt(e1, "left operand to -");
  top.errors <- checkInt(e2, "right operand to -");
}

production mulInt
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} * ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = intType();
  top.errors <- checkInt(e1, "left operand to *");
  top.errors <- checkInt(e2, "right operand to *");
}

production divInt
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} / ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = intType();
  top.errors <- checkInt(e1, "left operand to /");
  top.errors <- checkInt(e2, "right operand to /");
}

production andOp
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} && ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = boolType();
  top.errors <- checkBool(e1, "left operand to &&");
  top.errors <- checkBool(e2, "right operand to &&");
}

production orOp
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} || ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = boolType();
  top.errors <- checkBool(e1, "left operand to ||");
  top.errors <- checkBool(e2, "right operand to ||");
}

production ltInt
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} - ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = boolType();
  top.errors <- checkInt(e1, "left operand to <");
  top.errors <- checkInt(e2, "right operand to <");
}

production neg
top::Expr ::= n::Expr
{
  top.pp = pp"~${n.wrapPP}";
  top.wrapPP = parens(top.pp);
  local nVar::Name = freshName(n.env);  -- TODO: Should be non-decorating
  local impl::Expr = case n.type of
    | intType()  -> intNeg  (var(new(nVar)))
    | boolType() -> boolNeg (var(new(nVar)))
    | t -> errorExpr ([errFromOrigin(n, s"Invalid operand type ${show(80, t)} to ~")])
    end;
  forwards to let_(new(nVar), @n, @impl);
}

production intNeg
top::Expr ::= e::Expr
{
  top.pp = pp"-${e.wrapPP}";
  top.freeVars = e.freeVars;
  top.type = intType();
  top.errors <- checkInt(e, "operand to ~");
}

production boolNeg
top::Expr ::= e::Expr
{
  top.pp = pp"-${e.wrapPP}";
  top.freeVars = e.freeVars;
  top.type = boolType();
  top.errors <- checkBool(e, "operand to ~");
}

production eqOp
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} == ${e2.wrapPP}";
  top.wrapPP = parens(top.pp);
  local e1Var::Name = freshName(e1.env);  -- TODO: Should be non-decorating
  local e2Var::Name = freshName(e2.env);  -- TODO: Should be non-decorating
  local impl::Expr =
    case e1.type of
    | intType()  -> eqInt(var(new(e1Var)), var(new(e2Var)))
    | boolType() -> eqBool(var(new(e1Var)), var(new(e2Var)))
    | t -> errorExpr ([errFromOrigin(e1, s"Invalid operand type ${show(80, t)} to ==")])
    end;
  forwards to let_(new(e1Var), @e1, let_(new(e2Var), @e2, @impl));
}

production eqInt
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} == ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = boolType();
  top.errors <- checkInt(e1, "left operand to ==");
  top.errors <- checkInt(e2, "right operand to ==");
}

production eqBool
top::Expr ::= e1::Expr e2::Expr
{
  top.pp = pp"${e1.wrapPP} == ${e2.wrapPP}";
  top.freeVars = e1.freeVars ++ e2.freeVars;
  top.type = boolType();
  top.errors <- checkBool(e1, "left operand to ==");
  top.errors <- checkBool(e2, "right operand to ==");
}

production intConst
top::Expr ::= i::Integer
{
  top.pp = text(toString(i));
  top.wrapPP = top.pp;
  top.freeVars = [];
  top.type = intType();
}

production trueConst
top::Expr ::=
{
  top.pp = pp"true";
  top.wrapPP = top.pp;
  top.freeVars = [];
  top.type = boolType();
}

production falseConst
top::Expr ::=
{
  top.pp = pp"false";
  top.wrapPP = top.pp;
  top.freeVars = [];
  top.type = boolType();
}

production let_
top::Expr ::= id::Name e::Expr body::Expr
{
  top.pp = group(pp"let ${id} = ${box(e.pp)}\nin ${box(body.pp)}\nend");
  top.wrapPP = top.pp;
  top.freeVars = e.freeVars ++ remove(id.name, e.freeVars);
  top.type = body.type;

  e.env = top.env;
  body.env = addEnv([(id.name, e.type)], top.env);
}

production var
top::Expr ::= id::Name
{
  top.pp = id.pp;
  top.wrapPP = top.pp;
  top.freeVars = [id.name];
  top.type = id.type;
  top.errors <- id.lookupErrors;
}

production errorExpr
top::Expr ::= msg::[Message]
{
  top.pp = pp"/*err*/";
  top.wrapPP = top.pp;
  top.freeVars = [];
  top.type = errorType();
  top.errors <- msg;
}

tracked nonterminal Exprs with pps, env, errors, freeVars;
propagate env, errors on Exprs;

production consExpr
top::Exprs ::= h::Expr t::Exprs
{
  top.pps = h.pp :: t.pps;
  top.freeVars = h.freeVars ++ t.freeVars;
}

production nilExpr
top::Exprs ::=
{
  top.pps = [];
  top.freeVars = [];
}
