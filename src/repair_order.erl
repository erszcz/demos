-module(repair_order).

-export([validate/1,
         invalid_use/0]).

-type result(Ok, Error) :: {ok, Ok} | {error, Error}.

-record(?MODULE, {order_number,
                  damage_description,
                  vehicle,
                  customer,
                  state}).
-type t(State) :: #?MODULE{state :: State}.

-type new() :: new.
-type valid() :: valid.
-type invalid() :: {invalid, [string()]}.
-record(in_progress, {assigned_technician,
                      steps_left = []}).
-type in_progress() :: #in_progress{}.
-type work_done() :: work_done.
-type waiting_for_payment() :: waiting_for_payment.
-type paid() :: {paid, non_neg_integer()}.

-spec validate(t(new())) -> result(t(valid()), t(invalid())).
validate(Order) ->
    case is_valid(Order) of
        true -> {ok, #?MODULE{state = valid}};
        %% This is correctly flagged as a type error by Gradualizer:
        %%
        %%   repair_order.erl: The tuple on line 39 at column 18 is expected to have type
        %%   result(t(valid()), t(invalid())) but it has type {error, #repair_order{}}
        %%
        %%    case is_valid(Order) of
        %%        true -> {ok, #?MODULE{state = valid}};
        %%        false -> {error, #?MODULE{state = invalid}}
        %%                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        %%
        %% But not identified as an error by Dialyzer.
        false -> {error, #?MODULE{state = invalid}}
        %false -> {error, #?MODULE{state = {invalid, ["error1", "error2"]}}}
    end.

-spec invalid_use() -> result(t(_), t(_)).
invalid_use() ->
    %% Gradualizer:
    %%
    %%   src/repair_order.erl: The atom on line 52 at column 31 is expected
    %%   to have type 'new' but it has type 'asd'
    %%
    %% Dialyzer - no warning
    validate(#?MODULE{state = asd}).
    %validate(#?MODULE{state = new}).

is_valid(_) -> false.
