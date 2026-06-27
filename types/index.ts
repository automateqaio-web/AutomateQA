export interface Meme {
  id: string;
  title: string;
  caption: string;
  image_url: string | null;
  video_url: string | null;
  category: MemeCategory;
  tags: string[];
  featured: boolean;
  published: boolean;
  seo_title: string | null;
  seo_description: string | null;
  created_at: string;
}

export interface Video {
  id: string;
  youtube_url: string;
  youtube_id: string;
  title: string;
  description: string;
  thumbnail: string;
  category: VideoCategory;
  tags: string[];
  featured: boolean;
  published: boolean;
  created_at: string;
}

export interface Blog {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  cover_image: string | null;
  category: BlogCategory;
  tags: string[];
  featured: boolean;
  published: boolean;
  read_time: number;
  created_at: string;
}

export interface LearningContent {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  cover_image: string | null;
  youtube_url: string | null;
  category: LearnCategory;
  difficulty: Difficulty;
  tags: string[];
  featured: boolean;
  published: boolean;
  views: number;
  read_time: number;
  created_at: string;
  updated_at: string;
}

export interface AutomationTip {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  cover_image: string | null;
  youtube_url: string | null;
  category: TipCategory;
  difficulty: Difficulty;
  tags: string[];
  featured: boolean;
  published: boolean;
  views: number;
  likes: number;
  read_time: number;
  created_at: string;
  updated_at: string;
}

export interface YoutubeStats {
  id: string;
  subscribers: number;
  total_views: number;
  total_videos: number;
  watch_hours: number;
  created_at: string;
}

export interface InstagramStats {
  id: string;
  followers: number;
  total_reel_views: number;
  engagement_rate: number;
  reach: number;
  impressions: number;
  total_posts: number;
  created_at: string;
}

export interface ViralContent {
  id: string;
  platform: "youtube" | "instagram";
  title: string;
  thumbnail: string;
  views: number;
  likes: number;
  comments: number;
  shares: number;
  content_url: string;
  created_at: string;
}

export interface Subscriber {
  id: string;
  email: string;
  created_at: string;
}

export interface SiteSettings {
  id: string;
  hero_headline: string;
  hero_subtitle: string;
  updated_at: string;
}

export type Difficulty = "Beginner" | "Intermediate" | "Advanced";

export type LearnCategory =
  | "Selenium"
  | "Playwright"
  | "Cypress"
  | "WebdriverIO"
  | "Postman"
  | "Rest Assured"
  | "Jenkins"
  | "GitHub Actions"
  | "API Testing"
  | "CI/CD"
  | "Java"
  | "TestNG"
  | "Cucumber"
  | "SQL"
  | "Performance Testing";

export type TipCategory =
  | "Selenium"
  | "Playwright"
  | "API Testing"
  | "Jenkins"
  | "CI/CD"
  | "Java"
  | "Cypress"
  | "TestNG"
  | "Cucumber"
  | "Corporate QA Tips"
  | "Production Issues"
  | "Debugging Tips";

export type MemeCategory =
  | "QA vs Dev"
  | "Corporate"
  | "Selenium"
  | "Playwright"
  | "Agile"
  | "Jira"
  | "Production Bugs"
  | "Standup Meetings";

export type VideoCategory =
  | "QA Memes"
  | "Corporate Memes"
  | "Playwright Tutorials"
  | "Selenium Tutorials"
  | "API Testing";

export type BlogCategory =
  | "Automation Testing"
  | "Selenium"
  | "Playwright"
  | "API Testing"
  | "QA Career"
  | "Interview Questions"
  | "Corporate Stories";

export const MEME_CATEGORIES: MemeCategory[] = [
  "QA vs Dev",
  "Corporate",
  "Selenium",
  "Playwright",
  "Agile",
  "Jira",
  "Production Bugs",
  "Standup Meetings",
];

export const VIDEO_CATEGORIES: VideoCategory[] = [
  "QA Memes",
  "Corporate Memes",
  "Playwright Tutorials",
  "Selenium Tutorials",
  "API Testing",
];

export const BLOG_CATEGORIES: BlogCategory[] = [
  "Automation Testing",
  "Selenium",
  "Playwright",
  "API Testing",
  "QA Career",
  "Interview Questions",
  "Corporate Stories",
];

export const DIFFICULTIES: Difficulty[] = ["Beginner", "Intermediate", "Advanced"];

export const LEARN_CATEGORIES: LearnCategory[] = [
  "Selenium", "Playwright", "Cypress", "WebdriverIO", "Postman",
  "Rest Assured", "Jenkins", "GitHub Actions", "API Testing",
  "CI/CD", "Java", "TestNG", "Cucumber", "SQL", "Performance Testing",
];

export const TIP_CATEGORIES: TipCategory[] = [
  "Selenium", "Playwright", "API Testing", "Jenkins", "CI/CD",
  "Java", "Cypress", "TestNG", "Cucumber", "Corporate QA Tips",
  "Production Issues", "Debugging Tips",
];

export const DIFFICULTY_COLORS: Record<Difficulty, string> = {
  Beginner: "bg-green-500/20 text-green-400 border-green-500/30",
  Intermediate: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
  Advanced: "bg-red-500/20 text-red-400 border-red-500/30",
};

// ── Interview Prep ────────────────────────────────────────────────────────────

export type InterviewTechnology =
  | "Selenium" | "Playwright" | "Cypress" | "WebdriverIO"
  | "Rest Assured" | "Postman" | "API Automation"
  | "Core Java" | "Collections" | "Multithreading" | "OOPs" | "Streams" | "Exception Handling"
  | "Page Object Model" | "Hybrid Framework" | "Data-Driven Framework" | "Keyword-Driven Framework" | "CI/CD Integration"
  | "Cucumber" | "TestNG" | "BDD" | "Gherkin"
  | "Jenkins" | "GitHub Actions" | "Azure DevOps"
  | "SQL" | "Database Testing"
  | "Scenario-Based" | "Managerial" | "HR" | "General";

export type InterviewQuestionType =
  | "Technical" | "Scenario-Based" | "Coding" | "Managerial" | "HR"
  | "Framework Design" | "API Testing" | "Real-Time Issues" | "CI/CD" | "Debugging";

export type InterviewExperienceLevel =
  | "Fresher" | "1-2 Years" | "3-5 Years" | "5+ Years" | "Senior SDET";

export interface InterviewQuestion {
  id: string;
  question: string;
  slug: string;
  short_description: string | null;
  answer: string | null;
  real_world_example: string | null;
  best_practices: string | null;
  common_mistakes: string | null;
  code_snippet: string | null;
  code_language: string | null;
  technology: InterviewTechnology;
  question_type: InterviewQuestionType;
  experience_level: InterviewExperienceLevel;
  difficulty: Difficulty;
  youtube_url: string | null;
  tags: string[];
  featured: boolean;
  published: boolean;
  views: number;
  created_at: string;
  updated_at: string;
}

export const INTERVIEW_TECHNOLOGIES: InterviewTechnology[] = [
  "Selenium", "Playwright", "Cypress", "WebdriverIO",
  "Rest Assured", "Postman", "API Automation",
  "Core Java", "Collections", "Multithreading", "OOPs", "Streams", "Exception Handling",
  "Page Object Model", "Hybrid Framework", "Data-Driven Framework", "Keyword-Driven Framework", "CI/CD Integration",
  "Cucumber", "TestNG", "BDD", "Gherkin",
  "Jenkins", "GitHub Actions", "Azure DevOps",
  "SQL", "Database Testing",
  "Scenario-Based", "Managerial", "HR", "General",
];

export const INTERVIEW_QUESTION_TYPES: InterviewQuestionType[] = [
  "Technical", "Scenario-Based", "Coding", "Managerial", "HR",
  "Framework Design", "API Testing", "Real-Time Issues", "CI/CD", "Debugging",
];

export const INTERVIEW_EXPERIENCE_LEVELS: InterviewExperienceLevel[] = [
  "Fresher", "1-2 Years", "3-5 Years", "5+ Years", "Senior SDET",
];

export const INTERVIEW_CODE_LANGUAGES = ["java", "javascript", "typescript", "python", "sql", "json", "xml", "bash", "gherkin"];

// ── Jobs ─────────────────────────────────────────────────────────────────────

export type JobSource = "adzuna" | "manual" | "referral";
export type JobType = "regular" | "referral";

export interface Job {
  id: string;
  title: string;
  company: string;
  location: string;
  description: string;
  apply_url: string | null;
  source: JobSource;
  job_type: JobType;
  is_remote: boolean;
  experience_level: string | null;
  salary: string | null;
  referral_contact: string | null;
  referral_note: string | null;
  is_active: boolean;
  posted_at: string | null;
  fetched_at: string | null;
  created_at: string;
  updated_at: string;
}

export const CATEGORY_COLORS: Record<string, string> = {
  "QA vs Dev": "bg-red-500/20 text-red-400 border-red-500/30",
  Corporate: "bg-blue-500/20 text-blue-400 border-blue-500/30",
  Selenium: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
  Playwright: "bg-purple-500/20 text-purple-400 border-purple-500/30",
  Agile: "bg-orange-500/20 text-orange-400 border-orange-500/30",
  Jira: "bg-indigo-500/20 text-indigo-400 border-indigo-500/30",
  "Production Bugs": "bg-red-600/20 text-red-400 border-red-600/30",
  "Standup Meetings": "bg-teal-500/20 text-teal-400 border-teal-500/30",
  "QA Memes": "bg-pink-500/20 text-pink-400 border-pink-500/30",
  "Corporate Memes": "bg-blue-500/20 text-blue-400 border-blue-500/30",
  "Playwright Tutorials": "bg-purple-500/20 text-purple-400 border-purple-500/30",
  "Selenium Tutorials": "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
  "API Testing": "bg-green-500/20 text-green-400 border-green-500/30",
  "Automation Testing": "bg-emerald-500/20 text-emerald-400 border-emerald-500/30",
  "QA Career": "bg-cyan-500/20 text-cyan-400 border-cyan-500/30",
  "Interview Questions": "bg-violet-500/20 text-violet-400 border-violet-500/30",
  "Corporate Stories": "bg-slate-500/20 text-slate-400 border-slate-500/30",
  // Learn / Tips shared
  Cypress: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30",
  WebdriverIO: "bg-orange-500/20 text-orange-400 border-orange-500/30",
  Postman: "bg-amber-500/20 text-amber-400 border-amber-500/30",
  "Rest Assured": "bg-lime-500/20 text-lime-400 border-lime-500/30",
  Jenkins: "bg-red-700/20 text-red-400 border-red-700/30",
  "GitHub Actions": "bg-gray-500/20 text-gray-300 border-gray-500/30",
  "CI/CD": "bg-sky-500/20 text-sky-400 border-sky-500/30",
  Java: "bg-orange-600/20 text-orange-400 border-orange-600/30",
  TestNG: "bg-violet-500/20 text-violet-400 border-violet-500/30",
  Cucumber: "bg-green-700/20 text-green-400 border-green-700/30",
  SQL: "bg-blue-700/20 text-blue-400 border-blue-700/30",
  "Performance Testing": "bg-rose-500/20 text-rose-400 border-rose-500/30",
  "Corporate QA Tips": "bg-slate-500/20 text-slate-400 border-slate-500/30",
  "Production Issues": "bg-red-600/20 text-red-400 border-red-600/30",
  "Debugging Tips": "bg-purple-600/20 text-purple-400 border-purple-600/30",
  // Interview-prep specific technologies
  "Core Java": "bg-orange-600/20 text-orange-400 border-orange-600/30",
  "Collections": "bg-amber-500/20 text-amber-400 border-amber-500/30",
  "Multithreading": "bg-rose-500/20 text-rose-400 border-rose-500/30",
  "OOPs": "bg-orange-500/20 text-orange-400 border-orange-500/30",
  "Streams": "bg-teal-500/20 text-teal-400 border-teal-500/30",
  "Exception Handling": "bg-red-500/20 text-red-400 border-red-500/30",
  "Page Object Model": "bg-purple-600/20 text-purple-400 border-purple-600/30",
  "Hybrid Framework": "bg-violet-500/20 text-violet-400 border-violet-500/30",
  "Data-Driven Framework": "bg-blue-500/20 text-blue-400 border-blue-500/30",
  "Keyword-Driven Framework": "bg-cyan-600/20 text-cyan-400 border-cyan-600/30",
  "CI/CD Integration": "bg-sky-500/20 text-sky-400 border-sky-500/30",
  "BDD": "bg-green-600/20 text-green-400 border-green-600/30",
  "Gherkin": "bg-lime-500/20 text-lime-400 border-lime-500/30",
  "API Automation": "bg-emerald-600/20 text-emerald-400 border-emerald-600/30",
  "Azure DevOps": "bg-blue-600/20 text-blue-400 border-blue-600/30",
  "Database Testing": "bg-indigo-600/20 text-indigo-400 border-indigo-600/30",
  "Scenario-Based": "bg-amber-600/20 text-amber-400 border-amber-600/30",
  "Managerial": "bg-slate-500/20 text-slate-300 border-slate-500/30",
  "HR": "bg-pink-500/20 text-pink-400 border-pink-500/30",
  "General": "bg-gray-500/20 text-gray-300 border-gray-500/30",
};

// ── Advertisements ────────────────────────────────────────────────────────────

export type AdType =
  | "promotion" | "collaboration" | "sponsor" | "course"
  | "announcement" | "event" | "hiring" | "affiliate" | "custom";

export type AdDisplayStyle =
  | "premium_banner" | "glassmorphism_card" | "floating_banner"
  | "hero_banner" | "sidebar_card" | "bottom_sticky" | "inline_banner"
  | "popup" | "toast" | "ribbon" | "small_card" | "full_width_banner";

export type AdAnimation = "fade" | "slide" | "zoom" | "bounce" | "pulse" | "shimmer" | "none";
export type AdCtaOpen  = "same_tab" | "new_tab";

export interface Ad {
  id: string;
  name: string;
  type: AdType;
  title: string;
  subtitle: string | null;
  description: string | null;
  cta_text: string | null;
  cta_link: string | null;
  cta_open: AdCtaOpen;
  desktop_image_url: string | null;
  mobile_image_url: string | null;
  logo_url: string | null;
  bg_color: string | null;
  gradient: string | null;
  text_color: string | null;
  button_color: string | null;
  badge: string | null;
  display_style: AdDisplayStyle;
  animation: AdAnimation;
  priority: number;
  is_active: boolean;
  impressions: number;
  clicks: number;
  last_viewed_at: string | null;
  last_clicked_at: string | null;
  created_at: string;
  updated_at: string;
  // joined relations
  locations?: AdLocationRecord[];
  schedule?: AdSchedule | null;
  targeting?: AdTargeting | null;
}

export interface AdLocationRecord {
  id: string;
  ad_id: string;
  location: string;
  css_selector: string | null;
}

export interface AdSchedule {
  id: string;
  ad_id: string;
  start_date: string | null;
  end_date: string | null;
  timezone: string;
}

export interface AdTargeting {
  id: string;
  ad_id: string;
  show_to_logged_in: boolean;
  show_to_guests: boolean;
  devices: string[];
  countries: string[] | null;
  user_type: "all" | "new" | "returning";
}

// ── Ad constants ──────────────────────────────────────────────────────────────

export const AD_TYPES: { value: AdType; label: string }[] = [
  { value: "promotion",     label: "Promotion"    },
  { value: "collaboration", label: "Collaboration" },
  { value: "sponsor",       label: "Sponsor"       },
  { value: "course",        label: "Course"        },
  { value: "announcement",  label: "Announcement"  },
  { value: "event",         label: "Event"         },
  { value: "hiring",        label: "Hiring"        },
  { value: "affiliate",     label: "Affiliate"     },
  { value: "custom",        label: "Custom"        },
];

export const AD_DISPLAY_STYLES: { value: AdDisplayStyle; label: string; desc: string }[] = [
  { value: "premium_banner",     label: "Premium Banner",       desc: "Full-width gradient banner with CTA" },
  { value: "glassmorphism_card", label: "Glassmorphism Card",   desc: "Frosted-glass floating card"         },
  { value: "floating_banner",    label: "Floating Banner",      desc: "Slides in from corner"               },
  { value: "hero_banner",        label: "Hero Banner",          desc: "Large immersive hero section"        },
  { value: "sidebar_card",       label: "Sidebar Card",         desc: "Compact card for sidebars"           },
  { value: "bottom_sticky",      label: "Bottom Sticky Bar",    desc: "Fixed bottom bar"                    },
  { value: "inline_banner",      label: "Inline Banner",        desc: "Fits inline inside content"          },
  { value: "popup",              label: "Popup Modal",          desc: "Centered modal overlay"              },
  { value: "toast",              label: "Toast Notification",   desc: "Corner toast notification"           },
  { value: "ribbon",             label: "Ribbon",               desc: "Thin top/bottom ribbon bar"          },
  { value: "small_card",         label: "Small Card",           desc: "Minimal compact card"                },
  { value: "full_width_banner",  label: "Full Width Banner",    desc: "Edge-to-edge banner"                 },
];

export const AD_ANIMATIONS: { value: AdAnimation; label: string }[] = [
  { value: "fade",    label: "Fade"    },
  { value: "slide",   label: "Slide"   },
  { value: "zoom",    label: "Zoom"    },
  { value: "bounce",  label: "Bounce"  },
  { value: "pulse",   label: "Pulse"   },
  { value: "shimmer", label: "Shimmer" },
  { value: "none",    label: "None"    },
];

export const AD_LOCATIONS: { value: string; label: string; group: string }[] = [
  { value: "homepage_top",             label: "Homepage — Top",                     group: "Homepage"       },
  { value: "homepage_middle",          label: "Homepage — Middle",                  group: "Homepage"       },
  { value: "homepage_bottom",          label: "Homepage — Bottom",                  group: "Homepage"       },
  { value: "interview_listing",        label: "Interview Prep — Listing",           group: "Interview Prep" },
  { value: "interview_sidebar",        label: "Interview Prep — Sidebar",           group: "Interview Prep" },
  { value: "interview_after_q5",       label: "Interview Prep — After 5 Questions", group: "Interview Prep" },
  { value: "interview_detail_sidebar", label: "Interview Detail — Sidebar",         group: "Interview Prep" },
  { value: "blog_listing",             label: "Blog — Listing",                     group: "Blog"           },
  { value: "blog_sidebar",             label: "Blog — Sidebar",                     group: "Blog"           },
  { value: "blog_after_article",       label: "Blog — After Article",               group: "Blog"           },
  { value: "jobs_listing",             label: "Jobs Board — Listing",               group: "Jobs"           },
  { value: "jobs_detail_sidebar",      label: "Jobs Board — Detail Sidebar",        group: "Jobs"           },
  { value: "learn_listing",            label: "Learn — Listing",                    group: "Learn"          },
  { value: "learn_sidebar",            label: "Learn — Sidebar",                    group: "Learn"          },
  { value: "tips_listing",             label: "Tips — Listing",                     group: "Tips"           },
  { value: "videos_listing",           label: "Videos — Listing",                   group: "Videos"         },
  { value: "sidebar_global",           label: "Global Sidebar",                     group: "Global"         },
  { value: "footer",                   label: "Footer",                             group: "Global"         },
  { value: "custom",                   label: "Custom (CSS Selector)",              group: "Custom"         },
];

export const AD_BADGE_PRESETS = [
  "🔥 Sponsored",
  "🚀 Promotion",
  "⭐ Premium",
  "🤝 Collaboration",
  "🎁 Limited Offer",
  "🎯 Featured",
  "📢 Announcement",
  "💼 Hiring",
  "📚 Course",
];
