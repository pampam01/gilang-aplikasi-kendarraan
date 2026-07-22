# Aplikasi Pengelolaan dan Klasifikasi Aset Kendaraan Daerah Kabupaten Muaro Jambi

Prototype UI untuk Aplikasi Pengelolaan dan Klasifikasi Aset Kendaraan Daerah di Badan Pengelolaan Keuangan dan Aset Daerah (BPKAD) Kabupaten Muaro Jambi.

## Deskripsi Singkat
Aplikasi ini dikembangkan sebagai prototype (tahap pertama) dengan fokus pada antarmuka pengguna (UI), pengalaman pengguna (UX), dan navigasi. Seluruh data yang ditampilkan bersifat simulasi (dummy) dan disimpan di dalam memori lokal aplikasi.

## Daftar Fitur Prototype
*   **Splash Screen & Autentikasi**: Tampilan awal dan login khusus Admin.
*   **Dashboard Utama**: Ringkasan data (Total Kendaraan, OPD, Kondisi), grafik kondisi, dan menu cepat.
*   **Manajemen Pengguna**: CRUD pengguna (simulasi lokal).
*   **Manajemen OPD**: CRUD Data Organisasi Perangkat Daerah (simulasi lokal).
*   **Manajemen Kendaraan**: CRUD data kendaraan, detail kendaraan, pencarian, dan penyaringan berdasarkan jenis, kondisi, dan status (simulasi lokal).
*   **Klasifikasi Kendaraan**: Halaman simulasi hasil klasifikasi kendaraan berdasarkan berbagai kategori.
*   **Laporan**: Pembuatan laporan (simulasi preview laporan) dan filter data untuk ekspor PDF.
*   **Profil**: Halaman profil pengguna aktif dan logout.

## Teknologi yang Digunakan
*   **Flutter** (Versi stabil terbaru)
*   **Dart** (Null safety)
*   **Material Design 3**
*   **go_router** (Routing dan navigasi)
*   **flutter_riverpod** (State management)
*   **google_fonts** (Tipografi - Inter)
*   **fl_chart** (Visualisasi grafik)

## Cara Menjalankan Aplikasi
1.  Pastikan Flutter SDK sudah terpasang.
2.  Buka terminal/command prompt dan arahkan ke direktori proyek.
3.  Jalankan perintah untuk mengunduh dependensi:
    ```bash
    flutter pub get
    ```
4.  Jalankan aplikasi (disarankan menggunakan emulator atau perangkat fisik Android/iOS):
    ```bash
    flutter run
    ```

## Kredensial Demo (Simulasi Login)
Gunakan kredensial berikut untuk masuk ke dalam aplikasi:
*   **Username:** admin
*   **Password:** admin

## Batasan Prototype
*   **Data Bersifat Sementara:** Aplikasi ini menggunakan *Mock Repository*. Semua perubahan data (tambah, edit, hapus) hanya tersimpan di memori saat aplikasi berjalan dan akan hilang saat aplikasi ditutup (restart).
*   **Belum Terintegrasi Backend:** Tidak ada koneksi ke REST API, database (MySQL, Firebase, dll).
*   **Ekspor PDF:** Fitur cetak PDF saat ini hanya menampilkan notifikasi UI (SnackBar) dan halaman preview laporan.

## Rencana Integrasi Backend (Tahap Berikutnya)
Pada tahap pengembangan selanjutnya, aplikasi ini direncanakan akan diintegrasikan dengan:
*   REST API menggunakan framework backend (seperti Laravel atau Node.js).
*   Database relasional (seperti MySQL) untuk penyimpanan data secara permanen.
*   Autentikasi menggunakan JWT/Token.
*   Generator PDF untuk mencetak laporan.
*   Sistem manajemen role dan permission yang komprehensif.

## Struktur Folder (Arsitektur)
Proyek ini mengadopsi struktur berbasis fitur (feature-based):
*   `lib/core`: Konfigurasi warna, rute, ukuran, utils, dll.
*   `lib/data`: Mock data dan repositories.
*   `lib/features`: Fitur-fitur aplikasi (auth, dashboard, opd, vehicles, dll).
*   `lib/models`: Definisi struktur model entitas.
*   `lib/shared`: Widget-widget reusable (komponen UI bersama).
