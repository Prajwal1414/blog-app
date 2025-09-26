export const getApiPath = (): string => {
  // Wait for window.env to be available or use fallback
  return window.env?.VITE_API_PATH || 'http://backend-service:8080';
};