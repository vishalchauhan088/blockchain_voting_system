import { createSlice } from "@reduxjs/toolkit";

const walletSlice = createSlice({
  name: "wallet",
  initialState: {
    address: null,
    isConnected: false,
  },
  reducers: {
    connectWallet(state, action) {
      state.address = action.payload;
      state.isConnected = true;
    },
    disconnectWallet(state) {
      state.address = null;
      state.isConnected = false;
    },
  },
});

// Export actions
export const { connectWallet, disconnectWallet } = walletSlice.actions;

// Export the reducer
export default walletSlice.reducer;
