# Enterprise Active Directory & Windows Server Infrastructure Homelab

Kompleksowe laboratorium inżynieryjne symulujące produkcyjną infrastrukturę serwerową opartą na systemach Windows Server oraz Active Directory Domain Services (AD DS). Projekt został zaprojektowany i wdrożony od podstaw w izolowanym środowisku wirtualnym w celu praktycznego opanowania administracji systemami, zapewniania wysokiej dostępności (High Availability), zarządzania tożsamością i dostępem (IAM), wdrażania zasad bezpieczeństwa (Tiering Model, GPO) oraz automatyzacji w PowerShell.

---

## Architektura i topologia sieci

Środowisko działa w oparciu o **Oracle VM VirtualBox** z wykorzystaniem odseparowanej sieci wewnętrznej (`Internal Network: TIER0-SERVERS`), izolującej ruch krytycznych usług tożsamości (Tier 0) od sieci zewnętrznej.

| Nazwa maszyny | Rola w infrastrukturze | Adres IPv4 | Preferowany DNS | Zasoby |
| :--- | :--- | :--- | :--- | :--- |
| **`CORP-DC01`** | Primary Domain Controller, DNS, Global Catalog, posiadacz ról FSMO | `192.168.20.10/24` | `127.0.0.1` | 2 vCPU, 4 GB RAM |
| **`CORP-DC02`** | Secondary Domain Controller, DNS, Global Catalog (High Availability) | `192.168.20.11/24` | `192.168.20.10` | 2 vCPU, 4 GB RAM |
| **`CORP-FS01`** | Member Server – File Server (SMB, NTFS, DFS), Print & DHCP Server | `192.168.20.20/24` | `192.168.20.10` | 2 vCPU, 2 GB RAM |
| **`CORP-WS01`** | Stacja robocza Windows 10/11 Enterprise do testów GPO i logowania | `192.168.20.100/24` | `192.168.20.10` | 2 vCPU, 4 GB RAM |

* **Nazwa lasu i domeny:** `corp.homelab.local` (NetBIOS: `CORP`)
* **System operacyjny serwerów:** Windows Server (Desktop Experience)

---

## Mapa projektu i laboratoria

### Moduł I: Architektura wirtualizacji i sieć bazowa
* **[1.Initial configuration](./1.Initial%20configuration/README.md)**
  * Budowa izolowanej sieci wewnętrznej (`TIER0-SERVERS`), instalacja bazowego systemu Windows Server, standaryzacja nazw hostów (`Rename-Computer`) oraz konfiguracja statycznej adresacji IPv4.

### Moduł II: Active Directory Core & Identity
* **[2.Active Directory and DNS configuration](./2.Active%20Directory%20and%20DNS%20configuration/README.md)**
  * Instalacja ról AD DS i DNS, utworzenie nowego lasu `corp.homelab.local`, konfiguracja stref zintegrowanych z AD oraz weryfikacja rekordów `SRV` i udziałów `SYSVOL`/`NETLOGON`.
* **[3.Adding a second domain controller](./3.Adding%20a%20second%20domain%20controller/README.md)**
  * Promocja drugiego kontrolera w istniejącej domenie, konfiguracja replikacji Multi-Master bazy `NTDS` oraz synchronizacji plików przez silnik DFSR (`repadmin /replsummary`).
* **[4.Active Directory FSMO Roles Transfer](./4.Active%20Directory%20FSMO%20Roles%20Transfer/README.md)**
  * Weryfikacja i kontrolowany transfer wszystkich 5 ról FSMO w PowerShell (`Move-ADDirectoryServerOperationMasterRole`), analiza różnic **Transfer vs Seizure** oraz usunięcie awarii RPC (`8207`) wywołanej rozbieżnością stref czasowych (Kerberos Clock Skew).
* **[5.Organizational Units and Tiering Model](./5.Organizational%20Units%20and%20Tiering%20Model/README.md)**
  * Projektowanie hierarchii OU (Tier 0 / Tier 1 / Tier 2), wdrożenie zasady najmniejszych uprawnień (Least Privilege), delegacja uprawnień dla zespołu Helpdesk (AGDLP) oraz izolacja kont administracyjnych.

### Moduł III: Group Policy Objects (GPO) & Hardening
* **[6.Group Policy Management and Diagnostics](./6.Group%20Policy%20Management%20and%20Diagnostics/README.md)**
  * Konfiguracja zasad haseł (Fine-Grained Password Policies), mapowanie dysków sieciowych, ograniczenia dostępu do Panelu Sterowania/USB, kolejność przetwarzania (LSDOU) oraz diagnostyka za pomocą `gpupdate` i `gpresult`.
* **[7.Security Hardening and Authentication Protection](./7.Security%20Hardening%20and%20Authentication%20Protection/README.md)**
  * Wdrożenie Windows Defender Firewall przez GPO, wyłączenie przestarzałych protokołów (SMBv1, NTLMv1), ochrona kont uprzywilejowanych (Protected Users) oraz włączenie audytu zdarzeń bezpieczeństwa w Event Viewer.

### Moduł IV: Usługi Sieciowe i Serwery Plików (Member Servers)
* **[8.File Server Deployment and NTFS SMB Permissions](./8.File%20Server%20Deployment%20and%20NTFS%20SMB%20Permissions/README.md)**
  * Dołączenie serwera członkowskiego do domeny, konfiguracja udziałów sieciowych, wdrożenie Access-Based Enumeration (ABE), dysków kwotowych (FSRM) oraz rozwiązywanie konfliktów uprawnień Share vs NTFS.
* **[9.DHCP Failover and Advanced DNS Configuration](./9.DHCP%20Failover%20and%20Advanced%20DNS%20Configuration/README.md)**
  * Konfiguracja pul adresowych DHCP w trybie Load Balance / Hot Standby, rezerwacje adresów MAC, konfiguracja DNS Reverse Lookup Zones (rekordy PTR) oraz Conditional Forwarders.

### Moduł V: Automatyzacja PowerShell i Disaster Recovery
* **[10.PowerShell User Onboarding Automation](./10.PowerShell%20User%20Onboarding%20Automation/README.md)**
  * Tworzenie skryptów masowego importu pracowników z plików `.csv`, automatycznego przypisywania do grup i jednostek OU oraz raportowania nieaktywnych kont w Active Directory.
* **[11.Active Directory Backup and Disaster Recovery](./11.Active%20Directory%20Backup%20and%20Disaster%20Recovery/README.md)**
  * Włączenie kosza Active Directory, przywracanie przypadkowo usuniętych obiektów, kopie zapasowe stanu systemu (Windows Server Backup) oraz przywracanie autorytatywne i nieautorytatywne bazy NTDS w trybie DSRM.

---

## Kompetencje i stos technologiczny

* **Systemy i usługi katalogowe:** Windows Server, Active Directory Domain Services (AD DS), AD-Integrated DNS, DFS Replication (DFSR), Group Policy (GPO), DHCP Failover, File & Storage Services.
* **Bezpieczeństwo i protokoły:** Tiering Model (Tier 0/1/2), AGDLP, Kerberos, LDAP, RPC, SMBv3, NTFS Permissions, Fine-Grained Password Policies.
* **Automatyzacja i diagnostyka:** PowerShell (`ActiveDirectory`, `GroupPolicy`, `NetTCPIP`, `DnsServer`, `SmbShare`), `repadmin`, `netdom`, `gpresult`, `klist`, `w32tm`, `nslookup`.
