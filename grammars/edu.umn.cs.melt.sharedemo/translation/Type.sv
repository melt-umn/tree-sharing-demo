grammar edu:umn:cs:melt:sharedemo:translation;

attribute ctrans occurs on Type;

aspect production intType
top::Type ::=
{
  top.ctrans = pp"int";
}

aspect production boolType
top::Type ::=
{
  top.ctrans = pp"_Bool";
}

aspect production errorType
top::Type ::=
{
  top.ctrans = pp"err";
}
