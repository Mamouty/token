import Principal "mo:base/Principal"; // To use the Principal Data Type.
import HashMap "mo:base/HashMap";

actor Token {

    //Creating a variable of type Principle.
    //Converting the principle id from text to principle data type using the function fromText();
    var owner : Principal = Principal.fromText("2qv2o-owgj3-hsfse-y7qjv-j5xwz-vi573-rokcm-cm6u7-uwith-yuolg-uae"); 
    var totalSupply : Nat = 1000000000; //The total supply of our particular token.
    var symbol : Text = "DMAG"; //Giving a symbol to our token.

    //Using HashMap to create a ledger  that is going to store the id of a particular user or canister. 
    //The key for the HashMap will be the principal which will be linked to the value of the custom token they own which is a natural number.
    //We then initialize the HashMap with three inputs, the first one is the initial size of the hashmap, the second it the method used to check the equality of the keys and the third one is how the hashmap should hash the keys.
    var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    //Adding the owner to the ledger as the first entry.
    balances.put(owner, totalSupply);

    //Creating a check balance method to see who owns how much. 
    public query func balanceOf(who: Principal) : async Nat {      
        let balance : Nat = switch (balances.get(who)) {
        case null 0;//if it's null return zero
        case (?result) result;//if it's an optional result return the very result
    };
    return balance;
    }

};