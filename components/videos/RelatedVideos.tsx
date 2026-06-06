import Link from "next/link";
import { Play } from "lucide-react";
import { Video } from "@/types";
import { getYouTubeThumbnail } from "@/lib/utils";

interface RelatedVideosProps {
  videos: Video[];
}

export default function RelatedVideos({ videos }: RelatedVideosProps) {
  if (!videos.length) {
    return (
      <div className="glass-card p-6 text-center">
        <p className="text-[#9CA3AF] text-sm">No related videos yet</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {videos.map((video) => (
        <Link key={video.id} href={`/videos/${video.id}`} className="group block">
          <div className="flex gap-3 glass-card p-3 hover:border-[#00FF88]/20 transition-all duration-200">
            <div className="relative w-28 flex-shrink-0 aspect-video rounded-lg overflow-hidden">
              <img
                src={video.thumbnail || getYouTubeThumbnail(video.youtube_id)}
                alt={video.title}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                <Play size={16} className="text-white" />
              </div>
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-white leading-snug line-clamp-2 group-hover:text-[#00FF88] transition-colors">
                {video.title}
              </p>
              <p className="text-xs text-[#9CA3AF] mt-1">{video.category}</p>
            </div>
          </div>
        </Link>
      ))}
    </div>
  );
}
