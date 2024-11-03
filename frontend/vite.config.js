import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/api": {
        target: "http://localhost:3000", // Target server URL
        changeOrigin: true, // Ensures the host header is changed to match the target
        secure: false, // Use this if the target server is self-signed HTTPS
        //rewrite: (path) => path.replace(/^\/api/, '') // Optional: remove '/api' prefix if needed
      },
    },
  },
});
