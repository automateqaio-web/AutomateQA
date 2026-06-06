import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#0B0B0B",
        foreground: "#FFFFFF",
        primary: {
          DEFAULT: "#00FF88",
          foreground: "#0B0B0B",
        },
        secondary: {
          DEFAULT: "#9CA3AF",
          foreground: "#FFFFFF",
        },
        muted: {
          DEFAULT: "#1A1A1A",
          foreground: "#9CA3AF",
        },
        accent: {
          DEFAULT: "#00FF88",
          foreground: "#0B0B0B",
        },
        card: {
          DEFAULT: "#111111",
          foreground: "#FFFFFF",
        },
        border: "#2A2A2A",
        input: "#1A1A1A",
        ring: "#00FF88",
        destructive: {
          DEFAULT: "#FF4444",
          foreground: "#FFFFFF",
        },
        neon: {
          green: "#00FF88",
          blue: "#00D4FF",
          purple: "#9F7AEA",
          pink: "#FF6B9D",
        },
      },
      fontFamily: {
        sans: ["Inter", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "Fira Code", "monospace"],
      },
      borderRadius: {
        lg: "12px",
        md: "8px",
        sm: "4px",
        xl: "16px",
        "2xl": "20px",
        "3xl": "24px",
      },
      boxShadow: {
        neon: "0 0 20px rgba(0, 255, 136, 0.3), 0 0 40px rgba(0, 255, 136, 0.1)",
        "neon-lg": "0 0 40px rgba(0, 255, 136, 0.4), 0 0 80px rgba(0, 255, 136, 0.2)",
        "neon-blue": "0 0 20px rgba(0, 212, 255, 0.3), 0 0 40px rgba(0, 212, 255, 0.1)",
        glass: "0 8px 32px rgba(0, 0, 0, 0.4)",
        card: "0 4px 24px rgba(0, 0, 0, 0.3)",
      },
      backgroundImage: {
        "grid-pattern": "linear-gradient(rgba(0, 255, 136, 0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(0, 255, 136, 0.03) 1px, transparent 1px)",
        "hero-gradient": "radial-gradient(ellipse at top, rgba(0, 255, 136, 0.08) 0%, transparent 60%), radial-gradient(ellipse at bottom right, rgba(0, 212, 255, 0.05) 0%, transparent 60%)",
        "card-gradient": "linear-gradient(135deg, rgba(255,255,255,0.05) 0%, rgba(255,255,255,0.02) 100%)",
        "neon-gradient": "linear-gradient(135deg, #00FF88 0%, #00D4FF 100%)",
      },
      animation: {
        "fade-in": "fadeIn 0.6s ease-out forwards",
        "fade-up": "fadeUp 0.6s ease-out forwards",
        "glow-pulse": "glowPulse 3s ease-in-out infinite",
        "float": "float 6s ease-in-out infinite",
        "grid-move": "gridMove 20s linear infinite",
        "shimmer": "shimmer 2s linear infinite",
        "spin-slow": "spin 8s linear infinite",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        fadeUp: {
          "0%": { opacity: "0", transform: "translateY(20px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        glowPulse: {
          "0%, 100%": { boxShadow: "0 0 20px rgba(0, 255, 136, 0.3)" },
          "50%": { boxShadow: "0 0 40px rgba(0, 255, 136, 0.6), 0 0 80px rgba(0, 255, 136, 0.3)" },
        },
        float: {
          "0%, 100%": { transform: "translateY(0)" },
          "50%": { transform: "translateY(-20px)" },
        },
        gridMove: {
          "0%": { backgroundPosition: "0 0" },
          "100%": { backgroundPosition: "60px 60px" },
        },
        shimmer: {
          "0%": { backgroundPosition: "-200% 0" },
          "100%": { backgroundPosition: "200% 0" },
        },
      },
      backdropBlur: {
        xs: "2px",
      },
    },
  },
  plugins: [],
};

export default config;
