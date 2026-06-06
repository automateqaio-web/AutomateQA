"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Plus, Trash2, Edit2, Eye, EyeOff, X, Loader2, Star, Link2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Video, VIDEO_CATEGORIES } from "@/types";
import { extractYouTubeId, getYouTubeThumbnail, formatDate } from "@/lib/utils";

const EMPTY_FORM = {
  youtube_url: "", title: "", description: "", category: "QA Memes" as Video["category"],
  tags: "", featured: false, published: true,
};

export default function AdminVideosPage() {
  const [videos, setVideos] = useState<Video[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const supabase = createClient();

  const fetchVideos = async () => {
    setLoading(true);
    const { data } = await supabase.from("videos").select("*").order("created_at", { ascending: false });
    setVideos(data || []);
    setLoading(false);
  };

  useEffect(() => { fetchVideos(); }, []);

  const handleYoutubeUrlChange = (url: string) => {
    setForm((prev) => ({ ...prev, youtube_url: url }));
  };

  const openEdit = (video: Video) => {
    setEditingId(video.id);
    setForm({ youtube_url: video.youtube_url, title: video.title, description: video.description, category: video.category, tags: video.tags?.join(", ") || "", featured: video.featured, published: video.published });
    setShowForm(true);
  };

  const resetForm = () => { setForm(EMPTY_FORM); setEditingId(null); setError(""); setShowForm(false); };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.title || !form.youtube_url) { setError("Title and YouTube URL are required"); return; }
    const youtubeId = extractYouTubeId(form.youtube_url);
    if (!youtubeId) { setError("Invalid YouTube URL"); return; }
    setSaving(true);
    setError("");

    try {
      const payload = {
        youtube_url: form.youtube_url,
        youtube_id: youtubeId,
        title: form.title,
        description: form.description,
        thumbnail: getYouTubeThumbnail(youtubeId, "hq"),
        category: form.category,
        tags: form.tags.split(",").map((t) => t.trim()).filter(Boolean),
        featured: form.featured,
        published: form.published,
      };

      if (editingId) {
        await supabase.from("videos").update(payload).eq("id", editingId);
      } else {
        await supabase.from("videos").insert(payload);
      }

      resetForm();
      fetchVideos();
    } catch (err: any) {
      setError(err.message || "Failed to save");
    } finally {
      setSaving(false);
    }
  };

  const togglePublished = async (v: Video) => { await supabase.from("videos").update({ published: !v.published }).eq("id", v.id); fetchVideos(); };
  const toggleFeatured = async (v: Video) => { await supabase.from("videos").update({ featured: !v.featured }).eq("id", v.id); fetchVideos(); };
  const deleteVideo = async (id: string) => { if (!confirm("Delete this video?")) return; await supabase.from("videos").delete().eq("id", id); fetchVideos(); };

  const youtubeId = extractYouTubeId(form.youtube_url);

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-black text-white">Videos</h1>
          <p className="text-[#9CA3AF] text-sm mt-1">{videos.length} total videos</p>
        </div>
        <button onClick={() => setShowForm(true)} className="btn-primary"><Plus size={16} /> Add Video</button>
      </div>

      <AnimatePresence>
        {showForm && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-start justify-center p-4 overflow-y-auto">
            <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95 }} className="bg-[#111] border border-white/10 rounded-2xl w-full max-w-2xl my-8">
              <div className="flex items-center justify-between p-6 border-b border-white/5">
                <h2 className="text-lg font-bold text-white">{editingId ? "Edit Video" : "Add YouTube Video"}</h2>
                <button onClick={resetForm} className="p-2 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5"><X size={16} /></button>
              </div>

              <form onSubmit={handleSubmit} className="p-6 space-y-4">
                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">YouTube URL *</label>
                  <div className="relative">
                    <Link2 size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#9CA3AF]" />
                    <input value={form.youtube_url} onChange={(e) => handleYoutubeUrlChange(e.target.value)} placeholder="https://youtube.com/watch?v=..." className="w-full pl-9 pr-4 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50" required />
                  </div>
                </div>

                {youtubeId && (
                  <div className="flex gap-3 p-3 bg-[#0D0D0D] rounded-xl border border-[#2A2A2A]">
                    <img src={getYouTubeThumbnail(youtubeId)} alt="Preview" className="w-24 h-16 object-cover rounded-lg" />
                    <div>
                      <p className="text-xs text-[#00FF88] font-semibold">✓ Valid YouTube ID: {youtubeId}</p>
                      <p className="text-xs text-[#9CA3AF] mt-1">Thumbnail auto-generated</p>
                    </div>
                  </div>
                )}

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Title *</label>
                    <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} placeholder="Video title" className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50" required />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Category</label>
                    <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value as Video["category"] })} className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50">
                      {VIDEO_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Description</label>
                  <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={3} className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50 resize-none" />
                </div>

                <div>
                  <label className="block text-sm font-medium text-[#9CA3AF] mb-2">Tags (comma-separated)</label>
                  <input value={form.tags} onChange={(e) => setForm({ ...form, tags: e.target.value })} placeholder="playwright, testing, tutorial" className="w-full px-3 py-2.5 rounded-xl bg-[#1A1A1A] border border-[#2A2A2A] text-white text-sm focus:outline-none focus:border-[#00FF88]/50" />
                </div>

                <div className="flex items-center gap-6">
                  <label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={form.published} onChange={(e) => setForm({ ...form, published: e.target.checked })} className="w-4 h-4 accent-[#00FF88]" /><span className="text-sm text-white">Published</span></label>
                  <label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={form.featured} onChange={(e) => setForm({ ...form, featured: e.target.checked })} className="w-4 h-4 accent-[#00FF88]" /><span className="text-sm text-white">Featured on Homepage</span></label>
                </div>

                {error && <p className="text-red-400 text-sm">{error}</p>}
                <div className="flex gap-3 pt-2">
                  <button type="submit" disabled={saving} className="btn-primary flex-1 justify-center">{saving ? <Loader2 size={16} className="animate-spin" /> : (editingId ? "Update" : "Add Video")}</button>
                  <button type="button" onClick={resetForm} className="btn-outline px-6">Cancel</button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {loading ? (
        <div className="space-y-3">{Array.from({ length: 4 }).map((_, i) => <div key={i} className="skeleton h-16 rounded-xl" />)}</div>
      ) : videos.length === 0 ? (
        <div className="glass-card p-16 text-center">
          <div className="text-5xl mb-4">🎬</div>
          <h3 className="text-lg font-bold text-white mb-2">No videos yet</h3>
          <p className="text-[#9CA3AF] mb-6">Add your first YouTube video</p>
          <button onClick={() => setShowForm(true)} className="btn-primary inline-flex"><Plus size={16} /> Add Video</button>
        </div>
      ) : (
        <div className="glass-card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-white/5">
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Video</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden sm:table-cell">Category</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase hidden md:table-cell">Date</th>
                  <th className="text-left px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Status</th>
                  <th className="text-right px-4 py-3 text-xs font-semibold text-[#9CA3AF] uppercase">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {videos.map((video) => (
                  <tr key={video.id} className="hover:bg-white/2 transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        <img src={video.thumbnail || getYouTubeThumbnail(video.youtube_id)} alt="" className="w-16 h-10 rounded-lg object-cover flex-shrink-0" />
                        <p className="text-sm font-medium text-white truncate max-w-[200px]">{video.title}</p>
                      </div>
                    </td>
                    <td className="px-4 py-3 hidden sm:table-cell"><span className="text-xs text-[#9CA3AF]">{video.category}</span></td>
                    <td className="px-4 py-3 hidden md:table-cell"><span className="text-xs text-[#9CA3AF]">{formatDate(video.created_at)}</span></td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${video.published ? "bg-green-500/20 text-green-400" : "bg-[#2A2A2A] text-[#9CA3AF]"}`}>{video.published ? "Live" : "Draft"}</span>
                        {video.featured && <span className="text-xs px-2 py-0.5 rounded-full font-medium bg-[#00FF88]/20 text-[#00FF88]">Featured</span>}
                      </div>
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={() => toggleFeatured(video)} className={`p-1.5 rounded-lg transition-colors ${video.featured ? "text-[#00FF88] bg-[#00FF88]/10" : "text-[#9CA3AF] hover:text-[#00FF88] hover:bg-[#00FF88]/10"}`}><Star size={14} /></button>
                        <button onClick={() => togglePublished(video)} className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors">{video.published ? <EyeOff size={14} /> : <Eye size={14} />}</button>
                        <button onClick={() => openEdit(video)} className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-white hover:bg-white/5 transition-colors"><Edit2 size={14} /></button>
                        <button onClick={() => deleteVideo(video.id)} className="p-1.5 rounded-lg text-[#9CA3AF] hover:text-red-400 hover:bg-red-500/10 transition-colors"><Trash2 size={14} /></button>
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
