import React, {useState} from "react";
// Importing the Principal type from the dfinity module.
import { Principal } from '@dfinity/principal';
import { token } from "../../../declarations/token";

function Balance() {

  const [inputValue, setInput] = useState("");
  const [balanceResult, setBalance] = useState("");

  async function handleClick() {
    console.log(inputValue);
    // Creating a principle const by converting the inputValue from text to Principle.
    const principle = Principal.fromText(inputValue);
    //Calling the function balanceOf() from main.mo and passing the principle the user typed in the text field.
    //Assigning the returned value from balanceOf() to a const.
    const balance = await token.balanceOf(principle);
    //Converting the balance to a string with JS
    setBalance(balance.toLocaleString());
  }

  return (
    <div className="window white">
      <label>Check account token balance:</label>
      <p>
        <input
          id="balance-principal-id"
          type="text"
          placeholder="Enter a Principal ID"
          //To get hold of whatever the user types in the input we add the value attribute
          value={inputValue}
          //add an onChange listener attribute to set the input value using an arrow function
          //e is the event that triggered the onChange, it is in our case the typing.
          //target is the <input> and value is its value. 
          onChange={(e) => setInput(e.target.value)}
        />
      </p>
      <p className="trade-buttons">
        <button
          id="btn-request-balance"
          onClick={handleClick}
        >
          Check Balance
        </button>
      </p>
      <p>This account has a balance of {balanceResult}.</p>
    </div>
  );
}

export default Balance;

