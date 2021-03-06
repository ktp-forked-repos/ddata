:- use_module(library(ddata/pmap)).

greek(Map) :-
    pairs(
        Map,
        [alpha-one, beta-two, gamma-three, delta-four]
    ).

:- use_module(library(tap)).

'three insertions' :-
    % declare map contents
    insert(hello, world, empty,Map1),
    insert(goodbye, friends, Map1,Map2),
    insert(list, [1,2,3], Map2,Map),

    % can we fetch the right values?
    kv(Map,hello, World),
    World == world,
    kv(Map, goodbye, Friends),
    Friends == friends,
    kv(Map, list, List),
    List == [1,2,3].


'duplicate keys'(fail) :-
    insert(one, 1, empty, Map1),
    insert(one, won, Map1, _).


size :-
    greek(Map),
    size(Map,N),
    N == 4.


keys :-
    greek(Map),
    keys(Map,Keys0),
    msort(Keys0,Keys),  % make sure that key order is predictable
    Keys == [alpha,beta,delta,gamma].


'iterate keys' :-
    greek(Map),
    setof(Key-Value,kv(Map,Key,Value),Pairs),
    Pairs == [ alpha-one, beta-two, delta-four, gamma-three ].

'iterate keys with insert/4' :-
    greek(Map),
    setof(Key-Value,Map0^insert(Key,Value,Map0,Map),Pairs),
    Pairs == [ alpha-one, beta-two, delta-four, gamma-three ].

'iterate values' :-
    insert(alpha, greek, empty, Map1),
    insert(beta, greek, Map1, Map2),
    insert(aleph, hebrew, Map2, Map3),
    insert(beth, hebrew, Map3, Map),

    setof(Letter,kv(Map,Letter,greek),Greek),
    Greek == [alpha, beta],

    setof(Letter,kv(Map,Letter,hebrew),Hebrew),
    Hebrew == [aleph, beth].


'build map from pairs' :-
    pairs(Map,[a-1,b-2,c-3]),
    kv(Map,a,One),
    One == 1,
    kv(Map,b,Two),
    Two == 2,
    kv(Map,c,Three),
    Three == 3.

'build pairs from map' :-
    greek(M),
    pairs(M,Kvs0),
    msort(Kvs0,Kvs),  % make sure key order is predictable
    Kvs == [alpha-one, beta-two, delta-four, gamma-three].
