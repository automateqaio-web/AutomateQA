"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  Plus, Trash2, Edit2, Eye, EyeOff, X, Loader2, Star,
  ChevronDown, Search, BrainCircuit,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import {
  InterviewQuestion, INTERVIEW_TECHNOLOGIES, INTERVIEW_QUESTION_TYPES,
  INTERVIEW_EXPERIENCE_LEVELS, INTERVIEW_CODE_LANGUAGES, DIFFICULTIES,
} from "@/types";
import { formatDate, slugify } from "@/lib/utils";
import BlogEditor from "@/components/admin/BlogEditor";

// ── Helpers ───────────────────────────────────────────────────────────────────

function generateSlug(question: string): string {
  return slugify(question.replace(/\?/g, "").slice(0, 80));
}

const EMPTY_FORM = {
  question:           "",
  slug:               "",
  short_description:  "",
  answer:             "",
  real_world_example: "",
  best_practices:     "",
  common_mistakes:    "",
  code_snippet:       "",
  code_language:      "java",
  technology:         "Selenium" as InterviewQuestion["technology"],
  question_type:      "Technical" as InterviewQuestion["question_type"],
  experience_level:   "Fresher" as InterviewQuestion["experience_level"],
  difficulty:         "Beginner" as InterviewQuestion["difficulty"],
  youtube_url:        "",
  tags:               "",
  featured:           false,
  published:          false,
};

type FormState = typeof EMPTY_FORM;

// ── Component ─────────────────────────────────────────────────────────────────

export default function AdminInterviewPrepPage() {
  const [items,     setItems]     = useState<InterviewQuestion[]>([]);
  const [loading,   setLoading]   = useState(true);
  const [showForm,  setShowForm]  = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form,      setForm]      = useState<FormState>(EMPTY_FORM);
  const [activeTab, setActiveTab] = useState<"basic" | "content" | "code" | "meta">("basic");
  const [saving,    setSaving]    = useState(false);
  const [error,     setError]     = useState("");
  const [search,    setSearch]    = useState("");
  const [deleting,  setDeleting]  = useState<string | null>(null);
  const [ytMode,    setYtMode]    = useState<"url" | "embed">("url");
  const [embedRaw,  setEmbedRaw]  = useState("");
  const supabase = useRef(createClient()).current;

  function extractYouTubeId(input: string): string | null {
    const m = input.match(/(?:v=|youtu\.be\/|embed\/)([a-zA-Z0-9_-]{11})/);
    return m?.[1] || null;
  }

  const fetchItems = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("interview_questions")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(300);
    setItems((data || []) as InterviewQuestion[]);
    setLoading(false);
  }, [supabase]);

  useEffect(() => { fetchItems(); }, [fetchItems]);

  const handleQuestionChange = (question: string) => {
    setForm(prev => ({
      ...prev,
      question,
      slug: editingId ? prev.slug : generateSlug(question),
    }));
  };

  const openEdit = (item: InterviewQuestion) => {
    setEditingId(item.id);
    setForm({
      question:           item.question,
      slug:               item.slug,
      short_description:  item.short_description   || "",
      answer:             item.answer              || "",
      real_world_example: item.real_world_example  || "",
      best_practices:     item.best_practices      || "",
      common_mistakes:    item.common_mistakes     || "",
      code_snippet:       item.code_snippet        || "",
      code_language:      item.code_language       || "java",
      technology:         item.technology,
      question_type:      item.question_type,
      experience_level:   item.experience_level,
      difficulty:         item.difficulty,
      youtube_url:        item.youtube_url         || "",
      tags:               Array.isArray(item.tags) ? item.tags.join(", ") : "",
      featured:           item.featured,
      published:          item.published,
    });
    setActiveTab("basic");
    setYtMode("url");
    setEmbedRaw("");
    setShowForm(true);
  };

  const resetForm = () => {
    setForm(EMPTY_FORM);
    setEditingId(null);
    setError("");
    setShowForm(false);
    setActiveTab("basic");
    setYtMode("url");
    setEmbedRaw("");
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.question.trim() || !form.slug.trim()) {
      setError("Question and slug are required");
      return;
    }
    setSaving(true);
    setError("");

    const payload = {
      question:           form.question.trim(),
      slug:               form.slug.trim(),
      short_description:  form.short_description.trim()   || null,
      answer:             form.answer.trim()              || null,
      real_world_example: form.real_world_example.trim()  || null,
      best_practices:     form.best_practices.trim()      || null,
      common_mistakes:    form.common_mistakes.trim()     || null,
      code_snippet:       form.code_snippet.trim()        || null,
      code_language:      form.code_snippet.trim() ? form.code_language : null,
      technology:         form.technology,
      question_type:      form.question_type,
      experience_level:   form.experience_level,
      difficulty:         form.difficulty,
      youtube_url:        form.youtube_url.trim()         || null,
      tags:               form.tags.split(",").map(t => t.trim()).filter(Boolean),
      featured:           form.featured,
      published:          form.published,
      updated_at:         new Date().toISOString(),
    };

    try {
      if (editingId) {
        const { error: upErr } = await supabase
          .from("interview_questions")
          .update(payload)
          .eq("id", editingId);
        if (upErr) throw upErr;
      } else {
        // Check slug uniqueness
        const { data: existing } = await supabase
          .from("interview_questions")
          .select("id")
          .eq("slug", payload.slug)
          .maybeSingle();
        if (existing) { setError("A question with this slug already exists."); setSaving(false); return; }

        const { error: insErr } = await supabase
          .from("interview_questions")
          .insert({ ...payload, views: 0, created_at: new Date().toISOString() });
        if (insErr) throw insErr;
      }
      await fetchItems();
      resetForm();
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Save failed. Please try again.");
    }
    setSaving(false);
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm("Delete this question? This cannot be undone.")) return;
    setDeleting(id);
    await supabase.from("interview_questions").delete().eq("id", id);
    setItems(prev => prev.filter(i => i.id !== id));
    setDeleting(null);
  };

  const togglePublished = async (item: InterviewQuestion) => {
    await supabase.from("interview_questions").update({ published: !item.published }).eq("id", item.id);
    setItems(prev => prev.map(i => i.id === item.id ? { ...i, published: !i.published } : i));
  };

  const toggleFeatured = async (item: InterviewQuestion) => {
    await supabase.from("interview_questions").update({ featured: !item.featured }).eq("id", item.id);
    setItems(prev => prev.map(i => i.id === item.id ? { ...i, featured: !i.featured } : i));
  };

  const filtered = items.filter(item =>
    !search ||
    item.question.toLowerCase().includes(search.toLowerCase()) ||
    item.technology.toLowerCase().includes(search.toLowerCase()) ||
    item.question_type.toLowerCase().includes(search.toLowerCase())
  );

  const TABS = [
    { id: "basic",   label: "Basic Info" },
    { id: "content", label: "Answer & Examples" },
    { id: "code",    label: "Code Snippet" },
    { id: "meta",    label: "Media & Tags" },
  ] as const;

  return (
    <div className="flex-1 p-4 md:p-8 space-y-6 min-h-screen bg-[#0B0B0B]">

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
            <BrainCircuit size={18} className="text-[#00FF88]" />
          </div>
          <div>
            <h1 className="text-xl font-black text-white">Interview Prep</h1>
            <p className="text-[#6B7280] text-xs mt-0.5">{items.length} question{items.length !== 1 ? "s" : ""}</p>
          </div>
        </div>
        <button
          onClick={() => { setShowForm(true); setEditingId(null); setForm(EMPTY_FORM); }}
          className="btn-primary text-sm flex items-center gap-2"
        >
          <Plus size={15} /> Add Question
        </button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search size={15} className="absolute left-4 top-1/2 -translate-y-1/2 text-[#6B7280] pointer-events-none" />
        <input
          type="text"
          value={search}
          onChange={e => setSearch(e.target.value)}
          placeholder="Search questions, technologies..."
          className="w-full pl-10 pr-4 py-2.5 bg-[#111] border border-[#2A2A2A] rounded-xl text-white text-sm placeholder-[#6B7280] focus:outline-none focus:border-[#00FF88]/40 transition-all"
        />
      </div>

      {/* Table */}
      {loading ? (
        <div className="flex justify-center py-20"><Loader2 className="animate-spin text-[#00FF88]" size={28} /></div>
      ) : (
        <div className="rounded-2xl border border-[#1A1A1A] overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-[#1A1A1A] bg-[#0D0D0D]">
                  {["Question", "Technology", "Difficulty", "Experience", "Views", "Status", "Actions"].map(h => (
                    <th key={h} className="text-left px-4 py-3 text-xs font-semibold text-[#6B7280] uppercase tracking-widest whitespace-nowrap">
                      {h}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-[#1A1A1A]">
                {filtered.length === 0 ? (
                  <tr><td colSpan={7} className="text-center py-16 text-[#4B5563]">No questions found.</td></tr>
                ) : filtered.map(item => (
                  <tr key={item.id} className="bg-[#0B0B0B] hover:bg-[#0F0F0F] transition-colors">
                    <td className="px-4 py-3 max-w-xs">
                      <p className="text-white text-sm font-medium line-clamp-2 leading-snug">{item.question}</p>
                      <p className="text-[#4B5563] text-xs mt-0.5">{item.question_type}</p>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap">
                      <span className="text-xs text-[#9CA3AF] font-medium">{item.technology}</span>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap">
                      <span className={`text-xs font-semibold ${
                        item.difficulty === "Beginner" ? "text-green-400" :
                        item.difficulty === "Intermediate" ? "text-yellow-400" : "text-red-400"
                      }`}>{item.difficulty}</span>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-xs text-[#6B7280]">{item.experience_level}</td>
                    <td className="px-4 py-3 whitespace-nowrap text-xs text-[#6B7280]">{item.views || 0}</td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-1.5 flex-wrap">
                        <button
                          onClick={() => togglePublished(item)}
                          className={`flex items-center gap-1 px-2 py-0.5 rounded text-[10px] font-bold border transition-all ${
                            item.published
                              ? "bg-[#00FF88]/10 text-[#00FF88] border-[#00FF88]/20"
                              : "bg-[#1A1A1A] text-[#6B7280] border-[#2A2A2A]"
                          }`}
                        >
                          {item.published ? <Eye size={9} /> : <EyeOff size={9} />}
                          {item.published ? "Live" : "Draft"}
                        </button>
                        <button
                          onClick={() => toggleFeatured(item)}
                          className={`p-0.5 rounded transition-colors ${
                            item.featured ? "text-yellow-400" : "text-[#2A2A2A] hover:text-[#6B7280]"
                          }`}
                          title={item.featured ? "Unfeature" : "Feature"}
                        >
                          <Star size={13} fill={item.featured ? "currentColor" : "none"} />
                        </button>
                      </div>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-1.5">
                        <button
                          onClick={() => openEdit(item)}
                          className="p-1.5 rounded-lg text-[#6B7280] hover:text-[#00FF88] hover:bg-[#00FF88]/10 transition-all"
                          title="Edit"
                        >
                          <Edit2 size={14} />
                        </button>
                        <button
                          onClick={() => handleDelete(item.id)}
                          disabled={deleting === item.id}
                          className="p-1.5 rounded-lg text-[#6B7280] hover:text-red-400 hover:bg-red-500/10 transition-all disabled:opacity-50"
                          title="Delete"
                        >
                          {deleting === item.id ? <Loader2 size={14} className="animate-spin" /> : <Trash2 size={14} />}
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

      {/* ── Form Modal ── */}
      <AnimatePresence>
        {showForm && (
          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-start justify-center p-4 overflow-y-auto"
            onClick={e => { if (e.target === e.currentTarget) resetForm(); }}
          >
            <motion.div
              initial={{ opacity: 0, y: 20, scale: 0.97 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 20, scale: 0.97 }}
              transition={{ duration: 0.2 }}
              className="w-full max-w-5xl bg-[#0D0D0D] border border-[#2A2A2A] rounded-2xl shadow-2xl my-8"
              onClick={e => e.stopPropagation()}
            >
              {/* Modal header */}
              <div className="flex items-center justify-between px-6 py-4 border-b border-[#1A1A1A]">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
                    <BrainCircuit size={14} className="text-[#00FF88]" />
                  </div>
                  <h2 className="text-white font-black text-base">
                    {editingId ? "Edit Question" : "New Question"}
                  </h2>
                </div>
                <button onClick={resetForm} className="p-1.5 rounded-lg text-[#6B7280] hover:text-white hover:bg-white/5 transition-all">
                  <X size={18} />
                </button>
              </div>

              {/* Tabs */}
              <div className="flex border-b border-[#1A1A1A] px-6 overflow-x-auto">
                {TABS.map(tab => (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`px-4 py-3 text-xs font-bold whitespace-nowrap border-b-2 transition-all ${
                      activeTab === tab.id
                        ? "border-[#00FF88] text-[#00FF88]"
                        : "border-transparent text-[#6B7280] hover:text-[#9CA3AF]"
                    }`}
                  >
                    {tab.label}
                  </button>
                ))}
              </div>

              <form onSubmit={handleSubmit} className="p-6 space-y-5">

                {/* ── Tab: Basic Info ── */}
                {activeTab === "basic" && (
                  <div className="space-y-5">
                    <FormField label="Interview Question *">
                      <textarea
                        value={form.question}
                        onChange={e => handleQuestionChange(e.target.value)}
                        placeholder="e.g. What are the different types of waits in Selenium?"
                        rows={3}
                        required
                        className="input-field resize-none"
                      />
                    </FormField>

                    <FormField label="Slug *">
                      <input
                        type="text"
                        value={form.slug}
                        onChange={e => setForm(p => ({ ...p, slug: e.target.value }))}
                        placeholder="auto-generated-from-question"
                        required
                        className="input-field font-mono text-xs"
                      />
                    </FormField>

                    <FormField label="Short Description">
                      <textarea
                        value={form.short_description}
                        onChange={e => setForm(p => ({ ...p, short_description: e.target.value }))}
                        placeholder="One-line summary shown in cards and SEO description"
                        rows={2}
                        className="input-field resize-none"
                      />
                    </FormField>

                    <div className="grid grid-cols-2 gap-4">
                      <FormField label="Technology *">
                        <SelectField
                          value={form.technology}
                          onChange={v => setForm(p => ({ ...p, technology: v as InterviewQuestion["technology"] }))}
                          options={INTERVIEW_TECHNOLOGIES}
                        />
                      </FormField>
                      <FormField label="Question Type *">
                        <SelectField
                          value={form.question_type}
                          onChange={v => setForm(p => ({ ...p, question_type: v as InterviewQuestion["question_type"] }))}
                          options={INTERVIEW_QUESTION_TYPES}
                        />
                      </FormField>
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                      <FormField label="Experience Level *">
                        <SelectField
                          value={form.experience_level}
                          onChange={v => setForm(p => ({ ...p, experience_level: v as InterviewQuestion["experience_level"] }))}
                          options={INTERVIEW_EXPERIENCE_LEVELS}
                        />
                      </FormField>
                      <FormField label="Difficulty *">
                        <SelectField
                          value={form.difficulty}
                          onChange={v => setForm(p => ({ ...p, difficulty: v as InterviewQuestion["difficulty"] }))}
                          options={DIFFICULTIES}
                        />
                      </FormField>
                    </div>

                    <div className="flex items-center gap-6">
                      <Toggle label="Published" checked={form.published} onChange={v => setForm(p => ({ ...p, published: v }))} />
                      <Toggle label="Featured"  checked={form.featured}  onChange={v => setForm(p => ({ ...p, featured: v }))} />
                    </div>
                  </div>
                )}

                {/* ── Tab: Answer & Examples ── */}
                {activeTab === "content" && (
                  <div className="space-y-8">
                    <FormField label="Answer (Markdown supported)">
                      <BlogEditor
                        value={form.answer}
                        onChange={v => setForm(p => ({ ...p, answer: v }))}
                      />
                    </FormField>
                    <FormField label="Real-World Example">
                      <BlogEditor
                        value={form.real_world_example}
                        onChange={v => setForm(p => ({ ...p, real_world_example: v }))}
                      />
                    </FormField>
                    <FormField label="Best Practices">
                      <BlogEditor
                        value={form.best_practices}
                        onChange={v => setForm(p => ({ ...p, best_practices: v }))}
                      />
                    </FormField>
                    <FormField label="Common Mistakes">
                      <BlogEditor
                        value={form.common_mistakes}
                        onChange={v => setForm(p => ({ ...p, common_mistakes: v }))}
                      />
                    </FormField>
                  </div>
                )}

                {/* ── Tab: Code Snippet ── */}
                {activeTab === "code" && (
                  <div className="space-y-5">
                    <FormField label="Code Language">
                      <SelectField
                        value={form.code_language}
                        onChange={v => setForm(p => ({ ...p, code_language: v }))}
                        options={INTERVIEW_CODE_LANGUAGES}
                      />
                    </FormField>
                    <FormField label="Code Snippet">
                      <textarea
                        value={form.code_snippet}
                        onChange={e => setForm(p => ({ ...p, code_snippet: e.target.value }))}
                        placeholder={`// Paste your ${form.code_language} code example here\n// It will be displayed with syntax highlighting and a copy button`}
                        rows={16}
                        className="input-field resize-y font-mono text-xs leading-relaxed"
                        spellCheck={false}
                      />
                    </FormField>
                  </div>
                )}

                {/* ── Tab: Media & Tags ── */}
                {activeTab === "meta" && (
                  <div className="space-y-5">
                    <FormField label="YouTube Video">
                      {/* Mode toggle */}
                      <div className="flex gap-1 mb-2">
                        {(["url", "embed"] as const).map(mode => (
                          <button
                            key={mode}
                            type="button"
                            onClick={() => {
                              setYtMode(mode);
                              setEmbedRaw("");
                              setForm(p => ({ ...p, youtube_url: "" }));
                            }}
                            className={`px-3 py-1 rounded-md text-[11px] font-semibold transition-all border ${
                              ytMode === mode
                                ? "bg-[#00FF88]/15 text-[#00FF88] border-[#00FF88]/30"
                                : "text-[#6B7280] border-white/8 bg-transparent hover:text-[#9CA3AF]"
                            }`}
                          >
                            {mode === "url" ? "🔗 URL" : "</> Embed Code"}
                          </button>
                        ))}
                      </div>

                      {ytMode === "url" ? (
                        <input
                          type="text"
                          value={form.youtube_url}
                          onChange={e => setForm(p => ({ ...p, youtube_url: e.target.value }))}
                          placeholder="https://www.youtube.com/watch?v=..."
                          className="input-field"
                        />
                      ) : (
                        <textarea
                          rows={3}
                          value={embedRaw}
                          onChange={e => {
                            const raw = e.target.value;
                            setEmbedRaw(raw);
                            const id = extractYouTubeId(raw);
                            setForm(p => ({
                              ...p,
                              youtube_url: id ? `https://www.youtube.com/watch?v=${id}` : "",
                            }));
                          }}
                          placeholder='<iframe src="https://www.youtube.com/embed/VIDEO_ID" ...></iframe>'
                          className="input-field resize-none font-mono text-[11px]"
                        />
                      )}

                      {/* Parsed preview */}
                      {form.youtube_url && extractYouTubeId(form.youtube_url) ? (
                        <p className="text-[10px] text-[#00FF88] mt-1.5 flex items-center gap-1">
                          ✓ Video ID: <span className="font-mono">{extractYouTubeId(form.youtube_url)}</span>
                        </p>
                      ) : (ytMode === "embed" && embedRaw && !form.youtube_url) ? (
                        <p className="text-[10px] text-red-400 mt-1.5">Could not find a YouTube video ID in that embed code.</p>
                      ) : (
                        <p className="text-[10px] text-[#4B5563] mt-1.5">Optional — embeds a tutorial video on the question page.</p>
                      )}
                    </FormField>
                    <FormField label="Tags (comma-separated)">
                      <input
                        type="text"
                        value={form.tags}
                        onChange={e => setForm(p => ({ ...p, tags: e.target.value }))}
                        placeholder="selenium, implicit wait, explicit wait, FluentWait"
                        className="input-field"
                      />
                    </FormField>
                  </div>
                )}

                {/* Error */}
                {error && (
                  <div className="flex items-center gap-2 text-red-400 text-sm bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3">
                    <X size={14} className="flex-shrink-0" />
                    {error}
                  </div>
                )}

                {/* Actions */}
                <div className="flex items-center justify-between pt-2">
                  <div className="flex gap-2">
                    {TABS.map((tab, i) => (
                      <button
                        key={tab.id}
                        type="button"
                        onClick={() => setActiveTab(tab.id)}
                        className={`w-2 h-2 rounded-full transition-all ${
                          activeTab === tab.id ? "bg-[#00FF88]" : "bg-[#2A2A2A] hover:bg-[#4B5563]"
                        }`}
                      />
                    ))}
                  </div>
                  <div className="flex gap-3">
                    <button type="button" onClick={resetForm} className="px-5 py-2 rounded-xl border border-[#2A2A2A] text-[#9CA3AF] text-sm hover:border-white/20 hover:text-white transition-all">
                      Cancel
                    </button>
                    <button
                      type="submit"
                      disabled={saving}
                      className="btn-primary flex items-center gap-2 text-sm"
                    >
                      {saving ? <Loader2 size={14} className="animate-spin" /> : null}
                      {saving ? "Saving..." : editingId ? "Update Question" : "Create Question"}
                    </button>
                  </div>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

// ── Sub-components ─────────────────────────────────────────────────────────────

function FormField({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <label className="block text-xs font-semibold text-[#9CA3AF] mb-2 uppercase tracking-wide">{label}</label>
      {children}
    </div>
  );
}

function SelectField({ value, onChange, options }: { value: string; onChange: (v: string) => void; options: readonly string[] }) {
  return (
    <div className="relative">
      <select
        value={value}
        onChange={e => onChange(e.target.value)}
        className="w-full px-4 py-3 pr-9 bg-[#1A1A1A] border border-[#2A2A2A] rounded-xl text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all appearance-none"
      >
        {options.map(opt => <option key={opt} value={opt}>{opt}</option>)}
      </select>
      <ChevronDown size={14} className="absolute right-3 top-1/2 -translate-y-1/2 text-[#6B7280] pointer-events-none" />
    </div>
  );
}

function Toggle({ label, checked, onChange }: { label: string; checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <label className="flex items-center gap-2.5 cursor-pointer group select-none">
      <div
        onClick={() => onChange(!checked)}
        className={`w-10 h-5 rounded-full border transition-all ${
          checked ? "bg-[#00FF88]/20 border-[#00FF88]/40" : "bg-[#1A1A1A] border-[#2A2A2A]"
        } relative`}
      >
        <div className={`absolute top-0.5 w-4 h-4 rounded-full transition-all ${
          checked ? "left-[calc(100%-18px)] bg-[#00FF88]" : "left-0.5 bg-[#6B7280]"
        }`} />
      </div>
      <span className="text-sm text-[#9CA3AF] group-hover:text-white transition-colors">{label}</span>
    </label>
  );
}
