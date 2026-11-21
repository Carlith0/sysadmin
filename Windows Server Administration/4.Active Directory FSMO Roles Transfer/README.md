# Zarządzanie rolami FSMO oraz diagnostyka replikacji i synchronizacji czasu w Active Directory

W ramach laboratorium przećwiczyłem weryfikację oraz migrację ról FSMO między kontrolerami domeny (`DC01` i `DC02`) w PowerShellu. Po rozwiązaniu błędu RPC (`8207`) wynikającego z różnicy stref czasowych (synchronizacja czasu, `klist purge` oraz `repadmin /syncall /AdeP`) pomyślnie przeniosłem wszystkie 5 ról, a następnie przywróciłem je na `DC01`.

## Transfer vs Seizure

* **Transfer** – planowane, bezpieczne przekazanie ról między dwoma działającymi kontrolerami (np. przed pracami serwisowymi) z zachowaniem synchronizacji danych.
* **Seizure** – awaryjne przejęcie ról na siłę (`-Force`), gdy dotychczasowy serwer uległ trwałej awarii. Po tej operacji starego serwera nie wolno już nigdy włączać w tej samej sieci, aby nie zniszczyć bazy danych (ryzyko *USN Rollback*).

## Użyte polecenia

```powershell
# Sprawdzenie aktualnego rozmieszczenia ról FSMO
netdom query fsmo

# Synchronizacja czasu, odświeżenie biletów Kerberos i wymuszenie replikacji
w32tm /resync /force
klist purge
repadmin /syncall /AdeP

# Przeniesienie wszystkich 5 ról FSMO na serwer docelowy (Transfer)
Move-ADDirectoryServerOperationMasterRole -Identity "DC02" -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster -Confirm:$false
