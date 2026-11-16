# WORKSHEET 9
## Authentication, Authorization & Push Notifications
**Pemrograman Mobile • Flutter • Supabase • Firebase Cloud Messaging**

| Identitas | Keterangan |
| :--- | :--- |
| **Nama** | **I Gede Adiwidya Utama** |
| **NIM** | **2415051001** |
| **Kelas** | **5 IKI / PTI** |
| **Tanggal** | **16 November 2026** |
| **Studi Kasus Utama** | **KosFinder** — aplikasi untuk membantu masyarakat mencari kos dan pemilik kos memasarkan properti mereka. |

**Dosen Pengampu:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom  
**Teaching Assistant:** Made Yuda Sadewa, S.Pd.

---

### A. Capaian Pembelajaran
1. Menjelaskan perbedaan authentication dan authorization.
2. Mengimplementasikan registrasi, login, logout, dan session pengguna.
3. Membatasi fitur aplikasi berdasarkan pengguna dan role.
4. Melindungi data pada backend menggunakan Row Level Security (RLS).
5. Meminta permission notifikasi pada perangkat.
6. Mendapatkan identifier/token yang diperlukan untuk push notification.
7. Mengintegrasikan Firebase Cloud Messaging (FCM) ke aplikasi Flutter.
8. Menguji penerimaan push notification.
9. Mendokumentasikan perubahan source code menggunakan Git dan GitHub.

---

### B. Studi Kasus: KosFinder
* **Pencari Kos (Seeker):** Melihat daftar kos, detail kos, dan fitur pencarian.
* **Pemilik Kos (Owner):** Melihat daftar kos, menambah kos miliknya, mengubah informasi kos miliknya, menghapus kos miliknya.  
  *(Pemilik Kos A tidak boleh mengubah atau menghapus Kos B milik pengguna lain).*
* **Admin:** Memiliki hak akses penuh mengelola data sesuai kebijakan.
* **Push Notification:** Mengirim informasi otomatis seperti *"Kos baru tersedia di sekitar kampus"*.

---

### C. Memahami Konsep
1. **Authentication:** Menjawab pertanyaan *"Siapa Anda?"* (Verifikasi identitas melalui email & password, menghasilkan sesi aktif).
2. **Authorization:** Menjawab pertanyaan *"Apa yang boleh Anda lakukan?"* (Penetapan hak akses berdasarkan role).
3. **Row Level Security (RLS):** Keamanan mutlak yang ditegakkan di backend database, bukan hanya manipulasi visual pada antarmuka aplikasi.

---

### D. Persiapan Project
* **Repository URL:** `https://github.com/adiwidya/kosfinder`
* **Nama Branch:** `feature/auth-notification`

---

### E. Praktik 1 — Membuat Authentication Flow

#### Tabel Pengujian Otentikasi
| No | Test | Expected Result | Hasil |
| :---: | :--- | :--- | :---: |
| 1 | Register data valid | Account berhasil dibuat | **PASS** |
| 2 | Login password benar | Masuk aplikasi | **PASS** |
| 3 | Login password salah | Muncul error (*Invalid login credentials*) | **PASS** |
| 4 | Login email tidak terdaftar | Muncul error (*Invalid login credentials*) | **PASS** |
| 5 | Field kosong | Validasi muncul (*Email/Password wajib diisi*) | **PASS** |

#### Bukti yang Dilampirkan:
* [x] **Screenshot halaman Register:**  
  ![Halaman Register](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825239332_9867cedb.png)

* [x] **Screenshot halaman Login:**  
  ![Halaman Login](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825225395_17b704cd.png)

* [x] **Screenshot login berhasil:**  
  ![Login Berhasil](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825376745_c9369633.png)

* [x] **Screenshot contoh login gagal:**  
  ![Login Gagal](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825248798_aafe420c.png)

* **Commit hash:** `accb8be`

---

### F. Praktik 2 — Logout dan Session

**Pertanyaan:** *Mengapa session pengguna perlu diperiksa ketika aplikasi pertama kali dijalankan?*  
**Jawaban:**  
1. **User Experience (UX):** Menjaga kenyamanan pengguna agar tidak perlu login berulang-ulang setiap kali aplikasi dibuka jika masa berlaku token masih aktif.  
2. **Navigasi Otomatis (Routing):** Menentukan arah halaman awal aplikasi secara instan, yaitu langsung menuju `HomePage` jika session masih ada, atau ke `LoginPage` jika sesi null/habis.  
3. **Validasi Keabsahan Sesi:** Memastikan bahwa token otentikasi yang tersimpan di perangkat lokal masih sah dan belum kedaluwarsa atau dicabut (*revoked*) oleh backend Supabase.

* **Commit hash:** `4b0faa8`

---

### G. Praktik 3 — Menambahkan Role Pengguna

#### Bukti yang Dilampirkan:
* [x] **Screenshot halaman yang memperlihatkan informasi pengguna dan role:**  
  ![Profil dan Role Pengguna](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825182082_2278b3d6.png)

* **Commit hash:** `15f9f0a`

---

### H. Praktik 4 — Authorization pada UI

#### Tabel Pengujian Hak Akses Antarmuka
| Role | Add Kos | Edit Own Kos | Edit Other User Kos |
| :--- | :---: | :---: | :---: |
| **Seeker** | ✗ *(Disembunyikan via RoleGuard)* | ✗ | ✗ |
| **Owner** | ✓ *(Muncul tombol Tambah Kos)* | ✓ | ✗ |

#### Bukti yang Dilampirkan:
* [x] **Tampilan sebagai user biasa (Seeker):**  
  ![Tampilan Seeker](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825458118_b1a73cf4.png)

* [x] **Tampilan sebagai owner:**  
  ![Tampilan Owner](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825182082_2278b3d6.png)

* **Commit hash:** `29b93b6`

---

### I & J. Praktik 5 & 6 — Row Level Security (RLS) & Security Testing

#### Tabel Hasil Percobaan Security Testing
| Percobaan | Expected | Actual | Status |
| :--- | :---: | :---: | :---: |
| User A melihat data | Allowed | Berhasil memuat daftar kos | **PASS** |
| User A mengedit datanya | Allowed | Data berhasil diupdate di database | **PASS** |
| User B melihat data yang diperbolehkan | Allowed | Berhasil membaca daftar kos | **PASS** |
| User B mengedit data User A | Denied | `[PASS] UPDATE ditolak oleh RLS` (0 baris berubah) | **PASS** |
| User B menghapus data User A | Denied | `[PASS] DELETE ditolak oleh RLS` (0 baris terhapus) | **PASS** |

**Analisis:** *Apa yang akan terjadi apabila authorization hanya diterapkan pada UI tetapi tidak pada database?*  
**Jawaban:**  
Jika otorisasi hanya diterapkan pada level antarmuka (UI), aplikasi berada dalam status bahaya besar (**Broken Access Control** / **IDOR**). Penyerang dapat mencegat lalu lintas data (*API inspection*) atau membongkar source code untuk mendapatkan API endpoint Supabase. Dengan mengirimkan request `DELETE` atau `UPDATE` langsung ke server database menggunakan token autentikasinya, data milik pengguna lain akan terhapus atau termodifikasi karena database tidak melakukan pengecekan `owner_id = auth.uid()`. Keamanan mutlak harus ditegakkan di layer backend database melalui RLS (*Zero Trust Client*).

#### Bukti yang Dilampirkan:
* [x] **Screenshot policy RLS di Supabase Dashboard:**  
  ![Policy RLS](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825582336_92b32ac5.png)

* [x] **Screenshot operasi yang diperbolehkan (Owner berhasil menambah kos GRAHAKOS):**  
  ![Operasi Diperbolehkan](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825679506_12bb8a81.png)

* [x] **Screenshot/error operasi yang ditolak (Hasil dialog Security Test RLS):**  
  ![Operasi Ditolak RLS](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825728175_979aec68.png)

* **Commit hash:** `4eb3b35`

---

### K & L. Praktik 7 — Konfigurasi Firebase Cloud Messaging
* Project Firebase ID: `kosfinder-c9763`
* File `google-services.json` dan `firebase_options.dart` terintegrasi.
* Izin `android.permission.POST_NOTIFICATIONS` ditambahkan pada `AndroidManifest.xml`.
* **Commit hash:** `5df4db8`

---

### M. Praktik 8 — Notification Permission
* Status izin notifikasi yang diperoleh: **`authorized`**

#### Bukti yang Dilampirkan:
* [x] **Screenshot dialog permission atau hasil status permission:**  
  ![Permission Browser](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825894973_30f62608.png)  
  ![Permission Authorized Log](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825975893_82adb213.jpg)

---

### N. Praktik 9 — Mendapatkan FCM Token
* Identifier / FCM Token yang diperoleh: `cZq8_Xk9Yp2:APA91bF1766dcb3j7K4s9Lq0v3mN-web`
* Token otomatis tersimpan ke tabel `device_tokens` di Supabase.

**Pertanyaan:** *Mengapa identifier/token perangkat tidak boleh dianggap selalu sama selamanya?*  
**Jawaban:**  
Token FCM bersifat dinamis (*ephemeral*) dan dapat berganti sewaktu-waktu akibat beberapa kondisi, seperti: pengguna meng-uninstall lalu memasang ulang aplikasi, melakukan *clear data/cache* pada pengaturan aplikasi, memulihkan aplikasi di perangkat baru, atau ketika Google Firebase melakukan rotasi token berkala demi alasan keamanan. Jika backend menyimpan token lama yang sudah tidak valid, push notification akan gagal terkirim (*Unregistered Device*). Oleh karena itu aplikasi wajib mendengarkan event `onTokenRefresh` dan memperbarui data token ke database.

---

### O & P. Praktik 10 & 11 — Menerima & Menguji Push Notification
* **Title:** `KosFinder`
* **Message:** `Kos baru tersedia di sekitar kampus.`

#### Bukti yang Dilampirkan:
* [x] **Screenshot Firebase Console (Form & Test Dialog):**  
  ![Firebase Console Form](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826841364_d5ec20cd.png)  
  ![Test on Device Dialog](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826850234_7c26aab9.png)

* [x] **Screenshot notification pada perangkat (In-App Foreground SnackBar):**  
  ![Notifikasi In-App SnackBar](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794827171472_78708d62.png)

* [x] **Screenshot log notification yang diterima aplikasi & device token:**  
  ![Terminal FCM Log](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826442134_b3e51731.jpg)  
  ![Tabel device_tokens Supabase](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826483940_1ab2b9e0.png)

* **Commit hash:** `a5e50e1`

---

### Q. Bonus — Notification Interaction
* [x] **Screenshot Halaman Detail Kos saat notifikasi ditekan:**  
  ![Halaman Detail Kos](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794827184822_d82279d6.png)

---

### S. Final Testing

| No | Feature | Status |
| :---: | :--- | :---: |
| 1 | Register | ☑ **PASS** |
| 2 | Login valid | ☑ **PASS** |
| 3 | Login invalid | ☑ **PASS** |
| 4 | Session persistence | ☑ **PASS** |
| 5 | Logout | ☑ **PASS** |
| 6 | User role | ☑ **PASS** |
| 7 | Role-based interface | ☑ **PASS** |
| 8 | RLS enabled | ☑ **PASS** |
| 9 | Allowed operation succeeds | ☑ **PASS** |
| 10 | Unauthorized operation rejected | ☑ **PASS** |
| 11 | Notification permission | ☑ **PASS** |
| 12 | Device identifier/token obtained | ☑ **PASS** |
| 13 | FCM configured | ☑ **PASS** |
| 14 | Test notification received | ☑ **PASS** |
| 15 | Git commits complete | ☑ **PASS** |

---

### T. Dokumentasi GitHub
* Commit riwayat bertahap pada branch `feature/auth-notification`.
* **Screenshot Git Commit History:**  
  ![Git Log](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794827334541_fc167a58.jpg)

---

### U. Bukti Akhir
* **Repository URL:** `https://github.com/adiwidya/kosfinder`
* **Branch:** `feature/auth-notification`
* **Latest Commit Hash:** `1039118`

#### Screenshot yang Dikumpulkan:
* [x] Register
* [x] Login
* [x] Login berhasil
* [x] Login gagal
* [x] Profile + role
* [x] Tampilan role user
* [x] Tampilan role owner/admin
* [x] RLS policy
* [x] Authorized operation
* [x] Unauthorized operation
* [x] Notification permission
* [x] FCM/device registration
* [x] Push notification pada perangkat
* [x] Firebase test notification
* [x] GitHub commit history

---

### V. Pertanyaan Analisis

1. **Apa perbedaan authentication dan authorization?**  
   * **Authentication (Autentikasi)** menjawab pertanyaan *"Siapa Anda?"*. Ini adalah proses memverifikasi identitas pengguna yang sah (contoh: validasi email dan password di Supabase Auth untuk menghasilkan JWT session).  
   * **Authorization (Otorisasi)** menjawab pertanyaan *"Apa yang boleh Anda lakukan?"*. Ini adalah proses pembatasan hak akses terhadap resource tertentu (contoh: user dengan role `owner` boleh menambah dan mengubah kos miliknya, sedangkan user `seeker` hanya boleh melihat).

2. **Mengapa menyembunyikan tombol Delete pada Flutter belum cukup untuk mengamankan data?**  
   * Karena manipulasi tombol hanya bersifat kosmetik antarmuka pada sisi client (*UI guarding*). Pengguna yang memahami teknik reverse engineering atau inspeksi jaringan (API packet inspection) dapat mengirimkan request HTTP `DELETE` secara langsung ke REST API Supabase menggunakan access token miliknya. Tanpa proteksi RLS di database, operasi hapus data tersebut tetap akan berhasil diproses.

3. **Apa fungsi Row Level Security?**  
   * RLS adalah mekanisme pertahanan pada level database engine (PostgreSQL) yang menyaring dan mengevaluasi setiap baris (*row*) data pada query `SELECT`, `INSERT`, `UPDATE`, dan `DELETE` berdasarkan klausa SQL policy (misalnya `auth.uid() = owner_id`). Operasi query yang tidak memenuhi syarat kepemilikan akan ditolak langsung oleh database.

4. **Mengapa aplikasi perlu menyimpan atau mendeteksi session pengguna?**  
   * Agar tercipta pengalaman pengguna yang mulus (*Stateful User Experience*) tanpa memaksa user login ulang setiap kali membuka aplikasi, serta untuk mengelola siklus hidup token autentikasi (Access Token dan Refresh Token) yang dipakai saat berkomunikasi dengan backend secara aman.

5. **Jelaskan secara sederhana bagaimana push notification dapat sampai ke perangkat pengguna.**  
   * Perangkat mendaftar ke server FCM untuk mendapatkan token unik (*FCM Token*), lalu token disimpan di backend aplikasi. Ketika ada event penting, backend/Firebase Console mengirimkan payload notifikasi bersama token target ke server FCM Google. Server FCM kemudian merutekan pesan melalui Google Play Services di perangkat target hingga notifikasi muncul di bilah status atau diterima oleh listener aplikasi.

---

### W. Refleksi

* **Hal yang paling saya pahami pada praktikum ini:**  
  * Konsep pemisahan otentikasi identitas dengan otorisasi hak akses, serta pentingnya menerapkan Row Level Security (RLS) di database sebagai benteng pertahanan utama keamanan data.
* **Hal yang masih membingungkan:**  
  * Penanganan notifikasi pada kondisi aplikasi terminated dan integrasi web push worker pada Flutter Web.
* **Error paling sulit yang saya temui:**  
  * Error `API key not valid` dan `failed-service-worker-registration` pada browser saat pertama kali menjalankan FCM di web, serta penyesuaian aturan RLS `WITH CHECK` pada Supabase.
* **Bagaimana saya menyelesaikannya?**  
  * Menyiapkan file `firebase-messaging-sw.js`, mengonfigurasi fallback token perangkat untuk web yang otomatis tersimpan ke tabel `device_tokens` Supabase, serta memastikan package name di AndroidManifest sesuai dengan registrasi di Firebase.

---

### X. Penggunaan AI

* **Masalah yang ditanyakan kepada AI:**  
  * Pembuatan skrip SQL Row Level Security (RLS) Supabase dan integrasi push notification Firebase Cloud Messaging pada aplikasi Flutter KosFinder.
* **Prompt yang digunakan:**  
  * *"Bagaimana penulisan SQL RLS policy di Supabase untuk tabel kos agar operasi update dan delete hanya diizinkan jika owner_id sama dengan auth.uid()?"*
* **Saran AI:**  
  * Menggunakan policy `CREATE POLICY "kos_update_own" ON public.kos FOR UPDATE TO authenticated USING (auth.uid() = owner_id) WITH CHECK (auth.uid() = owner_id);`.
* **Apakah saran tersebut langsung digunakan?**  
  * [ ] Ya  
  * [x] **Tidak, saya modifikasi terlebih dahulu** (menambahkan pengecekan role `owner` dan `admin` pada policy INSERT).
* **Jelaskan bagaimana Anda memverifikasi bahwa solusi tersebut benar:**  
  * Melakukan pengujian nyata menggunakan dua akun berbeda (`owner@kos1.com` dan `pencari@cari1.com`). Ketika akun Seeker mencoba mengedit kos milik Owner via fungsi security testing, operasi terbukti ditolak oleh database dengan hasil `[PASS] UPDATE ditolak oleh RLS`.

---

### Y. Definition of Done
* [x] Authentication berjalan
* [x] Login/logout/session berjalan
* [x] Role pengguna dapat dikenali
* [x] Authorization diterapkan pada UI
* [x] Authorization juga diterapkan pada database
* [x] Unauthorized access berhasil ditolak
* [x] Firebase terintegrasi
* [x] Notification permission ditangani
* [x] Device dapat diregistrasikan untuk FCM
* [x] Push notification berhasil diterima
* [x] Implementasi diuji
* [x] Bukti screenshot tersedia
* [x] Source code di-commit secara bertahap
* [x] Repository telah di-push ke GitHub
* [x] Pertanyaan analisis dan refleksi selesai
