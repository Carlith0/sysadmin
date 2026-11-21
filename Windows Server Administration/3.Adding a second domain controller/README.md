# Wysoka dostępność Active Directory – wdrożenie drugiego Kontrolera Domeny (`DC02`)

W ramach laboratorium zapewniłem redundancję usług tożsamości poprzez wdrożenie drugiego kontrolera domeny (`CORP-DC02`, IP `192.168.20.11`) w istniejącej domenie `corp.homelab.local`. Podczas promocji rozwiązałem problem uwierzytelniania wynikający z domyślnego kontekstu konta lokalnego (`DC02\Administrator` zamiast domenowego `CORP\Administrator`), a po restarcie zweryfikowałem dwukierunkową replikację bazy `NTDS` oraz synchronizację plików `SYSVOL` za pomocą silnika DFSR.

## Kluczowe elementy wdrożenia

* **Konfiguracja sieci i DNS:** Wskazanie pierwszego kontrolera (`192.168.20.10`) jako preferowanego serwera DNS przed promocją, aby umożliwić odnalezienie domeny i jej rekordów SRV.
* **Replikacja Multi-Master:** Konfiguracja `DC02` jako pełnoprawnego kontrolera z rolą Global Catalog oraz zintegrowanym serwerem DNS.
* **Audyt zdrowia replikacji:** Weryfikacja spójności bazy danych oraz braku błędów synchronizacji między `DC01` i `DC02`.

## Użyte polecenia

```powershell
# Weryfikacja podsumowania replikacji między kontrolerami domeny
repadmin /replsummary

# Sprawdzenie replikacji udziałów SYSVOL i NETLOGON na nowym serwerze
net share

# Wymuszenie natychmiastowej synchronizacji wszystkich partycji
repadmin /syncall /AdeP
