import type { Metadata } from "next";
import Link from "next/link";
import { FileText, ArrowLeft } from "lucide-react";

export const metadata: Metadata = {
  title: "Terms of Service | AutomateQA",
  description: "Terms of Service for AutomateQA — rules and guidelines for using our platform.",
  alternates: { canonical: "https://automateqa.online/terms" },
  robots: { index: true, follow: true },
};

const EFFECTIVE_DATE = "June 6, 2025";
const CONTACT_EMAIL = "automate.qa.io@gmail.com";

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mb-10">
      <h2 className="text-xl font-bold text-white mb-4 pb-2 border-b border-white/10">{title}</h2>
      <div className="space-y-3 text-[#D1D5DB] leading-relaxed text-sm">{children}</div>
    </section>
  );
}

export default function TermsPage() {
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
              <FileText size={20} className="text-[#00FF88]" />
            </div>
            <span className="text-xs font-semibold text-[#00FF88] uppercase tracking-wider">Legal</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-white mb-3">Terms of Service</h1>
          <p className="text-[#9CA3AF] text-sm">
            Effective Date: <span className="text-white">{EFFECTIVE_DATE}</span>
          </p>
          <p className="text-[#9CA3AF] text-sm mt-2">
            Please read these Terms of Service carefully before using AutomateQA. By accessing or using our platform, you agree to be bound by these terms. If you do not agree, please do not use the platform.
          </p>
        </div>

        <div className="glass-card p-8 sm:p-10">

          <Section title="1. Acceptance of Terms">
            <p>
              By accessing <strong className="text-white">AutomateQA</strong> (the &quot;Platform&quot;, &quot;Service&quot;, &quot;Site&quot;), you confirm that you are at least 13 years of age, have read and understood these Terms of Service, and agree to comply with them. These terms apply to all visitors, subscribers, and registered users.
            </p>
          </Section>

          <Section title="2. Description of Service">
            <p>
              AutomateQA is a content platform for QA engineers and automation testers. The platform provides:
            </p>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li>QA and automation-related memes (including AI-generated images)</li>
              <li>Educational videos and tutorials on tools like Playwright, Selenium, and Cypress</li>
              <li>Blog articles on automation testing, career advice, and corporate culture</li>
              <li>YouTube channel statistics and creator analytics</li>
            </ul>
          </Section>

          <Section title="3. AI-Generated Content">
            <p>
              AutomateQA publishes content that includes <strong className="text-white">AI-generated images, memes, and videos</strong>. By using this platform, you acknowledge and agree that:
            </p>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li>AI-generated content is created using artificial intelligence tools and is intended for entertainment and educational purposes only.</li>
              <li>AI-generated content does not depict real events, real individuals, or constitute factual reporting unless explicitly stated.</li>
              <li>AutomateQA does not guarantee the accuracy, completeness, or fitness for any particular purpose of AI-generated content.</li>
              <li>You may not use AI-generated content from this platform to misrepresent facts, defame individuals, or engage in deceptive practices.</li>
              <li>Ownership of AI-generated content published on this platform remains with AutomateQA unless otherwise stated.</li>
            </ul>
          </Section>

          <Section title="4. Intellectual Property">
            <p>
              All content on AutomateQA — including but not limited to text, memes, images, videos, graphics, logos, and code — is the property of AutomateQA or its content suppliers and is protected by applicable intellectual property laws.
            </p>
            <p className="mt-3">
              <strong className="text-white">You may:</strong>
            </p>
            <ul className="list-disc pl-5 space-y-1 mt-1">
              <li>Share individual pieces of content with proper credit to AutomateQA.</li>
              <li>Use content for personal, non-commercial reference.</li>
            </ul>
            <p className="mt-3">
              <strong className="text-white">You may not:</strong>
            </p>
            <ul className="list-disc pl-5 space-y-1 mt-1">
              <li>Reproduce, republish, or redistribute content in bulk without written permission.</li>
              <li>Use our content for commercial purposes without prior written consent.</li>
              <li>Remove or alter any copyright, trademark, or attribution notices.</li>
              <li>Claim ownership of content created by AutomateQA.</li>
            </ul>
          </Section>

          <Section title="5. Acceptable Use">
            <p>You agree not to use the platform to:</p>
            <ul className="list-disc pl-5 space-y-2 mt-2">
              <li>Violate any applicable local, state, national, or international law or regulation.</li>
              <li>Transmit unsolicited commercial messages (spam).</li>
              <li>Impersonate any person or entity, or misrepresent your affiliation.</li>
              <li>Attempt to gain unauthorized access to any part of the platform.</li>
              <li>Interfere with or disrupt the integrity or performance of the platform.</li>
              <li>Scrape, crawl, or systematically extract data from the platform without permission.</li>
              <li>Upload or distribute malware, viruses, or any harmful code.</li>
            </ul>
          </Section>

          <Section title="6. Third-Party Links and Content">
            <p>
              The platform may contain links to third-party websites, YouTube videos, and external resources. These links are provided for convenience only. AutomateQA does not endorse, control, or assume responsibility for any third-party content, products, or services. Your use of third-party sites is subject to their own terms and privacy policies.
            </p>
          </Section>

          <Section title="7. Newsletter and Communications">
            <p>
              A newsletter feature is planned for a future release of AutomateQA. No email subscriptions are currently being collected. When the newsletter launches, these Terms will be updated with the relevant subscription terms and opt-out options.
            </p>
            <p className="mt-2">
              For general inquiries, you may contact us at{" "}
              <a href={`mailto:${CONTACT_EMAIL}`} className="text-[#00FF88] hover:underline">{CONTACT_EMAIL}</a>.
            </p>
          </Section>

          <Section title="8. Disclaimer of Warranties">
            <p>
              The platform and all content are provided on an <strong className="text-white">&quot;AS IS&quot; and &quot;AS AVAILABLE&quot;</strong> basis without warranties of any kind, either express or implied, including but not limited to implied warranties of merchantability, fitness for a particular purpose, or non-infringement.
            </p>
            <p className="mt-2">
              AutomateQA does not warrant that:
            </p>
            <ul className="list-disc pl-5 space-y-1 mt-2">
              <li>The platform will be uninterrupted, error-free, or secure.</li>
              <li>Any information or content on the platform is accurate, complete, or up to date.</li>
              <li>The platform is free of viruses or other harmful components.</li>
            </ul>
          </Section>

          <Section title="9. Limitation of Liability">
            <p>
              To the fullest extent permitted by applicable law, AutomateQA and its operators shall not be liable for any indirect, incidental, special, consequential, or punitive damages — including loss of data, revenue, or goodwill — arising from:
            </p>
            <ul className="list-disc pl-5 space-y-1 mt-2">
              <li>Your use of or inability to use the platform.</li>
              <li>Any content obtained from the platform.</li>
              <li>Unauthorized access to your data or transmissions.</li>
              <li>Actions of third-party services used by the platform.</li>
            </ul>
          </Section>

          <Section title="10. Indemnification">
            <p>
              You agree to indemnify, defend, and hold harmless AutomateQA and its affiliates, operators, and contributors from and against any claims, damages, losses, liabilities, costs, and expenses (including legal fees) arising from your use of the platform or violation of these Terms.
            </p>
          </Section>

          <Section title="11. Modifications to the Service">
            <p>
              AutomateQA reserves the right to modify, suspend, or discontinue any part of the platform at any time, with or without notice. We are not liable to you or any third party for any modification, suspension, or discontinuation of the service.
            </p>
          </Section>

          <Section title="12. Changes to These Terms">
            <p>
              We may revise these Terms of Service from time to time. The most current version will always be posted on this page with an updated effective date. Continued use of the platform after changes are posted constitutes your acceptance of the revised terms.
            </p>
          </Section>

          <Section title="13. Governing Law">
            <p>
              These Terms shall be governed by and construed in accordance with the laws of <strong className="text-white">India</strong>, without regard to its conflict of law provisions. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts located in India.
            </p>
          </Section>

          <Section title="14. Contact Us">
            <p>If you have any questions about these Terms of Service, please contact us:</p>
            <div className="mt-4 p-4 rounded-xl bg-[#111] border border-white/10">
              <p className="text-white font-semibold mb-1">AutomateQA</p>
              <p>Email: <a href={`mailto:${CONTACT_EMAIL}`} className="text-[#00FF88] hover:underline">{CONTACT_EMAIL}</a></p>
              <p>Website: <Link href="/" className="text-[#00FF88] hover:underline">automateqa.io</Link></p>
            </div>
          </Section>

        </div>

        {/* Bottom links */}
        <div className="mt-8 flex flex-wrap gap-4 justify-center text-sm text-[#9CA3AF]">
          <Link href="/privacy" className="hover:text-[#00FF88] transition-colors">Privacy Policy</Link>
          <span>·</span>
          <Link href="/contact" className="hover:text-[#00FF88] transition-colors">Contact Us</Link>
          <span>·</span>
          <Link href="/" className="hover:text-[#00FF88] transition-colors">Home</Link>
        </div>
      </div>
    </div>
  );
}
