:- writeln('*** Loading init file ***').
:- use_module(library(clpfd)).
:- set_prolog_flag(answer_write_options,
  [quoted(true),
   portray(true),
   max_depth(20),
   spacing(next_argument)
  ]).
