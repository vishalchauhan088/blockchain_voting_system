import React from "react";
import { Link } from "react-router-dom";

const Sidebar = ({ isOpen, setIsSidebarOpen }) => {
  return (
    <aside
      className={`fixed inset-y-0 left-0 transform bg-gray-800 text-white transition-transform duration-300 ease-in-out ${
        isOpen ? "translate-x-0" : "-translate-x-full"
      } lg:translate-x-0 lg:relative lg:block lg:w-64`}
    >
      <div className="p-4">
        {/* Close button for small screens */}
        <button
          className="text-white lg:hidden"
          onClick={() => setIsSidebarOpen(false)}
        >
          Close
        </button>
        <nav className="flex flex-col space-y-2 mt-4">
          <Link to="/" onClick={() => setIsSidebarOpen(false)}>
            Home
          </Link>
          <Link to="/about" onClick={() => setIsSidebarOpen(false)}>
            About
          </Link>
          <Link to="/contact" onClick={() => setIsSidebarOpen(false)}>
            Contact Us
          </Link>
          <Link to="/profile" onClick={() => setIsSidebarOpen(false)}>
            Profile
          </Link>
        </nav>
      </div>
    </aside>
  );
};

export default Sidebar;
