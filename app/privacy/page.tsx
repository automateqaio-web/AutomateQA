import type { Metadata } from "next";
import Link from "next/link";
import { Shield, ArrowLeft } from "lucide-react";

export const metadata: Metadata = {
  title: "Privacy Policy | AutomateQA",
  description: "Privacy Policy for AutomateQA — learn how we collect, use, and protect your information.",
  alternates: { canonical: "https://automateqa.online/privacy" },
  robots: { index: true, follow: true },
};

const EFFECTIVE_DATE = "June 27, 2026";
const CONTACT_EMAIL = "automate.qa.io@gmail.com";

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mb-10">
      <h2 className="text-xl font-bold text-white mb-4 pb-2 border-b border-white/10">{title}</h2>
      <div className="space-y-3 text-[#D1D5DB] leading-relaxed text-sm">{children}</div>
    </section>
  );
}

export default function PrivacyPage() {
  return (
    <div className="min-h-screen pt-24 pb-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Back */}
        <Link
          href="/"
          className="inline-flex items-center gap-2 text-sm text-[#9CA3AF] hover:text-[#00FF88] transition-colors mb-8 group"
        >
          <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
          Back to Home
        </Link>

        {/* Header */}
        <div className="glass-card p-8 mb-8 border-[#00FF88]/10">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
              <Shield size={20} className="text-[#00FF88]" />
            </div>
            <span className="text-xs font-semibold text-[#00FF88] uppercase tracking-wider">Legal</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-white mb-3">Privacy Policy</h1>
          <p className="text-[#9CA3AF] text-sm">
            Effective Date: <span className="text-white">{EFFECTIVE_DATE}</span>
          </p>
          <p className="text-[#9CA3AF] text-sm mt-2">
            AutomateQA (&quot;we&quot;, &quot;us&quot;, or &quot;our&quot;) is committed to protecting your privacy. This policy explains what information we collect, how we use it, and your rights regarding that information.
          </p>
        </div>

        <div className="glass-card p-8 sm:p-10">

          <Section title="1. Information We Collect">
            <p><strong className="text-white">a) Information you provide directly:</strong></p>
            <ul className="list-disc pl-5 space-y-1 mt-2">
              <li>Contact details — when you fill out our contact form.</li>
            </ul>
            <p className="mt-3"><strong className="text-white">b) Information collected automatically:</strong></p>
            <ul className="list-disc pl-5 space-y-1 mt-2">
              <li>Browser type, device type, and operating system.</li>
              <li>Pages visited, time spent, and click patterns (via analytics tools).</li>
              <li>IP address (anonymised where possible).</li>
              <li>Cookies and similar tracking technologies.</li>
            </ul>
            <p className="mt-3"><strong className="text-white">c) Third-party data:</strong></p>
            <ul className="list-disc pl-5 space-y-1 mt-2">
              <li>YouTube channel statistics via the YouTube Data API v3 (public data only).</li>
              <li>No data is collected from your personal YouTube or social media accounts.</li>
            </ul>
          </Section>

          <Section title="2. AI-Generated Content">
            <p>
              AutomateQA publishes content that may include <strong className="text-white">AI-generated images, videos, memes, and written material</strong>. This content is created using artificial intelligence tools for entertainment, education, and informational purposes.
            </p>
            <p>
              We clearly aim to label AI-generated content where practical. Such content does not represent real events, real people, or factual information unless explicitly stated. We do not collect any personal data through the creation or display of AI-generated content.
            </p>
            <p>
              If you believe any AI-generated content on this platform infringes upon your rights or is harmful, please contact us at{" "}
              <a href={`mailto:${CONTACT_EMAIL}`} className="text-[#00FF88] hover:underline">{CONTACT_EMAIL}</a>.
            </p>
          </Section>

          <Section title="3. How We Use Your Information">
            <ul className="list-disc pl-5 space-y-2">
              <li>To respond to your inquiries and support requests.</li>
              <li>To improve the platform based on usage patterns.</li>
              <li>To display relevant content — including job listings — and improve your browsing experience.</li>
              <li>To monitor and maintain the security of our platform.</li>
              <li>To send newsletter emails to subscribers (you may unsubscribe at any time).</li>
            </ul>
            <p className="mt-3">We do <strong className="text-white">not</strong> sell, rent, or trade your personal information to third parties for their marketing purposes.</p>
          </Section>

          <Section title="4. Cookies">
            <p>
              We use cookies and similar technologies to enhance your experience. Types of cookies we use:
            </p>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li><strong className="text-white">Essential cookies</strong> — required for the site to function (e.g., session management).</li>
              <li><strong className="text-white">Analytics cookies</strong> — help us understand how visitors interact with our site.</li>
              <li><strong className="text-white">Preference cookies</strong> — remember your settings and choices.</li>
            </ul>
            <p className="mt-3">
              You can disable cookies through your browser settings. Note that disabling essential cookies may affect site functionality.
            </p>
          </Section>

          <Section title="5. Third-Party Services">
            <p>We use the following third-party services that may process your data under their own privacy policies:</p>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li><strong className="text-white">Supabase</strong> — database and backend. Data stored in secure cloud infrastructure.</li>
              <li><strong className="text-white">Adzuna API</strong> — we fetch publicly available job listings from Adzuna to populate our Jobs Board. No personal user data is shared with Adzuna. Job listings link to employer or Adzuna sites with their own privacy policies.</li>
              <li><strong className="text-white">YouTube Data API v3</strong> — we display publicly available YouTube channel statistics.</li>
              <li><strong className="text-white">Vercel</strong> — hosting and edge network delivery.</li>
              <li><strong className="text-white">Clearbit / Google S2</strong> — we load company logos for job listings using publicly available favicon and logo services. No personal data is transmitted.</li>
            </ul>
            <p className="mt-3">
              We encourage you to review the privacy policies of these services. We are not responsible for their data practices.
            </p>
          </Section>

          <Section title="6. Data Retention">
            <p>
              We retain your personal information only for as long as necessary to fulfill the purposes outlined in this policy or as required by law. Newsletter subscription data is retained until you unsubscribe. Analytics data is retained in aggregated, anonymised form.
            </p>
          </Section>

          <Section title="7. Your Rights">
            <p>Depending on your location, you may have the following rights:</p>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li><strong className="text-white">Access</strong> — request a copy of the personal data we hold about you.</li>
              <li><strong className="text-white">Correction</strong> — request correction of inaccurate personal data.</li>
              <li><strong className="text-white">Deletion</strong> — request deletion of your personal data (&quot;right to be forgotten&quot;).</li>
              <li><strong className="text-white">Unsubscribe</strong> — opt out of marketing emails at any time via the unsubscribe link in any email.</li>
              <li><strong className="text-white">Objection</strong> — object to certain types of data processing.</li>
            </ul>
            <p className="mt-3">
              To exercise any of these rights, contact us at{" "}
              <a href={`mailto:${CONTACT_EMAIL}`} className="text-[#00FF88] hover:underline">{CONTACT_EMAIL}</a>.
            </p>
          </Section>

          <Section title="8. Children's Privacy">
            <p>
              AutomateQA is not directed at children under the age of 13. We do not knowingly collect personal information from children. If you believe we have inadvertently collected information from a child, please contact us and we will delete it promptly.
            </p>
          </Section>

          <Section title="9. Security">
            <p>
              We implement reasonable technical and organizational measures to protect your personal data against unauthorized access, loss, or disclosure. However, no internet transmission is completely secure. We cannot guarantee absolute security of data transmitted to or from our platform.
            </p>
          </Section>

          <Section title="10. Changes to This Policy">
            <p>
              We may update this Privacy Policy from time to time. When we do, we will update the effective date at the top of this page. Continued use of the platform after changes constitutes acceptance of the updated policy. We encourage you to review this page periodically.
            </p>
          </Section>

          <Section title="11. Contact Us">
            <p>If you have any questions, concerns, or requests regarding this Privacy Policy, please reach out:</p>
            <div className="mt-4 p-4 rounded-xl bg-[#111] border border-white/10">
              <p className="text-white font-semibold mb-1">AutomateQA</p>
              <p>Email: <a href={`mailto:${CONTACT_EMAIL}`} className="text-[#00FF88] hover:underline">{CONTACT_EMAIL}</a></p>
              <p>Website: <Link href="/" className="text-[#00FF88] hover:underline">automateqa.online</Link></p>
            </div>
          </Section>

        </div>

        {/* Bottom links */}
        <div className="mt-8 flex flex-wrap gap-4 justify-center text-sm text-[#9CA3AF]">
          <Link href="/terms" className="hover:text-[#00FF88] transition-colors">Terms of Service</Link>
          <span>·</span>
          <Link href="/contact" className="hover:text-[#00FF88] transition-colors">Contact Us</Link>
          <span>·</span>
          <Link href="/" className="hover:text-[#00FF88] transition-colors">Home</Link>
        </div>
      </div>
    </div>
  );
}
