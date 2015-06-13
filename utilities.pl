%%====================================================================
%%
%% GNU Prolog -- Useful utilities
%%
%% @author Sean James Charles <sean at objitsu dot com>
%%
%% I cannot guarantee this won't smoke your system. Use at your own
%% risk as usual, I take no responsibility for any damage you may
%% cause with it. Usual rules apply concerning this sort of thing.
%%
%%====================================================================


%%--------------------------------------------------------------------
%% fmap(+Functor, +In, -Out).
%%
%% Maps a functor over a list to produce a new list. This predicate
%% can be used with functions that take two arguments, e.g. atom_codes
%% and it will work either way. Thanks to GNU list and Paulo Moura for
%% help on this one.
%%
%% --------------------------------------------------------------------
fmap(_, [], []).

fmap(MapFn, [HIN|TIN], [HOUT|TOUT]) :-
        call(MapFn, HIN, HOUT),
        fmap(MapFn, TIN, TOUT).


%%--------------------------------------------------------------------
%% join(+In, +With, -Out).
%%
%% Unifies Out with the process of interspersing With between every
%% input list element. Handy for string joining e.g. PHP `implode`
%% sort of thing.
%% --------------------------------------------------------------------
join([], _, []).

join(List, With, Out) :-
	join(List, With, [], Out).


%%--------------------------------------------------------------------
%% join/4.
%%
%% Accumulator predicate for join/2, not intended for external use but
%% do what you like I guess.
%% --------------------------------------------------------------------
join([], _, Acc, Out) :-
	reverse(Acc, Data),
	Data = [ _ | Out].

join([H | T], With, Acc, Out) :-
	join(T, With, [H, With | Acc], Out).


%%--------------------------------------------------------------------
%% loadfile(+Filename, -Out).
%%
%% Loads the contents of a file (any file) into a character code list.
%% I use this a lot to parse a file with a DCG. Unlike SWI, gprolog
%% doesn't yet have the ability to run a DCG suite over a file so this
%% is the way I do it. Of course, you have to be able to load the
%% whole file into memory!
%% --------------------------------------------------------------------
loadfile(Filename, Out) :-
	open(Filename, read, Stream),
	loadfile(Stream, [], Out),
	close(Stream).

loadfile(Stream, Acc, Out) :-
	at_end_of_stream(Stream),
	reverse(Acc, Out),
	!.

loadfile(Stream, Acc, Out) :-
	get_code(Stream, Chr),
	loadfile(Stream, [Chr | Acc], Out).
