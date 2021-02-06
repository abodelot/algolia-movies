import axios from 'axios';

/**
 * Extract Rails CSRF token which is generated in static/index.html
 */
function getCsrfToken() {
  const tokenEl = document.querySelector('meta[name=csrf-token]');

  if (tokenEl !== null) {
    return tokenEl.getAttribute('content');
  }
  return '';
}

// Inject token in HTTP requests
axios.defaults.headers.common['X-CSRF-Token'] = getCsrfToken();
axios.defaults.headers.common['X-Request-With'] = 'XMLHttpRequest';

// Keep track of pending HTTP calls
window.pendingApiCalls = 0;

axios.interceptors.request.use((config) => {
  window.pendingApiCalls += 1;
  return config;
}, (error) => (Promise.reject(error)));

axios.interceptors.response.use((response) => {
  window.pendingApiCalls -= 1;
  return response;
}, (error) => (Promise.reject(error)));

export default axios;

export const getDefaultAdaptater = () => axios.defaults.adapter;
