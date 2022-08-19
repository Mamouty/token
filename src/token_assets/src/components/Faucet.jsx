import React, { useState } from "react";
import { token, canisterId, createActor } from "../../../declarations/token";
import { AuthClient } from "@dfinity/auth-client";

function Faucet() {

  const [isDisabled, setDisabled] = useState(false);
  const [buttonText, setText] = useState("Gimme gimme")

  async function handleClick(event) {
    setDisabled(true);
    //Creating an auClient object using AuthClient's create() method.
    const authClient = await AuthClient.create();
    //Using the authClient to get the identity of the user.
    const identity = await authClient.getIdentity();
    //Using the identity to create an actor which is gonna take the canisterId and an agent options where we supply the identity of the authenticated user.
    const authenticatedCanister = createActor(canisterId, {
      agentOptions: {
        identity,
      },
    });
    //Calling the payOut() method with the authenticatedCanister
    const result = await authenticatedCanister.payOut()
    setText(result); 
    // setDisabled(false);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free DMamouty tokens here! Claim 10,000 DMAG coins to your account.</label>
      <p className="trade-buttons">
        <button 
        id="btn-payout" 
        onClick={handleClick}
        //Disabling the button once the user has made a request by pressing it.
        disabled={isDisabled}
        >
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
