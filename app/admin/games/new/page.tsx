import { Suspense } from "react";
import type { Metadata } from "next";
import { Loader2 } from "lucide-react";
import NewGameWizard from "@/components/admin/games/NewGameWizard";

export const metadata: Metadata = { title: "New Game" };

export default function NewGamePage() {
  return (
    <Suspense fallback={<div className="flex justify-center py-20"><Loader2 className="animate-spin text-[#00FF88]" /></div>}>
      <NewGameWizard />
    </Suspense>
  );
}
