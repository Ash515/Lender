@echo off 

IF EXIST "ha_wal_archive\%1" (copy "ha_wal_archive\%1" "%2")
