import Http "http";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor Counter {

  stable var counter = 0;

  // Get the value of the counter.
  public query func get() : async Nat {
    return counter;
  };

  // Set the value of the counter.
  public func set(n : Nat) : async () {
    counter := n;
  };

  // Increment the value of the counter.
  public func inc() : async () {
    counter += 1;
  };


  public shared query func http_request(req: Http.HttpRequest): async (Http.HttpResponse) {
      let body1 = "<html><body><h1>";
      let body2=  Nat.toText(counter); 
      let body3 = "</h1></body></html>";
      let body = Text.concat(Text.concat(body1, body2), body3);
      {
        body = Text.encodeUtf8(body);
        headers = [];
        status_code = 200;
        streaming_strategy = null;
      };
   };
};
