// src/store/store.js
import { configureStore } from "@reduxjs/toolkit";
import walletReducer from "./slices/walletSlice";
import contractReducer from "./slices/contractSlice";
import userActivityReducer from "./slices/userActivitySlice"; // Assuming you have this slice
import electionReducer from "./slices/electionSlice"; // Assuming you have this slice
import userReducer from "./slices/userSlice";

const store = configureStore({
  reducer: {
    wallet: walletReducer,
    contract: contractReducer,
    userActivity: userActivityReducer,
    election: electionReducer,
    user: userReducer,
  },
  // No need to add middleware; redux-thunk is included by default
});

export default store;
