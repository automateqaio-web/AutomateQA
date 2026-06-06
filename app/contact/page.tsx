"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Mail, MessageSquare, Users, DollarSign, Send, Check, Loader2, Play, Camera } from "lucide-react";

const socialLinks = [
  { icon: Play, href: "https://youtube.com/@automateqa", label: "YouTube", desc: "Tutorials & Meme Compilations", color: "text-red-400 bg-red-500/10 border-red-500/20" },
  { icon: Camera, href: "https://www.instagram.com/automateqa.io", label: "Instagram", desc: "Daily QA Memes", color: "text-pink-400 bg-pink-500/10 border-pink-500/20" },
];

export default function ContactPage() {
  const [form, setForm] = useState({ name: "", email: "", subject: "", message: "", type: "general" });
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle");
  const [errorMsg, setErrorMsg] = useState("");

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus("loading");
    setErrorMsg("");
    try {
      const res = await fetch("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || "Something went wrong.");
      setStatus("success");
    } catch (err) {
      setErrorMsg(err instanceof Error ? err.message : "Failed to send. Please try again.");
      setStatus("error");
    }
  };

  return (
    <div className="min-h-screen pt-24 pb-20">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#00FF88]/10 border border-[#00FF88]/20 text-[#00FF88] text-xs font-semibold mb-4">
            <Mail size={10} />
            GET IN TOUCH
          </div>
          <h1 className="text-4xl sm:text-5xl font-black text-white mb-4">
            Let&apos;s <span className="text-gradient">Connect</span>
          </h1>
          <p className="text-[#9CA3AF] text-lg max-w-xl mx-auto">
            Collaboration, sponsorship, content ideas, or just want to rant about flaky tests? Slide into our inbox.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-5 gap-8">
          {/* Left sidebar */}
          <div className="lg:col-span-2 space-y-6">
            {/* Contact types */}
            {[
              { icon: MessageSquare, title: "General Inquiries", desc: "Questions, feedback, content suggestions, or just saying hi.", color: "text-[#00FF88] bg-[#00FF88]/10 border-[#00FF88]/20" },
              { icon: Users, title: "Collaborate", id: "collaborate", desc: "Guest posts, joint tutorials, podcast appearances, content collaborations.", color: "text-purple-400 bg-purple-500/10 border-purple-500/20" },
              { icon: DollarSign, title: "Sponsorship", id: "sponsorship", desc: "Reach 10K+ QA engineers. Tool reviews, banner placements, sponsored content.", color: "text-yellow-400 bg-yellow-500/10 border-yellow-500/20" },
            ].map(({ icon: Icon, title, desc, id, color }) => (
              <div key={title} id={id} className="glass-card p-5">
                <div className={`w-9 h-9 rounded-xl border flex items-center justify-center mb-3 ${color}`}>
                  <Icon size={17} />
                </div>
                <h3 className="font-bold text-white mb-1">{title}</h3>
                <p className="text-[#9CA3AF] text-sm leading-relaxed">{desc}</p>
              </div>
            ))}

            {/* Social links */}
            <div className="glass-card p-5">
              <h3 className="font-bold text-white mb-4">Find Us Online</h3>
              <div className="space-y-3">
                {socialLinks.map(({ icon: Icon, href, label, desc, color }) => (
                  <a key={label} href={href} target="_blank" rel="noopener noreferrer"
                    className={`flex items-center gap-3 p-3 rounded-xl border transition-all hover:opacity-80 ${color}`}>
                    <Icon size={18} />
                    <div>
                      <div className="text-sm font-semibold">{label}</div>
                      <div className="text-xs opacity-70">{desc}</div>
                    </div>
                  </a>
                ))}
              </div>
            </div>

            {/* Direct email */}
            <div className="glass-card p-5 text-center border border-[#00FF88]/10">
              <Mail size={20} className="text-[#00FF88] mx-auto mb-2" />
              <p className="text-sm text-[#9CA3AF]">Direct email</p>
              <a href="mailto:automate.qa.io@gmail.com" className="text-[#00FF88] font-semibold hover:underline">
                automate.qa.io@gmail.com
              </a>
            </div>
          </div>

          {/* Contact form */}
          <div className="lg:col-span-3">
            <div className="glass-card p-8">
              {status === "success" ? (
                <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="text-center py-12">
                  <div className="w-16 h-16 rounded-2xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center mx-auto mb-4">
                    <Check size={28} className="text-[#00FF88]" />
                  </div>
                  <h3 className="text-2xl font-black text-white mb-2">Message Sent!</h3>
                  <p className="text-[#9CA3AF]">We&apos;ll get back to you within 24-48 hours. Thanks for reaching out!</p>
                  <button onClick={() => { setStatus("idle"); setForm({ name: "", email: "", subject: "", message: "", type: "general" }); }} className="btn-outline mt-6 inline-flex">Send Another</button>
                </motion.div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-5">
                  <h2 className="text-2xl font-black text-white mb-6">Send a Message</h2>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Name *</label>
                      <input name="name" value={form.name} onChange={handleChange} required placeholder="Your name" className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all" />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Email *</label>
                      <input name="email" type="email" value={form.email} onChange={handleChange} required placeholder="your@email.com" className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all" />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Type</label>
                    <select name="type" value={form.type} onChange={handleChange} className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all">
                      <option value="general">General Inquiry</option>
                      <option value="collaborate">Collaboration</option>
                      <option value="sponsorship">Sponsorship</option>
                      <option value="bug">Report Issue</option>
                      <option value="other">Other</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Subject *</label>
                    <input name="subject" value={form.subject} onChange={handleChange} required placeholder="What's this about?" className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all" />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Message *</label>
                    <textarea name="message" value={form.message} onChange={handleChange} required rows={6} placeholder="Tell us what's on your mind..." className="w-full px-4 py-3 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/50 transition-all resize-none" />
                  </div>

                  {errorMsg && <p className="text-red-400 text-sm">{errorMsg}</p>}

                  <motion.button type="submit" disabled={status === "loading"} whileHover={{ scale: 1.01 }} whileTap={{ scale: 0.99 }} className="btn-primary w-full justify-center py-3.5">
                    {status === "loading" ? <Loader2 size={16} className="animate-spin" /> : <><Send size={16} /> Send Message</>}
                  </motion.button>
                </form>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
