// src/store/actions/walletActions.js
import { ethers } from "ethers";
import { connectWallet } from "../slices/walletSlice";

export const connectWalletAction = () => async (dispatch) => {
  if (window.ethereum) {
    try {
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });

      // Assuming the user has granted access
      const address = accounts[0];
      dispatch(connectWallet(address)); // Use the updated connectWallet action

      // Optionally, you can also handle provider setup here
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      // Do something with the provider if needed
    } catch (error) {
      console.error("Error connecting to wallet:", error);
    }
  } else {
    alert("Please install MetaMask!");
  }
};
