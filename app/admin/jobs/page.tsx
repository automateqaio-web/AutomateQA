"use client";

import { useState, useEffect, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  Plus, Trash2, Edit2, Eye, EyeOff, X, Loader2, Briefcase,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Job } from "@/types";
import { formatDate } from "@/lib/utils";

// ── Form state ────────────────────────────────────────────────────────────────

const EMPTY_FORM = {
  title: "",
  company: "",
  location: "",
  description: "",
  apply_url: "",
  job_type: "regular" as "regular" | "referral",
  is_remote: false,
  experience_level: "",
  salary: "",
  posted_at: new Date().toISOString().slice(0, 10),
  referral_contact: "",
  referral_note: "",
};

// ── Shared input class ────────────────────────────────────────────────────────
const INPUT =
  "w-full px-4 py-2.5 rounded-xl bg-[#141414] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 placeholder-[#3A3A3A] transition-all";
const LABEL =
  "block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-1.5";

// ── Source badge colours ──────────────────────────────────────────────────────
const SOURCE_COLORS: Record<string, string> = {
  adzuna:   "bg-blue-500/20 text-blue-400",
  manual:   "bg-purple-500/20 text-purple-400",
  referral: "bg-[#00FF88]/20 text-[#00FF88]",
};

export default function AdminJobsPage() {
  const [jobs, setJobs] = useState<Job[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const supabase = createClient();

  // ── Fetch ─────────────────────────────────────────────────────────────────
  const fetchJobs = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("jobs")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(500);
    setJobs(data || []);
    setLoading(false);
  }, [supabase]);

  useEffect(() => { fetchJobs(); }, [fetchJobs]);

  // ── Reset form ────────────────────────────────────────────────────────────
  const resetForm = () => {
    setForm(EMPTY_FORM);
    setEditingId(null);
    setError("");
    setShowForm(false);
  };

  // ── Open edit ─────────────────────────────────────────────────────────────
  const openEdit = (job: Job) => {
    setEditingId(job.id);
    setForm({
      title: job.title,
      company: job.company,
      location: job.location,
      description: job.description,
      apply_url: job.apply_url || "",
      job_type: job.job_type as "regular" | "referral",
      is_remote: job.is_remote,
      experience_level: job.experience_level || "",
      salary: job.salary || "",
      posted_at: job.posted_at
        ? new Date(job.posted_at).toISOString().slice(0, 10)
        : new Date().toISOString().slice(0, 10),
      referral_contact: job.referral_contact || "",
      referral_note: job.referral_note || "",
    });
    setShowForm(true);
  };

  // ── Save (create or update) ────────────────────────────────────────────────
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.title || !form.company || !form.location || !form.description) {
      setError("Title, company, location and description are required.");
      return;
    }
    if (form.job_type === "regular" && !form.apply_url) {
      setError("Apply URL is required for regular jobs.");
      return;
    }
    if (form.job_type === "referral" && !form.referral_contact) {
      setError("Referral contact is required for referral jobs.");
      return;
    }

    setSaving(true);
    setError("");

    const payload = {
      title: form.title,
      company: form.company,
      location: form.location,
      description: form.description,
      apply_url: form.apply_url || null,
      source: form.job_type === "referral" ? "referral" : "manual",
      job_type: form.job_type,
      is_remote: form.is_remote,
      experience_level: form.experience_level || null,
      salary: form.salary || null,
      posted_at: form.posted_at ? new Date(form.posted_at).toISOString() : new Date().toISOString(),
      fetched_at: null,
      referral_contact: form.referral_contact || null,
      referral_note: form.referral_note || null,
      updated_at: new Date().toISOString(),
    };

    try {
      if (editingId) {
        const { error: err } = await supabase
          .from("jobs")
          .update(payload)
          .eq("id", editingId);
        if (err) throw err;
      } else {
        const { error: err } = await supabase
          .from("jobs")
          .insert({ ...payload, is_active: true });
        if (err) throw err;
      }
      resetForm();
      fetchJobs();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to save job.");
    } finally {
      setSaving(false);
    }
  };

  // ── Toggle is_active ──────────────────────────────────────────────────────
  const toggleActive = async (job: Job) => {
    await supabase
      .from("jobs")
      .update({ is_active: !job.is_active, updated_at: new Date().toISOString() })
      .eq("id", job.id);
    fetchJobs();
  };

  // ── Delete ────────────────────────────────────────────────────────────────
  const deleteJob = async (id: string) => {
    if (!confirm("Permanently delete this job?")) return;
    await supabase.from("jobs").delete().eq("id", id);
    fetchJobs();
  };

  // ── Field helpers ─────────────────────────────────────────────────────────
  const set = (key: keyof typeof EMPTY_FORM) =>
    (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) =>
      setForm((prev) => ({ ...prev, [key]: e.target.value }));

  return (
    <div>
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-black text-white">Jobs Board</h1>
          <p className="text-[#9CA3AF] text-sm mt-1">{jobs.length} total jobs</p>
        </div>
        <button onClick={() => setShowForm(true)} className="btn-primary">
          <Plus size={16} /> Add Job
        </button>
      </div>

      {/* ── Add / Edit modal ─────────────────────────────────────────────── */}
      <AnimatePresence>
        {showForm && (
          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-black/85 backdrop-blur-sm flex items-start justify-center p-4 overflow-y-auto"
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.96, y: 24 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.96 }}
              transition={{ type: "spring", stiffness: 350, damping: 28 }}
              className="bg-[#0D0D0D] border border-white/8 rounded-3xl w-full max-w-2xl my-8 overflow-hidden shadow-2xl"
            >
              {/* Modal header */}
              <div className="flex items-center justify-between px-6 py-4 border-b border-white/5 bg-[#111]">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
                    <Briefcase size={15} className="text-[#00FF88]" />
                  </div>
                  <h2 className="text-base font-bold text-white">
                    {editingId ? "Edit Job" : "Add New Job"}
                  </h2>
                </div>
                <button onClick={resetForm} className="p-2 rounded-xl text-[#5A5A5A] hover:text-white hover:bg-white/5 transition-all">
                  <X size={18} />
                </button>
              </div>

              <form onSubmit={handleSubmit} className="p-6 space-y-5">
                {/* Job type selector */}
                <div>
                  <label className={LABEL}>Job Type</label>
                  <select value={form.job_type} onChange={set("job_type")} className={INPUT}>
                    <option value="regular">Regular</option>
                    <option value="referral">Referral</option>
                  </select>
                </div>

                {/* Title + Company */}
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className={LABEL}>Title *</label>
                    <input value={form.title} onChange={set("title")} placeholder="Senior QA Engineer" className={INPUT} required />
                  </div>
                  <div>
                    <label className={LABEL}>Company *</label>
                    <input value={form.company} onChange={set("company")} placeholder="Acme Corp" className={INPUT} required />
                  </div>
                </div>

                {/* Location + Remote */}
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className={LABEL}>Location *</label>
                    <input value={form.location} onChange={set("location")} placeholder="Bangalore, India" className={INPUT} required />
                  </div>
                  <div className="flex flex-col justify-end">
                    <label className="flex items-center gap-2.5 cursor-pointer pb-2.5">
                      <input
                        type="checkbox"
                        checked={form.is_remote}
                        onChange={(e) => setForm((p) => ({ ...p, is_remote: e.target.checked }))}
                        className="w-4 h-4 accent-[#00FF88]"
                      />
                      <span className="text-sm text-white">Remote / WFH</span>
                    </label>
                  </div>
                </div>

                {/* Description */}
                <div>
                  <label className={LABEL}>Description *</label>
                  <textarea
                    value={form.description} onChange={set("description")}
                    rows={4} placeholder="Brief job summary (max ~500 chars for public listing)"
                    className={INPUT + " resize-none"} required
                  />
                </div>

                {/* Experience + Salary */}
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className={LABEL}>Experience Level</label>
                    <input value={form.experience_level} onChange={set("experience_level")} placeholder="Fresher / 2-4 yrs / Senior" className={INPUT} />
                  </div>
                  <div>
                    <label className={LABEL}>Salary</label>
                    <input value={form.salary} onChange={set("salary")} placeholder="₹8-12 LPA" className={INPUT} />
                  </div>
                </div>

                {/* Posted date */}
                <div>
                  <label className={LABEL}>Posted Date</label>
                  <input type="date" value={form.posted_at} onChange={set("posted_at")} className={INPUT} />
                </div>

                {/* Regular-only: Apply URL */}
                {form.job_type === "regular" && (
                  <div>
                    <label className={LABEL}>Apply URL *</label>
                    <input
                      value={form.apply_url} onChange={set("apply_url")}
                      placeholder="https://company.com/careers/job-id"
                      className={INPUT}
                      required
                    />
                  </div>
                )}

                {/* Referral-only fields */}
                {form.job_type === "referral" && (
                  <>
                    <div>
                      <label className={LABEL}>Referral Contact *</label>
                      <input
                        value={form.referral_contact} onChange={set("referral_contact")}
                        placeholder="name@email.com or https://linkedin.com/in/…"
                        className={INPUT}
                        required
                      />
                      <p className="text-xs text-[#3A3A3A] mt-1">Email or LinkedIn URL of the referrer</p>
                    </div>
                    <div>
                      <label className={LABEL}>Referral Note</label>
                      <textarea
                        value={form.referral_note} onChange={set("referral_note")}
                        rows={3} placeholder="DM me on LinkedIn with your resume subject: QA Referral"
                        className={INPUT + " resize-none"}
                      />
                    </div>
                    <div>
                      <label className={LABEL}>Apply URL (optional)</label>
                      <input
                        value={form.apply_url} onChange={set("apply_url")}
                        placeholder="https://… (optional for referral jobs)"
                        className={INPUT}
                      />
                    </div>
                  </>
                )}

                {error && (
                  <div className="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm">
                    {error}
                  </div>
                )}

                <div className="flex gap-3 pt-1">
                  <button type="submit" disabled={saving} className="btn-primary flex-1 justify-center py-3 text-sm font-semibold">
                    {saving ? <Loader2 size={16} className="animate-spin" /> : (editingId ? "Update Job" : "Add Job")}
                  </button>
                  <button type="button" onClick={resetForm} className="btn-outline px-8 py-3 text-sm">
                    Cancel
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* ── Jobs list ─────────────────────────────────────────────────────── */}
      {loading ? (
        <div className="space-y-3">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="skeleton h-16 rounded-xl" />
          ))}
        </div>
      ) : jobs.length === 0 ? (
        <div className="glass-card p-16 text-center">
          <div className="text-5xl mb-4">💼</div>
          <h3 className="text-lg font-bold text-white mb-2">No jobs yet</h3>
          <p className="text-[#9CA3AF] mb-6">Add your first job posting or wait for the daily cron to fetch from Adzuna.</p>
          <button onClick={() => setShowForm(true)} className="btn-primary inline-flex">
            <Plus size={16} /> Add Job
          </button>
        </div>
      ) : (
        <div className="glass-card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Job</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden sm:table-cell">Source</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden md:table-cell">Posted</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Status</th>
                  <th className="text-right px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {jobs.map((job) => (
                  <tr key={job.id} className="hover:bg-white/[0.02] transition-colors">
                    <td className="px-4 py-3">
                      <p className="text-sm font-medium text-white truncate max-w-[240px]">{job.title}</p>
                      <p className="text-xs text-[#9CA3AF]">{job.company} · {job.location}</p>
                    </td>
                    <td className="px-4 py-3 hidden sm:table-cell">
                      <div className="flex gap-1.5 flex-wrap">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${SOURCE_COLORS[job.source] || "bg-white/10 text-white"}`}>
                          {job.source}
                        </span>
                        {job.job_type === "referral" && (
                          <span className="text-xs px-2 py-0.5 rounded-full font-medium bg-[#00FF88]/20 text-[#00FF88]">
                            Referral
                          </span>
                        )}
                      </div>
                    </td>
                    <td className="px-4 py-3 hidden md:table-cell">
                      <span className="text-xs text-[#9CA3AF]">
                        {job.posted_at ? formatDate(job.posted_at) : formatDate(job.created_at)}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${job.is_active ? "bg-green-500/20 text-green-400" : "bg-red-500/20 text-red-400"}`}>
                        {job.is_active ? "Active" : "Hidden"}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center justify-end gap-1">
                        <button
                          onClick={() => toggleActive(job)}
                          title={job.is_active ? "Hide job" : "Show job"}
                          className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors"
                        >
                          {job.is_active ? <EyeOff size={14} /> : <Eye size={14} />}
                        </button>
                        {/* Only manual/referral jobs are editable — adzuna rows are managed by cron */}
                        {job.source !== "adzuna" && (
                          <button
                            onClick={() => openEdit(job)}
                            className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors"
                          >
                            <Edit2 size={14} />
                          </button>
                        )}
                        <button
                          onClick={() => deleteJob(job.id)}
                          className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-red-400 hover:bg-red-500/10 transition-colors"
                        >
                          <Trash2 size={14} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
