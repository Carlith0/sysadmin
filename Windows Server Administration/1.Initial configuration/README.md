# Inicjalizacja środowiska wirtualnego i sieci (Lab Bootstrap)

W ramach laboratorium zaprojektowałem i wdrożyłem od podstaw izolowane środowisko wirtualne w Oracle VM VirtualBox do budowy infrastruktury Active Directory. Skonfigurowałem dedykowaną sieć wewnętrzną (`TIER0-SERVERS`) oraz przeprowadziłem proces post-instalacyjny (bootstrap) maszyny bazowej z systemem Windows Server (Desktop Experience) – nadałem docelową nazwę hosta (`CORP-DC01`), skonfigurowałem statyczną adresację IP (`192.168.20.10`) oraz zsynchronizowałem strefę czasową.

## Kluczowe elementy konfiguracji

* **Wirtualizacja i sieć:** Izolowana sieć wewnętrzna (`Internal Network: TIER0-SERVERS`) eliminująca konflikty z siecią domową i symulująca odseparowany segment serwerowy Tier 0.
* **Adresacja statyczna:** Stały adres IPv4 (`192.168.20.10/24`) gwarantujący przewidywalną komunikację usług katalogowych oraz DNS.
* **Standaryzacja systemu:** Zmiana nazwy komputera (`Rename-Computer`) oraz przygotowanie bazy pod instalację ról serwerowych.

## Użyte polecenia

```powershell
# Sprawdzenie konfiguracji kart sieciowych i adresacji IP
Get-NetIPConfiguration

# Zmiana nazwy serwera (wymaga restartu)
Rename-Computer -NewName "DC01" -Restart
