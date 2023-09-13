grammar edu:umn:cs:melt:sharedemo:translation;

synthesized attribute ctrans::Document;

attribute ctrans occurs on Root;

aspect production root
top::Root ::= s::Stmt
{
  top.ctrans = pp"""
#include <stdio.h>

int main() {
  ${nest(2, s.ctrans)}
}
""";
}
