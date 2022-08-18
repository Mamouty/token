import Principal "mo:base/Principal"; // To use the Principal Data Type.
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    //Debug.print("Hello.");
    //Creating a variable of type Principle.
    //Converting the principle id from text to principle data type using the function fromText();
    let owner : Principal = Principal.fromText("2qv2o-owgj3-hsfse-y7qjv-j5xwz-vi573-rokcm-cm6u7-uwith-yuolg-uae"); 
    let totalSupply : Nat = 1000000000; //The total supply of our particular token.
    let symbol : Text = "DMAG"; //Giving a symbol to our token.

    //Creating a stable array that will hold the data of the HashMap since the hashMap can't be stable.
    //We're going to use the HashMap instead of the array because it is more efficient when searching data in it.
    private stable var balanceEntries: [(Principal, Nat)] = [];

    //Using HashMap to create a ledger  that is going to store the id of a particular user or canister. 
    /* The key for the HashMap will be the principal which will be linked to the value of the custom token they own which is a natural number.
    We then initialize the HashMap with three inputs, the first one is the initial size of the hashmap, the second is the method used to check the equality of the keys and the third one is how the hashmap should hash the keys. */
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
        //If we have an empty balance we add the owner to the ledger as the first entry.
    if (balances.size() < 1){
        balances.put(owner, totalSupply);
    };

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
           //Transferring the 10000 coins from the canister to the user (the claimant).
           let result = await transfer(msg.caller, 10000);//msg.caller is the user of the website at the moment.
           return result;
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

    //Using the preupgrade() to push the data of the HashMap to the stable balanceEntries array before the upgrade of the canister 
    system func preupgrade() {
        //Converting the HashMap to an array and assigning it to balanceEntries
        balanceEntries := Iter.toArray(balances.entries()); //To iterate over the HashMap we have to use the entries() method
    }; 
 
    //Using the postupgrade() system method to retrieve data from the balanceEntries array after the upgrade
    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        //If we have an empty balance we add the owner to the ledger as the first entry.
        if (balances.size() < 1){
            balances.put(owner, totalSupply);
        }
    };
};