grammar edu:umn:cs:melt:sharedemo:composed:with_forloop;

imports edu:umn:cs:melt:sharedemo:host;
imports edu:umn:cs:melt:sharedemo:driver;

parser parse::Root_c {
  edu:umn:cs:melt:sharedemo:host;
  edu:umn:cs:melt:sharedemo:exts:forloop;
}

--global main::(IO<Integer> ::= [String]) = driver(parse, _);
function main
IO<Integer> ::= arg::[String]
{
  return driver(parse, arg);
}
