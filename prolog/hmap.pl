:- module(hmap, [kv/3]).

% node(Hash,Key,Value)

kv(Map,Key,Value) :-
    term_hash(Key,Hash),
    Depth is floor(log(Hash)/log(8)),  % log8(Hash)
    kv(Depth,Hash,Map,Hash,Key,Value).

kv(0,_P,Node,Hash,Key,Value) :-
    node(Node,Hash,Key,Value),
    !.
kv(Depth,P,Node,Hash,Key,Value) :-
    Depth > 0,
    node(Node,_,_,_),
    N is 4 + (P /\ 0b111),
    arg(N,Node,Child),
    Depth1 is Depth - 1,
    P1 is P >> 3,
    kv(Depth1,P1,Child,Hash,Key,Value).


node(Node,Hash,Key,Value) :-
    functor(Node,node,11 /*3+8*/),
    arg(1,Node,Hash),
    arg(2,Node,Key),
    arg(3,Node,Value).


show(Map) :-
    show(Map,0).

show(Map,Indent) :-
    var(Map),
    !,
    indent(Indent),
    format(".~n").
show(Node,Indent) :-
    node(Node,_,K,V),
    indent(Indent),
    format("~p => ~p~n", [K,V]),
    succ(Indent,NextIndent),
    forall( between(4,11,N)
          , ( arg(N,Node,X)
            , show(X,NextIndent)
            )
          ).

indent(N) :-
    forall( between(1,N,_), write("    ") ).
