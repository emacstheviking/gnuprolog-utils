:- include('../utilities').
:- include(testing_framework).

test_encode_three_characters :- base64("Man", X), tf_equals("TWFu", X).
test_encode_two_characters   :- base64("Ma", X), tf_equals("TWE=", X).
test_encode_one_character    :- base64("M", X), tf_equals("TQ==", X).

test_long_string_padding_1 :-
	base64("any carnal pleasure.", X),
	tf_equals("YW55IGNhcm5hbCBwbGVhc3VyZS4=", X).

test_long_string_padding_2 :-
	base64("any carnal pleasure", X),
	tf_equals("YW55IGNhcm5hbCBwbGVhc3VyZQ==", X).

test_long_string_padding_0 :-
	base64("any carnal pleasur", X),
	tf_equals("YW55IGNhcm5hbCBwbGVhc3Vy", X).

test_short_string_sure_1 :-
	base64("pleasure.", X), tf_equals("cGxlYXN1cmUu", X).

test_short_string_sure_2 :-
	base64("leasure.", X), tf_equals("bGVhc3VyZS4=", X).

test_short_string_sure_3 :-
	base64("easure.", X), tf_equals("ZWFzdXJlLg==", X).

test_short_string_sure_4 :-
	base64("asure.", X), tf_equals("YXN1cmUu", X).

test_short_string_sure_5 :-
	base64("sure.", X), tf_equals("c3VyZS4=", X).

test_large_text_encoding :-
	base64("Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.", X),
	tf_equals("TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=", X).
