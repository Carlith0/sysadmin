#!/bin/bash

#zmienne konfiguracyjne
SOURCE_DIR="$HOME/projekty/devops-start/data_to_backup"
BACKUP_DIR="$HOME/projekty/devops-start/backup_storage"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"

#funkcja do tworzenia logow
log_message() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

#Sprawdzenie czy katalog zrodlowy istnieje
if [ ! -d "$SOURCE_DIR" ]; then
	log_message "BLAD: Katalog zrodlowy $SOURCE_DIR nie istnieje!"
	exit 1
fi

#Tworzenie archiwum
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" . 2>/dev/null

#Weryfikacja kodu wyjscia komendy tar
if [ $? -eq 0 ]; then
	log_message "SUKCES: Utworzonoo backup $BACKUP_FILE"
else
	log_message "BLAD: NIe udalo sie utworzyc backupu!"
	exit 2
fi

#rotacja: usuwanie kopii starszych niz 7 dni
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -exec rm {} \;
log_message "INFO: Wyczyszcozno stare kopie zapasowe"
