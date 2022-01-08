import Text "mo:base/Text";
import Nat "mo:base/Nat";
actor Counter {
    stable var currentValue : Nat = 0;

    public func increment() : async () {
        currentValue += 1;
    };

    public query func get() : async Nat {
        currentValue;
    };

    public func set(value : Nat) : async () {
        currentValue := value;
    };

    public type HeaderField = (Text, Text);
    public type StreamingStrategy = {
        #Callback : {
            token : StreamingCallbackToken;
            callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };
    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };
    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };
    public type HttpRequest = {
        url : Text;
        method: Text;
        body : [Nat8];
        headers :[HeaderField];
    };
    public type HttpResponse = {
        body : Blob;
        headers : [HeaderField];
        streaming_strategy : ?StreamingStrategy;
        status_code : Nat16;
    };

    public shared query func http_request(request: HttpRequest) : async HttpResponse {
        {
            // body = Text.encodeUtf8("<html><body><h1>"+currentValue+"</h1></body></html>");
            //body = Text.encodeUtf8("<html><body><h1>" # Nat.toText(currentValue) # "</h1></body></html>");

            body = Text.encodeUtf8("<html><body><h1 id=app></h1><script>document.getElementById('app').innerHTML=" # Nat.toText(currentValue) # "</script></body></html>");
            headers = [];
            streaming_strategy = null;
            status_code = 200;
        }
    };
}


