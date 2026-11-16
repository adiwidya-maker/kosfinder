# LAPORAN WORKSHEET 9
## Pemrograman Mobile: Authentication, Authorization & Push Notifications
**Flutter • Supabase • Firebase Cloud Messaging**

```
+--------------------------------------------------------------------------+
| Nama      : I Gede Adiwidya Utama                                        |
| NIM       : 2415051001                                                   |
| Kelas     : 5 IKI / PTI                                                  |
| Tanggal   : 16 November 2026                                             |
| Proyek    : KosFinder (Aplikasi Pencarian & Manajemen Kos)               |
| Dosen     : Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom                  |
| Asisten   : Made Yuda Sadewa, S.Pd.                                      |
+--------------------------------------------------------------------------+
```

---

### D. Persiapan Proyek & Git Branch

* **Repository:** `https://github.com/adiwidya/kosfinder`
* **Branch Kerja:** `feature/auth-notification`
* **Status Kerja:** Seluruh kode terintegrasi, dependency `supabase_flutter`, `firebase_core`, dan `firebase_messaging` telah terpasang.

---

### E. Praktik 1 — Authentication Flow

#### Tabel Pengujian Otentikasi
| No | Skenario Pengujian | Hasil yang Diharapkan | Hasil Nyata | Status |
| :---: | :--- | :--- | :--- | :---: |
| 1 | Register dengan data valid | Akun berhasil dibuat dan user diarahkan ke Home | Akun terdaftar di Supabase Auth & baris profil otomatis terbuat | **PASS** |
| 2 | Login dengan password benar | Berhasil masuk ke Home aplikasi | Session tersimpan, diarahkan ke HomePage | **PASS** |
| 3 | Login dengan password salah | Muncul pesan error kredensial tidak valid | Tampil SnackBar: *"Invalid login credentials"* | **PASS** |
| 4 | Login email tidak terdaftar | Muncul pesan error kredensial | Tampil SnackBar: *"Invalid login credentials"* | **PASS** |
| 5 | Field email/password kosong | Validasi form muncul mencegah submit | Tampil pesan peringatan: *"Email/Password wajib diisi"* | **PASS** |

#### Bukti Screenshot Praktik 1:

**1. Screenshot Halaman Register:**  
![Halaman Register KosFinder](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825239332_9867cedb.png)

**2. Screenshot Halaman Login:**  
![Halaman Login KosFinder](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825225395_17b704cd.png)

**3. Screenshot Login Gagal (Validasi Error):**  
![Login Gagal](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825248798_aafe420c.png)

**4. Screenshot Login Berhasil:**  
![Login Berhasil](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825376745_c9369633.png)

* **Commit Hash:** `accb8be` — `feat: implement user authentication`

---

### F. Praktik 2 — Logout & Session Management

> **Pertanyaan Analisis:**  
> *Mengapa session pengguna perlu diperiksa ketika aplikasi pertama kali dijalankan?*  
>
> **Jawaban:**  
> 1. **Meningkatkan Kenyamanan Pengguna (User Experience / UX):** Pengguna tidak perlu login berulang-ulang setiap kali membuka aplikasi jika sesi otentikasinya masih aktif.  
> 2. **Menentukan Alur Navigasi Awal (Smart Routing):** Memungkinkan `MaterialApp` menentukan halaman awal secara instan: langsung menuju `HomePage` jika session masih ada, atau ke `LoginPage` jika sesi kosong/expired.  
> 3. **Validasi & Integritas Sesi:** Menjamin bahwa token JWT yang tersimpan di memori perangkat lokal masih valid dan belum dicabut (*revoked*) oleh server Supabase.

* **Commit Hash:** `4b0faa8` — `feat: implement authentication session and logout`

---

### G & H. Praktik 3 & 4 — User Roles & UI Authorization

#### Matriks Hak Akses Antarmuka (Role-based UI)
| Fitur Aplikasi | Role: Seeker (Pencari Kos) | Role: Owner (Pemilik Kos) | Role: Admin |
| :--- | :---: | :---: | :---: |
| **Lihat Daftar & Detail Kos** | ✓ | ✓ | ✓ |
| **Pencarian Kos** | ✓ | ✓ | ✓ |
| **Menu "My Kos"** | ✗ *(Disembunyikan)* | ✓ | ✓ |
| **Tombol FAB "Tambah Kos"** | ✗ *(Disembunyikan via RoleGuard)* | ✓ | ✓ |
| **Edit & Hapus Kos Sendiri** | ✗ | ✓ | ✓ |
| **Kelola Seluruh Data** | ✗ | ✗ | ✓ |

#### Bukti Screenshot Praktik 3 & 4:

**5. Profil Pengguna & Tampilan Role Owner:**  
![Tampilan Owner](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825182082_2278b3d6.png)

**6. Tampilan Role Seeker (Pencari Kos - Tombol Tambah Kos Tersembunyi):**  
![Tampilan Seeker](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825458118_b1a73cf4.png)

* **Commit Hash:**  
  * `15f9f0a` — `feat: implement user roles`  
  * `29b93b6` — `feat: implement role based interface authorization`

---

### I & J. Praktik 5 & 6 — Row Level Security (RLS) & Security Testing

#### Tabel Hasil Pengujian Keamanan Database
| Percobaan Aksi Keamanan | Target Akses | Hasil yang Diharapkan | Respon Aktual Database | Status |
| :--- | :--- | :--- | :--- | :---: |
| User A (Owner) membaca kos | Tabel `kos` | Diizinkan (*Allowed*) | Menampilkan seluruh daftar kos | **PASS** |
| User A mengedit kos miliknya | Kos milik User A | Diizinkan (*Allowed*) | Data berhasil diupdate di database | **PASS** |
| User B (Seeker) membaca kos | Tabel `kos` | Diizinkan (*Allowed*) | Menampilkan seluruh daftar kos | **PASS** |
| User B mencoba mengedit data User A | Kos milik User A | Ditolak (*Denied*) | `[PASS] UPDATE ditolak oleh RLS` (0 baris diubah) | **PASS** |
| User B mencoba menghapus data User A | Kos milik User A | Ditolak (*Denied*) | `[PASS] DELETE ditolak oleh RLS` (0 baris dihapus) | **PASS** |
| User B mencoba INSERT atas nama User A | Kolom `owner_id` | Ditolak (*Denied*) | Error code `42501` (violates row-level security) | **PASS** |

> **Pertanyaan Analisis:**  
> *Apa yang akan terjadi apabila authorization hanya diterapkan pada UI tetapi tidak pada database?*  
>
> **Jawaban:**  
> Jika otorisasi hanya diterapkan di sisi UI (misalnya hanya menyembunyikan tombol Edit/Delete pada widget Flutter), sistem memiliki celah kerentanan fatal berupa **Broken Access Control** atau **Insecure Direct Object References (IDOR)**.  
> Penyerang dapat menginspeksi lalu lintas data jaringan (*API packet inspection*) atau membongkar APK dan mengirim request HTTP `DELETE /rest/v1/kos?id=...` langsung ke Supabase REST API menggunakan token miliknya. Tanpa adanya aturan Row Level Security (RLS) di database yang memeriksa `owner_id = auth.uid()`, database akan mengeksekusi perintah tersebut dan **data pengguna lain akan terhapus atau rusak**. Keamanan mutlak harus ditegakkan di layer database (**Zero Trust Client**).

#### Bukti Screenshot Praktik 5 & 6:

**7. Policy Row Level Security di Supabase:**  
![RLS Policies](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825582336_92b32ac5.png)

**8. Authorized Operation: Owner Berhasil Tambah Kos (GRAHAKOS):**  
![Authorized Operation Tambah Kos](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825679506_12bb8a81.png)

**9. Unauthorized Operation: Security Testing RLS Berhasil Menolak Akses Liar:**  
![Security Testing Dialog PASS](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825728175_979aec68.png)

* **Commit Hash:** `4eb3b35` — `security: implement row level security policies`

---

### K - N. Praktik 7 s/d 9 — Firebase Cloud Messaging & Device Tokens

> **Pertanyaan Analisis:**  
> *Mengapa identifier/token perangkat tidak boleh dianggap selalu sama selamanya?*  
>
> **Jawaban:**  
> Token registrasi FCM bersifat dinamis (*ephemeral*) dan dapat mengalami rotasi (*refresh*) sewaktu-waktu karena:  
> 1. Pengguna melakukan instalasi ulang (*uninstall & reinstall*) aplikasi.  
> 2. Pengguna membersihkan data/cache aplikasi melalui *Settings* Android.  
> 3. Aplikasi dipulihkan (*restored*) pada perangkat baru.  
> 4. Firebase melakukan peremajaan token secara berkala demi keamanan.  
> 
> Jika sistem berasumsi token selalu statis, notifikasi yang dikirim ke token lama akan gagal (*error: NotRegistered*). Oleh sebab itu, aplikasi harus mendengarkan event `onTokenRefresh` dan memperbarui tabel `device_tokens` di database.

#### Bukti Screenshot Praktik 8 & 9:

**10. Status Permission Notifikasi (Authorized):**  
![Permission Chrome](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825894973_30f62608.png)  
![Permission Console Log](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794825975893_82adb213.jpg)

**11. FCM Device Token & Registrasi di Supabase:**  
![Terminal FCM Token](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826442134_b3e51731.jpg)  
![Tabel device_tokens di Supabase](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826483940_1ab2b9e0.png)

* **Commit Hash:** `5df4db8` — `chore: configure firebase cloud messaging`

---

### O - Q. Praktik 10 & 11 — Push Notification Testing & Bonus

#### Bukti Screenshot Praktik 10 & 11:

**12. Pengujian Notifikasi di Firebase Console:**  
![Firebase Campaign KosFinder](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826841364_d5ec20cd.png)  
![Test on Device Dialog](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794826850234_7c26aab9.png)

**13. Penerimaan Push Notification di Dalam Aplikasi (Foreground SnackBar):**  
![Foreground SnackBar Notifikasi](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794827171472_78708d62.png)

**14. (Bonus Q) Interaksi Notifikasi: Tap Notifikasi Membuka Halaman Detail Kos:**  
![Halaman Detail Kos Bonus](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794827184822_d82279d6.png)

* **Commit Hash:** `a5e50e1` — `feat: implement push notification with FCM`

---

### T. Riwayat Commit Git Lengkap

![Riwayat Commit Git Terminal](C:/Users/LENOVO/.gemini/antigravity/brain/714e8c7a-61ec-4b97-a735-47f955b91cd3/.user_uploaded/media_1794827334541_fc167a58.jpg)

```text
eff8f4b (HEAD -> feature/auth-notification) docs: complete worksheet 9 report and final integration
a5e50e1 feat: implement push notification with FCM
5df4db8 chore: configure firebase cloud messaging
4eb3b35 security: implement row level security policies
29b93b6 feat: implement role based interface authorization
15f9f0a feat: implement user roles
4b0faa8 feat: implement authentication session and logout
accb8be feat: implement user authentication
```

---

### V. Pertanyaan Analisis Lengkap

1. **Apa perbedaan authentication dan authorization?**  
   * **Authentication** adalah proses pembuktian identitas (*"Siapa Anda?"*), contohnya verifikasi email & password.  
   * **Authorization** adalah proses penentuan hak akses (*"Apa yang boleh Anda lakukan?"*), contohnya hak user `owner` untuk menambah kos sementara user `seeker` hanya boleh melihat.

2. **Mengapa menyembunyikan tombol Delete pada Flutter belum cukup untuk mengamankan data?**  
   * Karena kontrol antarmuka pada client dapat dibypass melalui inspeksi API jaringan atau reverse engineering. Tanpa proteksi database, request HTTP `DELETE` langsung ke endpoint Supabase tetap akan dieksekusi.

3. **Apa fungsi Row Level Security?**  
   * Menyaring dan mengevaluasi akses data di tingkat baris PostgreSQL berdasarkan identitas user (`auth.uid()`) sehingga pengguna hanya dapat berinteraksi dengan baris data miliknya.

4. **Mengapa aplikasi perlu menyimpan atau mendeteksi session pengguna?**  
   * Agar pengguna tidak perlu login berulang kali (Stateful UX) dan aplikasi dapat mengelola siklus hidup access token (JWT) untuk otentikasi request ke backend secara aman.

5. **Jelaskan secara sederhana bagaimana push notification dapat sampai ke perangkat pengguna.**  
   * Perangkat mendaftar ke FCM untuk mendapatkan token $\rightarrow$ Token disimpan di backend $\rightarrow$ Backend/Console mengirim pesan ke server FCM dengan token target $\rightarrow$ Server FCM meneruskan pesan ke Google Play Services di perangkat $\rightarrow$ Perangkat menampilkan notifikasi ke pengguna.

---

### W & X. Refleksi & Penggunaan AI

* **Refleksi Praktikum:**  
  Memahami pentingnya arsitektur keamanan terdistribusi antara UI guarding dan database RLS, serta konfigurasi push notification multi-status (foreground, background, terminated).
* **Penggunaan AI:**  
  Digunakan untuk merancang policy RLS PostgreSQL Supabase dan konfigurasi FCM background handler Flutter, yang kemudian diverifikasi dan diuji secara langsung menggunakan skenario pengujian dua akun berbeda (User A vs User B).

---

### Y. Definition of Done (100% Selesai)

- [x] **Authentication berjalan:** Register dan Login menggunakan Supabase Auth berhasil 100%.
- [x] **Login/logout/session berjalan:** Session tersimpan persisten di perangkat dan tombol logout berfungsi mengembalikan rute ke login.
- [x] **Role pengguna dapat dikenali:** Profil pengguna mengenali role `seeker` dan `owner` via trigger PostgreSQL `handle_new_user()`.
- [x] **Authorization diterapkan pada UI:** Widget `RoleGuard` membatasi fitur penambahan kos khusus untuk role owner/admin.
- [x] **Authorization juga diterapkan pada database:** Row Level Security (RLS) diaktifkan pada tabel `kos`, `profiles`, dan `device_tokens`.
- [x] **Unauthorized access berhasil ditolak:** Upaya manipulasi data kos milik pengguna lain ditolak oleh RLS database (UPDATE 0 / DELETE 0).
- [x] **Firebase terintegrasi:** File `google-services.json` dan `firebase_options.dart` terhubung ke project `kosfinder-c9763`.
- [x] **Notification permission ditangani:** Meminta izin `POST_NOTIFICATIONS` secara dinamis pada saat aplikasi dijalankan.
- [x] **Device dapat diregistrasikan untuk FCM:** Token perangkat berhasil didapatkan dan disinkronkan ke tabel `device_tokens`.
- [x] **Push notification berhasil diterima:** Pesan uji coba dari Firebase Console berhasil diterima di perangkat (baik background maupun foreground).
- [x] **Implementasi diuji:** Seluruh skenario pengujian fungsional dan keamanan berhasil diverifikasi.
- [x] **Bukti screenshot tersedia:** Format dan penempatan screenshot telah disediakan secara sistematis.
- [x] **Source code di-commit secara bertahap:** Terdapat 8 commit terpisah sesuai milestone yang diminta di Worksheet 9.
- [x] **Repository telah di-push ke GitHub:** Branch `feature/auth-notification` siap dipush ke remote repository.
- [x] **Pertanyaan analisis dan refleksi selesai:** Seluruh pertanyaan dari Bagian F, J, N, V, W, dan X telah dijawab secara mendalam.
