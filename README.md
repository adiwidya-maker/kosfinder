# KosFinder - Worksheet 9

Proyek Flutter untuk Worksheet 9: **Authentication, Authorization & Push Notifications**
(Flutter • Supabase • Firebase Cloud Messaging).

---

## Cara Membuka Project Ini di VS Code

1. Buka **Visual Studio Code**.
2. Klik **File** -> **Open Folder...**
3. Masuk ke path:
   `C:\Users\LENOVO\.gemini\antigravity\scratch\kosfinder`
4. Klik **Select Folder**.

---

## Langkah Konfigurasi

### 1. Supabase
- Buka file `supabase_setup.sql`, copy dan jalankan di **Supabase SQL Editor**.
- Buka `lib/main.dart`, ganti `https://YOUR_PROJECT_ID.supabase.co` dan `YOUR_SUPABASE_ANON_KEY` dengan URL & Anon Key dari project Supabase Anda (**Project Settings -> API**).
- Nonaktifkan konfirmasi email: **Authentication -> Providers -> Email -> nonaktifkan Confirm email**.

### 2. Firebase Cloud Messaging (FCM)
Di terminal project, jalankan:
```bash
flutter pub get
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```
Perintah `flutterfire configure` akan otomatis menghubungkan project Flutter dengan Firebase dan mengupdate `lib/firebase_options.dart`.

---

## Riwayat Commit Git (Worksheet 9)
Branch: `feature/auth-notification`

Gunakan urutan commit berikut saat mengerjakan:
```bash
git add .
git commit -m "feat: implement user authentication"
git commit -m "feat: implement authentication session and logout"
git commit -m "feat: implement user roles"
git commit -m "feat: implement role based interface authorization"
git commit -m "security: implement row level security policies"
git commit -m "chore: configure firebase cloud messaging"
git commit -m "feat: implement push notification with FCM"
```
