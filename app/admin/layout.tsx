import type { Metadata } from "next";
import AdminGuard from "@/components/admin/AdminGuard";
import AdminSidebar from "@/components/admin/AdminSidebar";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: { default: "Admin Dashboard", template: "%s | AutomateQA Admin" },
  robots: { index: false, follow: false },
};

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  return (
    <AdminGuard>
      <div className="min-h-screen flex bg-[#080808]">
        <AdminSidebar />
        <main className="flex-1 ml-64 p-8 overflow-y-auto">
          {children}
        </main>
      </div>
    </AdminGuard>
  );
}
