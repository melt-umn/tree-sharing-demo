grammar edu:umn:cs:melt:sharedemo:host:abstractsyntax;

synthesized attribute name::String;

synthesized attribute lookupErrors::[Message];

tracked nonterminal Name with pp, name, env, type, lookupErrors;

production name
top::Name ::= n::String
{
  top.pp = text(n);
  top.name = n;

  local lookupRes::[Type] = lookupEnv(n, top.env);
  top.lookupErrors =
    if null(lookupRes) then [errFromOrigin(top, s"Undefined variable ${n}")] else [];
  top.type = if null(lookupRes) then errorType() else head(lookupRes);
}

function freshName
Name ::= e::Env
{
  return name(s"_n${toString(genInt())}");
}
