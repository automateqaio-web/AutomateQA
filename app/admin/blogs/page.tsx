"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Plus, Trash2, Edit2, Eye, EyeOff, X, Loader2, Star, Upload } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Blog, BLOG_CATEGORIES } from "@/types";
import { formatDate, slugify, calculateReadTime } from "@/lib/utils";
import BlogEditor from "@/components/admin/BlogEditor";
import { fixEmojiBullets } from "@/lib/formatTipContent";

const EMPTY_FORM = {
  title: "", slug: "", excerpt: "", content: "",
  category: "Automation Testing" as Blog["category"],
  tags: "", featured: false, published: false,
};

export default function AdminBlogsPage() {
  const [blogs, setBlogs] = useState<Blog[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [coverFile, setCoverFile] = useState<File | null>(null);
  const [coverPreview, setCoverPreview] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);
  const supabase = useRef(createClient()).current;

  const fetchBlogs = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase.from("blogs").select("*").order("created_at", { ascending: false }).limit(200);
    setBlogs(data || []);
    setLoading(false);
  }, [supabase]);

  useEffect(() => { fetchBlogs(); }, [fetchBlogs]);

  const handleTitleChange = (title: string) => {
    setForm((prev) => ({ ...prev, title, slug: editingId ? prev.slug : slugify(title) }));
  };

  const openEdit = (blog: Blog) => {
    setEditingId(blog.id);
    setForm({
      title: blog.title, slug: blog.slug, excerpt: blog.excerpt,
      content: blog.content, category: blog.category,
      tags: blog.tags?.join(", ") || "", featured: blog.featured, published: blog.published,
    });
    setCoverPreview(blog.cover_image || null);
    setShowForm(true);
  };

  const resetForm = () => {
    setForm(EMPTY_FORM); setEditingId(null); setError("");
    setShowForm(false); setCoverFile(null); setCoverPreview(null);
  };

  const handleCoverChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) { setCoverFile(file); setCoverPreview(URL.createObjectURL(file)); }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.title || !form.slug) { setError("Title and slug are required"); return; }
    setSaving(true); setError("");
    try {
      let coverImageUrl = coverPreview;
      if (coverFile) {
        const ext = coverFile.name.split(".").pop()?.toLowerCase() || "";
        const allowed = ["jpg", "jpeg", "png", "webp", "gif", "avif"];
        if (!allowed.includes(ext)) { setError("Only image files are allowed (JPG, PNG, WebP, GIF)"); setSaving(false); return; }
        const filename = `covers/${Date.now()}.${ext}`;
        const { error: uploadError } = await supabase.storage.from("blogs").upload(filename, coverFile, { upsert: true });
        if (uploadError) throw uploadError;
        const { data: { publicUrl } } = supabase.storage.from("blogs").getPublicUrl(filename);
        coverImageUrl = publicUrl;
      }
      const payload = {
        title: form.title, slug: form.slug, excerpt: form.excerpt, content: form.content,
        cover_image: coverImageUrl || null, category: form.category,
        tags: form.tags.split(",").map((t) => t.trim()).filter(Boolean),
        featured: form.featured, published: form.published,
        read_time: calculateReadTime(form.content),
      };
      if (editingId) {
        await supabase.from("blogs").update(payload).eq("id", editingId);
      } else {
        await supabase.from("blogs").insert(payload);
      }
      resetForm(); fetchBlogs();
    } catch {
      setError("Failed to save blog post. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  const togglePublished = async (b: Blog) => { await supabase.from("blogs").update({ published: !b.published }).eq("id", b.id); fetchBlogs(); };
  const toggleFeatured  = async (b: Blog) => { await supabase.from("blogs").update({ featured: !b.featured }).eq("id", b.id); fetchBlogs(); };
  const deleteBlog      = async (id: string) => { if (!confirm("Delete this blog post?")) return; await supabase.from("blogs").delete().eq("id", id); fetchBlogs(); };

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-black text-white">Blog Posts</h1>
          <p className="text-[#9CA3AF] text-sm mt-1">{blogs.length} total posts</p>
        </div>
        <button onClick={() => setShowForm(true)} className="btn-primary">
          <Plus size={16} /> Write Blog
        </button>
      </div>

      {/* ── Blog form modal ── */}
      <AnimatePresence>
        {showForm && (
          <motion.div
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-black/85 backdrop-blur-sm flex items-start justify-center p-4 overflow-y-auto">
            <motion.div
              initial={{ opacity: 0, scale: 0.96, y: 24 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.96 }}
              transition={{ type: "spring", stiffness: 350, damping: 28 }}
              className="bg-[#0D0D0D] border border-white/8 rounded-3xl w-full max-w-6xl my-8 overflow-hidden shadow-2xl">

              {/* Modal header */}
              <div className="flex items-center justify-between px-8 py-5 border-b border-white/5 bg-[#111]">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-[#00FF88]/10 border border-[#00FF88]/20 flex items-center justify-center">
                    <Edit2 size={15} className="text-[#00FF88]" />
                  </div>
                  <h2 className="text-base font-bold text-white">
                    {editingId ? "Edit Blog Post" : "Write New Blog Post"}
                  </h2>
                </div>
                <button onClick={resetForm} className="p-2 rounded-xl text-[#5A5A5A] hover:text-white hover:bg-white/5 transition-all">
                  <X size={18} />
                </button>
              </div>

              <form onSubmit={handleSubmit} className="p-8 space-y-6">

                {/* Cover image */}
                <div>
                  <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Cover Image</label>
                  <div onClick={() => fileRef.current?.click()}
                    className="border-2 border-dashed border-[#2A2A2A] rounded-2xl cursor-pointer hover:border-[#00FF88]/30 transition-all overflow-hidden group">
                    {coverPreview ? (
                      <div className="relative h-44">
                        <img src={coverPreview} alt="" className="w-full h-full object-cover" />
                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                          <span className="text-white text-sm font-medium">Change Image</span>
                        </div>
                        <button type="button" onClick={(e) => { e.stopPropagation(); setCoverFile(null); setCoverPreview(null); }}
                          className="absolute top-2 right-2 w-6 h-6 rounded-full bg-red-500 hover:bg-red-400 flex items-center justify-center transition-colors">
                          <X size={12} />
                        </button>
                      </div>
                    ) : (
                      <div className="p-8 text-center">
                        <Upload size={24} className="text-[#3A3A3A] mx-auto mb-2" />
                        <p className="text-sm text-[#5A5A5A]">Click to upload cover image</p>
                        <p className="text-xs text-[#3A3A3A] mt-1">PNG, JPG, WebP · Recommended 1200×630</p>
                      </div>
                    )}
                  </div>
                  <input ref={fileRef} type="file" accept="image/*" className="hidden" onChange={handleCoverChange} />
                </div>

                {/* Title + Slug + Category */}
                <div className="grid grid-cols-1 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Title *</label>
                    <input
                      value={form.title} onChange={(e) => handleTitleChange(e.target.value)}
                      placeholder="Write an engaging blog post title…"
                      className="w-full px-4 py-3 rounded-xl bg-[#141414] border border-[#2A2A2A] text-white text-base focus:outline-none focus:border-[#00FF88]/40 transition-all placeholder-[#3A3A3A] font-semibold"
                      required />
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Slug *</label>
                      <input
                        value={form.slug} onChange={(e) => setForm({ ...form, slug: e.target.value })}
                        placeholder="url-slug"
                        className="w-full px-4 py-2.5 rounded-xl bg-[#141414] border border-[#2A2A2A] text-[#00FF88] text-sm focus:outline-none focus:border-[#00FF88]/40 font-mono transition-all placeholder-[#3A3A3A]"
                        required />
                    </div>
                    <div>
                      <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Category</label>
                      <select
                        value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value as Blog["category"] })}
                        className="w-full px-4 py-2.5 rounded-xl bg-[#141414] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 transition-all">
                        {BLOG_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                      </select>
                    </div>
                  </div>
                </div>

                {/* Excerpt */}
                <div>
                  <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Excerpt</label>
                  <textarea
                    value={form.excerpt} onChange={(e) => setForm({ ...form, excerpt: e.target.value })}
                    rows={2} placeholder="A brief summary shown in blog listings and SEO descriptions…"
                    className="w-full px-4 py-2.5 rounded-xl bg-[#141414] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 resize-none placeholder-[#3A3A3A] transition-all" />
                </div>

                {/* Rich markdown editor */}
                <div>
                  <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Content</label>
                  <BlogEditor value={form.content} onChange={(v) => setForm({ ...form, content: v })} contentPreprocessor={fixEmojiBullets} />
                </div>

                {/* Tags */}
                <div>
                  <label className="block text-xs font-semibold text-[#9CA3AF] uppercase tracking-wider mb-2">Tags</label>
                  <input
                    value={form.tags} onChange={(e) => setForm({ ...form, tags: e.target.value })}
                    placeholder="playwright, tutorial, automation, testing"
                    className="w-full px-4 py-2.5 rounded-xl bg-[#141414] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/40 placeholder-[#3A3A3A] transition-all" />
                  <p className="text-xs text-[#3A3A3A] mt-1.5">Comma-separated tags</p>
                </div>

                {/* Toggles */}
                <div className="flex items-center gap-6 py-2">
                  <label className="flex items-center gap-2.5 cursor-pointer group">
                    <input type="checkbox" checked={form.published} onChange={(e) => setForm({ ...form, published: e.target.checked })}
                      className="w-4 h-4 accent-[#00FF88] rounded" />
                    <span className="text-sm text-white group-hover:text-[#00FF88] transition-colors">Published</span>
                  </label>
                  <label className="flex items-center gap-2.5 cursor-pointer group">
                    <input type="checkbox" checked={form.featured} onChange={(e) => setForm({ ...form, featured: e.target.checked })}
                      className="w-4 h-4 accent-[#00FF88] rounded" />
                    <span className="text-sm text-white group-hover:text-[#00FF88] transition-colors">Featured on Homepage</span>
                  </label>
                </div>

                {error && (
                  <div className="bg-red-500/10 border border-red-500/20 rounded-xl px-4 py-3 text-red-400 text-sm">
                    {error}
                  </div>
                )}

                <div className="flex gap-3 pt-2">
                  <button type="submit" disabled={saving}
                    className="btn-primary flex-1 justify-center py-3 text-sm font-semibold">
                    {saving ? <Loader2 size={16} className="animate-spin" /> : (editingId ? "Update Post" : "Publish Post")}
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

      {/* Blog list */}
      {loading ? (
        <div className="space-y-3">
          {Array.from({ length: 4 }).map((_, i) => <div key={i} className="skeleton h-16 rounded-xl" />)}
        </div>
      ) : blogs.length === 0 ? (
        <div className="glass-card p-16 text-center">
          <div className="text-5xl mb-4">✍️</div>
          <h3 className="text-lg font-bold text-white mb-2">No blog posts yet</h3>
          <p className="text-[#9CA3AF] mb-6">Write your first automation tutorial</p>
          <button onClick={() => setShowForm(true)} className="btn-primary inline-flex">
            <Plus size={16} /> Write Blog
          </button>
        </div>
      ) : (
        <div className="glass-card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Post</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden sm:table-cell">Category</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden md:table-cell">Date</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Status</th>
                  <th className="text-right px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {blogs.map((blog) => (
                  <tr key={blog.id} className="hover:bg-white/[0.02] transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        {blog.cover_image && (
                          <img src={blog.cover_image} alt="" className="w-14 h-9 rounded-lg object-cover flex-shrink-0" />
                        )}
                        <div className="min-w-0">
                          <p className="text-sm font-medium text-white truncate max-w-[250px]">{blog.title}</p>
                          <p className="text-xs text-[#9CA3AF] font-mono">/{blog.slug}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3 hidden sm:table-cell">
                      <span className="text-xs text-[#9CA3AF]">{blog.category}</span>
                    </td>
                    <td className="px-4 py-3 hidden md:table-cell">
                      <span className="text-xs text-[#9CA3AF]">{formatDate(blog.created_at)}</span>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${blog.published ? "bg-green-500/20 text-green-400" : "bg-yellow-500/20 text-yellow-400"}`}>
                          {blog.published ? "Live" : "Draft"}
                        </span>
                        {blog.featured && (
                          <span className="text-xs px-2 py-0.5 rounded-full font-medium bg-[#00FF88]/20 text-[#00FF88]">Featured</span>
                        )}
                      </div>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={() => toggleFeatured(blog)}
                          className={`p-1.5 rounded-lg transition-colors ${blog.featured ? "text-[#00FF88] bg-[#00FF88]/10" : "text-[#9CA3AF] hover:text-[#00FF88] hover:bg-[#00FF88]/10"}`}>
                          <Star size={14} />
                        </button>
                        <button onClick={() => togglePublished(blog)}
                          className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors">
                          {blog.published ? <EyeOff size={14} /> : <Eye size={14} />}
                        </button>
                        <button onClick={() => openEdit(blog)}
                          className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors">
                          <Edit2 size={14} />
                        </button>
                        <button onClick={() => deleteBlog(blog.id)}
                          className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-red-400 hover:bg-red-500/10 transition-colors">
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
