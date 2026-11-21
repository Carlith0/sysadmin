# 4. Active Directory FSMO Roles Transfer

W ramach laboratorium przećwiczyłem weryfikację oraz migrację ról FSMO między kontrolerami domeny (`DC01` i `DC02`) w PowerShellu. Po rozwiązaniu błędu RPC (`8207`) wynikającego z różnicy stref czasowych (synchronizacja czasu, `klist purge` oraz `repadmin /syncall /AdeP`) pomyślnie przeniosłem wszystkie 5 ról, a następnie przywróciłem je na `DC01`.

## Transfer vs Seizure

* **Transfer** – planowane, bezpieczne przekazanie ról między dwoma działającymi kontrolerami (np. przed pracami serwisowymi) z zachowaniem synchronizacji danych.
* **Seizure** – awaryjne przejęcie ról na siłę (`-Force`), gdy dotychczasowy serwer uległ trwałej awarii. Po tej operacji starego serwera nie wolno już nigdy włączać w tej samej sieci, aby nie zniszczyć bazy danych (ryzyko *USN Rollback*).

---

## Przebieg konfiguracji i zrzuty ekranu

### 1. Sprawdzenie aktualnego rozmieszczenia ról FSMO (CLI)
Weryfikacja wyjściowego posiadacza wszystkich pięciu ról FSMO (`DC01.corp.homelab.local`) za pomocą polecenia `netdom query fsmo`[cite: 7].

![Checking who has FSMO](./1.checking%20who%20has%20fsmo.JPG)

### 2. Weryfikacja ról FSMO w interfejsie graficznym (GUI)
Otwarcie konsoli *Active Directory Users and Computers* (`dsa.msc`) w celu podglądu przypisania ról domenowych[cite: 7].

![FSMO GUI check 1](./2.fsmo%20GUI%20check%201.JPG)

### 3. Podgląd zakładki Operations Masters
Potwierdzenie w GUI, że role RID, PDC oraz Infrastructure są przypisane do kontrolera `DC01`[cite: 7].

![Operations Masters](./3.Operations%20Masters.JPG)

### 4. Przygotowanie do transferu ról na `DC02`
Symulacja scenariusza serwisowego (konserwacja `DC01`) wymagającego bezpiecznego przekazania wszystkich ról na zapasowy kontroler `DC02`[cite: 7].

![Master roles transfer to DC02](./4.Master%20roles%20transfer%20to%20DC02%20in%20case%20of%20DC01%20temporary%20configuration%20etc..JPG)

### 5. Wykonanie transferu ról FSMO na `DC02` w PowerShell
Przeniesienie ról `SchemaMaster`, `DomainNamingMaster`, `PDCEmulator`, `RIDMaster` oraz `InfrastructureMaster` poleceniem `Move-ADDirectoryServerOperationMasterRole`[cite: 7].

![Moving FSMO to DC02](./5.moving%20fsmo%20to%20DC02.JPG)

### 6. Potwierdzenie przejęcia ról przez `DC02`
Weryfikacja poleceniem `netdom query fsmo` potwierdzająca, że wszystkie 5 ról działa poprawnie na `DC02.corp.homelab.local`[cite: 7].

![FSMO changed to DC02 successfully](./6.FSMO%20changed%20to%20DC02%20succesfully.JPG)

### 7. Przywrócenie ról FSMO z powrotem na `DC01`
Kontrolowany zwrot ról na główny kontroler domeny po zakończeniu prac serwisowych[cite: 7].

![Moving FSMO to DC01 again](./7.after%20configuration%20etc.%20MOVING%20FSMO%20TO%20DC01%20AGAIN.JPG)

### 8. Weryfikacja powrotu do stanu początkowego
Końcowe potwierdzenie, że cała infrastruktura wróciła do architektury wyjściowej z rolami na `DC01`[cite: 7].

![Everything returned to its initial state](./8.everything%20returned%20to%20its%20initial%20state.JPG)

---

## Użyte polecenia (PowerShell)

```powershell
# Sprawdzenie aktualnego rozmieszczenia ról FSMO
netdom query fsmo

# Synchronizacja czasu, odświeżenie biletów Kerberos i wymuszenie replikacji
w32tm /resync /force
klist purge
repadmin /syncall /AdeP

# Przeniesienie wszystkich 5 ról FSMO na serwer docelowy (Transfer)
Move-ADDirectoryServerOperationMasterRole -Identity "DC02" -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster -Confirm:$false

# Przywrócenie ról z powrotem na DC01
Move-ADDirectoryServerOperationMasterRole -Identity "DC01" -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster -Confirm:$false
