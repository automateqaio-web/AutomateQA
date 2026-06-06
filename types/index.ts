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
};
