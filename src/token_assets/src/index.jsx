import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
//Importing the AuthClient module and use it to log in the user.
import { AuthClient } from "@dfinity/auth-client";

const init = async () => {
  //Creating an auClient object using AuthClient's create() method.
  const authClient = await AuthClient.create();

  //Checking if the user has already logged in using the isAuthenticated() method.
  if (await authClient.isAuthenticated()) {
    handleAuthenticated(authClient);
  } else {
    //if they are not authenticated we send them to the log in page.
    await authClient.login({
      //Passing a javascript object that describes who the identity provider is
      identityProvider: "https://identity.ic0.app/#authorize",//The identity provider is url that points to the identity service on the ICP.
      onSuccess: () => {
        handleAuthenticated(authClient);
      },
    });
  }
};

async function handleAuthenticated(authClient) {
  ReactDOM.render(
    <App />,
    document.getElementById("root")
  );
}


init();


