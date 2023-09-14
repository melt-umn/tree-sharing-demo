grammar edu:umn:cs:melt:sharedemo:translation;

attribute ctrans occurs on Expr;


aspect production addInt
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} + ${e2.ctrans})";
}

aspect production subInt
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} - ${e2.ctrans})";
}

aspect production mulInt
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} * ${e2.ctrans})";
}

aspect production divInt
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} / ${e2.ctrans})";
}

aspect production andOp
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} && ${e2.ctrans})";
}

aspect production orOp
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} || ${e2.ctrans})";
}

aspect production ltInt
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"(${e1.ctrans} < ${e2.ctrans})";
}

aspect production intNeg
top::Expr ::= e::Expr
{
  top.ctrans = pp"(-${e.ctrans})";
}

aspect production boolNeg
top::Expr ::= e::Expr
{
  top.ctrans = pp"(!${e.ctrans})";
}

aspect production eqInt
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"${e1.ctrans} == ${e2.ctrans}";
}

aspect production eqBool
top::Expr ::= e1::Expr e2::Expr
{
  top.ctrans = pp"${e1.ctrans} == ${e2.ctrans}";
}

aspect production intConst
top::Expr ::= i::Integer
{
  top.ctrans = text(toString(i));
}

aspect production trueConst
top::Expr ::=
{
  top.ctrans = pp"1";
}

aspect production falseConst
top::Expr ::=
{
  top.ctrans = pp"0";
}

aspect production let_
top::Expr ::= id::Name e::Expr body::Expr
{
  top.ctrans = pp"({${e.type.ctrans} ${id} = ${e.ctrans}; ${body.ctrans};})";
}

aspect production var
top::Expr ::= id::Name
{
  top.ctrans = id.pp;
}

aspect production errorExpr
top::Expr ::= msg::[Message]
{
  top.ctrans = pp"/*err*/";
}