import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

actor {
  public type Message = {
    time: Time.Time;
    author: Text;
    msg: Text;
  };

  public type Microblog = actor {
    set_name: shared (Text, Text) -> async ();
    get_name: shared query () -> async Text;
    follow: shared (Principal, Text) -> async ();
    follows: shared query () -> async [Principal];
    post: shared (Text, Text) -> async ();
    posts: shared query () -> async [Message];
    timeline: shared () -> async [Message];
  };

  var name = "";
  let otp = "123456";

  var followed: List.List<Principal> = List.nil();

  public shared func set_name(name_var: Text, otp_var: Text): async () {
    assert(otp == otp_var);
    name := name_var;
  };

  public shared query func get_name (): async Text {
    name;
  };

  public shared func follow(id: Principal, otp_var: Text): async () {
    assert(otp == otp_var);
    followed := List.push(id, followed);
  };

  public shared query func follows(): async [Principal] {
    List.toArray(followed);
  };
  
  var messages : List.List<Message> = List.nil();

  public shared func post(text: Text, otp_var: Text): async () {
    assert(otp == otp_var);
    assert(name != "");
    let payload : Message = {
      time = Time.now(); 
      author = name; 
      msg = text
    };
    messages := List.push(payload, messages);
  };

  public shared func posts(): async [Message] {
        List.toArray(messages);
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
