// src/store/slices/contractSlice.js
import { createSlice } from "@reduxjs/toolkit";

const contractSlice = createSlice({
  name: "contract",
  initialState: {
    instance: null, // To hold the contract instance
    isLoaded: false, // To track if the contract is loaded
  },
  reducers: {
    setContract(state, action) {
      state.instance = action.payload;
      state.isLoaded = true;
    },
    resetContract(state) {
      state.instance = null;
      state.isLoaded = false;
    },
  },
});

// Export actions
export const { setContract, resetContract } = contractSlice.actions;

// Export the reducer
export default contractSlice.reducer;
