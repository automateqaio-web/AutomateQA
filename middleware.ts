import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  let response = NextResponse.next({ request });

  // Block all admin sub-routes (not /admin itself — that shows the login form)
  if (pathname.startsWith("/admin")) {
    // Attach noindex headers so search engines never index admin pages
    response.headers.set("X-Robots-Tag", "noindex, nofollow");

    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

    // If Supabase isn't configured, block access entirely
    if (!supabaseUrl || supabaseUrl.includes("placeholder") || !supabaseKey) {
      if (pathname !== "/admin") {
        return NextResponse.redirect(new URL("/admin", request.url));
      }
      return response;
    }

    const supabase = createServerClient(supabaseUrl, supabaseKey, {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          response = NextResponse.next({ request });
          response.headers.set("X-Robots-Tag", "noindex, nofollow");
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options)
          );
        },
      },
    });

    const {
      data: { user },
    } = await supabase.auth.getUser();

    // Unauthenticated user trying to reach a sub-route — redirect to login
    if (!user && pathname !== "/admin") {
      return NextResponse.redirect(new URL("/admin", request.url));
    }
  }

  return response;
}

export const config = {
  matcher: ["/admin", "/admin/:path*"],
};
