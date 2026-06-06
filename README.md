# AutomateQA — QA Memes, Tutorials & Corporate Chaos

A modern full-stack platform for QA automation content, memes, tutorials, and corporate humor.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS v4 |
| Animations | Framer Motion |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth |
| Storage | Supabase Storage |
| Deployment | Vercel |

## Quick Start

### 1. Install dependencies

```bash
cd automateqa
npm install
```

### 2. Set up environment variables

```bash
cp .env.local.example .env.local
```

Fill in your Supabase credentials from [supabase.com/dashboard](https://supabase.com/dashboard):
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `NEXT_PUBLIC_SITE_URL`

### 3. Set up Supabase database

1. Create a project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** → run `lib/supabase/schema.sql`
3. Creates all tables, RLS policies, storage buckets, and sample data

### 4. Create admin user

1. Supabase Dashboard → **Authentication > Users** → **Add User**
2. Use those credentials to log in at `/admin`

### 5. Run dev server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

## Project Structure

```
automateqa/
├── app/
│   ├── page.tsx              # Home page
│   ├── memes/                # Meme feed + detail
│   ├── videos/               # Video hub + detail
│   ├── blog/                 # Blog listing + post
│   ├── about/                # About page
│   ├── contact/              # Contact page
│   ├── admin/                # Admin dashboard (auth-gated)
│   │   ├── memes/            # Meme management
│   │   ├── videos/           # Video management
│   │   └── blogs/            # Blog editor
│   ├── api/                  # API routes
│   ├── sitemap.ts            # Auto-generated sitemap
│   └── robots.ts
├── components/
│   ├── shared/               # Navbar, Footer
│   ├── home/                 # Landing page sections
│   ├── memes/                # Meme feed components
│   ├── videos/               # Video grid + player
│   ├── blog/                 # Blog listing + content
│   └── admin/                # Admin guard + sidebar
├── lib/
│   ├── supabase/
│   │   ├── client.ts         # Browser client
│   │   ├── server.ts         # Server client
│   │   └── schema.sql        # Full DB schema
│   └── utils.ts
└── types/index.ts
```

## Pages

| Route | Description |
|-------|-------------|
| `/` | Home — hero, featured videos, trending memes, 100 Days of Playwright, latest blogs, newsletter |
| `/memes` | Infinite-scroll meme feed with category filters |
| `/videos` | YouTube video hub with featured video + grid |
| `/videos/[id]` | Video detail with embed + related |
| `/blog` | Blog listing with featured post + search |
| `/blog/[slug]` | Full markdown blog post |
| `/about` | Mission, values, story |
| `/contact` | Contact form + sponsorship section |
| `/admin` | Admin dashboard (login required) |

## Deployment to Vercel

1. Push to GitHub
2. Import at [vercel.com](https://vercel.com/new)
3. Add environment variables
4. Deploy

## Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#0B0B0B` | Main background |
| Neon Green | `#00FF88` | Primary accent, CTAs |
| Secondary Text | `#9CA3AF` | Subtitles, metadata |
| White | `#FFFFFF` | Headings, body text |

---

Built with love for the QA community 🚀
