clear
capture log close
capture program drop _all
cd "$root"
adopath + "JPP/brazhetw/ado"

log using "JPP/brazspil/logs/%stata/%2workregs/worker-level-regs-metro.log", replace

use "JPP/brazspil/data/wid/aggcnpj-workers-metro.dta"
drop nat_estb tipo_estbl grupo_base tipo_vinc sit_vinculo caus_desl cbobasestr
order wid ano identificad firmid municipio

* Generate Shares
foreach var in mne hwmne lwmne expmne nemne dom hwdom lwdom expdom nedom {
 gen `var'sh = total`var'/emp
} 

foreach var1 in layoff quit _ten1 _ten2 lowwageind highwageind indprim higheduc highocc lowocc {
foreach var2 in mne hwmne lwmne expmne nemne dom hwdom lwdom expdom nedom {
 gen `var1'_`var2'sh = `var1'_total`var2'/emp
} 
}

egen ca = group(cnae2d ano)
gen region = int(municipio/100000)
egen ra = group(region ano)
egen ea = group(identificad ano)
preserve

** TABLE 4.1 **
* OLS
reg lnwage mnesh domsh idade idadesq tenure indfem indbraz indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof, cluster(ea)
test mnesh=domsh
estimates store reg1

* Add Year Dummies
xi: reg lnwage mnesh domsh idade idadesq tenure indfem indbraz indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ano, cluster(ea)
test mnesh=domsh
estimates store reg2

* Add Establishment FE
iis identificad
xi: xtreg lnwage mnesh domsh idade idadesq tenure indfem indbraz indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ano, fe i(identificad) cluster(ea) nonest 
test mnesh=domsh
estimates store reg3

* Add Worker FE
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ano, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg4

* By Skill-Intensity of 2-Digit Sector
restore, preserve
keep if skilled==1
 tsset wid ano
 xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ano, fe i(wid) cluster(ea) nonest
 test mnesh=domsh
estimates store reg5

restore, preserve
keep if skilled==0
 tsset wid ano
 xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ano, fe i(wid) cluster(ea) nonest
 test mnesh=domsh
estimates store reg6

* Include 2-Digit-Year Dummies & Region-Year Dummies
restore, preserve
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg7

xml_tab reg1 reg2 reg3 reg4 reg5 reg6, stats(N) sheet("worker-level-regs") save("JPP/brazspil/xml/worker-level-regs-table-4-1-metro") append below
xml_tab reg7, stats(N) sheet("worker-level-regs-col5") save("JPP/brazspil/xml/worker-level-regs-table-4-1-metro") append below
estimates clear

** TABLE 4.2 **
* Include Additional Time-Varying Firm-Level Controls
* Exporter Data 
tsset wid ano
xi: xtreg lnwage mnesh domsh export numprod numprodsq numdest numdestsq idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg8

* Future Exporter Data
tsset wid ano
xi: xtreg lnwage mnesh domsh f.export f.numprod f.numprodsq f.numdest f.numdestsq export numprod numprodsq numdest numdestsq idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg9

* Future Wage Growth
tsset wid ano
xi: xtreg lnwage mnesh domsh p_lnwage_gr f.export f.numprod f.numprodsq f.numdest f.numdestsq export numprod numprodsq numdest numdestsq idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg10

* Consistent Sample
xi: xtreg lnwage mnesh domsh export numprod numprodsq numdest numdestsq idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra if e(sample), fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg11

xml_tab reg8, stats(N) sheet("worker-level-regs-col1") save("JPP/brazspil/xml/worker-level-regs-table-4-2-metro") append below
xml_tab reg9, stats(N) sheet("worker-level-regs-col2") save("JPP/brazspil/xml/worker-level-regs-table-4-2-metro") append below
*xml_tab reg10, stats(N) sheet("worker-level-regs-col3") save("JPP/brazspil/xml/worker-level-regs-table-4-2-metro") append below
xml_tab reg11, stats(N) sheet("worker-level-regs-col4") save("JPP/brazspil/xml/worker-level-regs-table-4-2-metro") append below
estimates clear

** TABLE 4.3 **
* Include High-Wage MNE Switcher Share
tsset wid ano
xi: xtreg lnwage hwmnesh lwmnesh hwdomsh lwdomsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test hwmnesh=lwmnesh
test hwmnesh=hwdomsh
test hwmnesh=lwdomsh
test lwmnesh=hwdomsh
test lwmnesh=lwdomsh
test hwdomsh=lwdomsh
estimates store reg12

* Separate into Exporters and Non-Exporters
tsset wid ano
xi: xtreg lnwage expmnesh nemnesh expdomsh nedomsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test expmnesh=nemnesh
test expmnesh=expdomsh
test expmnesh=nedomsh
test nemnesh=expdomsh
test nemnesh=nedomsh
test expdomsh=nedomsh
estimates store reg13

xml_tab reg12, stats(N) sheet("worker-level-regs-col1") save("JPP/brazspil/xml/worker-level-regs-table-4-3-metro") append below
xml_tab reg13, stats(N) sheet("worker-level-regs-col2") save("JPP/brazspil/xml/worker-level-regs-table-4-3-metro") append below
estimates clear

** TABLE 4.4 **
* By Switcher Tenure at MNE
tsset wid ano
xi: xtreg lnwage _ten2_mnesh _ten1_mnesh _ten2_domsh _ten1_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test _ten2_mnesh=_ten1_mnesh
test _ten2_mnesh=_ten2_domsh
test _ten2_mnesh=_ten1_domsh
test _ten1_mnesh=_ten2_domsh
test _ten1_mnesh=_ten1_domsh
test _ten2_domsh=_ten1_domsh
estimates store reg14

* By Type of Switcher
tsset wid ano
xi: xtreg lnwage layoff_mnesh layoff_domsh quit_mnesh quit_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test layoff_mnesh=layoff_domsh
test layoff_mnesh=quit_mnesh
test layoff_mnesh=quit_domsh
test layoff_domsh=quit_mnesh
test layoff_domsh=quit_domsh
test quit_mnesh=quit_domsh
estimates store reg15

xml_tab reg14, stats(N) sheet("worker-level-regs-col1") save("JPP/brazspil/xml/worker-level-regs-table-4-4-metro") append below
xml_tab reg15, stats(N) sheet("worker-level-regs-col2") save("JPP/brazspil/xml/worker-level-regs-table-4-4-metro") append below
estimates clear

** TABLE 5.1 **
* By Switcher Skill-Level
* By Education
tsset wid ano
xi: xtreg lnwage higheduc_mnesh indprim_mnesh higheduc_domsh indprim_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test higheduc_mnesh=indprim_mnesh
test higheduc_mnesh=higheduc_domsh
test higheduc_mnesh=indprim_domsh
test indprim_mnesh=higheduc_domsh
test indprim_mnesh=indprim_domsh
test higheduc_domsh=indprim_domsh
estimates store reg16

* By Occupation
tsset wid ano
xi: xtreg lnwage highocc_mnesh lowocc_mnesh highocc_domsh lowocc_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test highocc_mnesh=lowocc_mnesh
test highocc_mnesh=highocc_domsh
test highocc_mnesh=lowocc_domsh
test lowocc_mnesh=highocc_domsh
test lowocc_mnesh=lowocc_domsh
test highocc_domsh=lowocc_domsh
estimates store reg17

* By Ability
tsset wid ano
xi: xtreg lnwage highwageind_mnesh lowwageind_mnesh highwageind_domsh lowwageind_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test highwageind_mnesh=lowwageind_mnesh
test highwageind_mnesh=highwageind_domsh
test highwageind_mnesh=lowwageind_domsh
test lowwageind_mnesh=highwageind_domsh
test lowwageind_mnesh=lowwageind_domsh
test highwageind_domsh=lowwageind_domsh
estimates store reg18

xml_tab reg16, stats(N) sheet("worker-level-regs-col1") save("JPP/brazspil/xml/worker-level-regs-table-5-1-metro") append below
xml_tab reg17, stats(N) sheet("worker-level-regs-col2") save("JPP/brazspil/xml/worker-level-regs-table-5-1-metro") append below
xml_tab reg18, stats(N) sheet("worker-level-regs-col3") save("JPP/brazspil/xml/worker-level-regs-table-5-1-metro") append below
estimates clear

** TABLE 5.2 **
* By Incumbent Skill-Level
* By Education
restore, preserve
keep if indprim==1
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg19

restore, preserve
keep if higheduc==1
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg20

* By Occupation
restore, preserve
keep if lowocc==1
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg21

restore, preserve
keep if highocc==1
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg22

* By Ability
restore, preserve
keep if lowwageind==1
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg23

restore, preserve
keep if highwageind==1
tsset wid ano
xi: xtreg lnwage mnesh domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test mnesh=domsh
estimates store reg24

xml_tab reg19 reg20, stats(N) sheet("worker-level-regs-educ") save("JPP/brazspil/xml/worker-level-regs-table-5-2-metro") append below
xml_tab reg21 reg22, stats(N) sheet("worker-level-regs-occ") save("JPP/brazspil/xml/worker-level-regs-table-5-2-metro") append below
xml_tab reg23 reg24, stats(N) sheet("worker-level-regs-ability") save("JPP/brazspil/xml/worker-level-regs-table-5-2-metro") append below
estimates clear

** TABLE 5.3
* By Switcher and Incumbent Skill Level
* By Education
restore, preserve
keep if indprim==1
tsset wid ano
xi: xtreg lnwage higheduc_mnesh indprim_mnesh higheduc_domsh indprim_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test higheduc_mnesh=indprim_mnesh
test higheduc_mnesh=higheduc_domsh
test higheduc_mnesh=indprim_domsh
test indprim_mnesh=higheduc_domsh
test indprim_mnesh=indprim_domsh
test higheduc_domsh=indprim_domsh
estimates store reg25

restore, preserve
keep if higheduc==1
tsset wid ano
xi: xtreg lnwage higheduc_mnesh indprim_mnesh higheduc_domsh indprim_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test higheduc_mnesh=indprim_mnesh
test higheduc_mnesh=higheduc_domsh
test higheduc_mnesh=indprim_domsh
test indprim_mnesh=higheduc_domsh
test indprim_mnesh=indprim_domsh
test higheduc_domsh=indprim_domsh
estimates store reg26

* By Occupation
restore, preserve
keep if lowocc==1
tsset wid ano
xi: xtreg lnwage highocc_mnesh lowocc_mnesh highocc_domsh lowocc_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test highocc_mnesh=lowocc_mnesh
test highocc_mnesh=highocc_domsh
test highocc_mnesh=lowocc_domsh
test lowocc_mnesh=highocc_domsh
test lowocc_mnesh=lowocc_domsh
test highocc_domsh=lowocc_domsh
estimates store reg27

restore, preserve
keep if highocc==1
tsset wid ano
xi: xtreg lnwage highocc_mnesh lowocc_mnesh highocc_domsh lowocc_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test highocc_mnesh=lowocc_mnesh
test highocc_mnesh=highocc_domsh
test highocc_mnesh=lowocc_domsh
test lowocc_mnesh=highocc_domsh
test lowocc_mnesh=lowocc_domsh
test highocc_domsh=lowocc_domsh
estimates store reg28

* By Ability
restore, preserve
keep if lowwageind==1 
tsset wid ano
xi: xtreg lnwage highwageind_mnesh lowwageind_mnesh highwageind_domsh lowwageind_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test highwageind_mnesh=lowwageind_mnesh
test highwageind_mnesh=highwageind_domsh
test highwageind_mnesh=lowwageind_domsh
test lowwageind_mnesh=highwageind_domsh
test lowwageind_mnesh=lowwageind_domsh
test highwageind_domsh=lowwageind_domsh
estimates store reg29

restore, preserve
keep if highwageind==1 
tsset wid ano
xi: xtreg lnwage highwageind_mnesh lowwageind_mnesh highwageind_domsh lowwageind_domsh idade idadesq tenure indhigh indgrad indsklb indwhit indprof p_lnsize p_tenure p_indfem p_indhigh p_indgrad p_indsklb p_indwhit p_indprof i.ca i.ra, fe i(wid) cluster(ea) nonest
test highwageind_mnesh=lowwageind_mnesh
test highwageind_mnesh=highwageind_domsh
test highwageind_mnesh=lowwageind_domsh
test lowwageind_mnesh=highwageind_domsh
test lowwageind_mnesh=lowwageind_domsh
test highwageind_domsh=lowwageind_domsh
estimates store reg30

xml_tab reg25 reg26, stats(N) sheet("worker-level-regs-educ") save("JPP/brazspil/xml/worker-level-regs-table-5-3-metro") append below
xml_tab reg27 reg28, stats(N) sheet("worker-level-regs-occ") save("JPP/brazspil/xml/worker-level-regs-table-5-3-metro") append below
xml_tab reg29 reg30, stats(N) sheet("worker-level-regs-ability") save("JPP/brazspil/xml/worker-level-regs-table-5-3-metro") append below
estimates clear

log close