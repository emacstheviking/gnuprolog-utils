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
%% fmap/3 (thx: P.Moura!)
%%
%%--------------------------------------------------------------------
fmap(_, [], []).
fmap(MapFn, [HIN|TIN], [HOUT|TOUT]) :-
        call(MapFn, HIN, HOUT),
        fmap(MapFn, TIN, TOUT).



%%--------------------------------------------------------------------
%% join/2
%%
%% Unifies Out with the process of interspersing With between every
%% input list element. Handy for string joining.
%%--------------------------------------------------------------------
join([], _, []).

join(List,With,Out) :-
	join(List, With, [], Out).



%%--------------------------------------------------------------------
%% join/3
%%
%% Accumulator predicate for join/2
%%--------------------------------------------------------------------
join([], _, Acc, Out) :-
	reverse(Acc, Data),
	Data = [ _ | Out].

join([H|T], With, Acc, Out) :-
	join(T, With, [H, With | Acc], Out).



%%--------------------------------------------------------------------
%% loadfile/3
%%
%% Loads the contents of a file (any file) into a character code list.
%%--------------------------------------------------------------------
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
