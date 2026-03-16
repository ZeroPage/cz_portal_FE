// API 루트 및 공통 fetch 함수
// 환경에 따른 API URL 설정
export const API_ROOT =
  import.meta.env.VITE_API_URL ||
  (import.meta.env.PROD
    ? "https://api.zeropage.org"
    : "https://api.zeropage.org");

export async function apiFetch(path, options = {}) {
  const url = `${API_ROOT}${path}`;
  return fetch(url, options);
}
