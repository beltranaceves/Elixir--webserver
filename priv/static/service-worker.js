importScripts('https://storage.googleapis.com/workbox-cdn/releases/6.1.1/workbox-sw.js');

workbox.routing.registerRoute(
    ({request}) => request.destination === 'image',
    new workbox.strategies.NetworkFirst()
);

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open('local-cache').then(function(cache) {
      return cache.addAll(
        [
          './todo.css',
          './icon.png'
        ]
      );
    })
  );
});