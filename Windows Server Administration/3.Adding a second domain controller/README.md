# 3. Adding a Second Domain Controller (High Availability)

W ramach laboratorium zapewniłem redundancję usług tożsamości poprzez wdrożenie drugiego kontrolera domeny (`DC02`, IP `192.168.20.11`) w istniejącej domenie `corp.homelab.local`. Podczas promocji rozwiązałem problem uwierzytelniania wynikający z domyślnego kontekstu konta lokalnego (`DC02\Administrator` zamiast domenowego `CORP\Administrator`), a po restarcie zweryfikowałem dwukierunkową replikację bazy `NTDS` oraz synchronizację plików `SYSVOL` za pomocą silnika DFSR.

---

## Przebieg konfiguracji i zrzuty ekranu

### 1. Konfiguracja sieciowa serwera `DC02`
Nadanie statycznego adresu IPv4 (`192.168.20.11/24`) w sieci `TIER0-SERVERS` oraz wskazanie pierwszego kontrolera (`192.168.20.10`) jako preferowanego serwera DNS w celu odnalezienia domeny.

![Network configuration DC-02](./1.network%20configuration%20DC-02.JPG)

### 2. Instalacja ról AD DS oraz DNS na `DC02`
Dodanie wymaganych ról Active Directory Domain Services oraz DNS na drugim serwerze za pomocą Server Managera.

![Installing AD DS and DNS on DC02](./2.installing%20ad%20ds%20and%20dns%20on%20DC02.JPG)

### 3. Promocja `DC02` do roli Kontrolera Domeny
Dołączenie nowego kontrolera do istniejącej domeny `corp.homelab.local` z rolą Global Catalog (GC) oraz zintegrowanym serwerem DNS.

![Promoting DC02 to a domain controller](./3.promoting%20DC02%20to%20a%20domain%20controller.JPG)

### 4. Weryfikacja konfiguracji po promocji i restarcie
Sprawdzenie poprawności przypisania sufiksu domenowego, ustawień DNS oraz statusu usług domenowych po pierwszym logowaniu na konto `CORP\Administrator`.

![After promoting to domain controller](./4.after%20promoting%20to%20domain%20controller.JPG)

### 5. Widok dwóch kontrolerów w konsoli Active Directory
Potwierdzenie obecności obu obiektów kontrolerów domeny (`DC01` oraz `DC02`) w kontenerze `Domain Controllers`.

![Two domain controllers](./5.Two%20domain%20controllers.JPG)

### 6. Potwierdzenie pobrania danych i replikacji z `DC01`
Weryfikacja poprawności dwukierunkowej synchronizacji bazy katalogowej `NTDS` oraz udziałów `SYSVOL` i `NETLOGON` pomiędzy kontrolerami.

![Confirmation of data retrieval from DC01](./6.confirmation%20of%20data%20retrieval%20from%20dc01.JPG)

---

## Użyte polecenia (PowerShell / CMD)

```powershell
# Weryfikacja podsumowania replikacji między kontrolerami domeny
repadmin /replsummary

# Sprawdzenie replikacji udziałów SYSVOL i NETLOGON na nowym serwerze
net share

# Wymuszenie natychmiastowej synchronizacji wszystkich partycji
repadmin /syncall /AdeP
