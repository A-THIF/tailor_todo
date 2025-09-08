# Tailor Todo

A powerful Flutter todo app using Supabase for backend, Firebase for messaging, and local notifications for real-time task reminders.

---

## Features

- 📝 User authentication (Supabase)
- ✅ Todo CRUD (Supabase/Postgres)
- 🔔 Local notifications when task deadline is reached (flutter_local_notifications + timezone)
- 🎨 Beautiful UI with custom fonts/colors
- ☁️ Firebase configuration ready for FCM/push

---

## Getting Started

### 1. Clone the Repository

```
git clone https://github.com/yourusername/tailor_todo.git
cd tailor_todo
```

---

### 2. Flutter Setup

- Minimum Flutter SDK: `3.8.1`
- Android minSdk: **23**
- Ensure your IDE and Flutter tools are updated.

---

### 3. Supabase Configuration

1. Create a [Supabase](https://supabase.com/) project.
2. Get your project URL and anon/public key from Project Settings > API.
3. Update your `lib/main.dart`:

   ```
   await Supabase.initialize(
     url: 'https://YOUR_PROJECT_REF.supabase.co',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

---

### 4. Firebase Setup

1. [Register your app in Firebase Console](https://console.firebase.google.com/)
2. Download `google-services.json` from Firebase for Android.
3. Place `google-services.json` in:  
   `android/app/google-services.json`
4. Run:

   ```
   flutter pub add firebase_core firebase_messaging
   ```

---

### 5. Notifications Setup

#### Packages

```
dependencies:
  flutter_local_notifications: ^19.4.1
  timezone: ^0.10.1
```

#### Android Manifest

Add this in `android/app/src/main/AndroidManifest.xml`:

```
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### NotificationService Init

Initialize notifications and permissions in `main.dart`:

```
await NotificationService.instance.init();
await FlutterLocalNotificationsPlugin()
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.requestNotificationsPermission();
```

---

### 6. Run the App

```
flutter pub get
flutter run
```

---

## How Local Notifications Work

- Every new or edited task schedules a local notification for the deadline using `zonedSchedule` (exactAllowWhileIdle).
- When the timer runs out, users receive a native notification, even if the app is in the background or closed.
- Notifications are managed in `lib/notifications/notification_service.dart`.

---

## Development Notes

- Always use UTC deadlines for cross-timezone safety.
- For remote push, save device FCM tokens for future backend sends.
- Update Supabase and Firebase credentials for your own environment.

---

## Questions?

Feel free to open an issue or discussion in this repo.

---

## License

MIT or your preferred license.
