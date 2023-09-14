grammar edu:umn:cs:melt:sharedemo:exts:forloop:abstractsyntax;

production forLoop
top::Stmt ::= iVar::Name lower::Expr upper::Expr body::Stmt
{
  top.pp = pp"for ${iVar} in ${lower} to ${upper} {${groupnestlines(2, body.pp)}}";
  local localErrors::[Message] =
    checkInt(lower, "lower bound") ++
    checkInt(upper, "upper bound") ++
    lower.errors ++ upper.errors ++ body.errors;

  local upperVar::Name = freshName(top.env);
  forward fwrd = block(seq(
    decl(new(iVar), intType(), @lower),
    seq(decl(new(upperVar), intType(), @upper),
      while(ltInt(var(new(iVar)), var(new(upperVar))),
        seq(@body, assign(new(iVar),
          addInt(var(new(iVar)), intConst(1))))))));
  forwards to if null(localErrors) then @fwrd
    else errorStmt(localErrors);
}
