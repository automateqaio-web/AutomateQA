import type { AdAnimation } from "@/types";

export function getAdAnimationVariants(animation: AdAnimation) {
  switch (animation) {
    case "fade":
      return {
        initial: { opacity: 0 },
        animate: { opacity: 1 },
        transition: { duration: 0.5, ease: "easeOut" },
      };

    case "slide":
      return {
        initial: { opacity: 0, y: -32 },
        animate: { opacity: 1, y: 0 },
        transition: { duration: 0.45, ease: "easeOut" },
      };

    case "zoom":
      return {
        initial: { opacity: 0, scale: 0.85 },
        animate: { opacity: 1, scale: 1 },
        // cubic-bezier back easing: slight overshoot on scale
        transition: { duration: 0.45, ease: [0.34, 1.56, 0.64, 1] },
      };

    case "bounce":
      return {
        initial: { opacity: 0, y: -60 },
        animate: { opacity: 1, y: 0 },
        transition: {
          // Fade in fast so the movement is clearly visible
          opacity: { duration: 0.15, ease: "easeOut" },
          // Underdamped spring: stiffness 320, damping 12
          // damping ratio ≈ 12 / (2√320) ≈ 0.34 → obvious oscillating bounce
          y: { type: "spring" as const, stiffness: 320, damping: 12, mass: 1 },
        },
      };

    case "pulse":
      return {
        initial: { opacity: 0 },
        animate: { opacity: [0, 1, 0.65, 1] },
        transition: {
          duration: 1.1,
          times: [0, 0.28, 0.6, 1],
          ease: "easeInOut",
        },
      };

    case "shimmer":
    case "none":
    default:
      return {
        initial: { opacity: 0 },
        animate: { opacity: 1 },
        transition: { duration: 0.3 },
      };
  }
}

export function getDeviceType(): "desktop" | "mobile" | "tablet" {
  if (typeof window === "undefined") return "desktop";
  const ua = navigator.userAgent.toLowerCase();
  if (/tablet|ipad|playbook|silk|(android(?!.*mobile))/.test(ua)) return "tablet";
  if (/mobile|android|iphone|ipod|blackberry|opera mini|iemobile/.test(ua)) return "mobile";
  return "desktop";
}
