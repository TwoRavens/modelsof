*******************************************
*
*Trim CCAP 2008 Yale Content Data to exclude other content
*
*******************************************
clear
set mem 500m
use "..\SourcesFilesNotInArchive\ccap0001_yal_output_r2_1.dta", clear
     
* Items to Keep
keep caseid weight psweight profile66 profile54 profile55 profile51 profile57 profile59 profile40-profile49 oct_yal031-oct_yal072 pcap600

* Save data
save "sourcedata\YaleCCAP2008_PeersPersonalityItems.dta", replace


*******************************************
*
*Trim Yale February 2011 Survey to exclude other content
*
*******************************************
clear
use "..\SourcesFilesNotInArchive\yale020_output_final_worder.dta", clear

* Items to Keep
keep caseid weight inputstate  gender race birthyr educ income yal060_insert yal065_insert yal110-yal113 yal050a yal050b yal050c yal051a yal051b yal051c yal060a-yal066a yal060b-yal066b yal070-yal076 insert_yal110_1-insert_yal110_6 yal060a_grid_row_rnd yal060b_grid_row_rnd

* Save data
save "sourcedata\YaleFeb2011Survey_PeersPersonalityItems.dta", replace



