"use client";

import { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Plus, Trash2, Edit2, Eye, EyeOff, Upload, X, Loader2, Star } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Meme, MEME_CATEGORIES } from "@/types";
import { formatDate } from "@/lib/utils";

const EMPTY_FORM = {
  title: "", caption: "", category: "Corporate" as Meme["category"], tags: "",
  featured: false, published: true, seo_title: "", seo_description: "",
};

export default function AdminMemesPage() {
  const [memes, setMemes] = useState<Meme[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);
  const supabase = createClient();

  const fetchMemes = async () => {
    setLoading(true);
    const { data } = await supabase.from("memes").select("*").order("created_at", { ascending: false }).limit(200);
    setMemes(data || []);
    setLoading(false);
  };

  useEffect(() => { fetchMemes(); }, []);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setImageFile(file);
      setImagePreview(URL.createObjectURL(file));
    }
  };

  const openEdit = (meme: Meme) => {
    setEditingId(meme.id);
    setForm({ title: meme.title, caption: meme.caption, category: meme.category, tags: meme.tags?.join(", ") || "", featured: meme.featured, published: meme.published, seo_title: meme.seo_title || "", seo_description: meme.seo_description || "" });
    setImagePreview(meme.image_url);
    setShowForm(true);
  };

  const resetForm = () => {
    setForm(EMPTY_FORM);
    setImageFile(null);
    setImagePreview(null);
    setEditingId(null);
    setError("");
    setShowForm(false);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.title) { setError("Title is required"); return; }
    setSaving(true);
    setError("");

    try {
      let imageUrl = imagePreview;

      if (imageFile) {
        const ext = imageFile.name.split(".").pop()?.toLowerCase() || "";
        const allowed = ["jpg", "jpeg", "png", "webp", "gif", "avif"];
        if (!allowed.includes(ext)) { setError("Only image files are allowed (JPG, PNG, WebP, GIF)"); setSaving(false); return; }
        const filename = `${Date.now()}.${ext}`;
        const { data: uploadData, error: uploadError } = await supabase.storage.from("memes").upload(filename, imageFile, { upsert: true });
        if (uploadError) throw uploadError;
        const { data: { publicUrl } } = supabase.storage.from("memes").getPublicUrl(filename);
        imageUrl = publicUrl;
      }

      const payload = {
        title: form.title,
        caption: form.caption,
        category: form.category,
        tags: form.tags.split(",").map((t) => t.trim()).filter(Boolean),
        featured: form.featured,
        published: form.published,
        seo_title: form.seo_title || null,
        seo_description: form.seo_description || null,
        image_url: imageUrl || null,
      };

      if (editingId) {
        await supabase.from("memes").update(payload).eq("id", editingId);
      } else {
        await supabase.from("memes").insert(payload);
      }

      resetForm();
      fetchMemes();
    } catch {
      setError("Failed to save meme. Please try again.");
    } finally {
      setSaving(false);
    }
  };

  const togglePublished = async (meme: Meme) => {
    await supabase.from("memes").update({ published: !meme.published }).eq("id", meme.id);
    fetchMemes();
  };

  const toggleFeatured = async (meme: Meme) => {
    await supabase.from("memes").update({ featured: !meme.featured }).eq("id", meme.id);
    fetchMemes();
  };

  const deleteMeme = async (id: string) => {
    if (!confirm("Delete this meme?")) return;
    await supabase.from("memes").delete().eq("id", id);
    fetchMemes();
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-black text-white">Memes</h1>
          <p className="text-[#9CA3AF] text-sm mt-1">{memes.length} total memes</p>
        </div>
        <button onClick={() => setShowForm(true)} className="btn-primary">
          <Plus size={16} /> Upload Meme
        </button>
      </div>

      {/* Upload Form Modal */}
      <AnimatePresence>
        {showForm && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-start justify-center p-4 overflow-y-auto">
            <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95 }} className="bg-[#111] border border-white/10 rounded-2xl w-full max-w-2xl my-8">
              <div className="flex items-center justify-between p-6 border-b border-white/5">
                <h2 className="text-lg font-bold text-white">{editingId ? "Edit Meme" : "Upload Meme"}</h2>
                <button onClick={resetForm} className="p-2 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5"><X size={16} /></button>
              </div>

              <form onSubmit={handleSubmit} className="p-6 space-y-4">
                {/* Image upload */}
                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Meme Image</label>
                  <div
                    onClick={() => fileRef.current?.click()}
                    className="border-2 border-dashed border-[#2A2A2A] rounded-xl p-6 text-center cursor-pointer hover:border-[#00FF88]/40 transition-colors"
                  >
                    {imagePreview ? (
                      <div className="relative">
                        <img src={imagePreview} alt="Preview" className="max-h-48 mx-auto rounded-lg object-contain" />
                        <button type="button" onClick={(e) => { e.stopPropagation(); setImageFile(null); setImagePreview(null); }} className="absolute top-0 right-0 w-6 h-6 rounded-full bg-red-500 flex items-center justify-center"><X size={12} /></button>
                      </div>
                    ) : (
                      <div>
                        <Upload size={24} className="text-[#9CA3AF] mx-auto mb-2" />
                        <p className="text-sm text-[#9CA3AF]">Click to upload image</p>
                        <p className="text-xs text-[#9CA3AF]/60 mt-1">PNG, JPG, GIF, WEBP</p>
                      </div>
                    )}
                    <input ref={fileRef} type="file" accept="image/*" className="hidden" onChange={handleFileChange} />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Title *</label>
                    <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} placeholder="Meme title" className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50" required />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Category</label>
                    <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value as Meme["category"] })} className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50">
                      {MEME_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Caption</label>
                  <textarea value={form.caption} onChange={(e) => setForm({ ...form, caption: e.target.value })} rows={3} placeholder="Caption text..." className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50 resize-none" />
                </div>

                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Tags (comma-separated)</label>
                  <input value={form.tags} onChange={(e) => setForm({ ...form, tags: e.target.value })} placeholder="qa, bugs, playwright" className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50" />
                </div>

                <div className="flex items-center gap-6">
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input type="checkbox" checked={form.published} onChange={(e) => setForm({ ...form, published: e.target.checked })} className="w-4 h-4 accent-[#00FF88]" />
                    <span className="text-sm text-white">Published</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input type="checkbox" checked={form.featured} onChange={(e) => setForm({ ...form, featured: e.target.checked })} className="w-4 h-4 accent-[#00FF88]" />
                    <span className="text-sm text-white">Featured on Homepage</span>
                  </label>
                </div>

                {error && <p className="text-red-400 text-sm">{error}</p>}

                <div className="flex gap-3 pt-2">
                  <button type="submit" disabled={saving} className="btn-primary flex-1 justify-center">
                    {saving ? <Loader2 size={16} className="animate-spin" /> : (editingId ? "Update Meme" : "Upload Meme")}
                  </button>
                  <button type="button" onClick={resetForm} className="btn-outline px-6">Cancel</button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Memes table */}
      {loading ? (
        <div className="space-y-3">
          {Array.from({ length: 5 }).map((_, i) => <div key={i} className="skeleton h-16 rounded-xl" />)}
        </div>
      ) : memes.length === 0 ? (
        <div className="glass-card p-16 text-center">
          <div className="text-5xl mb-4">😅</div>
          <h3 className="text-lg font-bold text-white mb-2">No memes yet</h3>
          <p className="text-[#9CA3AF] mb-6">Upload your first QA meme to get started</p>
          <button onClick={() => setShowForm(true)} className="btn-primary inline-flex"><Plus size={16} /> Upload Meme</button>
        </div>
      ) : (
        <div className="glass-card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Meme</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden sm:table-cell">Category</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden md:table-cell">Date</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Status</th>
                  <th className="text-right px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {memes.map((meme) => (
                  <tr key={meme.id} className="hover:bg-white/2 transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        {meme.image_url && <img src={meme.image_url} alt="" className="w-10 h-10 rounded-lg object-cover flex-shrink-0" />}
                        <div className="min-w-0">
                          <p className="text-sm font-medium text-white truncate max-w-[200px]">{meme.title}</p>
                          {meme.caption && <p className="text-xs text-[#9CA3AF] truncate max-w-[200px]">{meme.caption}</p>}
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3 hidden sm:table-cell">
                      <span className="text-xs text-[#9CA3AF]">{meme.category}</span>
                    </td>
                    <td className="px-4 py-3 hidden md:table-cell">
                      <span className="text-xs text-[#9CA3AF]">{formatDate(meme.created_at)}</span>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${meme.published ? "bg-green-500/20 text-green-400" : "bg-[#2A2A2A] text-[#9CA3AF]"}`}>{meme.published ? "Live" : "Draft"}</span>
                        {meme.featured && <span className="text-xs px-2 py-0.5 rounded-full font-medium bg-[#00FF88]/20 text-[#00FF88]">Featured</span>}
                      </div>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={() => toggleFeatured(meme)} title="Toggle Featured" className={`p-1.5 rounded-lg transition-colors ${meme.featured ? "text-[#00FF88] bg-[#00FF88]/10" : "text-[#9CA3AF] hover:text-[#00FF88] hover:bg-[#00FF88]/10"}`}><Star size={14} /></button>
                        <button onClick={() => togglePublished(meme)} title="Toggle Published" className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors">{meme.published ? <EyeOff size={14} /> : <Eye size={14} />}</button>
                        <button onClick={() => openEdit(meme)} className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors"><Edit2 size={14} /></button>
                        <button onClick={() => deleteMeme(meme.id)} className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-red-400 hover:bg-red-500/10 transition-colors"><Trash2 size={14} /></button>
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
