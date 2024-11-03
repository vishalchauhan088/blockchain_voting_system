import { createSlice } from "@reduxjs/toolkit";

const electionSlice = createSlice({
  name: "elections",
  initialState: {
    elections: [],
    loading: false,
    error: null,
  },
  reducers: {
    fetchElectionsStart(state) {
      state.loading = true;
      state.error = null;
    },
    fetchElectionsSuccess(state, action) {
      state.loading = false;
      state.elections = action.payload;
    },
    fetchElectionsFailure(state, action) {
      state.loading = false;
      state.error = action.payload;
    },
    // Add other reducers as needed, e.g., for adding, updating, or deleting elections
  },
});

// Export actions
export const {
  fetchElectionsStart,
  fetchElectionsSuccess,
  fetchElectionsFailure,
} = electionSlice.actions;

// Export the reducer
export default electionSlice.reducer;
