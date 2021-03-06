-module(mmynapi_decode).
-export([to_message/1, to_header/1, to_body/2]).
-include("mmynapi.hrl").


to_message({PropList}) ->
    case proplists:get_value(<<"header">>, PropList) of
        undefined ->
            {error, no_header};
        Header ->
            case to_header(Header) of 
                {error, Reason} ->
                    {error, Reason};
                {ok, #'mmyn.header'{type=MsgType}=Hrecord} -> 
                    case proplists:get_value(<<"body">>, PropList) of 
                        undefined -> 
                            {error, no_body}; 
                        Body -> 
                            case to_body(MsgType, Body) of
                                {error, Reason} ->
                                    {error, Reason};
                                {ok, Brecord} ->
                                    {ok, #'mmyn.message'{h=Hrecord, b=Brecord}}
                            end
                    end
            end
    end.

to_header({PropList}) ->
    case proplists:get_value(<<"vsn">>, PropList) of
        undefined ->
            {error, no_version};
        ?MMYN_MSG_VSN->
            case proplists:get_value(<<"type">>, PropList) of
                undefined ->
                    {error, no_type};
                Type ->
                    case proplists:get_value(<<"system">>, PropList) of
                        undefined ->
                            {error, no_system};
                        Sid ->
                            case proplists:get_value(<<"transaction_id">>, PropList) of
                                undefined ->
                                    {error, no_transaction_id};
                                Tid ->
                                    {ok, #'mmyn.header'{vsn=?MMYN_MSG_VSN, type=Type, system=Sid, transaction_id=Tid}}
                            end
                    end
            end;
        N ->
            {error, {wrong_msg_vsn, [{current_msg_vsn, ?MMYN_MSG_VSN}, {parsed_msg_vsn, N}]}}
    end.

to_body(<<"req.sendsms">>, {PropList}) ->
    case proplists:get_value(<<"sender">>, PropList) of
        undefined ->
            {error, no_sender};
        Sender ->
            case proplists:get_value(<<"msisdn">>, PropList) of
                undefined ->
                    {error, no_msisdn};
                Msisdn ->
                    case proplists:get_value(<<"message">>, PropList) of
                        undefined ->
                            {error, no_message};
                        Message ->
                            {ok, #'req.sendsms'{sender=Sender, msisdn=Msisdn, message=Message}}
                    end
            end
    end;
to_body(<<"res.sendsms">>, {PropList}) ->
    case proplists:get_value(<<"status">>, PropList) of
        undefined ->
            {error, no_status};
        Status->
            case proplists:get_value(<<"detail">>, PropList) of
                undefined ->
                    {error, no_detail};
                Detail -> 
                    {ok, #'res.sendsms'{status=Status, detail=Detail}}
            end
    end;
to_body(<<"req.reply">>, {PropList}) ->
    case proplists:get_value(<<"id">>, PropList) of
        undefined ->
            {error, no_id};
        Id ->
            case proplists:get_value(<<"sender">>, PropList) of
                undefined ->
                    {error, no_sender};
                Sender ->
                    case proplists:get_value(<<"msisdn">>, PropList) of
                        undefined ->
                            {error, no_msisdn};
                        Msisdn ->
                            case proplists:get_value(<<"message">>, PropList) of
                                undefined ->
                                    {error, no_message};
                                Message ->
                                    {ok, #'req.reply'{id=Id, sender=Sender, msisdn=Msisdn, message=Message}}
                            end
                    end
            end
    end;
to_body(<<"res.reply">>, {PropList}) ->
    case proplists:get_value(<<"status">>, PropList) of
        undefined ->
            {error, no_status};
        Status->
            case proplists:get_value(<<"detail">>, PropList) of
                undefined ->
                    {error, no_detail};
                Detail -> 
                    {ok, #'res.reply'{status=Status, detail=Detail}}
            end
    end;
to_body(<<"req.notify">>, {PropList}) ->
    case proplists:get_value(<<"id">>, PropList) of
        undefined ->
            {error, no_id};
        Id ->
            case proplists:get_value(<<"shortcode">>, PropList) of
                undefined ->
                    {error, no_shortcode};
                Shortcode ->
                    case proplists:get_value(<<"keywords">>, PropList) of
                        undefined ->
                            {error, no_keywords};
                        Keywords ->
                            case proplists:get_value(<<"msisdn">>, PropList) of
                                undefined ->
                                    {error, no_msisdn};
                                Msisdn ->
                                    case proplists:get_value(<<"message">>, PropList) of
                                        undefined ->
                                            {error, no_message};
                                        Message ->
                                            case proplists:get_value(<<"max_ttl">>, PropList) of
                                                undefined ->
                                                    {error, no_max_ttl};
                                                MaxTtl -> 
                                                    {ok, #'req.notify'{id=Id, shortcode=Shortcode, keywords=Keywords,
                                                                       msisdn=Msisdn, message=Message, max_ttl=MaxTtl}}
                                            end
                                    end
                            end
                    end
            end
    end;
to_body(<<"res.notify">>, {PropList}) ->
    case proplists:get_value(<<"status">>, PropList) of
        undefined ->
            {error, no_status};
        Status->
            case proplists:get_value(<<"detail">>, PropList) of
                undefined ->
                    {error, no_detail};
                Detail -> 
                    case proplists:get_value(<<"wait_for_reply">>, PropList) of
                        undefined ->
                            {error, no_wait_for_reply};
                        WaitForReply ->
                            case proplists:get_value(<<"ttl">>, PropList) of
                                undefined ->
                                    {error, no_ttl};
                                Ttl -> 
                                    {ok, #'res.notify'{status=Status, detail=Detail, 
                                            wait_for_reply=WaitForReply, ttl=Ttl}}
                            end
                    end
            end
    end;
to_body(<<"mmyn.fault">>, {PropList}) ->
    case proplists:get_value(<<"code">>, PropList) of
        undefined ->
            {error, no_code};
        Code ->
            case proplists:get_value(<<"detail">>, PropList) of
                undefined ->
                    {error, no_detail};
                Detail -> 
                    {ok, #'mmyn.fault'{code=Code, detail=Detail}}
            end
    end.
