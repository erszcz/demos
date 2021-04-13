-module(callbacks_with_docs).

-export_type([t/0]).

-type t() :: any().
%% Type used to pass as a callback parameter. Just that.

-callback cb_with_simple_text_doc() -> ok.
%% This is a callback with simple text doc.

-callback cb_another_one(t()) -> ok | error.
%% And another one.
