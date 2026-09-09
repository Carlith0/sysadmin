#!/bin/bash

echo "== RAPORT SYSTEMOWY =="
echo "Data i czas: $(date)"
echo "Uzytkownik: $(whoami)"
echo "Uzycie dysku:"
df -h / | tail -n 1
echo "======================="
