/** Returns true if real Supabase credentials are present */
export function isSupabaseConfigured(): boolean {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  return !!url && !url.includes("placeholder");
}

/**
 * Wraps any async call with a hard timeout.
 * Returns the fallback value if the call takes longer than `ms`.
 */
export async function withTimeout<T>(
  fn: () => Promise<T>,
  fallback: T,
  ms = 5000
): Promise<T> {
  const timer = new Promise<T>((resolve) => setTimeout(() => resolve(fallback), ms));
  try {
    return await Promise.race([fn(), timer]);
  } catch {
    return fallback;
  }
}
