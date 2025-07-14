#!/bin/bash

# Получаем список серверов — как есть, многострочный
connections=$(sudo __vpn_manager list)

# Получаем статус подключения
status=$(sudo __vpn_manager status)

# Создаём массив меню
menu_list=()

# Если подключены — добавляем disconnect первым
if echo "$status" | grep -q "Connected to"; then
    menu_list+=("Disconnect")
fi

# Добавляем остальные строки как есть
while IFS= read -r line; do
    # Пропускаем пустые строки (если есть)
    [[ -z "$line" ]] && continue
    menu_list+=("$line")
done <<< "$connections"

printf "%s\n" "${menu_list[*]}"

# Запускаем wofi с меню
choice=$(printf "%s\n" "${menu_list[@]}" | dmenu --show dmenu --prompt "Выбери:" --sort-order=default)

if [[ -n "$choice" ]]; then
    if [[ "$choice" == "Disconnect" ]]; then
        sudo __vpn_manager disconnect
    else
        # Чтобы подключаться по имени сервера (второе слово в строке)
        server_name=$(echo "$choice" | awk '{print $1}')
        sudo __vpn_manager connect "$server_name"
    fi
fi

