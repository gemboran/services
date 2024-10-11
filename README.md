# Gemboran Services

Gemboran Services adalah proyek untuk mengelola service-service yang dijalankan dengan Docker Compose. Proyek ini menyediakan alat untuk memudahkan pengelolaan, deployment, dan pemeliharaan berbagai layanan dalam lingkungan Docker.

## Fitur

- Mengelola multiple services dengan Docker Compose
- Memudahkan commit perubahan service dengan bantuan AI untuk generate commit message
- Menjalankan service / Docker Compose dengan mudah
- Menyimpan konfigurasi dan file pendukung untuk setiap service

## Struktur Proyek

1. `commit`: Script untuk memudahkan proses commit perubahan service dan menghasilkan commit message dengan AI.
2. `runner`: Script untuk memudahkan menjalankan service atau Docker Compose.

Setiap service memiliki direktori sendiri yang berisi:
- `docker-compose.yaml`
- File-file pendukung yang diperlukan untuk menjalankan service

## Services

Beberapa contoh service yang dikelola dalam proyek ini:
- cloudflared
- n8n

## Cara Penggunaan

1. Untuk menambah atau mengubah service:
   - Buat atau ubah file dalam direktori service yang sesuai
   - Gunakan script `commit` untuk melakukan commit perubahan

2. Untuk menjalankan service:
   - Gunakan script `runner` kemudian pilih nama service

## Persyaratan

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)
- [Gum](https://github.com/charmbracelet/gum)
- [Mods](https://github.com/aarondl/mods)

## Kontribusi

Kontribusi untuk proyek ini sangat diterima. Silakan buat pull request atau laporkan masalah jika Anda menemukan bug atau memiliki saran perbaikan.

## Lisensi

[MIT](LICENSE)