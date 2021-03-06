-module(mmynapi_tests).
-include("../include/mmynapi.hrl").
-include_lib("eunit/include/eunit.hrl").

to_json_test_() ->
	[
        {"Convert '#mmyn.message{}' to JSON document",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.sendsms\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"sender\":\"ASENDER\",\"msisdn\":\"+23481618\",\"message\":\"a dumb message\"}}">>,
                mmynapi:to_json(#'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"req.sendsms">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'req.sendsms'{
                            sender= <<"ASENDER">>, msisdn= <<"+23481618">>, 
                            message= <<"a dumb message">>}}))},
        {"Convert #'req.sendsms'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.sendsms\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"sender\":\"ASENDER\",\"msisdn\":\"+23481618\",\"message\":\"a dumb message\"}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'req.sendsms'{
                            sender= <<"ASENDER">>, msisdn= <<"+23481618">>, 
                            message= <<"a dumb message">>}))},
        {"Convert #'res.sendsms'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"res.sendsms\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"status\":0,\"detail\":\"All Okay\"}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'res.sendsms'{
                            status=0, detail= <<"All Okay">>}))},
        {"Convert #'req.reply'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.reply\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"id\":\"0xcafebabe\",\"sender\":\"ASENDER\",\"msisdn\":\"+23481618\",\"message\":\"a dumb message\"}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'req.reply'{
                            id= <<"0xcafebabe">>, sender= <<"ASENDER">>, msisdn= <<"+23481618">>, 
                            message= <<"a dumb message">>}))},
        {"Convert #'res.reply'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"res.reply\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"status\":0,\"detail\":\"All Okay\"}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'res.reply'{
                            status=0, detail= <<"All Okay">>}))},
        {"Convert #'req.notify'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.notify\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"id\":\"0xcafebabe\",\"shortcode\":4000,\"keywords\":[\"kwd\"],\"msisdn\":\"+23481618\",\"message\":\"a dumb message\",\"max_ttl\":30}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'req.notify'{
                            id= <<"0xcafebabe">>, shortcode=4000,
                            keywords= [<<"kwd">>], msisdn= <<"+23481618">>, 
                            message= <<"a dumb message">>, max_ttl=30}))},
        {"Convert #'res.notify'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"res.notify\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"status\":0,\"detail\":\"All Okay\",\"wait_for_reply\":false,\"ttl\":60}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'res.notify'{
                            status=0, detail= <<"All Okay">>,
                            wait_for_reply=false, ttl=60}))},
        {"Convert #'mmyn.fault'{} to JSON via mmynapi:to_json/3",
            ?_assertEqual(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"mmyn.fault\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"code\":0,\"detail\":\"All Okay\"}}">>,
                mmynapi:to_json('mmyn', '0xdeadbeef', #'mmyn.fault'{
                            code=0, detail= <<"All Okay">>}))}
   ].

from_json_test_() ->
    [
        {"Convert req.sendsms JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"req.sendsms">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'req.sendsms'{
                            sender= <<"ASENDER">>, msisdn= <<"+23481618">>, 
                            message= <<"a dumb message">>}}},
                    mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.sendsms\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"sender\":\"ASENDER\",\"msisdn\":\"+23481618\",\"message\":\"a dumb message\"}}">>))},
        {"Convert res.sendsms JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"res.sendsms">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'res.sendsms'{
                            status= 0, detail= <<"All okay!">>}}},
                    mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"res.sendsms\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"status\":0,\"detail\":\"All okay!\"}}">>))},
        {"Convert req.reply JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"req.reply">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'req.reply'{id= <<"0xcafebabe">>,
                            sender= <<"ASENDER">>, msisdn= <<"+23481618">>, 
                            message= <<"a dumb message">>}}},
                mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.reply\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"id\":\"0xcafebabe\", \"sender\":\"ASENDER\",\"msisdn\":\"+23481618\",\"message\":\"a dumb message\"}}">>))},
        {"Convert res.reply JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"res.reply">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'res.reply'{
                            status= 0, detail= <<"All okay!">>}}},
                    mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"res.reply\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"status\":0,\"detail\":\"All okay!\"}}">>))},
        {"Convert req.notify JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"req.notify">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'req.notify'{id= <<"0xcafebabe">>,
                            shortcode= 5999, keywords=[<<"kwd1">>],
                            msisdn= <<"+23481618">>, message= <<"a dumb message">>,
                            max_ttl=60 }}},
                mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"req.notify\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"id\":\"0xcafebabe\", \"shortcode\":5999,\"keywords\":[\"kwd1\"],\"msisdn\":\"+23481618\",\"message\":\"a dumb message\",\"max_ttl\":60}}">>))},
        {"Convert res.notify JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"res.notify">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'res.notify'{
                            status= 0, detail= <<"All okay!">>, wait_for_reply=true, ttl=60}}},
                    mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"res.notify\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"status\":0,\"detail\":\"All okay!\",\"wait_for_reply\":true,\"ttl\":60}}">>))},
        {"Convert mmyn.fault JSON document to #'mmyn.message'{} ",
            ?_assertEqual({ok, #'mmyn.message'{
                        h=#'mmyn.header'{ 
                            vsn= [2,0,1], type= <<"mmyn.fault">>, 
                            system= <<"mmyn">>, transaction_id= <<"0xdeadbeef">>},
                        b=#'mmyn.fault'{
                            code= 0, detail= <<"All okay!">>}}},
                    mmynapi:from_json(<<"{\"header\":{\"vsn\":[2,0,1],\"type\":\"mmyn.fault\",\"system\":\"mmyn\",\"transaction_id\":\"0xdeadbeef\"},\"body\":{\"code\":0,\"detail\":\"All okay!\"}}">>))}
    ].
