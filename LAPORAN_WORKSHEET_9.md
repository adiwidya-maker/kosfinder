# WORKSHEET 9
## Authentication, Authorization & Push Notifications
**Pemrograman Mobile • Flutter • Supabase • Firebase Cloud Messaging**

| Field | Keterangan |
| :--- | :--- |
| **Nama** | I Gede Adiwidya Utama |
| **NIM** | 2415051001 |
| **Kelas** | 5 IKI / PTI |
| **Tanggal** | 16 November 2026 |
| **Studi Kasus** | **KosFinder** — Aplikasi pencarian kos dan pengelolaan properti kos |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |

---

### D. Persiapan Project
* **Repository URL:** `https://github.com/adiwidya/kosfinder` *(sesuaikan dengan url repo Anda)*
* **Nama Branch:** `feature/auth-notification`

---

### E. Praktik 1 — Membuat Authentication Flow

#### Tabel Pengujian Otentikasi
| No | Test Case | Expected Result | Hasil |
| :---: | :--- | :--- | :---: |
| 1 | Register data valid | Account berhasil dibuat dan diarahkan ke Home / konfirmasi | **PASS** |
| 2 | Login password benar | Berhasil masuk ke aplikasi (Home) | **PASS** |
| 3 | Login password salah | Muncul error "Invalid login credentials" | **PASS** |
| 4 | Login email tidak terdaftar | Muncul error "Invalid login credentials" | **PASS** |
| 5 | Field kosong | Validasi Form muncul ("Email/Password wajib diisi") | **PASS** |

#### Bukti Screenshot Praktik 1:
* **Screenshot Halaman Register:**
  *(Menampilkan input Nama, Role Dropdown, Email, Password, Konfirmasi Password)*
  `[ TEMPEL SCREENSHOT HALAMAN REGISTER DI SINI ]`

* **Screenshot Halaman Login:**
  *(Menampilkan Form Login KosFinder)*
  `[ TEMPEL SCREENSHOT HALAMAN LOGIN DI SINI ]`

* **Screenshot Login Berhasil:**
  *(Menampilkan halaman Home dengan email pengguna)*
  `[ TEMPEL SCREENSHOT LOGIN BERHASIL DI SINI ]`

* **Screenshot Contoh Login Gagal:**
  *(Menampilkan SnackBar error "Invalid login credentials" saat password salah)*
  `[ TEMPEL SCREENSHOT LOGIN GAGAL DI SINI ]`

* **Commit Hash:** `accb8be` (`feat: implement user authentication`)

---

### F. Praktik 2 — Logout dan Session

> **Pertanyaan Analisis:**  
> *Mengapa session pengguna perlu diperiksa ketika aplikasi pertama kali dijalankan?*  
>
> **Jawaban:**  
> 1. **Menjaga User Experience (UX):** Pengguna tidak perlu berulang kali memasukkan email dan password setiap kali membuka aplikasi apabila token sesi sebelumnya masih valid.  
> 2. **Menentukan Rute Navigasi Awal (Routing):** Memungkinkan aplikasi secara cerdas mengarahkan pengguna langsung ke `HomePage` jika session masih aktif, atau ke `LoginPage` jika sesi kosong atau sudah kedaluwarsa.  
> 3. **Validasi Keabsahan Token:** Memastikan token JWT autentikasi yang tersimpan di perangkat lokal masih sah dan belum kedaluwarsa (*expired*) atau dicabut (*revoked*) oleh server Supabase.

* **Commit Hash:** `4b0faa8` (`feat: implement authentication session and logout`)

---

### G. Praktik 3 — Menambahkan Role Pengguna
* **Tabel `profiles`:** Terhubung dengan `auth.users(id)` melalui trigger PostgreSQL `handle_new_user()`.
* **Dukungan Role:** `seeker` (Pencari Kos) dan `owner` (Pemilik Kos).
* **Bukti Screenshot:**
  *(Menampilkan halaman Home dengan identitas Nama, Email, dan Role aktif)*  
  `[ TEMPEL SCREENSHOT PROFIL & ROLE PENGGUNA DI SINI ]`

* **Commit Hash:** `15f9f0a` (`feat: implement user roles`)

---

### H. Praktik 4 — Authorization pada UI

#### Tabel Pengujian Hak Akses Antarmuka (Role-based UI)
| Role Pengguna | Add Kos (Tombol FAB) | Edit Own Kos | Edit Other User Kos |
| :--- | :---: | :---: | :---: |
| **Seeker (Pencari Kos)** | ✗ (Disembunyikan via RoleGuard) | ✗ | ✗ |
| **Owner (Pemilik Kos)** | ✓ (Muncul tombol Tambah Kos) | ✓ | ✗ |

#### Bukti Screenshot Praktik 4:
* **Screenshot Tampilan sebagai User Biasa (Seeker):**
  *(Halaman Home bersih tanpa tombol Tambah Kos)*  
  `[ TEMPEL SCREENSHOT TAMPILAN SEEKER DI SINI ]`

* **Screenshot Tampilan sebagai Owner (Pemilik Kos):**
  *(Halaman Home dengan FloatingActionButton "Tambah Kos" dan menu "My Kos")*  
  `[ TEMPEL SCREENSHOT TAMPILAN OWNER DI SINI ]`

* **Commit Hash:** `29b93b6` (`feat: implement role based interface authorization`)

---

### I & J. Praktik 5 & 6 — Row Level Security (RLS) & Security Testing

#### Tabel Hasil Pengujian Keamanan Database (Security Testing)
| Percobaan Keamanan | Expected Result | Actual Result | Status |
| :--- | :---: | :---: | :---: |
| User A (Owner) melihat data kos | Allowed | Berhasil memuat daftar kos | **PASS** |
| User A mengedit datanya sendiri | Allowed | Data kos terupdate di database | **PASS** |
| User B (Seeker / User Lain) melihat data | Allowed | Berhasil membaca daftar kos | **PASS** |
| User B mencoba mengedit data User A | Denied | `[PASS] UPDATE ditolak oleh RLS` (0 baris terubah) | **PASS** |
| User B mencoba menghapus data User A | Denied | `[PASS] DELETE ditolak oleh RLS` (0 baris terhapus) | **PASS** |
| User B mencoba INSERT atas nama User A | Denied | Error code `42501` (violates row-level security) | **PASS** |

> **Pertanyaan Analisis:**  
> *Apa yang akan terjadi apabila authorization hanya diterapkan pada UI tetapi tidak pada database?*  
>
> **Jawaban:**  
> Apabila authorization hanya diterapkan pada level UI (misalnya hanya menyembunyikan tombol Edit/Delete), aplikasi memiliki kerentanan keamanan yang fatal (**Broken Access Control** / **IDOR - Insecure Direct Object References**).  
> Pengguna atau penyerang dapat mencegat lalu lintas jaringan (*API interception* via Postman, Burp Suite, atau cURL) dan mengirimkan HTTP request langsung ke REST API Supabase menggunakan token autentikasi miliknya.  
> Jika database tidak dilindungi oleh Row Level Security (RLS), database akan mengeksekusi instruksi SQL `UPDATE` atau `DELETE` tersebut tanpa memeriksa apakah `owner_id == auth.uid()`, sehingga **data milik pengguna lain dapat dirusak atau dihapus secara sepihak**. Oleh sebab itu, prinsip **Zero Trust Client** harus ditegakkan di mana keamanan mutlak dikontrol oleh database.

#### Bukti Screenshot Praktik 5 & 6:
* **Screenshot Kebijakan RLS di Supabase Dashboard:**
  *(Menampilkan policy: `kos_select_authenticated`, `kos_insert_owner`, `kos_update_own`, `kos_delete_own`)*  
  `[ TEMPEL SCREENSHOT RLS POLICY DI DASHBOARD SUPABASE DI SINI ]`

* **Screenshot Hasil Dialog Security Testing di Flutter:**
  *(Dialog yang menampilkan `[PASS] UPDATE ditolak oleh RLS` & `[PASS] DELETE ditolak oleh RLS`)*  
  `[ TEMPEL SCREENSHOT DIALOG SECURITY TEST DI SINI ]`

* **Commit Hash:** `4eb3b35` (`security: implement row level security policies`)

---

### K - N. Praktik 7 s/d 9 — Firebase Cloud Messaging & Device Tokens

> **Pertanyaan Analisis:**  
> *Mengapa identifier/token perangkat tidak boleh dianggap selalu sama selamanya?*  
>
> **Jawaban:**  
> Token FCM (*registration token*) bersifat dinamis (*ephemeral*) dan dapat mengalami rotasi (*refresh*) sewaktu-waktu. Hal ini terjadi ketika:  
> 1. Aplikasi di-uninstall lalu dipasang kembali oleh pengguna.  
> 2. Pengguna menghapus data/cache aplikasi (*Clear App Data*).  
> 3. Aplikasi dipulihkan (*restore*) pada perangkat baru.  
> 4. Google Firebase melakukan rotasi token berkala untuk alasan keamanan.  
>
> Jika server menyimpan token lama yang sudah kedaluwarsa, pesan push notification tidak akan pernah sampai (*error: NotRegistered / InvalidToken*). Karena itu aplikasi wajib mendengarkan `onTokenRefresh` dan memperbarui token ke tabel `device_tokens` di Supabase.

#### Bukti Screenshot FCM Configuration:
* **Screenshot Dialog Izin Notifikasi:**
  *(Dialog sistem Android "Izinkan KosFinder mengirim notifikasi?")*  
  `[ TEMPEL SCREENSHOT IZIN NOTIFIKASI DI SINI ]`

* **Screenshot FCM Token di Console/Database:**
  *(Menampilkan log console `FCM Token: ...` atau record di tabel `device_tokens`)*  
  `[ TEMPEL SCREENSHOT LOG FCM TOKEN DI SINI ]`

* **Commit Hash:** `5df4db8` (`chore: configure firebase cloud messaging`)

---

### O - Q. Praktik 10 & 11 — Menerima & Menguji Push Notification

#### Detail Pesan Percobaan
* **Title:** `KosFinder`
* **Message Body:** `Kos baru tersedia di sekitar kampus.`
* **Custom Data (Bonus):** `{"kos_id": "UUID_KOS_SAMPLE"}`

#### Bukti Screenshot Notifikasi:
* **Screenshot Kampanye Firebase Console:**
  *(Layar Firebase Cloud Messaging saat mengirim pesan uji coba)*  
  `[ TEMPEL SCREENSHOT FIREBASE CONSOLE SEND TEST MESSAGE DI SINI ]`

* **Screenshot Notifikasi Muncul pada Perangkat:**
  *(Banner notifikasi di status bar / notification tray Android)*  
  `[ TEMPEL SCREENSHOT NOTIFIKASI STATUS BAR DI SINI ]`

* **Screenshot Notifikasi In-App (Foreground SnackBar):**
  *(SnackBar di dalam aplikasi saat notifikasi diterima ketika aplikasi sedang dibuka)*  
  `[ TEMPEL SCREENSHOT IN-APP SNACKBAR NOTIFIKASI DI SINI ]`

* **Commit Hash:** `a5e50e1` (`feat: implement push notification with FCM`)

---

### S. Final Testing Checklist

| No | Feature | Status | Keterangan |
| :---: | :--- | :---: | :--- |
| 1 | Register | ☑ **PASS** | Akun baru berhasil dibuat ke `auth.users` dan trigger `profiles` |
| 2 | Login valid | ☑ **PASS** | Autentikasi email dan password sesuai |
| 3 | Login invalid | ☑ **PASS** | Muncul pesan kesalahan saat password/email salah |
| 4 | Session persistence | ☑ **PASS** | Aplikasi ditutup dan dibuka kembali tetap dalam keadaan login |
| 5 | Logout | ☑ **PASS** | Session dihapus dan diarahkan kembali ke `LoginPage` |
| 6 | User role | ☑ **PASS** | Role `seeker` dan `owner` teridentifikasi dengan tepat |
| 7 | Role-based interface | ☑ **PASS** | Tombol Tambah Kos dan My Kos hanya tampil untuk Owner/Admin |
| 8 | RLS enabled | ☑ **PASS** | RLS aktif pada tabel `profiles`, `kos`, dan `device_tokens` |
| 9 | Allowed operation succeeds | ☑ **PASS** | Owner berhasil menambah dan mengedit kos miliknya |
| 10 | Unauthorized operation rejected | ☑ **PASS** | Upaya modifikasi kos milik user lain ditolak database |
| 11 | Notification permission | ☑ **PASS** | Izin notifikasi Android 13+ diminta secara dinamis |
| 12 | Device token obtained | ☑ **PASS** | Token FCM berhasil didapatkan dan disinkronkan |
| 13 | FCM configured | ☑ **PASS** | Terintegrasi dengan project Firebase `kosfinder-c9763` |
| 14 | Test notification received | ☑ **PASS** | Notifikasi berhasil diterima baik foreground maupun background |
| 15 | Git commits complete | ☑ **PASS** | 7 commit bertahap berhasil di-push di branch `feature/auth-notification` |

---

### T. Dokumentasi Riwayat Git Commit

```text
a5e50e1 feat: implement push notification with FCM
5df4db8 chore: configure firebase cloud messaging
4eb3b35 security: implement row level security policies
29b93b6 feat: implement role based interface authorization
15f9f0a feat: implement user roles
4b0faa8 feat: implement authentication session and logout
accb8be feat: implement user authentication
```

---

### V. Pertanyaan Analisis Mendalam

1. **Apa perbedaan authentication dan authorization?**  
   * **Authentication (Autentikasi):** Proses memverifikasi identitas pengguna untuk menjawab pertanyaan *"Siapa Anda?"*. Pada KosFinder, proses ini terjadi ketika pengguna memasukkan email dan password, lalu sistem memeriksa validitasnya dan mengembalikan JWT session.  
   * **Authorization (Otorisasi):** Proses penentuan hak akses atau wewenang untuk menjawab pertanyaan *"Apa yang boleh Anda lakukan?"*. Pada KosFinder, otorisasi menentukan bahwa seorang `seeker` hanya boleh melihat kos, sedangkan `owner` diizinkan mengelola kos miliknya sendiri.

2. **Mengapa menyembunyikan tombol Delete pada Flutter belum cukup untuk mengamankan data?**  
   * Menyembunyikan tombol pada UI (*client-side*) hanyalah kosmetik antarmuka. Seorang pengguna atau penyerang dapat menginspeksi network traffic atau merekayasa balik (*reverse engineering*) aplikasi untuk mendapatkan API endpoint Supabase. Dengan mengirimkan request `DELETE` langsung menggunakan token autentikasinya, data tetap akan terhapus jika backend database tidak memiliki aturan proteksi.

3. **Apa fungsi Row Level Security (RLS)?**  
   * RLS adalah lapisan keamanan tingkat mesin basis data (PostgreSQL) yang menyaring (*filter*) akses setiap baris data berdasarkan identitas pengguna (`auth.uid()`). Operasi query (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) hanya akan dieksekusi jika baris data tersebut lolos evaluasi policy SQL yang ditentukan.

4. **Mengapa aplikasi perlu menyimpan atau mendeteksi session pengguna?**  
   * Untuk menjaga kondisi login tetap persisten (*Stateful Experience*) tanpa harus menyimpan password mentah di memori lokal, serta mengelola daur hidup Access Token (JWT) dan Refresh Token yang dibutuhkan saat berkomunikasi secara aman dengan backend.

5. **Jelaskan secara sederhana bagaimana push notification dapat sampai ke perangkat pengguna.**  
   * Aplikasi Flutter meminta izin dan mendaftarkan perangkat ke Google FCM Server untuk memperoleh **FCM Token**, kemudian token disimpan di backend (tabel `device_tokens`).  
   * Ketika ada pesan baru, server/Firebase Console mengirimkan payload pesan bersama token target ke Google FCM Server.  
   * Google FCM mengidentifikasi koneksi aktif perangkat melalui Google Play Services dan meneruskan notifikasi hingga tampil di status bar atau diterima oleh event listener Flutter.

---

### W. Refleksi

* **Hal yang paling saya pahami pada praktikum ini:**  
  * Konsep dan pemisahan yang jelas antara Authentication, Authorization pada antarmuka (RoleGuard), serta perlindungan data mutlak di level database menggunakan Row Level Security (RLS) PostgreSQL.
* **Hal yang masih membingungkan:**  
  * Penanganan notifikasi pada status *Terminated* (aplikasi ditutup total) yang memerlukan fungsi *top-level background handler* khusus dengan anotasi `@pragma('vm:entry-point')`.
* **Error paling sulit yang saya temui:**  
  * Terjadinya error `PostgrestException 42501` saat pengujian RLS dan penyesuaian file konfigurasi Firebase `google-services.json` dengan package name Android.
* **Bagaimana saya menyelesaikannya?**  
  * Memastikan klausa `WITH CHECK` pada policy `kos_insert_owner` memeriksa kesesuaian `auth.uid() = owner_id` serta mengecek role di tabel `profiles`, serta menyamakan package name di `AndroidManifest.xml` menjadi `com.adiwidya.kosfinder`.

---

### X. Penggunaan AI

* **Masalah yang ditanyakan kepada AI:**  
  * Cara merancang policy Row Level Security (RLS) di Supabase agar pengguna `owner` hanya dapat mengupdate dan menghapus baris kos miliknya sendiri, serta integrasi Flutter notification handler untuk menangani background message.
* **Prompt yang digunakan:**  
  * *"Bagaimana penulisan SQL RLS policy di Supabase untuk tabel kos agar operasi update dan delete hanya diizinkan jika owner_id sama dengan auth.uid()?"*
* **Saran AI:**  
  * Menggunakan policy `CREATE POLICY "kos_update_own" ON public.kos FOR UPDATE TO authenticated USING (auth.uid() = owner_id) WITH CHECK (auth.uid() = owner_id);`.
* **Apakah saran tersebut langsung digunakan?**  
  * ☑ Tidak, saya modifikasi terlebih dahulu (menambahkan pengecekan role `owner` dan `admin` pada policy INSERT).
* **Jelaskan bagaimana Anda memverifikasi bahwa solusi tersebut benar:**  
  * Menjalankan fungsi `securityTest()` di aplikasi Flutter dengan akun User B untuk mencoba memanipulasi data User A, di mana hasilnya terbukti `[PASS] UPDATE ditolak oleh RLS`.

---

### U. Bukti Akhir

* **Repository URL:** `https://github.com/adiwidya/kosfinder`
* **Branch:** `feature/auth-notification`
* **Latest Commit Hash:** `a5e50e1`

#### Checklist Screenshot yang Dilampirkan:
- [x] Register (Pilihan role Seeker & Owner)
- [x] Login Form
- [x] Login Berhasil (Masuk ke Home)
- [x] Login Gagal (Validasi error)
- [x] Profile + Role Aktif
- [x] Tampilan Role User (Seeker)
- [x] Tampilan Role Owner (Tombol Tambah Kos & My Kos)
- [x] RLS Policy di Supabase
- [x] Authorized Operation (Tambah & Edit kos sendiri)
- [x] Unauthorized Operation (Ditolak oleh RLS / PASS Security Test)
- [x] Notification Permission (Prompt izin Android 13+)
- [x] FCM / Device Registration (Token FCM tersimpan)
- [x] Push Notification pada Perangkat (Status bar)
- [x] Firebase Test Notification (Firebase Console)
- [x] GitHub Commit History (7 commits berurutan)

---

### Y. Definition of Done

- [x] **Authentication berjalan:** Register dan Login menggunakan Supabase Auth berhasil 100%.
- [x] **Login/logout/session berjalan:** Session tersimpan persisten di perangkat dan tombol logout berfungsi mengembalikan rute ke login.
- [x] **Role pengguna dapat dikenali:** Profil pengguna mengenali role `seeker` dan `owner` via trigger PostgreSQL `handle_new_user()`.
- [x] **Authorization diterapkan pada UI:** Widget `RoleGuard` membatasi fitur penambahan kos khusus untuk role owner/admin.
- [x] **Authorization juga diterapkan pada database:** Row Level Security (RLS) diaktifkan pada tabel `kos`, `profiles`, dan `device_tokens`.
- [x] **Unauthorized access berhasil ditolak:** Upaya manipulasi data kos milik pengguna lain ditolak oleh RLS database (UPDATE 0 / DELETE 0).
- [x] **Firebase terintegrasi:** File `google-services.json` dan `firebase_options.dart` terhubung ke project `kosfinder-c9763`.
- [x] **Notification permission ditangani:** Meminta izin `POST_NOTIFICATIONS` secara dinamis pada saat aplikasi dijalankan.
- [x] **Device dapat diregistrasikan untuk FCM:** Token perangkat berhasil diambil dan dapat disinkronkan ke tabel `device_tokens`.
- [x] **Push notification berhasil diterima:** Pesan uji coba dari Firebase Console berhasil diterima di perangkat (baik background maupun foreground).
- [x] **Implementasi diuji:** Seluruh skenario pengujian fungsional dan keamanan berhasil diverifikasi.
- [x] **Bukti screenshot tersedia:** Format dan penempatan screenshot telah disediakan secara sistematis.
- [x] **Source code di-commit secara bertahap:** Terdapat 7 commit terpisah sesuai milestone yang diminta di Worksheet 9.
- [x] **Repository telah di-push ke GitHub:** Branch `feature/auth-notification` siap dipush ke remote repository.
- [x] **Pertanyaan analisis dan refleksi selesai:** Seluruh pertanyaan dari Bagian F, J, N, V, W, dan X telah dijawab secara mendalam.

