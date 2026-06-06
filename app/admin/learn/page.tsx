"use client";

import { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Plus, Trash2, Edit2, Eye, EyeOff, X, Loader2, Star, Upload, BookOpen } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { LearningContent, LEARN_CATEGORIES, DIFFICULTIES } from "@/types";
import { formatDate, slugify, calculateReadTime } from "@/lib/utils";

const EMPTY_FORM = {
  title: "", slug: "", excerpt: "", content: "", youtube_url: "",
  category: "Playwright" as LearningContent["category"],
  difficulty: "Beginner" as LearningContent["difficulty"],
  tags: "", featured: false, published: false,
};

export default function AdminLearnPage() {
  const [items, setItems] = useState<LearningContent[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [coverFile, setCoverFile] = useState<File | null>(null);
  const [coverPreview, setCoverPreview] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [tab, setTab] = useState<"editor" | "preview">("editor");
  const [search, setSearch] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);
  const supabase = createClient();

  const fetchItems = async () => {
    setLoading(true);
    const { data } = await supabase.from("learning_content").select("*").order("created_at", { ascending: false });
    setItems(data || []);
    setLoading(false);
  };

  useEffect(() => { fetchItems(); }, []);

  const handleTitleChange = (title: string) => {
    setForm((prev) => ({ ...prev, title, slug: editingId ? prev.slug : slugify(title) }));
  };

  const openEdit = (item: LearningContent) => {
    setEditingId(item.id);
    setForm({
      title: item.title, slug: item.slug, excerpt: item.excerpt, content: item.content,
      youtube_url: item.youtube_url || "", category: item.category, difficulty: item.difficulty,
      tags: item.tags?.join(", ") || "", featured: item.featured, published: item.published,
    });
    setCoverPreview(item.cover_image || null);
    setShowForm(true);
  };

  const resetForm = () => {
    setForm(EMPTY_FORM); setEditingId(null); setError(""); setShowForm(false);
    setCoverFile(null); setCoverPreview(null); setTab("editor");
  };

  const handleCoverChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) { setCoverFile(file); setCoverPreview(URL.createObjectURL(file)); }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.title || !form.slug) { setError("Title and slug are required"); return; }
    setSaving(true);
    setError("");

    try {
      let coverImageUrl = coverPreview;
      if (coverFile) {
        const ext = coverFile.name.split(".").pop();
        const filename = `learn/${Date.now()}.${ext}`;
        const { error: uploadError } = await supabase.storage.from("blogs").upload(filename, coverFile, { upsert: true });
        if (uploadError) throw uploadError;
        const { data: { publicUrl } } = supabase.storage.from("blogs").getPublicUrl(filename);
        coverImageUrl = publicUrl;
      }

      const payload = {
        title: form.title, slug: form.slug, excerpt: form.excerpt, content: form.content,
        cover_image: coverImageUrl || null, youtube_url: form.youtube_url || null,
        category: form.category, difficulty: form.difficulty,
        tags: form.tags.split(",").map((t) => t.trim()).filter(Boolean),
        featured: form.featured, published: form.published,
        read_time: calculateReadTime(form.content),
        updated_at: new Date().toISOString(),
      };

      if (editingId) {
        const { error: err } = await supabase.from("learning_content").update(payload).eq("id", editingId);
        if (err) throw err;
      } else {
        const { error: err } = await supabase.from("learning_content").insert({ ...payload, views: 0 });
        if (err) throw err;
      }

      await fetchItems();
      resetForm();
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Failed to save");
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Delete this tutorial?")) return;
    await supabase.from("learning_content").delete().eq("id", id);
    setItems((prev) => prev.filter((i) => i.id !== id));
  };

  const togglePublish = async (item: LearningContent) => {
    await supabase.from("learning_content").update({ published: !item.published }).eq("id", item.id);
    setItems((prev) => prev.map((i) => i.id === item.id ? { ...i, published: !i.published } : i));
  };

  const filtered = items.filter((i) =>
    !search || i.title.toLowerCase().includes(search.toLowerCase()) || i.category.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="p-6 max-w-6xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-black text-white flex items-center gap-2">
            <BookOpen size={20} className="text-[#00FF88]" /> Learn Management
          </h1>
          <p className="text-[#9CA3AF] text-sm mt-0.5">{items.length} tutorial{items.length !== 1 ? "s" : ""}</p>
        </div>
        <button onClick={() => setShowForm(true)} className="btn-primary gap-2 text-sm">
          <Plus size={16} /> New Tutorial
        </button>
      </div>

      {/* Search */}
      <input
        type="text" value={search} onChange={(e) => setSearch(e.target.value)}
        placeholder="Search tutorials..."
        className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all mb-6"
      />

      {/* List */}
      {loading ? (
        <div className="flex justify-center py-12"><Loader2 size={24} className="animate-spin text-[#00FF88]" /></div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-16 text-[#9CA3AF]">
          <BookOpen size={36} className="mx-auto mb-3 opacity-30" />
          <p>{search ? "No tutorials match your search" : "No tutorials yet. Create your first one!"}</p>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map((item) => (
            <motion.div key={item.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }}
              className="glass-card p-4 flex items-start gap-4">
              {item.cover_image && (
                <img src={item.cover_image} alt={item.title} className="w-20 h-14 object-cover rounded-lg flex-shrink-0" />
              )}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap mb-1">
                  <h3 className="text-white font-semibold text-sm truncate">{item.title}</h3>
                  {item.featured && <Star size={12} className="text-yellow-400 fill-yellow-400 flex-shrink-0" />}
                </div>
                <div className="flex items-center gap-2 text-xs text-[#9CA3AF] flex-wrap">
                  <span className="px-2 py-0.5 rounded-full bg-[#2A2A2A]">{item.category}</span>
                  <span className="px-2 py-0.5 rounded-full bg-[#2A2A2A]">{item.difficulty}</span>
                  <span>{formatDate(item.created_at)}</span>
                  <span>{item.views} views</span>
                  <span className={item.published ? "text-[#00FF88]" : "text-[#9CA3AF]"}>
                    {item.published ? "Published" : "Draft"}
                  </span>
                </div>
              </div>
              <div className="flex items-center gap-1 flex-shrink-0">
                <button onClick={() => togglePublish(item)} className="p-2 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-all" title={item.published ? "Unpublish" : "Publish"}>
                  {item.published ? <EyeOff size={14} /> : <Eye size={14} />}
                </button>
                <button onClick={() => openEdit(item)} className="p-2 rounded-lg text-[#9CA3AF] hover:text-[#00FF88] hover:bg-[#00FF88]/10 transition-all">
                  <Edit2 size={14} />
                </button>
                <button onClick={() => handleDelete(item.id)} className="p-2 rounded-lg text-[#9CA3AF] hover:text-red-400 hover:bg-red-500/10 transition-all">
                  <Trash2 size={14} />
                </button>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Form Modal */}
      <AnimatePresence>
        {showForm && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-start justify-center overflow-y-auto py-6 px-4">
            <motion.div initial={{ y: 30, opacity: 0 }} animate={{ y: 0, opacity: 1 }} exit={{ y: 30, opacity: 0 }}
              className="bg-[#111] border border-white/10 rounded-2xl w-full max-w-3xl">
              {/* Modal header */}
              <div className="flex items-center justify-between p-5 border-b border-white/5">
                <h2 className="text-lg font-black text-white">{editingId ? "Edit Tutorial" : "New Tutorial"}</h2>
                <button onClick={resetForm} className="p-2 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5"><X size={18} /></button>
              </div>

              <form onSubmit={handleSubmit} className="p-5 space-y-4">
                {/* Title */}
                <div>
                  <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Title *</label>
                  <input value={form.title} onChange={(e) => handleTitleChange(e.target.value)} required
                    placeholder="e.g. Getting Started with Playwright" className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all" />
                </div>

                {/* Slug */}
                <div>
                  <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Slug *</label>
                  <input value={form.slug} onChange={(e) => setForm((p) => ({ ...p, slug: e.target.value }))} required
                    placeholder="getting-started-playwright" className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm font-mono focus:outline-none focus:border-[#00FF88]/40 transition-all" />
                </div>

                {/* Category + Difficulty */}
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Category</label>
                    <select value={form.category} onChange={(e) => setForm((p) => ({ ...p, category: e.target.value as LearningContent["category"] }))}
                      className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all">
                      {LEARN_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Difficulty</label>
                    <select value={form.difficulty} onChange={(e) => setForm((p) => ({ ...p, difficulty: e.target.value as LearningContent["difficulty"] }))}
                      className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all">
                      {DIFFICULTIES.map((d) => <option key={d} value={d}>{d}</option>)}
                    </select>
                  </div>
                </div>

                {/* YouTube URL */}
                <div>
                  <label className="block text-xs font-medium text-[#9CA3AF] mb-1">YouTube URL (optional)</label>
                  <input value={form.youtube_url} onChange={(e) => setForm((p) => ({ ...p, youtube_url: e.target.value }))}
                    placeholder="https://youtube.com/watch?v=..." className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all" />
                </div>

                {/* Cover Image */}
                <div>
                  <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Cover Image</label>
                  <div className="flex items-center gap-3">
                    <button type="button" onClick={() => fileRef.current?.click()}
                      className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-[#9CA3AF] hover:text-white text-sm transition-all">
                      <Upload size={14} /> Upload Image
                    </button>
                    {coverPreview && <img src={coverPreview} alt="Preview" className="h-10 w-16 object-cover rounded-lg" />}
                    {coverPreview && <button type="button" onClick={() => { setCoverFile(null); setCoverPreview(null); }} className="text-red-400 hover:text-red-300"><X size={14} /></button>}
                  </div>
                  <input ref={fileRef} type="file" accept="image/*" onChange={handleCoverChange} className="hidden" />
                </div>

                {/* Excerpt */}
                <div>
                  <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Excerpt</label>
                  <textarea value={form.excerpt} onChange={(e) => setForm((p) => ({ ...p, excerpt: e.target.value }))}
                    rows={2} placeholder="Brief description..." className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all resize-none" />
                </div>

                {/* Content */}
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <label className="text-xs font-medium text-[#9CA3AF]">Content (Markdown)</label>
                    <div className="flex gap-1 ml-auto">
                      {(["editor", "preview"] as const).map((t) => (
                        <button key={t} type="button" onClick={() => setTab(t)}
                          className={`px-3 py-1 rounded-lg text-xs font-medium transition-all ${tab === t ? "bg-[#00FF88] text-black" : "text-[#9CA3AF] hover:text-white"}`}>
                          {t.charAt(0).toUpperCase() + t.slice(1)}
                        </button>
                      ))}
                    </div>
                  </div>
                  {tab === "editor" ? (
                    <textarea value={form.content} onChange={(e) => setForm((p) => ({ ...p, content: e.target.value }))}
                      rows={12} placeholder="# Tutorial Title&#10;&#10;Write your tutorial in Markdown..." className="w-full px-4 py-3 rounded-xl bg-[#0D0D0D] border border-[#2A2A2A] text-white placeholder-[#9CA3AF] text-sm font-mono focus:outline-none focus:border-[#00FF88]/40 transition-all resize-none" />
                  ) : (
                    <div className="w-full min-h-48 px-4 py-3 rounded-xl bg-[#0D0D0D] border border-[#2A2A2A] text-[#D1D5DB] text-sm prose prose-invert max-w-none overflow-auto">
                      <pre className="whitespace-pre-wrap text-xs">{form.content || "Nothing to preview"}</pre>
                    </div>
                  )}
                </div>

                {/* Tags */}
                <div>
                  <label className="block text-xs font-medium text-[#9CA3AF] mb-1">Tags (comma-separated)</label>
                  <input value={form.tags} onChange={(e) => setForm((p) => ({ ...p, tags: e.target.value }))}
                    placeholder="playwright, automation, testing" className="w-full px-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all" />
                </div>

                {/* Toggles */}
                <div className="flex items-center gap-6">
                  {([["featured", "⭐ Featured"], ["published", "✅ Published"]] as const).map(([key, label]) => (
                    <label key={key} className="flex items-center gap-2 cursor-pointer select-none">
                      <div
                        onClick={() => setForm((p) => ({ ...p, [key]: !p[key] }))}
                        className={`w-10 h-5 rounded-full transition-colors ${form[key] ? "bg-[#00FF88]" : "bg-[#2A2A2A]"} relative`}
                      >
                        <div className={`absolute top-0.5 w-4 h-4 rounded-full bg-white transition-transform ${form[key] ? "translate-x-5" : "translate-x-0.5"}`} />
                      </div>
                      <span className="text-sm text-[#9CA3AF]">{label}</span>
                    </label>
                  ))}
                </div>

                {error && <p className="text-red-400 text-sm">{error}</p>}

                <div className="flex gap-3 pt-2">
                  <button type="button" onClick={resetForm} className="btn-outline flex-1 justify-center">Cancel</button>
                  <button type="submit" disabled={saving} className="btn-primary flex-1 justify-center gap-2">
                    {saving ? <><Loader2 size={14} className="animate-spin" /> Saving...</> : (editingId ? "Update Tutorial" : "Create Tutorial")}
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
