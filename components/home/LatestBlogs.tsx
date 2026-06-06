"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { ArrowRight, Clock, BookOpen, Calendar } from "lucide-react";
import { Blog } from "@/types";
import { formatDate, truncate } from "@/lib/utils";
import { CATEGORY_COLORS } from "@/types";

interface LatestBlogsProps {
  blogs: Blog[];
}

function BlogCard({ blog, index }: { blog: Blog; index: number }) {
  return (
    <motion.article
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5, delay: index * 0.1 }}
    >
      <Link href={`/blog/${blog.slug}`} className="group block h-full">
        <div className="glass-card-hover h-full flex flex-col overflow-hidden">
          {/* Cover image */}
          {blog.cover_image && (
            <div className="relative aspect-[16/9] overflow-hidden rounded-t-2xl">
              <img
                src={blog.cover_image}
                alt={blog.title}
                className="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500"
                loading="lazy"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent" />
              <div className="absolute bottom-3 left-3">
                <span className={`category-badge border ${CATEGORY_COLORS[blog.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                  {blog.category}
                </span>
              </div>
            </div>
          )}

          {/* Content */}
          <div className="p-5 flex flex-col flex-1">
            {!blog.cover_image && (
              <span className={`category-badge border w-fit mb-3 ${CATEGORY_COLORS[blog.category] || "bg-gray-500/20 text-gray-400 border-gray-500/30"}`}>
                {blog.category}
              </span>
            )}

            <h3 className="font-bold text-white text-lg leading-snug line-clamp-2 mb-2 group-hover:text-[#00FF88] transition-colors">
              {blog.title}
            </h3>

            {blog.excerpt && (
              <p className="text-[#9CA3AF] text-sm leading-relaxed line-clamp-3 flex-1 mb-4">
                {blog.excerpt}
              </p>
            )}

            {/* Meta */}
            <div className="flex items-center justify-between text-xs text-[#9CA3AF] mt-auto pt-4 border-t border-white/5">
              <span className="flex items-center gap-1.5">
                <Calendar size={11} />
                {formatDate(blog.created_at)}
              </span>
              <span className="flex items-center gap-1.5">
                <Clock size={11} />
                {blog.read_time} min read
              </span>
            </div>
          </div>
        </div>
      </Link>
    </motion.article>
  );
}

export default function LatestBlogs({ blogs }: LatestBlogsProps) {
  if (!blogs || blogs.length === 0) return null;

  return (
    <section className="py-20 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-12"
        >
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold mb-3">
              <BookOpen size={10} />
              LATEST ARTICLES
            </div>
            <h2 className="text-3xl sm:text-4xl font-black text-white">
              From the QA Desk
            </h2>
            <p className="text-[#9CA3AF] mt-2">Tutorials, tips, and stories from the automation trenches</p>
          </div>
          <Link
            href="/blog"
            className="flex items-center gap-2 text-[#00FF88] text-sm font-semibold hover:gap-3 transition-all group"
          >
            Read all articles
            <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </motion.div>

        {/* Blog grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {blogs.map((blog, i) => (
            <BlogCard key={blog.id} blog={blog} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}
