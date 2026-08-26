importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js",
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js",
);

const firebaseConfig = {
  apiKey: "AIzaSyCralq63UDHShQ6IQFqnVKX3MJcy8KK6G0",
  authDomain: "expense-tracker-ab4ec.firebaseapp.com",
  projectId: "expense-tracker-ab4ec",
  storageBucket: "expense-tracker-ab4ec.firebasestorage.app",
  messagingSenderId: "994301263812",
  appId: "1:994301263812:web:2530b0cae909a55e75ee91",
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// ==========================================
// FCM BACKGROUND MESSAGE
// ==========================================

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Background message:", payload);

  const title = payload.notification?.title ?? "Expense Tracker";

  const body = payload.notification?.body ?? "";

  self.registration.showNotification(title, {
    body: body,
    icon: "/icons/Icon-192.png",
    tag: "expense-tracker-notification",
  });
});

// ==========================================
// MESSAGE FROM FLUTTER
// ==========================================

self.addEventListener("message", (event) => {
  console.log("[firebase-messaging-sw.js] Message from Flutter:", event.data);

  if (!event.data) return;

  if (event.data.type === "SHOW_NOTIFICATION") {
    const title = event.data.title ?? "Expense Tracker";

    const body = event.data.body ?? "";

    self.registration.showNotification(title, {
      body: body,
      icon: "/icons/Icon-192.png",
      tag: "expense-tracker-notification",
    });
  }
});
