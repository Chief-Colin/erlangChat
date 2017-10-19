%%Author CollinsAdomako, 2017
%% me@collinsadomko.org
-module(helpers).

%%
%% Include files
%%
-compile(export_all).
-include_lib("stdlib/include/qlc.hrl").
-include("records.hrl").


%%
%% API Functions
%%

%% Users API

insert( Username, Course, Year_Admitted, Password) ->
    Fun = fun() ->
         mnesia:write(
         #user{ username=Username,
                   course=Course, 
                        year_admitted=Year_Admitted,
                        password=Password    } )
               end,
         mnesia:transaction(Fun).
  
select( Index) ->
    Fun = 
        fun() ->
            mnesia:read({user, Index})
        end,
    {atomic, [Row]}=mnesia:transaction(Fun),
    io:format(" ~p ~p ~n ", [Row#user.username, Row#user.course] ).

select_some( Artist) ->
    Fun = 
        fun() ->
            mnesia:match_object({user, '_', Artist, '_' } )
        end,
    {atomic, Results} = mnesia:transaction( Fun),
    Results.
 
select_all() -> 
    mnesia:transaction( 
    fun() ->
        qlc:eval( qlc:q(
            [ X || X <- mnesia:table(user) ] 
        )) 
    end ).
  
select_search( Word ) -> 
    mnesia:transaction( 
    fun() ->
         qlc:eval( qlc:q(
              [ {F0,F1,F2,F3} || 
                   {F0,F1,F2,F3} <- 
                        mnesia:table(user),
                        (string:str(F2, Word)>0) or  
                        (string:str(F3, Word)>0)
               ] )) 
    end ).