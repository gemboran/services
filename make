#!/usr/bin/env bash

help() {
    gum style \
        --border normal \
        --margin "1" \
        --padding "1" \
        --border-foreground 212 \
        "$(gum style --foreground 212 'Penggunaan:') ./service [perintah]

$(gum style --foreground 99 'Perintah yang tersedia:')
  $(gum style --foreground 214 'up')      - Menjalankan layanan
  $(gum style --foreground 214 'down')    - Menghentikan layanan
  $(gum style --foreground 214 'status')  - Menampilkan status layanan
  $(gum style --foreground 214 'list')    - Menampilkan daftar layanan yang sedang berjalan
  $(gum style --foreground 214 'update')  - Memperbarui dan me-restart layanan
  $(gum style --foreground 214 'logs')    - Menampilkan log dari layanan
  $(gum style --foreground 214 'service') - Membuat layanan baru
  $(gum style --foreground 214 'help')    - Menampilkan pesan bantuan ini"
}

get_service_name() {
    if [ -n "$1" ]; then
        echo "$1"
    elif [ "$2" = "input" ]; then
        gum input --placeholder "Masukkan nama layanan"
    else
        gum choose --limit 1 --header="Pilih layanan:" $(ls -d */ | cut -f1 -d'/')
    fi
}

service() {
    name=$(get_service_name "$1" input)

    if [ -z "$name" ]; then
        gum style --foreground 196 "Nama layanan tidak boleh kosong. Proses pembuatan layanan dibatalkan."
        return 1
    fi

    template=$(cat <<END
services:
  $name:
    container_name: $name
    networks:
      - $name-network
      - cloudflared
  
networks:
  $name-network:
    driver: bridge
  cloudflared:
    external: true
END
    )

    gum spin --spinner dot --title "Membuat layanan $name" -- mkdir "$name"
    gum spin --spinner dot --title "Membuat layanan $name" -- mkdir "$name/data"
    gum spin --spinner dot --title "Membuat layanan $name" -- echo "$template" > "$name/docker-compose.yaml"
    gum spin --spinner dot --title "Membuat layanan $name" -- touch "$name/.env.example"
    gum spin --spinner dot --title "Membuat layanan $name" -- touch "$name/data/.gitkeep"

    gum style --foreground 82 "Layanan '$(gum style --foreground 214 "$name")' berhasil dibuat."
}

up() {
    name=$(get_service_name "$1")

    if [ -f "$name/docker-compose.yaml" ]; then
        gum style --foreground 82 "Menjalankan layanan $(gum style --foreground 214 "$name")"
        docker-compose -f "$name/docker-compose.yaml" up -d
    else
        gum style --foreground 196 "Tidak ada file docker-compose.yaml di $(gum style --foreground 214 "$name")"
    fi
}

down() {
    name=$(get_service_name "$1")

    if [ -f "$name/docker-compose.yaml" ]; then
        gum style --foreground 82 "Menghentikan layanan $(gum style --foreground 214 "$name")"
        docker-compose -f "$name/docker-compose.yaml" down
    else
        gum style --foreground 196 "Tidak ada file docker-compose.yaml di $(gum style --foreground 214 "$name")"
    fi
}

update() {
    name=$(get_service_name "$1")

    if [ -f "$name/docker-compose.yaml" ]; then
        gum spin --spinner dot --title "Memperbarui layanan $name" -- docker-compose -f "$name/docker-compose.yaml" pull
        gum spin --spinner dot --title "Me-restart layanan $name" -- docker-compose -f "$name/docker-compose.yaml" down
        gum spin --spinner dot --title "Menjalankan layanan $name" -- docker-compose -f "$name/docker-compose.yaml" up -d
    else
        gum style --foreground 196 "Tidak ada file docker-compose.yaml di $(gum style --foreground 214 "$name")"
    fi
}

status() {
    name=$(get_service_name "$1")

    if [ -f "$name/docker-compose.yaml" ]; then
        gum style --foreground 82 "Status layanan $(gum style --foreground 214 "$name"):"
        docker-compose -f "$name/docker-compose.yaml" ps
    else
        gum style --foreground 196 "Tidak ada file docker-compose.yaml di $(gum style --foreground 214 "$name")"
    fi
}

logs() {
    name=$(get_service_name "$1")

    if [ -f "$name/docker-compose.yaml" ]; then
        gum style --foreground 82 "Menampilkan log dari layanan $(gum style --foreground 214 "$name"):"
        docker-compose -f "$name/docker-compose.yaml" logs -f
    else
        gum style --foreground 196 "Tidak ada file docker-compose.yaml di $(gum style --foreground 214 "$name")"
    fi
}

list() {
    gum style --foreground 82 "Daftar layanan yang sedang berjalan:"
    docker-compose ls
}

# Periksa apakah ada argumen yang diberikan
if [ $# -eq 0 ]; then
    command=$(gum choose --header="Pilih perintah:" up down status list update logs service help)
    "$command"
fi

# Jalankan fungsi yang sesuai berdasarkan argumen
case "$1" in
    up|down|status|update|logs|service)
        "$1" "$2" "$3"
        ;;
    list|help)
        "$1"
        ;;
    *)
        gum style --foreground 196 "Perintah tidak dikenal: $1"
        help
        exit 1
        ;;
esac
