// src/store/slices/userSlice.js
import { createSlice } from "@reduxjs/toolkit";

const userSlice = createSlice({
  name: "user",
  initialState: {
    userInfo: JSON.parse(localStorage.getItem("userInfo")) || null,
    token: localStorage.getItem("token") || null,
    loading: false,
    error: null,
  },
  reducers: {
    // Action to set loading state
    setLoading(state, action) {
      state.loading = action.payload;
    },
    // Action to set user info and token
    setUser(state, action) {
      state.userInfo = action.payload.user;
      state.token = action.payload.token;
      state.loading = false;
      state.error = null;
      console.log(action.payload);
    },
    // Action to set error message
    setError(state, action) {
      state.error = action.payload;
      state.loading = false;
    },
    // Logout reducer
    logout(state) {
      state.userInfo = null;
      state.token = null;
      state.loading = false;
      state.error = null;
      localStorage.removeItem("token");
      localStorage.removeItem("userInfo");
    },
  },
});

// Export actions
export const { setLoading, setUser, setError, logout } = userSlice.actions;

// Export the reducer
export default userSlice.reducer;
