// pages/Home.js

import { useSelector } from "react-redux";

const Home = () => {
  const user = useSelector((state) => state.user); // This gets the entire user slice
  const { userInfo } = user; // Destructure to get userInfo

  return (
    <div>
      <h1 className="text-3xl font-bold">Welcome to the Home Page</h1>
      <p>This is the main landing page of the website.</p>
      {userInfo ? (
        <p>Welcome, {userInfo.username}!</p> // Accessing username from userInfo
      ) : (
        <p>Please log in to see your information.</p>
      )}
    </div>
  );
};

export default Home;
