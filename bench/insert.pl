:- use_module(library(hmap), [kv/3]).
:- use_module(library(quickcheck), [arbitrary/2]).
:- use_module(library(random), [random_permutation/2]).
:- use_module(library(assoc), [empty_assoc/1,put_assoc/4]).

:- use_module(bench, [compare/1]).

batch_size(3).

main(_) :-
    random_keys(Keys),
    random_values(Keys,Vals),
    compare([ assoc(_,Keys,Vals)
            , hmap(_,Keys,Vals)
            , dict(_,Keys,Vals)
           ]).


random_keys(Unique) :-
    batch_size(N),
    length(Keys,N),
    maplist(arbitrary(atom),Keys),
    sort(Keys,Sorted),
    random_permutation(Sorted,Unique).


random_values(Keys,Values) :-
    same_length(Keys,Values),
    maplist(arbitrary(any),Values).


hmap(Map,Keys,Vals) :-
    maplist(kv(Map),Keys,Vals).


dict(Dict,Keys,Vals) :-
    foldl(insert_dict,Keys,Vals,_{},Dict).

insert_dict(K,V,D0,D1) :-
    put_dict(K,D0,V,D1).


assoc(Assoc,Keys,Vals) :-
    empty_assoc(E),
    foldl(insert_assoc,Keys,Vals,E,Assoc).

insert_assoc(K,V,A0,A1) :-
    put_assoc(K,A0,V,A1).
