grammar edu:umn:cs:melt:sharedemo:composed:host;

imports edu:umn:cs:melt:sharedemo:host;
imports edu:umn:cs:melt:sharedemo:driver;

parser parse::Root_c {
  edu:umn:cs:melt:sharedemo:host;
}

--global main::(IO<Integer> ::= [String]) = driver(parse, _);
function main
IO<Integer> ::= arg::[String]
{
  return driver(parse, arg);
}
