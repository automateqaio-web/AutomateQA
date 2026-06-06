import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "AutomateQA",
    short_name: "AutomateQA",
    description: "QA memes, automation tutorials and testing resources for engineers",
    start_url: "/",
    display: "standalone",
    background_color: "#0B0B0B",
    theme_color: "#00FF88",
    orientation: "portrait-primary",
    categories: ["education", "entertainment"],
    icons: [
      { src: "/icons/icon-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
      { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png", purpose: "any" },
      { src: "/icons/icon-maskable-192.png", sizes: "192x192", type: "image/png", purpose: "maskable" },
      { src: "/icons/icon-maskable-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
    ],
    shortcuts: [
      {
        name: "QA Memes",
        short_name: "Memes",
        description: "Browse the latest QA memes",
        url: "/memes",
        icons: [{ src: "/icons/icon-192.png", sizes: "192x192" }],
      },
      {
        name: "Automation Videos",
        short_name: "Videos",
        description: "Watch automation testing videos",
        url: "/videos",
        icons: [{ src: "/icons/icon-192.png", sizes: "192x192" }],
      },
      {
        name: "Learn Playwright",
        short_name: "Learn",
        description: "100 days of Playwright tutorials",
        url: "/learn",
        icons: [{ src: "/icons/icon-192.png", sizes: "192x192" }],
      },
    ],
  };
}
