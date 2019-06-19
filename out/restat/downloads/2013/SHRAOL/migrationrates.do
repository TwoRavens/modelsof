/*Calculating migration rates*/
clear
capture log close
set matsize 1000
set memory 4g
set more off
log using migrationrates.log, replace

use year houseid FAC EST PER mujer binmigr binmigrp binmigrt using dataset, clear

svyset, clear
svyset houseid [pweight=FAC]

/*Quarterly migration rates for people older than 12*/
local quarters "200 300 400 101 201 301 401 102 202 302 402 103 203 303 403 104 204 304"
foreach quarter of local quarters {
	svy, subpop(if real(PER)==`quarter'): mean binmigr
	mat define B = e(b)
	mat define V = e(V)
	local migrate`quarter' = B[1,1]
	local lbmigrate`quarter' = `migrate`quarter'' - (1.96*sqrt(V[1,1]))
	local ubmigrate`quarter' = `migrate`quarter'' + (1.96*sqrt(V[1,1]))
	svy, subpop(if real(PER)==`quarter'): mean binmigrp
	mat define Bp = e(b)
	local migratep`quarter' = Bp[1,1]
	svy, subpop(if real(PER)==`quarter'): mean binmigrt
	mat define Bt = e(b)
	local migratet`quarter' = Bt[1,1]
	matrix drop B V Bp Bt
}
matrix input migrates12 = (`migrate200' \ `migrate300' \ `migrate400' \ `migrate101' \ `migrate201' \ `migrate301' \ `migrate401' \ `migrate102' \ `migrate202' \ `migrate302' \ `migrate402' \ `migrate103' \ `migrate203' \ `migrate303' \ `migrate403' \ `migrate104' \ `migrate204' \ `migrate304')
matrix input bounds = (`lbmigrate200',`ubmigrate200' \ `lbmigrate300',`ubmigrate300' \ `lbmigrate400',`ubmigrate400' \ `lbmigrate101',`ubmigrate101' \ `lbmigrate201',`ubmigrate201' \ `lbmigrate301',`ubmigrate301' \ `lbmigrate401',`ubmigrate401' \ `lbmigrate102',`ubmigrate102' \ `lbmigrate202',`ubmigrate202' \ `lbmigrate302',`ubmigrate302' \ `lbmigrate402',`ubmigrate402' \ `lbmigrate103',`ubmigrate103' \ `lbmigrate203',`ubmigrate203' \ `lbmigrate303',`ubmigrate303' \ `lbmigrate403',`ubmigrate403' \ `lbmigrate104',`ubmigrate104' \ `lbmigrate204',`ubmigrate204' \ `lbmigrate304',`ubmigrate304')
matrix input migrates12p = (`migratep200' \ `migratep300' \ `migratep400' \ `migratep101' \ `migratep201' \ `migratep301' \ `migratep401' \ `migratep102' \ `migratep202' \ `migratep302' \ `migratep402' \ `migratep103' \ `migratep203' \ `migratep303' \ `migratep403' \ `migratep104' \ `migratep204' \ `migratep304')
matrix input migrates12t = (`migratet200' \ `migratet300' \ `migratet400' \ `migratet101' \ `migratet201' \ `migratet301' \ `migratet401' \ `migratet102' \ `migratet202' \ `migratet302' \ `migratet402' \ `migratet103' \ `migratet203' \ `migratet303' \ `migratet403' \ `migratet104' \ `migratet204' \ `migratet304')
matrix list migrates12
matrix list bounds
matrix list migrates12p
matrix list migrates12t

/*Quarterly migration rates for people younger than 12*/
foreach quarter of local quarters {
	use men`quarter'm, clear
	svyset, clear
	svyset houseid [pweight=FAC]
	gen binmigr = binmigrp
	replace binmigr = 1 if binmigrt == 1
	svy: mean binmigr
	mat define B = e(b)
	local migrateyoung`quarter' = B[1,1]
	matrix drop B
}
matrix input migratesyoung = (`migrateyoung200' \ `migrateyoung300' \ `migrateyoung400' \ `migrateyoung101' \ `migrateyoung201' \ `migrateyoung301' \ `migrateyoung401' \ `migrateyoung102' \ `migrateyoung202' \ `migrateyoung302' \ `migrateyoung402' \ `migrateyoung103' \ `migrateyoung203' \ `migrateyoung303' \ `migrateyoung403' \ `migrateyoung104' \ `migrateyoung204' \ `migrateyoung304')
matrix list migratesyoung
