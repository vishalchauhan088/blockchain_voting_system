// src/components/ConnectWalletButton.jsx
import { useDispatch } from "react-redux";
import { connectWallet } from "../store/slices/walletSlice"; // Adjust import path
import { setContract } from "../store/slices/contractSlice"; // Import the setContract action
import { ethers } from "ethers";
import { contractAddress, contractABI } from "../contractConfig"; // Adjust import path for your contract config

const ConnectWalletButton = () => {
  const dispatch = useDispatch();

  const handleConnectWallet = async () => {
    if (window.ethereum) {
      try {
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });

        // Assuming the user has granted access
        const address = accounts[0];
        console.log("Connected wallet:", address);
        dispatch(connectWallet(address)); // Dispatch the connectWallet action

        // Initialize the contract
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contractInstance = new ethers.Contract(
          contractAddress,
          contractABI,
          provider
        );

        // Dispatch the contract instance to Redux store
        dispatch(setContract(contractInstance));
        console.log("Contract instance set in Redux store:", contractInstance);
      } catch (error) {
        console.error("Error connecting to wallet:", error);
      }
    } else {
      alert("Please install MetaMask!");
    }
  };

  return <button onClick={handleConnectWallet}>Connect Wallet</button>;
};

export default ConnectWalletButton;
