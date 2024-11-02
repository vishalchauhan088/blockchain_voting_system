const app = require("./src/app");

const MongodbService = require("./src/Services/mongodbService");

require("dotenv").config();

let connectionString = `mongodb+srv://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@cluster0.vdlubjb.mongodb.net/${process.env.MONGODB_DATABASE}?retryWrites=true&w=majority`;

const database = new MongodbService(connectionString);
database.connect();

app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
});
