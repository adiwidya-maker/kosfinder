importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyC-TrgxAbpcAG3FUrLwPjRv2arOqjidgew",
  authDomain: "kosfinder-c9763.firebaseapp.com",
  projectId: "kosfinder-c9763",
  storageBucket: "kosfinder-c9763.firebasestorage.app",
  messagingSenderId: "129705915058",
  appId: "1:129705915058:android:5d1b0a103a82f05fb3cfab"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message: ', payload);
  const notificationTitle = payload.notification?.title || 'KosFinder';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/favicon.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
