import React, { useState } from "react";
import { Principal } from '@dfinity/principal';
import { token } from "../../../declarations/token";

function Transfer() {
  const [recipientId, setId] = useState("");
  const [inputAmount, setAmount] = useState("");
  const [isDisabled, setDisabled] = useState(false);
  const [feedback, setFeedback] = useState("");
  const [isHidden, setHidden] = useState(true);
  
  async function handleClick() {
    //Hiding the previous transaction result message.
    setHidden(true);
    setDisabled(true);
    // Creating a recipient const by converting the inputValue from text to Principle.This is the same as in checking the balance in Balance.jsx
    const recipient = Principal.fromText(recipientId);
    // Creating an amount constant by converting the input amount to a number
    const amountToTransfer = Number(inputAmount);
    //Calling the transfer function from main.mo to update the balances.
    const result = await token.transfer(recipient, amountToTransfer);
    setFeedback(result);
    //Reviling the message after the transaction
    setHidden(false);
    setDisabled(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                //Adding the value attribute to get the principal id
                value={recipientId}
                //Setting the input value using the onChange listener
                onChange={(e) => setId(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                //Adding the value attribute to the amount to transfer
                value={inputAmount}
                //Setting the amount to transfer
                onChange={(e) => setAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button
           id="btn-transfer"
           onClick={handleClick}
           //Disabling the button until the transaction is done
           disabled={isDisabled}
          >
            Transfer
          </button>
        </p>
        {/* Adding a feedback message after the transaction. */}
        <p hidden={isHidden}>{feedback}</p>
      </div>
    </div>
  );
}

export default Transfer;
