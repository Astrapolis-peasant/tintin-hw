import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

actor {
  public type Message = (    
    time: Time.Time,
    msg: Text
  );

  public type Microblog = actor {
    follow: shared(Principal) -> async ();
    follows: shared query () -> async [Principal];
    post: shared (Text) -> async ();
    posts: shared query () -> async [Message];
    timeline: shared () -> async [Message];
  };

  var followed: List.List<Principal> = List.nil();

  public shared func follow(id: Principal): async () {
    followed := List.push(id, followed);
  };

  public shared query func follows(): async [Principal] {
    List.toArray(followed);
  };
  
  var messages : List.List<Message> = List.nil();

  public shared func post(text: Text): async () {
    messages := List.push((Time.now(), text), messages);
  };

  public shared func posts(since: Time.Time): async [Message] {
        var msgs_since : List.List<Message> = List.nil();
        for (msg in Iter.fromList(messages)){
            if (msg.0>=since){
                msgs_since := List.push(msg, msgs_since);
            };
        };
        List.toArray(msgs_since)
  };

  public shared func timeline (): async [Message] {
    var all : List.List<Message> = List.nil(); 

    for (id in Iter.fromList(followed)){
      let canister: Microblog = actor(Principal.toText(id));
      let msgs = await canister.posts();
      for (msg in Iter.fromArray(msgs)){
        all := List.push(msg, all);
      }
    };
      List.toArray(all);
  };
};
