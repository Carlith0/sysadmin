# Wdrożenie pierwszego Kontrolera Domeny (AD DS) oraz usługi DNS

W ramach laboratorium zainstalowałem role Active Directory Domain Services (AD DS) oraz DNS na pierwszym serwerze (`DC01`), a następnie promowałem go do roli Kontrolera Domeny, tworząc nowy las i domenę `corp.homelab.local`. Zweryfikowałem poprawność utworzenia struktur bazy danych (`NTDS.dit`), udziałów sieciowych (`SYSVOL`, `NETLOGON`) oraz kluczowych rekordów `SRV` w strefie DNS.

## Kluczowe elementy wdrożenia

* **Nowy las Active Directory:** Utworzenie domeny `corp.homelab.local` wraz z rolą Global Catalog (GC) oraz zdefiniowaniem hasła trybu przywracania usług katalogowych (DSRM).
* **Zintegrowany DNS (AD-Integrated DNS):** Konfiguracja strefy wyszukiwania do przodu przechowującej rekordy lokalizacyjne (`_ldap`, `_kerberos`), niezbędne do odnajdywania kontrolera przez przyszłe hosty w sieci.
* **Weryfikacja po promocji:** Potwierdzenie działania usług katalogowych oraz udostępnienia zasobów skryptowych i polis grupowych.

## Użyte polecenia

```powershell
# Sprawdzenie udostępnionych zasobów domenowych (SYSVOL i NETLOGON)
net share

# Weryfikacja podstawowych usług Active Directory i DNS
Get-Service NTDS, DNS, Netlogon, W32Time

# Test rozwiązywania nazw i rekordów domeny
nslookup corp.homelab.local
