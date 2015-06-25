%%====================================================================
%%
%% Simple Logging Predicates
%%
%% This is as simple a logging system as I need, it can manage a
%% single log filename and that's it. The default filename is
%% '/tmp/captains.log'.
%%====================================================================



%%--------------------------------------------------------------------
%% logger_output(+Filename:atom).
%%
%% This assigns the filename to the global variable so it can be
%% picked up during write operations.
%%--------------------------------------------------------------------
logger_output(Filename) :-
	atom(Filename),
	g_assign(logger_filename, Filename).


%%--------------------------------------------------------------------
%% logger_filename(-Filename:atom).
%%
%% Filename will be unified with either the default log filename or
%% whatever was given as the last argument to the last call of
%% logger_output/1.
%%--------------------------------------------------------------------
logger_filename(Filename) :-
	g_read(logger_filename, Filename),
	atom(Filename).

logger_filename('/tmp/captains.log').


%%--------------------------------------------------------------------
%%
%% OUTPUT PREDICATES
%%
%% These all cause output to be written to the designated logfile.
%%--------------------------------------------------------------------
logger_fail(String) :- logger('F', String, []).
logger_warn(String) :- logger('W', String, []).
logger_info(String) :- logger('I', String, []).

logger_fail(String, Args) :- logger('F', String, Args).
logger_warn(String, Args) :- logger('W', String, Args).
logger_info(String, Args) :- logger('I', String, Args).


%%--------------------------------------------------------------------
%% logger(+Level, +Format, +Args).
%%
%% Generic entry point for writing to the log file. Level should be a
%% one character atom, {F,W,I}, Format should contain a valid format
%% specifier and Args must be a list of arguments that matches the
%% expectation of the format specified.
%%--------------------------------------------------------------------
logger(Level, Format, Args) :-
	logger_open(Level, Log),
	format(Log, Format, Args),
	format(Log, "~n", []),
	close(Log, [force(true)]).


%%--------------------------------------------------------------------
%% logger_term(+Term).
%%
%% Uses portray_clause/2 to cause the Term to be written to the log
%% file.
%%--------------------------------------------------------------------
logger_term(Term) :-
	logger_open('T', Log),
	portray_clause(Log, Term),
	close(Log).


%%--------------------------------------------------------------------
%% logger_string(+String:character_codes).
%%
%% Writes a string to the logfile.
%%--------------------------------------------------------------------
logger_string(String) :-
	logger_open(term, Log),
	logger_string0(Log, String),
	close(Log).

logger_string0(_, []).
logger_string0(Log, [C|Cs]) :-
	format(Log, "%c", [C]),
	logger_string0(Log, Cs).


%%--------------------------------------------------------------------
%% logger_open(-Level, +Log).
%%
%% Level is one of the {F,W,I} level indicator atoms and on output Log
%% will be unified with an open file handle. The calling predicate
%% must close the handle.
%%--------------------------------------------------------------------
logger_open(Level, Log) :-
	logger_filename(LogFile),
	open(LogFile, append, Log, [type(text)]),
	date_time(dt(Yr,Mn,Dy,H,M,S)),
	format(Log,
	       "%d/%02d/%02d %02d:%02d:%02d ~a ",
	       [Yr, Mn, Dy, H, M, S, Level]).
