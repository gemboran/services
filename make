#!/usr/bin/env bash

help() {
    echo "Penggunaan: ./service [perintah]"
    echo ""
    echo "Perintah yang tersedia:"
    echo "  up      - Menjalankan layanan"
    echo "  down    - Menghentikan layanan"
    echo "  status  - Menampilkan status layanan"
    echo "  list    - Menampilkan daftar layanan yang sedang berjalan"
    echo "  update  - Memperbarui dan me-restart layanan"
    echo "  logs    - Menampilkan log dari layanan"
    echo "  service - Membuat layanan baru"
    echo "  help    - Menampilkan pesan bantuan ini"
}

template=$(cat <<END
services:
  $name:
    container_name: $name
    networks:
      - $name-network
      - cloudflared
  
networks:
  odoo-network:
    driver: bridge
  cloudflared:
    external: true
END
)

service() {
    name=$(gum input --placeholder "Enter service name")

    gum spin --title "Creating service" mkdir $name
    gum spin --title "Creating service" mkdir $name/data
    gum spin --title "Creating service" echo "$template" > $name/docker-compose.yaml
    gum spin --title "Creating service" touch $name/.env.example
    gum spin --title "Creating service" touch $name/data/.gitkeep
}

up() {
    TYPE=$(gum choose $(ls -d */ | cut -f1 -d'/'))

    if [ -f "$TYPE/docker-compose.yaml" ]; then
        echo "Running service $TYPE"
        docker-compose -f "$TYPE/docker-compose.yaml" up -d
    else
        echo "No docker-compose.yaml file at $TYPE"
    fi
}


down() {
    TYPE=$(gum choose $(ls -d */ | cut -f1 -d'/'))

    if [ -f "$TYPE/docker-compose.yaml" ]; then
        echo "Removing service $TYPE"
        docker-compose -f "$TYPE/docker-compose.yaml" down
    else
        echo "No docker-compose.yaml file at $TYPE"
    fi
}

update() {
    TYPE=$(gum choose $(ls -d */ | cut -f1 -d'/'))

    if [ -f "$TYPE/docker-compose.yaml" ]; then
        docker-compose -f "$TYPE/docker-compose.yaml" pull
        docker-compose -f "$TYPE/docker-compose.yaml" down
        docker-compose -f "$TYPE/docker-compose.yaml" up -d
    else
        echo "No docker-compose.yaml file at $TYPE"
    fi
}

status() {
    TYPE=$(gum choose $(ls -d */ | cut -f1 -d'/'))

    if [ -f "$TYPE/docker-compose.yaml" ]; then
        docker-compose -f "$TYPE/docker-compose.yaml" ps
    else
        echo "No docker-compose.yaml file at $TYPE"
    fi
}

logs() {
    TYPE=$(gum choose $(ls -d */ | cut -f1 -d'/'))

    if [ -f "$TYPE/docker-compose.yaml" ]; then
        docker-compose -f "$TYPE/docker-compose.yaml" logs -f
    else
        echo "No docker-compose.yaml file at $TYPE"
    fi
}

list() {
    docker-compose ls
}

# Periksa apakah ada argumen yang diberikan
if [ $# -eq 0 ]; then
    help
    exit 1
fi

# Jalankan fungsi yang sesuai berdasarkan argumen
case "$1" in
    up|down|status|list|update|logs|service|help)
        "$1"
        ;;
    *)
        echo "Perintah tidak dikenal: $1"
        help
        exit 1
        ;;
esac
