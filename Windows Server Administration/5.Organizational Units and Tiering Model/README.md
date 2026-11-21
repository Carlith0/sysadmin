# 5. Organizational Units and Tiering Model

W ramach laboratorium zaprojektowałem i wdrożyłem hierarchiczną strukturę Jednostek Organizacyjnych (OU) w oparciu o model bezpieczeństwa **Enterprise Access Model (Tiering: Tier 0 / Tier 1 / Tier 2)**. Oddzieliłem zwykłe konta użytkowników od uprzywilejowanych kont administracyjnych (z prefiksem `adm_`), wdrożyłem zarządzanie uprawnieniami metodą **AGDLP** (*Account -> Global Group -> Domain Local Group -> Permission*), skonfigurowałem delegację uprawnień dla zespołu wsparcia Helpdesk oraz zweryfikowałem spójność całej hierarchii i list kontroli dostępu (ACL) w PowerShellu.

---

## Przebieg konfiguracji i zrzuty ekranu

### 1. Projekt docelowej struktury Jednostek Organizacyjnych (OU)
Założenia architektoniczne drzewa `_CORP` z podziałem na krytyczną infrastrukturę tożsamości (`Tier0_Infrastructure`), serwery aplikacyjne (`Tier1_Servers`), stacje robocze (`Tier2_Workstations`), działy firmy (`Users_Departments`) oraz grupy (`Groups`).

![Docelowa struktura OU](./01.docelowa%20struktura%20ou.JPG)

### 2. Tworzenie Jednostek Organizacyjnych w konsoli `dsa.msc`
Budowa hierarchii w *Active Directory Users and Computers* z włączoną ochroną przed przypadkowym usunięciem (*Protect container from accidental deletion*).

![Creating organizational units](./02.Creating%20organizational%20units.JPG)

### 3. Weryfikacja utworzonej struktury OU w GUI
Kompletne drzewo kontenerów wewnątrz jednostki `_CORP` widoczne w konsoli Active Directory.

![Organizational units structure](./03.organizational%20units%20structure.JPG)

### 4. Tworzenie kont użytkowników
Rozpoczęcie konfiguracji testowych kont domenowych wewnątrz dedykowanych jednostek organizacyjnych działów.

![New users](./04.New%20users.JPG)

### 5. Utworzenie konta pracownika działu HR (`anowak`)
Konfiguracja standardowego konta użytkownika dla Anny Nowak w jednostce `HR`.

![Regular user Anna Nowak](./05.Regular%20user%20anna%20nowak.JPG)

### 6. Konfiguracja hasła i zasad logowania użytkownika
Ustawienie hasła domenowego oraz opcji wymuszania zmiany hasła przy pierwszym logowaniu.

![Setting password and user must change password at next logon](./06.Setting%20password%20and%20user%20must%20change%20password%20at%20next%20logon.JPG)

### 7. Potwierdzenie utworzenia konta w dziale HR
Obiekt `Anna Nowak` prawidłowo umieszczony w `OU=HR,OU=Users_Departments`.

![Created user](./07.Created%20user.JPG)

### 8. Utworzenie zwykłego konta dla pracownika IT (`jkowalski`)
Konfiguracja podstawowego konta użytkownika Jana Kowalskiego do codziennej pracy (poczta, przeglądanie zasobów) w jednostce `IT`.

![Created regular user Jan Kowalski in IT department](./08.Created%20regular%20user%20jan%20kowalski%20in%20it%20depratment.JPG)

### 9. Utworzenie dedykowanego konta administracyjnego Tier 2 (`adm_jkowalski_t2`)
Rozdzielenie uprawnień zgodnie z modelem Tiering – utworzenie odrębnego konta administracyjnego dla wsparcia Helpdesk w `OU=Admins_Helpdesk,OU=Tier2_Workstations`.

![Creating Tier 2 admin helpdesk account for Jan Kowalski](./09.Creating%20tier%202%20admin%20helpdesk%20account%20for%20jan%20kowalski.JPG)

### 10. Utworzenie grupy zabezpieczeń dla administratorów Tier 2 (AGDLP)
Konfiguracja grupy globalnej `GG_Tier2_Helpdesk_Admins` w kontenerze `Security_Roles`.

![Global group for admins from Tier 2 helpdesk](./10.Global%20group%20for%20admins%20from%20tier2%20helpdesk.JPG)

### 11. Przypisanie konta administracyjnego do grupy zabezpieczeń
Dodanie użytkownika `adm_jkowalski_t2` do grupy `GG_Tier2_Helpdesk_Admins`.

![Adding admin acc Jan Kowalski to the appropriate group](./11.Adding%20admin%20acc%20jan%20kowalski%20to%20the%20appropriate%20group.JPG)

### 12. Uruchomienie kreatora delegacji kontroli (Delegation of Control Wizard)
Rozpoczęcie procesu przekazywania ściśle ograniczonych uprawnień administracyjnych na poziomie jednostki `Users_Departments`.

![Delegation of controls](./12.Delegation%20of%20controls.JPG)

### 13. Wskazanie grupy docelowej do delegacji uprawnień
Przypisanie grupy `GG_Tier2_Helpdesk_Admins` jako odbiorcy uprawnień w kreatorze delegacji.

![Delegation of control to admins Tier 2 over Users_Departments OU](./13.Delegation%20of%20control%20to%20adminst%20tier2%20over%20user%20departments%20ou.JPG)

### 14. Nadanie uprawnień zgodnych z zasadą najmniejszych uprawnień (Least Privilege)
Ograniczenie zakresu działań Helpdesku wyłącznie do tworzenia/zarządzania kontami użytkowników oraz resetowania ich haseł w obrębie działów firmy.

![Setting reasonable rights](./14.Setting%20reasonable%20rights.JPG)

### 15. Audyt hierarchii Jednostek Organizacyjnych w PowerShell
Weryfikacja spójności drzewa i ścieżek `DistinguishedName` wszystkich utworzonych kontenerów poleceniem `Get-ADOrganizationalUnit`.

![Hierarchy audit in PowerShell](./15.hierarchy%20audit%20in%20powershell.JPG)

### 16. Audyt utworzonych użytkowników w PowerShell
Potwierdzenie poprawnego rozmieszczenia kont testowych oraz konta `adm_jkowalski_t2` w odpowiednich jednostkach OU.

![Added users in PowerShell](./16.Added%20users%20in%20powershell.JPG)

### 17. Weryfikacja listy kontroli dostępu (ACL) dla grupy Helpdesk
Audyt wpisów zabezpieczeń (`Get-Acl`) potwierdzający nadanie uprawnień `GenericAll` oraz `CreateChild, DeleteChild` grupie `GG_Tier2_Helpdesk_Admins` na kontenerze `Users_Departments`.

![Admins rights over Users_Departments OU](./17.Admins%20ritghts%20over%20Users%20deprartments%20ou.JPG)

---

## Użyte polecenia audytowe (PowerShell)

```powershell
# 1. Audyt całej hierarchii OU wewnątrz gałęzi _CORP
Get-ADOrganizationalUnit -Filter * -SearchBase "OU=_CORP,DC=corp,DC=homelab,DC=local" | Select-Object Name, DistinguishedName | Sort-Object DistinguishedName | Format-Table -AutoSize

# 2. Sprawdzenie utworzonych użytkowników i ich przypisania do OU
Get-ADUser -Filter * -SearchBase "OU=_CORP,DC=corp,DC=homelab,DC=local" | Select-Object Name, SamAccountName, DistinguishedName | Format-Table -AutoSize

# 3. Sprawdzenie członków grupy Helpdesk (AGDLP)
Get-ADGroupMember -Identity "GG_Tier2_Helpdesk_Admins" | Select-Object Name, SamAccountName

# 4. Audyt delegacji uprawnień (ACL) na jednostce Users_Departments
(Get-Acl "AD:\OU=Users_Departments,OU=_CORP,DC=corp,DC=homelab,DC=local").Access | Where-Object { $_.IdentityReference -like "*GG_Tier2_Helpdesk_Admins*" } | Select-Object IdentityReference, ActiveDirectoryRights, AccessControlType
