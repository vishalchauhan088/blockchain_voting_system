const express = require("express");
require("dotenv").config();
const app = express();
const auth = require("./routes/auth");
app.use(express.json());

const electionRoutes = require("./routes/election");
const userActivityRoutes = require("./routes/userActivity");

app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

app.get("/", (req, res, next) => {
  res.send("Hello World");
});
app.use("/api/v1/auth", auth);
app.use("/api/v1/election", electionRoutes);
app.use("/api/v1/userActivity", userActivityRoutes);

module.exports = app;
