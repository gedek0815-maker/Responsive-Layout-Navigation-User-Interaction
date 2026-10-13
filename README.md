## Struktur Arsitektur Aplikasi

Proyek Course Explorer v2 menggunakan pemisahan tanggung jawab agar kode lebih terstruktur dan mudah dikembangkan.

- **models**: Menyimpan struktur data mata kuliah dan proses konversi data JSON menjadi objek.
- **services**: Menangani pengambilan data dari file JSON.
- **repositories**: Menjadi perantara antara Provider dan Service dalam mengakses data.
- **providers**: Mengelola state aplikasi, seperti daftar mata kuliah, status loading, error, dan favorit.
- **screens**: Menyusun halaman utama dan halaman lain yang ditampilkan kepada pengguna.
- **widgets**: Menyimpan komponen antarmuka yang dapat digunakan kembali.
- **assets/data**: Menyimpan file JSON sebagai sumber data aplikasi.

Alur dependensi aplikasi dimulai dari Screen atau Widget, dilanjutkan ke Provider, Repository, kemudian Service atau sumber data. Pemisahan ini membantu agar tampilan aplikasi tidak menangani pengambilan data secara langsung.