import { NextRequest, NextResponse } from "next/server";
import nodemailer from "nodemailer";
import { createClient } from "@/lib/supabase/server";

const GMAIL_USER = "automate.qa.io@gmail.com";

async function getSiteSettings() {
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("site_settings")
      .select("contact_email,owner_email")
      .limit(1)
      .single();
    return {
      contactEmail: data?.contact_email || GMAIL_USER,
      ownerEmail: data?.owner_email || process.env.CONTACT_OWNER_EMAIL || GMAIL_USER,
    };
  } catch {
    return {
      contactEmail: GMAIL_USER,
      ownerEmail: process.env.CONTACT_OWNER_EMAIL || GMAIL_USER,
    };
  }
}

const TYPE_LABELS: Record<string, string> = {
  general: "General Inquiry",
  collaborate: "Collaboration",
  sponsorship: "Sponsorship",
  bug: "Report Issue",
  other: "Other",
};

// Escape HTML to prevent injection in email templates
function esc(str: string): string {
  return str
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#x27;");
}

// Simple in-memory rate limiter: max 3 submissions per IP per 10 minutes
const rateLimitMap = new Map<string, { count: number; resetAt: number }>();
const RATE_LIMIT = 3;
const RATE_WINDOW_MS = 10 * 60 * 1000;

function isRateLimited(ip: string): boolean {
  const now = Date.now();
  const entry = rateLimitMap.get(ip);
  if (!entry || now > entry.resetAt) {
    rateLimitMap.set(ip, { count: 1, resetAt: now + RATE_WINDOW_MS });
    return false;
  }
  if (entry.count >= RATE_LIMIT) return true;
  entry.count++;
  return false;
}

function createTransporter() {
  return nodemailer.createTransport({
    service: "gmail",
    auth: { user: GMAIL_USER, pass: process.env.GMAIL_APP_PASSWORD },
  });
}

export async function POST(req: NextRequest) {
  try {
    // Rate limiting
    const ip =
      req.headers.get("x-forwarded-for")?.split(",")[0].trim() ||
      req.headers.get("x-real-ip") ||
      "unknown";
    if (isRateLimited(ip)) {
      return NextResponse.json(
        { error: "Too many requests. Please wait 10 minutes before trying again." },
        { status: 429 }
      );
    }

    const body = await req.json();
    const { name, email, subject, message, type } = body;
    const { ownerEmail } = await getSiteSettings();

    // Validate required fields
    if (!name || !email || !subject || !message) {
      return NextResponse.json({ error: "All fields are required." }, { status: 400 });
    }

    // Length limits — prevents oversized payloads
    if (name.length > 100 || subject.length > 200 || message.length > 5000 || email.length > 254) {
      return NextResponse.json({ error: "Input exceeds maximum allowed length." }, { status: 400 });
    }

    // Basic email format check
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json({ error: "Invalid email address." }, { status: 400 });
    }

    if (!process.env.GMAIL_APP_PASSWORD) {
      return NextResponse.json({ error: "Email service not configured." }, { status: 503 });
    }

    // Sanitize all user inputs before inserting into HTML
    const safeName    = esc(name);
    const safeEmail   = esc(email);
    const safeSubject = esc(subject);
    const safeMessage = esc(message);
    const typeLabel   = esc(TYPE_LABELS[type] || type || "General");

    const transporter = createTransporter();

    // Notification email to owner
    await transporter.sendMail({
      from: `"AutomateQA Contact" <${GMAIL_USER}>`,
      to: ownerEmail,
      replyTo: email,
      subject: `[AutomateQA] ${typeLabel}: ${safeSubject}`,
      html: `
        <div style="font-family:sans-serif;max-width:600px;margin:0 auto;background:#0b0b0b;color:#e5e7eb;padding:32px;border-radius:12px;border:1px solid #1f1f1f;">
          <div style="margin-bottom:20px;">
            <span style="background:#00FF88;color:#000;font-size:11px;font-weight:700;padding:4px 12px;border-radius:20px;letter-spacing:1px;text-transform:uppercase;">${typeLabel}</span>
          </div>
          <h2 style="color:#fff;font-size:22px;margin:0 0 4px 0;">New Contact Form Submission</h2>
          <p style="color:#6b7280;font-size:13px;margin:0 0 28px 0;">Someone reached out via AutomateQA</p>
          <table style="width:100%;border-collapse:collapse;">
            <tr>
              <td style="padding:10px 0;border-bottom:1px solid #1f1f1f;color:#9ca3af;font-size:13px;width:90px;vertical-align:top;">Name</td>
              <td style="padding:10px 0;border-bottom:1px solid #1f1f1f;color:#fff;font-size:13px;">${safeName}</td>
            </tr>
            <tr>
              <td style="padding:10px 0;border-bottom:1px solid #1f1f1f;color:#9ca3af;font-size:13px;vertical-align:top;">Email</td>
              <td style="padding:10px 0;border-bottom:1px solid #1f1f1f;font-size:13px;"><a href="mailto:${safeEmail}" style="color:#00FF88;text-decoration:none;">${safeEmail}</a></td>
            </tr>
            <tr>
              <td style="padding:10px 0;border-bottom:1px solid #1f1f1f;color:#9ca3af;font-size:13px;vertical-align:top;">Subject</td>
              <td style="padding:10px 0;border-bottom:1px solid #1f1f1f;color:#fff;font-size:13px;">${safeSubject}</td>
            </tr>
          </table>
          <div style="margin-top:24px;">
            <p style="color:#9ca3af;font-size:12px;margin-bottom:8px;text-transform:uppercase;letter-spacing:0.5px;">Message</p>
            <div style="background:#141414;border:1px solid #1f1f1f;border-radius:8px;padding:16px;color:#d1d5db;font-size:14px;line-height:1.7;white-space:pre-wrap;">${safeMessage}</div>
          </div>
          <div style="margin-top:28px;text-align:center;">
            <a href="mailto:${safeEmail}" style="display:inline-block;background:#00FF88;color:#000;font-weight:700;font-size:13px;padding:12px 28px;border-radius:8px;text-decoration:none;">Reply to ${safeName}</a>
          </div>
          <p style="color:#4b5563;font-size:11px;text-align:center;margin-top:28px;">AutomateQA · automate.qa.io@gmail.com</p>
        </div>
      `,
    });

    // Auto-reply to the sender
    await transporter.sendMail({
      from: `"AutomateQA" <${GMAIL_USER}>`,
      to: email,
      subject: "We received your message — AutomateQA",
      html: `
        <div style="font-family:sans-serif;max-width:600px;margin:0 auto;background:#0b0b0b;color:#e5e7eb;padding:32px;border-radius:12px;border:1px solid #1f1f1f;">
          <h2 style="color:#fff;font-size:22px;margin:0 0 8px 0;">Hey ${safeName}, we got your message! 👋</h2>
          <p style="color:#9ca3af;font-size:14px;line-height:1.7;margin:0 0 24px 0;">
            Thanks for reaching out to <strong style="color:#00FF88;">AutomateQA</strong>. We've received your message and will get back to you within <strong style="color:#fff;">24–48 hours</strong>.
          </p>
          <div style="background:#141414;border:1px solid #1f1f1f;border-radius:8px;padding:16px;margin-bottom:24px;">
            <p style="color:#6b7280;font-size:12px;margin:0 0 8px 0;text-transform:uppercase;letter-spacing:0.5px;">Your message</p>
            <p style="color:#d1d5db;font-size:13px;margin:0;white-space:pre-wrap;">${safeMessage}</p>
          </div>
          <p style="color:#9ca3af;font-size:13px;line-height:1.7;margin:0 0 20px 0;">While you wait, feel free to explore our content:</p>
          <div style="margin-bottom:28px;">
            <a href="https://automateqa.dev/memes" style="display:inline-block;background:#1a1a1a;color:#fff;font-size:13px;padding:8px 18px;border-radius:8px;text-decoration:none;border:1px solid #2a2a2a;margin-right:8px;">🎭 Browse Memes</a>
            <a href="https://automateqa.dev/videos" style="display:inline-block;background:#1a1a1a;color:#fff;font-size:13px;padding:8px 18px;border-radius:8px;text-decoration:none;border:1px solid #2a2a2a;">▶️ Watch Videos</a>
          </div>
          <p style="color:#4b5563;font-size:11px;text-align:center;margin-top:8px;">AutomateQA · automate.qa.io@gmail.com</p>
        </div>
      `,
    });

    return NextResponse.json({ success: true });
  } catch (err) {
    console.error("Contact form error:", err instanceof Error ? err.message : "Unknown error");
    return NextResponse.json({ error: "Failed to send message. Please try again." }, { status: 500 });
  }
}
