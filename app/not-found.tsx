import Link from "next/link";

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="text-center">
        <div className="text-8xl font-black text-gradient mb-4">404</div>
        <h2 className="text-2xl font-bold text-white mb-2">Page Not Found</h2>
        <p className="text-[#9CA3AF] mb-8 max-w-md">
          Looks like this page went to production and got a 404. Classic.
        </p>
        <div className="flex gap-4 justify-center">
          <Link href="/" className="btn-primary">Go Home</Link>
          <Link href="/memes" className="btn-outline">Browse Memes</Link>
        </div>
      </div>
    </div>
  );
}
