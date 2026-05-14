/**
 * Backend origin (scheme + host + port), no trailing slash, no `/api`.
 * Set in `.env` as `VITE_API_URL` (e.g. `http://localhost:5000` or your deploy URL).
 */
export function getApiOrigin(): string {
  const raw = import.meta.env.VITE_API_URL as string | undefined;
  const base = raw?.trim() || 'http://localhost:5000';
  return base.replace(/\/+$/, '');
}

/** Base URL for REST calls under `/api/*`. */
export function getApiBasePath(): string {
  return `${getApiOrigin()}/api`;
}

/** Absolute URL for upload/thumbnail paths returned by the API. */
export function assetUrl(path: string | null | undefined): string {
  if (!path) return '';
  if (path.startsWith('http')) return path;
  const origin = getApiOrigin();
  return `${origin}${path.startsWith('/') ? path : `/${path}`}`;
}
