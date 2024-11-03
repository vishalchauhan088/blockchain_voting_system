const express = require("express");
require("dotenv").config();
const app = express();
const auth = require("./routes/auth");
app.use(express.json());

const cors = require("cors");
app.use(cors());

const electionRoutes = require("./routes/election");
const votingActivityRoutes = require("./routes/votingActivity");

app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

app.get("/", (req, res, next) => {
  res.send("Hello World");
});
app.use("/api/v1/auth", auth);
app.use("/api/v1/election", electionRoutes);
app.use("/api/v1/useractivity", votingActivityRoutes);
app.use("*", (req, res, next) => {
  res.status(404).json({ message: "Route not found" });
});

module.exports = app;
