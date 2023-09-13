grammar edu:umn:cs:melt:sharedemo:host;

import silver:util:treemap as tm;

type Defs = [(String, Type)];
type Env = tm:Map<String Type>;

monoid attribute defs::Defs;
inherited attribute env::Env;

global emptyEnv::Env = tm:empty();
global addEnv::(Env ::= Defs Env) = tm:add;
global lookupEnv::([Type] ::= String Env) = tm:lookup;
