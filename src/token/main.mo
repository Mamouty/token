import Principal "mo:base/Principal"; // To use the Principal Data Type.
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";

actor Token {

    //Creating a variable of type Principle.
    //Converting the principle id from text to principle data type using the function fromText();
    var owner : Principal = Principal.fromText("2qv2o-owgj3-hsfse-y7qjv-j5xwz-vi573-rokcm-cm6u7-uwith-yuolg-uae"); 
    var totalSupply : Nat = 1000000000; //The total supply of our particular token.
    var symbol : Text = "DMAG"; //Giving a symbol to our token.

    //Using HashMap to create a ledger  that is going to store the id of a particular user or canister. 
    //The key for the HashMap will be the principal which will be linked to the value of the custom token they own which is a natural number.
    //We then initialize the HashMap with three inputs, the first one is the initial size of the hashmap, the second is the method used to check the equality of the keys and the third one is how the hashmap should hash the keys.
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
    };

    //Creating a function that will return the symbol
    public query func getSymbol() : async Text {
        return symbol;
    };

    //Creating a shared function payOut with parameter of msg
    public shared(msg) func payOut() : async Text {
        Debug.print(debug_show(msg.caller));
        // Assigning to whomever calls the payOut method 10000 coins (coins or tokens) only if they have never claimed the free amount. We do this by checking if msg.caller exists in the ledger.
        if (balances.get(msg.caller) == null) {
           let amount = 10000;
           balances.put(msg.caller, amount);//msg.caller is the user of the website at the moment.
           return "Success";
        } else {
            return "You have already claimed your free coins"
        }

    };
    //Creating the transfer functionality using a public shared function.
    //The first parameter of the function is the principal while the second is the amount to transfer.
    //The id where the amount will be transferred from will be found thanks to msg.
    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        //Getting the amount that is to be transferred
        let fromBalance = await balanceOf(msg.caller);
        //Checking if they have enough amount of coins
        if (fromBalance > amount) {
            //Calculating the new amount to subtract from the user's ledger during the transaction.
            let newFromBalance : Nat = fromBalance - amount;
            //Updating the balance to the new amount for the user (msg.caller).
            balances.put(msg.caller, newFromBalance);
            //Getting the receiver's balance.
            let toBalance = await balanceOf(to); 
            //Calculating the new balance for the receiver of the transaction
            let newToBalance = toBalance + amount;
            //Updating the receiver's balance
            balances.put(to, newToBalance);
            
            return "Success";
        } else {
            return "Insufficient Funds";
        }
        
    };

};