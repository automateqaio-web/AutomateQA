import Link from "next/link";
import Image from "next/image";
import { Play, Camera, Mail, ArrowRight } from "lucide-react";

const footerLinks = {
  Content: [
    { label: "Memes", href: "/memes" },
    { label: "Videos", href: "/videos" },
    { label: "Blog", href: "/blog" },
    { label: "100 Days of Playwright", href: "/#playwright" },
  ],
  Company: [
    { label: "About", href: "/about" },
    { label: "Contact", href: "/contact" },
    { label: "Sponsorship", href: "/contact#sponsorship" },
    { label: "Collaborate", href: "/contact#collaborate" },
  ],
  Legal: [
    { label: "Privacy Policy", href: "/privacy" },
    { label: "Terms of Service", href: "/terms" },
  ],
};

const socialLinks = [
  { icon: Play, href: "https://youtube.com/@automateqa", label: "YouTube", color: "hover:text-red-500" },
  { icon: Camera, href: "https://www.instagram.com/automateqa.io", label: "Instagram", color: "hover:text-pink-500" },
  { icon: Mail, href: "mailto:automate.qa.io@gmail.com", label: "Email", color: "hover:text-[#00FF88]" },
];

export default function Footer() {
  return (
    <footer className="bg-[#080808] border-t border-white/5 mt-20">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Main footer */}
        <div className="py-16 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8">
          {/* Brand */}
          <div className="lg:col-span-2">
            <Link href="/" className="flex items-center gap-3 mb-5 group w-fit">
              <div className="relative w-12 h-12 flex-shrink-0 transition-all duration-300 group-hover:scale-105 group-hover:drop-shadow-[0_0_10px_rgba(0,255,136,0.5)]">
                <Image
                  src="/logo.png"
                  alt="AutomateQA Logo"
                  fill
                  className="object-contain rounded-full"
                />
              </div>
              <span className="font-black text-xl tracking-tight">
                <span className="text-white">Automate</span>
                <span className="text-[#00FF88]">QA</span>
              </span>
            </Link>
            <p className="text-[#9CA3AF] text-sm leading-relaxed mb-6 max-w-xs">
              The home for QA engineers, automation testers, and developers who appreciate a good meme about production bugs.
            </p>
            {/* Social links */}
            <div className="flex items-center gap-3">
              {socialLinks.map(({ icon: Icon, href, label, color }) => (
                <a
                  key={label}
                  href={href}
                  target="_blank"
                  rel="noopener noreferrer"
                  title={label}
                  className={`w-9 h-9 rounded-lg bg-white/5 flex items-center justify-center text-[#9CA3AF] ${color} transition-all duration-200 hover:bg-white/10 border border-white/5 hover:border-white/10`}
                >
                  <Icon size={16} />
                </a>
              ))}
            </div>
          </div>

          {/* Links */}
          {Object.entries(footerLinks).map(([category, links]) => (
            <div key={category}>
              <h3 className="text-white font-semibold text-sm mb-4">{category}</h3>
              <ul className="space-y-2">
                {links.map(({ label, href }) => (
                  <li key={label}>
                    <Link
                      href={href}
                      className="text-[#9CA3AF] hover:text-[#00FF88] text-sm transition-colors duration-200 flex items-center gap-1 group"
                    >
                      <ArrowRight size={12} className="opacity-0 group-hover:opacity-100 transition-opacity -ml-3 group-hover:ml-0" />
                      {label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        {/* Bottom bar */}
        <div className="py-6 border-t border-white/5 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <div className="relative w-5 h-5">
              <Image src="/logo.png" alt="AutomateQA" fill className="object-contain rounded-full" />
            </div>
            <p className="text-[#9CA3AF] text-sm">
              © {new Date().getFullYear()} AutomateQA. Built with ❤️ for the QA community.
            </p>
          </div>
          <p className="text-[#9CA3AF] text-xs">
            <a href="mailto:automate.qa.io@gmail.com" className="hover:text-[#00FF88] transition-colors">
              automate.qa.io@gmail.com
            </a>
          </p>
        </div>
      </div>
    </footer>
  );
}
