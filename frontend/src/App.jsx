import React, { useState } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  Navigate,
} from "react-router-dom";
import Home from "./pages/Home";
import About from "./pages/About";
import Contact from "./pages/Contact";
import Profile from "./pages/Profile";
import Login from "./pages/Login";
import Signup from "./pages/Signup";
import Sidebar from "./components/sideNavBar/SideNavBar";

const App = () => {
  const [isLoggedIn, setIsLoggedIn] = useState(true); // Track login state
  const [isSidebarOpen, setIsSidebarOpen] = useState(false); // Track sidebar visibility
  const [profileNav, setProfileNav] = useState(false);

  const handleLogout = () => {
    setIsLoggedIn(false);
    // Add logout logic here (clear tokens, session, etc.)
  };

  return (
    <Router>
      {/* Top Navigation Bar */}
      <header className="bg-gray-900 text-white p-4 flex justify-between items-center fixed w-full top-0 z-50">
        <div className="flex items-center space-x-4">
          <button
            className="lg:hidden"
            onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          >
            {/* Hamburger Icon */}
            <svg
              className="w-6 h-6 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M4 6h16M4 12h16M4 18h16"
              ></path>
            </svg>
          </button>
          <Link to="/" className="text-xl font-semibold">
            WebsiteName
          </Link>
        </div>

        <nav className="space-x-4 hidden lg:flex">
          {/* <Link to="/" className="hover:text-gray-400">
            Home
          </Link>
          <Link to="/about" className="hover:text-gray-400">
            About
          </Link>
          <Link to="/contact" className="hover:text-gray-400">
            Contact Us
          </Link> */}

          {!isLoggedIn ? (
            <>
              <Link to="/login" className="hover:text-gray-400">
                Login
              </Link>
              <Link to="/signup" className="hover:text-gray-400">
                Signup
              </Link>
            </>
          ) : (
            <div className="relative">
              <button
                className="hover:text-gray-400"
                onClick={() => setProfileNav(!profileNav)}
              >
                User Profile
              </button>
              {/* Dropdown for Profile */}
              <div
                className={`${
                  profileNav ? "block" : "hidden"
                } absolute right-0 mt-2 w-48 bg-white text-black rounded-md shadow-lg z-50`}
              >
                <Link
                  to="/profile"
                  className="block px-4 py-2 hover:bg-gray-200"
                  onClick={() => setProfileNav(false)} // Close menu on click
                >
                  Profile
                </Link>
                <button
                  onClick={handleLogout}
                  className="block w-full text-left px-4 py-2 hover:bg-gray-200"
                >
                  Logout
                </button>
              </div>
            </div>
          )}
        </nav>
      </header>

      {/* Layout with Sidebar and Main Content */}
      <div className="flex h-screen pt-16">
        {/* Sidebar */}
        <Sidebar isOpen={isSidebarOpen} setIsSidebarOpen={setIsSidebarOpen} />
        {/* Main Content */}
        <main className="flex-1 p-6 bg-gray-100">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/about" element={<About />} />
            <Route path="/contact" element={<Contact />} />
            <Route
              path="/profile"
              element={isLoggedIn ? <Profile /> : <Navigate to="/login" />}
            />
            <Route
              path="/login"
              element={<Login setIsLoggedIn={setIsLoggedIn} />}
            />
            <Route path="/signup" element={<Signup />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
};

export default App;
