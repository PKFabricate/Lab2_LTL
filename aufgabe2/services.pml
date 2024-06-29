/*
   services.pml
   Abstract model of simple web services with one client
*/

#define SERVER_COUNT  2
#define CLIENT_COUNT  1

mtype = {request, result}

chan services = [0] of { mtype, chan }

proctype server () {
   chan channel;
   do
   :: true ->
      // wait for a request
      services ? request(channel);
      // computations of the server abstracted away...
      // answer the request
      channel ! result
   od
}

proctype client () {
   chan channel = [0] of { mtype };
   do
   // non-deterministically do nothing
   :: true -> skip
   // non-deterministically finish the client
   :: true -> break
   // otherwise do something
   :: true ->
      // computations of the client abstracted away...
      // use a service
      services ! request, channel;
      channel ? result;
      // do something with the result (abstracted away)
   od
}

init {
   atomic {
      int i;
      for ( i : 0 .. SERVER_COUNT-1 ) {
         run server();
      }
      run client();
   }
}
