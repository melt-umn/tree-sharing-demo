grammar edu:umn:cs:melt:sharedemo:driver;

imports silver:langutil;
imports silver:langutil:pp;

imports edu:umn:cs:melt:sharedemo:concretesyntax;
imports edu:umn:cs:melt:sharedemo:host;
imports edu:umn:cs:melt:sharedemo:translation;

parser parse::Root_c {
  edu:umn:cs:melt:sharedemo:concretesyntax;
}

function main
IO<Integer> ::= args::[String]
{
  local fileName :: String = head(args);
  local cFileName :: String = head(explode(".", fileName)) ++ ".c";
  return do {
    if length(args) != 1 || !endsWith(".demo", fileName) then do {
      print("Usage: java -jar sharedemo.jar [file name].demo\n");
      return 1;
    } else do {
      isF::Boolean <- isFile(fileName);
      if !isF then do {
        print("File \"" ++ fileName ++ "\" not found.\n");
        return 2;
      } else do {
        text :: String <- readFile(fileName);
        let result :: ParseResult<Root_c> = parse(text, fileName);
        if !result.parseSuccess then do {
          print(result.parseErrors ++ "\n");
          return 3;
        } else do {
          let ast::Decorated Root = decorate result.parseTree.ast with {};
          if !null(ast.errors) then do {
            print(messagesToString(ast.errors) ++ "\n");
            return 4;
          } else do {
            writeFile(cFileName, show(80, ast.ctrans));
            return 0;
          };
        };
      };
    };
  };
}
