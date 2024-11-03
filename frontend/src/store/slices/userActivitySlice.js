import { createSlice } from "@reduxjs/toolkit";

const userActivitySlice = createSlice({
  name: "userActivities",
  initialState: {
    activities: [],
    loading: false,
    error: null,
  },
  reducers: {
    fetchActivitiesStart(state) {
      state.loading = true;
      state.error = null;
    },
    fetchActivitiesSuccess(state, action) {
      state.loading = false;
      state.activities = action.payload;
    },
    fetchActivitiesFailure(state, action) {
      state.loading = false;
      state.error = action.payload;
    },
    // Add other reducers as needed
  },
});

// Export actions
export const {
  fetchActivitiesStart,
  fetchActivitiesSuccess,
  fetchActivitiesFailure,
} = userActivitySlice.actions;

// Export the reducer
export default userActivitySlice.reducer;
