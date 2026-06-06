import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { z } from "zod";

const schema = z.object({
  email: z.string().email("Invalid email address"),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email } = schema.parse(body);

    const supabase = await createClient();
    const { error } = await supabase.from("subscribers").insert({ email });

    if (error) {
      if (error.code === "23505") {
        return NextResponse.json({ error: "Already subscribed!" }, { status: 409 });
      }
      throw error;
    }

    return NextResponse.json({ message: "Successfully subscribed!" }, { status: 201 });
  } catch (err) {
    if (err instanceof z.ZodError) {
      const issues = err.issues;
      return NextResponse.json({ error: issues[0]?.message || "Invalid input" }, { status: 400 });
    }
    return NextResponse.json({ error: "Failed to subscribe" }, { status: 500 });
  }
}
