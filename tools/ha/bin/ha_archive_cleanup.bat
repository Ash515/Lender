@echo off 

..\bin\pg_archivecleanup -d ..\data\ha_wal_archive "%1"
