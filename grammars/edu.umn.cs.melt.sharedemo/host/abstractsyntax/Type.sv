grammar edu:umn:cs:melt:sharedemo:host:abstractsyntax;

biequality attribute typeEqualPartial, typeEqual with compareTo;
tracked nonterminal Type with pp, compareTo<{compareTo}>, typeEqualPartial, typeEqual;
propagate compareTo, typeEqual on Type;
propagate typeEqualPartial on Type excluding errorType;

production intType
top::Type ::=
{
  top.pp = pp"int";
}

production boolType
top::Type ::=
{
  top.pp = pp"bool";
}

production errorType
top::Type ::=
{
  top.pp = pp"err";
  top.typeEqualPartial = true;
}

function typeEqual
Boolean ::= a::Type b::Type
{
  a.compareTo = b;
  b.compareTo = a;
  return a.typeEqual;
}

instance Eq Type {
  eq = typeEqual;
}

function checkInt
[Message] ::= e::Decorated Expr str::String
{
  return if e.type == intType() then [] else [errFromOrigin(e, s"Expected ${str} to be an int")];
}

function checkBool
[Message] ::= e::Decorated Expr str::String
{
  return if e.type == boolType() then [] else [errFromOrigin(e, s"Expected ${str} to be a bool")];
}

