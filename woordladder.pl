% File I/O
file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", L),
    delete(L, "", Lines).

% Building blocks
rstring_length(X, Word) :- string_length(Word, X).

same_length(Word, Words, Same) :-
    string_length(Word, X),
    include(rstring_length(X), Words, Same).


difference(String, String, 0) :- !.
%difference(String, String, 0).

difference(String1, String2, 1) :-
    string_length(String1, 1),
    string_length(String2, 1),
    !.

difference(String1, String2, D) :-
    string_length(String1, L),
    string_length(String2, L),
%    L > 1, !,
    sub_string(String1, 0, 1, After, H1), sub_string(String1, 1, After, _, T1),
    sub_string(String2, 0, 1, After, H2), sub_string(String2, 1, After, _, T2),
    difference(H1, H2, DH), difference(T1, T2, DT),
    D is DH + DT.

dif1(String1, String2) :- difference(String1, String2, 1).

% Find the paths from Start to End within words of the same length and one letter difference

ladder(Word, Goal, _, [Goal]) :-
    dif1(Word, Goal),
    !.

ladder(Word, Goal, Words, Ladder) :-
    length(Ladder, L),
    L < 10,
    [Head|Tail] = Ladder,
    delete(Words, Word, Rest),
    member(Head, Rest),
    dif1(Word, Head),
    ladder(Head, Goal, Rest, Tail).

woordladder(Start, Goal, Ladder) :-
    file_lines("woorden.txt", Lines),
    same_length(Start, Lines, Same),
    ladder(Start, Goal, Same, Ladder).

% Tests and notes

%file_lines('test.txt', Lines).

%file_lines("test.txt", Lines), same_length("uren", Lines, Same), include(dif1("uren"), Same, Dif1).
%Lines = Same, Same = ["uren", "uien", "wien", "wiek", "week", "bren", "been", "beek"],
%Dif1 = ["uien", "bren"].

%ladder("uren", "wien", ["uien", "wren"], ["uien", "wien"]).
%ladder("uren", "wien", ["uien", "wren"], ["wren", "wien"]).
