import { contractABI, contractAddress } from "../contractConfig";
import { ethers } from "ethers";

const useContract = () => {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const contract = new ethers.Contract(contractABI, contractAddress, signer);

  return contract;
};
export default useContract;
