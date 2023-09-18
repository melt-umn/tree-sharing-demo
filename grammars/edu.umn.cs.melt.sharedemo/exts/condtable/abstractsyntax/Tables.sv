grammar edu:umn:cs:melt:sharedemo:exts:condtable:abstractsyntax;

production condTable
top::Expr ::= rows::TRows
{
  top.pp = pp"table { ${box(group(ppImplode(line(), rows.pps)))} }";
  top.wrapPP = top.pp;
  rows.numCols = nothing();
  rows.conds = [];

  --top.errors <- rows.errors;
  --forwards to @rows.trans;

  forward fwrd = @rows.trans;
  forwards to if null(rows.errors) then @fwrd else errorExpr(rows.errors);
}

inherited attribute numCols::Maybe<Integer>;
inherited attribute conds::[Expr];
translation attribute trans::Expr;
nonterminal TRows with pps, numCols, errors, conds, trans;
propagate errors on TRows;

production consRow
top::TRows ::= e::Expr tf::TruthFlags rest::TRows
{
  top.pps = pp"${e} : ${tf}" :: rest.pps;
  top.errors <- checkBool(e, "row expression");
  top.errors <-
    case top.numCols of
    | just(n) when n != length(tf.rowConds) ->
      [errFromOrigin(tf, s"Expected ${toString(n)} columns, but this row has ${toString(length(tf.rowConds))}")]
    | _ -> []
    end;
  rest.numCols = just(length(tf.rowConds));

  local eVar::Name = freshName(top.trans.env);
  tf.rowExpr = var(new(eVar));
  rest.conds =
    if null(top.conds)
    then tf.rowConds
    else zipWith(andOp, top.conds, tf.rowConds);
  top.trans = let_(@eVar, @e, @rest.trans);
}
production nilRow
top::TRows ::=
{
  top.pps = [];
  top.errors <-
    case top.numCols of
    | nothing() -> [errFromOrigin(top, "Table cannot be empty")]
    | just(_) -> []
    end;

  top.trans = foldr1(orOp, top.conds);
}

inherited attribute rowExpr::Expr;
synthesized attribute rowConds::[Expr];
nonterminal TruthFlags with pp, rowExpr, rowConds;
propagate rowExpr on TruthFlags;

production consTruthFlag
top::TruthFlags ::= h::TruthFlag t::TruthFlags
{
  top.pp = pp"${h} ${t}";
  top.rowConds = h.rowCond :: t.rowConds;
}
production nilTruthFlag
top::TruthFlags ::=
{
  top.pp = pp"";
  top.rowConds = [];
}

synthesized attribute rowCond::Expr;
nonterminal TruthFlag with pp, rowExpr, rowCond;
propagate rowExpr on TruthFlag;

production trueFlag
top::TruthFlag ::=
{
  top.pp = pp"T";
  top.rowCond = top.rowExpr;
}
production falseFlag
top::TruthFlag ::=
{
  top.pp = pp"F";
  top.rowCond = neg(top.rowExpr);
}
production starFlag
top::TruthFlag ::=
{
  top.pp = pp"*";
  top.rowCond = trueConst();
}
