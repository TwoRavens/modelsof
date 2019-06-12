* multfiles_rep.do
* This file is the outer-loop for each of the provincial census files and runs
* the provrouter2_rep.do that aggregates individual-level census data from the
* 2000 Census into village, subdistrict, district, and provincial-level variables
* The output data will be merged with the PODES datasets. Replication.
* Yuhki Tajima
* Updated: 25 Sept 2012




clear
use gab1200a
append villageid using gab1200b
save gab1200, replace

clear
use gab3200a
append villageid using gab3200b
append villageid using gab3200c
append villageid using gab3200d
append villageid using gab3200e
append villageid using gab3200f
save gab3200, replace

clear
use gab3300a
append villageid using gab3300b
append villageid using gab3300c
append villageid using gab3300d
save gab3300, replace

clear 
use gab3500a
append villageid using gab3500b
append villageid using gab3500c
append villageid using gab3500d
append villageid using gab3500e
append villageid using gab3500f
append villageid using gab3500g
append villageid using gab3500h
save gab3500

clear
use gab1200
do provouter2_rep
sort villageid
save censclean, replace

* List of provinces that will be analyzed separately then merged 
local filelist "gab1300 gab1400 gab1500 gab1600 gab1700 gab1800 gab1900 gab3100 gab3200 gab3300 gab3400 gab3500 gab3600 gab5100 gab5200 gab5300 gab6100 gab6200 gab6300 gab6400 gab7100 gab7200 gab7300a gab7400 gab7500 gab8100 gab8200 gab9400"

foreach file in `filelist' {
	use "`file'"
	do provouter2_rep
	drop _all

	use censclean
	append villageid using provmerged
	save censclean, replace
	drop _all
}

ren villageid id2000
sort id2000
save censclean-id, replace


*save "outfiles/`file'temp", replace
