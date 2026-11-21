# 1. Initial Configuration (Lab Bootstrap)

W ramach laboratorium zaprojektowałem i wdrożyłem od podstaw izolowane środowisko wirtualne w Oracle VM VirtualBox do budowy infrastruktury Active Directory. Skonfigurowałem dedykowaną sieć wewnętrzną (`TIER0-SERVERS`) oraz przeprowadziłem proces post-instalacyjny (bootstrap) maszyny bazowej z systemem Windows Server (Desktop Experience) – nadałem docelową nazwę hosta (`DC01`), skonfigurowałem statyczną adresację IP (`192.168.20.10`) oraz zsynchronizowałem strefę czasową.

---

## Przebieg konfiguracji i zrzuty ekranu

### 1. Weryfikacja właściwości systemu (System Properties)
Sprawdzenie podstawowych parametrów zainstalowanego systemu Windows Server oraz grupy roboczej przed rozpoczęciem konfiguracji domenowej.

![System Properties](./1.system%20properties.JPG)

### 2. Standaryzacja nazwy hosta (System Name)
Zmiana domyślnej, losowej nazwy maszyny na docelową nazwę zgodną ze schematem nazewnictwa infrastruktury (`DC01`).

![System Name](./2.system%20name.JPG)

### 3. Konfiguracja sieci i statycznego adresu IPv4
Konfiguracja karty sieciowej w izolowanym segmencie `TIER0-SERVERS` ze stałym adresem IP `192.168.20.10/24` oraz wskazaniem pętli zwrotnej (`127.0.0.1`) jako preferowanego serwera DNS.

![Network Configuration](./3.network%20configuration.JPG)

### 4. Synchronizacja czasu i strefy czasowej
Ustawienie właściwej strefy czasowej (`UTC+01:00`), co jest kluczowe dla przyszłego działania uwierzytelniania Kerberos oraz replikacji między kontrolerami domeny.

![Time and Date Configuration](./4.time%20and%20date%20configuration.JPG)

---

## Użyte polecenia (PowerShell)

```powershell
# Sprawdzenie konfiguracji kart sieciowych i adresacji IP
Get-NetIPConfiguration

# Konfiguracja statycznego adresu IPv4
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.20.10 -PrefixLength 24

# Zmiana nazwy serwera (wymaga restartu)
Rename-Computer -NewName "DC01" -Restart
