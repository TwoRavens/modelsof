/*******************************************************************************
Run this file to replicate all tables and figures. This file also produces a log
file, "replication.log."
*******************************************************************************/

capture log close
log using replication.log, replace

foreach x in "table 1" "table 2" "table A1" "figure A1" {
	do "`x'"
}

log close
