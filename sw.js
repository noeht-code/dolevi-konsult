// Dolevi Konsult v1.8.4 – cache only application assets; never cache customer data or invoices.
const CACHE='dolevi-shell-v1.8.4-corrected';
const FILES=['./','./index.html','./manifest.webmanifest','./icons/icon-180.png','./icons/icon-192.png','./icons/icon-512.png'];
self.addEventListener('install', event => { event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(FILES)).then(()=>self.skipWaiting())); });
self.addEventListener('activate', event => { event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k.startsWith('dolevi-shell-')&&k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim())); });
self.addEventListener('fetch', event => {
  if(event.request.method!=='GET'||new URL(event.request.url).origin!==self.location.origin)return;
  if (event.request.mode === 'navigate') {
    event.respondWith(fetch(event.request).then(response => {
      if (response.ok) { const copy=response.clone(); event.waitUntil(caches.open(CACHE).then(cache=>cache.put(event.request,copy))); }
      return response;
    }).catch(()=>caches.match(event.request).then(cached=>cached||caches.match('./index.html'))));
    return;
  }
  event.respondWith(caches.match(event.request).then(cached=>cached||fetch(event.request)));
});
