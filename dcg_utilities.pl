%%====================================================================
%%
%% GNU Prolog -- DCG Utilities
%%
%% @author Sean James Charles <sean at objitsu dot com>
%%
%% I cannot guarantee this won't smoke your system. Use at your own
%% risk as usual, I take no responsibility for any damage you may
%% cause with it. Usual rules apply concerning this sort of thing.
%%
%%====================================================================


%%--------------------------------------------------------------------
%% dcg_skipws//0.
%%
%% Skips optional whitespace. Depends on dcg_skipws1//1.
%%--------------------------------------------------------------------
dcg_skipws --> dcg_skipws1, dcg_skipws, !.
dcg_skipws --> dcg_skipws1, !.
dcg_skipws --> [].


%%--------------------------------------------------------------------
%% dcg_crlf//1.
%% dcg_cr//1.
%% dcf_lf//1.
%%
%% Simple line ending checks for parsing buffers etc.
%%--------------------------------------------------------------------
dcg_crlf --> "\r\n".
dcg_cr --> "\r".
dcg_lf --> "\n".


%%--------------------------------------------------------------------
%% dcg_scan_util//1.
%% Used to scan until a certain character is encountered.
%%--------------------------------------------------------------------
dcg_scan_until(Chr) --> [Chr]. %% ? [] should work!
dcg_scan_until(Chr) --> [C], {\+ C=Chr}, dcg_scan_until(Chr).



dcg_slurp_until(Chr, Out) -->
	dcg_slurp_until(Chr, [], Out).


dcg_slurp_until(Chr, Acc, Out), [Chr] -->
	[Chr],
	{reverse(Acc, Out)}.

dcg_slurp_until(Chr, Acc, Out) -->
	[C],
	{\+ C=Chr},
	dcg_slurp_until(Chr, [C | Acc], Out).


%%--------------------------------------------------------------------
%% dcg_next_token//1.
%%
%% Scans and consumes the next non-whitespace bounded token
%% sequence. The returned data is a character code list.
%%--------------------------------------------------------------------
dcg_next_token(T) --> dcg_next_token([], T).
dcg_next_tokenws(T) --> dcg_skipws, dcg_next_token([], T).

%% NOTE: We pushback the whitespace character W in order to maintain
%% the context for the calling parser! Very VERY important!
dcg_next_token(Acc, Out), [W] -->
	dcg_skipws1(W), {reverse(Acc, Out)}.

dcg_next_token(Acc, Out) --> [C], dcg_next_token([C|Acc], Out).
dcg_next_token(Acc, Out) --> [], {reverse(Acc, Out)}.


%%--------------------------------------------------------------------
%% dcg_skipws1//0.
%% dcg_skipws1//1.
%%
%% Whitespace: simple but effective; anything not ASCII printable is
%% considered to be whitespace. Second one returns the character in
%% case push-back is required.
%%--------------------------------------------------------------------
dcg_skipws1    --> [C], { C=<32 ; C>=127}.
dcg_skipws1(C) --> [C], { C=<32 ; C>=127}.


%%--------------------------------------------------------------------
%% dcg_string//1.
%%
%% Extraction of characters into a string. We return the string as a
%% character codes list. Empty string will of course be [].
%%--------------------------------------------------------------------
dcg_string(Str) --> [34], [34], {Str = str([])}, !.
dcg_string(Str) --> [34], dcg_strget([], Tmp), [34], !, {Str = str(Tmp)}.


%%--------------------------------------------------------------------
%% dcg_strget//2
%%
%% Extraction of a single character. We have three predicates, the
%% first manages the sequence (backslash, double-quote), the second
%% manages generic characters and the final predicate is when we have
%% consumed the contents of the string and need to reverse the
%% accumulator for presentation.
%%--------------------------------------------------------------------
dcg_strget(Acc, Out) -->
	[92, Chr],		% Backslash something
	dcg_strget([Chr, 92 | Acc], Out).

dcg_strget(Acc, Out) -->
	dcg_char(Chr),
	dcg_strget([Chr | Acc], Out).

dcg_strget(Acc, Str) --> [],
	{reverse(Acc, Str)}, !.


%%--------------------------------------------------------------------
%% dcg_char//1.
%%
%% Within the context of our DCG ruleset, we allow any thing into a
%% string except the double quote character. The only exception we
%% recognise is the sequence '\"' used to escape a double quote within
%% the string. The dcg_strget//2 predicate handles that situation.
%% anything BUT a double-quote character is a valid character
%%--------------------------------------------------------------------
dcg_char(C) --> [C], {C \= 34}.


%%--------------------------------------------------------------------
%% dcg_digit//1.
%% Scan a single digit 0-9 or 1-9
%%--------------------------------------------------------------------
dcg_digit(D) --> [Chr], { "0"=<Chr, Chr=<"9", D is Chr-"0"}.
dcg_digit19(D) --> dcg_digit(D), {D > 0}.


%%--------------------------------------------------------------------
%% dcg_digits//1.
%% Scan a a series of digits, returns actual value
%%--------------------------------------------------------------------
dcg_digits(Val) --> dcg_digit(D0), dcg_digsum(D0, Val).
dcg_digits(Val) --> dcg_digit(Val).


%%--------------------------------------------------------------------
%% dcg_digsum//2.
%% Scan/consume digits returning decimal value to json_digits//1.
%%--------------------------------------------------------------------
dcg_digsum(Acc, N) -->
	dcg_digit(D),
	{Acc1 is Acc*10 + D},
	dcg_digsum(Acc1, N).

dcg_digsum(N, N) --> [], !.
