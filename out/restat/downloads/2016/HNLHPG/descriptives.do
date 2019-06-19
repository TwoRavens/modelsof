***	This file produces tables 1, 2 and figures 1, 2.
*	NB: the file rebuilds the data set including financial companies for table 1.

********************************************************************************
********************************************************************************

***	Data preparation ***********************************************************

use Dataset_MiDi_August2010.dta, clear

merge m:1 lan jhr using "tax rates.dta"
drop _merge

* relevant years
drop if jhr < 2001
* only direct FDI
keep if bil == 1 | bil == 2

* degree of participation
drop if ppu < 100
* misclassified holding companies I 
* (parents for which sales and employees are zero throughout are very likely misclassified holdings)
sort num jhr nu2
by num: egen mean_br1 = mean(br1)
gen dum7490 = (br1 == 7490)
by num: egen potHLD = max(dum7490)

* sector restriction
drop if br1 == 7490 | br1 == 7560 | br1 == 7570 | br1 == 7580 | br1 == 7590 | br1 == 9550 | br1 == 9560 | br1 == 9600

* misclassified holding companies II
* (parents for which sales and employees are zero throughout are very likely misclassified holdings)
sort num jhr nu2
by num: egen mean_sales = mean(pm5)
by num: egen mean_emplo = mean(pm6)
drop if mean_sales == 0 & mean_emplo == 0 & potHLD == 1
drop mean_br1 dum7490 potHLD mean_sales mean_emplo

* implausible sales/balance sheet total figures
drop if pm4 < 1000 & pm4 > 0 | pm5 < 1000 & pm5 > 0

* parents for which figures from consolidated statement are available and equal to figures for parent for other years are assigned figures from consolidated statement
gen pm4_copy = pm4
gen pm5_copy = pm5
gen pm6_copy = pm6
gen pm4_CFS = (pm4 != pm7) if pm4 != 0
gen pm5_CFS = (pm5 != pm8) if pm5 != 0
gen pm6_CFS = (pm6 != pm9) if pm6 != 0
sort num jhr
by num: egen equal_pm4 = mean(pm4_CFS)
by num: egen equal_pm5 = mean(pm5_CFS)
by num: egen equal_pm6 = mean(pm6_CFS)
replace pm4 = pm7 if pm4_copy == 0 & pm5_copy == 0 & pm6_copy == 0 & equal_pm5 == 0 & equal_pm6 == 0 & equal_pm4 == 0
replace pm5 = pm8 if pm4_copy == 0 & pm5_copy == 0 & pm6_copy == 0 & equal_pm5 == 0 & equal_pm6 == 0 & equal_pm4 == 0
replace pm6 = pm9 if pm4_copy == 0 & pm5_copy == 0 & pm6_copy == 0 & equal_pm5 == 0 & equal_pm6 == 0 & equal_pm4 == 0
drop pm4_copy pm5_copy pm6_copy pm4_CFS pm5_CFS pm6_CFS equal_pm4 equal_pm5 equal_pm6

* harmonization of sector definitions (two digit NACE rev. 1.1 for all firms)
replace br1 = int(br1 / 100) * 100
replace br2 = int(br2 / 100) * 100

***	Variable definition ********************************************************

gen aff_haven = 0
replace aff_haven = 1 if lan==43 | lan==446 | lan==459 | lan==453 | lan==640 | lan==469 | lan==421 | lan==413 | lan==468 | lan==461 | ///
	lan==463 | lan==107 | lan==108 | lan==109 | lan==837 | lan==600 | lan==460 | lan==44 | lan==473 | lan==740 | lan==7 | lan==628 | ///
	lan==604 | lan==268 | lan==37 | lan==4 | lan==667 | lan==46 | lan==824 | lan==743 | lan==470 | lan==465 | lan==478 | lan==442 | ///
	lan==449 | lan==467 | lan==706 | lan==39 | lan==454 | lan==816
sort num jhr
by num jhr: egen have_haven = max(aff_haven)

keep if jhr >= 2002

//potentiell loeschen
	gen d_manu = 0
replace d_manu = 1 if br1 > 1400 & br1 < 4000
gen d_finc = 0
replace d_finc = 1 if br1 == 6500 | br1 == 6600 | br1 == 6700 | br1 == 7000 
gen d_serv = 0
replace d_serv = 1 if br1 >= 5000 & br1 <= 9300 & d_finc == 0
//potentiell loeschen

********************************************************************************
********************************************************************************

***	Table 1 ********************************************************************

gen d_sector = .
replace d_sector = 1 if br1 > 1400 & br1 < 4000 // manufacturing firms
replace d_sector = 2 if br1 >= 5000 & br1 <= 9300 // service firms
replace d_sector = 3 if br1 == 6500 | br1 == 6600 | br1 == 6700 | br1 == 7000 // financial firms

gen aff_sector = .
replace aff_sector = 1 if br2 > 1400 & br2 < 4000 // manufacturing firms
replace aff_sector = 2 if br2 >= 5000 & br2 <= 9300 // service firms
replace aff_sector = 3 if br2 == 6500 | br2 == 6600 | br2 == 6700 | br2 == 7000 // financial firms

*	Upper panel
sort num jhr
egen flg_parjhr = tag(num jhr)
tab d_sector if flg_parjhr == 1
tab d_sector if flg_parjhr == 1 & have_haven == 1

sort num jhr aff_haven
gen nohav = 0
replace nohav = 1 if aff_haven == 0
by num jhr: egen has_nhaff = max(nohav)

tab d_sector has_nhaff if flg_parjhr == 1 & have_haven == 1, row

by num jhr: egen count_thaff = sum(aff_haven)
gen mult_thaff = (count_thaff > 1)

tab d_sector mult_thaff if flg_parjhr == 1 & have_haven == 1, row

*	Middle panel
tab d_sector aff_haven
bys d_sector: tab2 aff_sector aff_haven, col missing

bys num jhr aff_haven: egen count_aff = count(nu2)
egen flg_parjhrhav = tag(num jhr aff_haven)
table aff_haven d_sector if flg_parjhrhav == 1, contents(mean count_aff)

*	Lower panel
sort lan d_sector jhr
by lan d_sector: egen affparlan = count(num) // confidentiality

count if d_sector == 1 & aff_haven == 1 // sum
tabulate lan if d_sector == 1 & aff_haven == 1 & affparlan > 2, nolabel
count if d_sector == 2 & aff_haven == 1 // sum
tabulate lan if d_sector == 2 & aff_haven == 1 & affparlan > 2, nolabel
count if d_sector == 3 & aff_haven == 1
tabulate lan if d_sector == 3 & aff_haven == 1 & affparlan > 2, nolabel

sort lan jhr num
egen flg_parth = tag(lan jhr num) if lan==43 | lan==446 | lan==459 | lan==453 | lan==640 | lan==469 | lan==421 | lan==413 | lan==468 | lan==461 | ///
 lan==463 | lan==107 | lan==108 | lan==109 | lan==837 | lan==600 | lan==460 | lan==44 | lan==473 | lan==740 | lan==7 | lan==628 | ///
 lan==604 | lan==268 | lan==37 | lan==4 | lan==667 | lan==46 | lan==824 | lan==743 | lan==470 | lan==465 | lan==478 | lan==442 | ///
 lan==449 | lan==467 | lan==706 | lan==39 | lan==454 | lan==816

sort lan d_sector jhr
by lan d_sector: egen numparlan = total(flg_parth) // confidentiality

count if flg_parth == 1 & d_sector == 1 
tabstat flg_parth if d_sector == 1 & numparlan > 2 & (lan==43 | lan==446 | lan==459 | lan==453 | lan==640 | lan==469 | lan==421 | lan==413 | lan==468 | lan==461 | ///
 lan==463 | lan==107 | lan==108 | lan==109 | lan==837 | lan==600 | lan==460 | lan==44 | lan==473 | lan==740 | lan==7 | lan==628 | ///
 lan==604 | lan==268 | lan==37 | lan==4 | lan==667 | lan==46 | lan==824 | lan==743 | lan==470 | lan==465 | lan==478 | lan==442 | ///
 lan==449 | lan==467 | lan==706 | lan==39 | lan==454 | lan==816), by(lan) statistics(sum) 
count if flg_parth == 1 & d_sector == 2
tabstat flg_parth if d_sector == 2 & numparlan > 2 & (lan==43 | lan==446 | lan==459 | lan==453 | lan==640 | lan==469 | lan==421 | lan==413 | lan==468 | lan==461 | ///
 lan==463 | lan==107 | lan==108 | lan==109 | lan==837 | lan==600 | lan==460 | lan==44 | lan==473 | lan==740 | lan==7 | lan==628 | ///
 lan==604 | lan==268 | lan==37 | lan==4 | lan==667 | lan==46 | lan==824 | lan==743 | lan==470 | lan==465 | lan==478 | lan==442 | ///
 lan==449 | lan==467 | lan==706 | lan==39 | lan==454 | lan==816), by(lan) statistics(sum) 
count if flg_parth == 1 & d_sector == 3
tabstat flg_parth if d_sector == 3 & numparlan > 2 & (lan==43 | lan==446 | lan==459 | lan==453 | lan==640 | lan==469 | lan==421 | lan==413 | lan==468 | lan==461 | ///
 lan==463 | lan==107 | lan==108 | lan==109 | lan==837 | lan==600 | lan==460 | lan==44 | lan==473 | lan==740 | lan==7 | lan==628 | ///
 lan==604 | lan==268 | lan==37 | lan==4 | lan==667 | lan==46 | lan==824 | lan==743 | lan==470 | lan==465 | lan==478 | lan==442 | ///
 lan==449 | lan==467 | lan==706 | lan==39 | lan==454 | lan==816), by(lan) statistics(sum) 

********************************************************************************

***	Table 2 ********************************************************************

use Data_toUse.dta, clear 

label variable have_haven "Have haven"
label variable ln_pemployees "Ln (# parent employees)"
label variable ln_nhemployees "Ln (# non-haven employees)"
label variable aveemp_nhtax "Average foreign non-haven tax rate"
label variable instr_2001 "Average tax rate at 2001 non-haven locations"

label variable ln_nhgdp "Average market size"
label variable ln_nhdist "Average distance"
label variable nh_rq "Average regulatory quality"
label variable nh_rl "Average rule of law"
label variable nh_corr "Average control of corruption"

gen pm6_k = pm6/1000
label variable pm6_k "\# parent employees (in 1,000)"
gen nonh_emp_k = nonh_employees/1000
label variable nonh_emp_k "\# non-haven employees (in 1,000)"
replace aveemp_nhtax = aveemp_nhtax/100
replace instr_2001 = instr_2001/100

qui tab jhr, gen(Djhr)
qui {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr*, vce(robust)
	}
eststo sumsfull: estpost tabstat have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001 ln_nhgdp ln_nhdist nh_rq nh_rl nh_corr if e(sample), statistics(N mean sd) columns(statistics)
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr* if d_manu == 1, vce(robust)
	}
eststo sumsmanu: estpost tabstat have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001 ln_nhgdp ln_nhdist nh_rq nh_rl nh_corr if e(sample), statistics(N mean sd) columns(statistics)
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr* if d_serv == 1, vce(robust)
	}
eststo sumsserv: estpost tabstat have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001 ln_nhgdp ln_nhdist nh_rq nh_rl nh_corr if e(sample), statistics(N mean sd) columns(statistics) 
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr*, vce(robust)
	}
eststo difffull: estpost ttest have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001 ln_nhgdp ln_nhdist nh_rq nh_corr nh_rl if e(sample), by(have_haven) unequal
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr* if d_manu == 1, vce(robust)
	}
eststo diffmanu: estpost ttest have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001 ln_nhgdp ln_nhdist nh_rq nh_corr nh_rl if e(sample), by(have_haven) unequal
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr* if d_serv == 1, vce(robust)
	}
eststo diffserv: estpost ttest have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001 ln_nhgdp ln_nhdist nh_rq nh_corr nh_rl if e(sample), by(have_haven) unequal

esttab sumsfull sumsmanu sumsserv, nonumber mtitle("Full Sample" "Manufacturing firms" "Service firms") compress label cells("count mean(fmt(3)) sd(fmt(3))") obslast 
esttab difffull diffmanu diffserv, nonumber mtitle("Full Sample" "Manufacturing firms" "Service firms") compress label cells("mu_1(fmt(3)) mu_2(fmt(3)) p(fmt(3))") obslast 

xtset num jhr
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr*, vce(robust)
	}
xtsum have_haven if e(sample)
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr* if d_manu == 1, vce(robust)
	}
xtsum have_haven if e(sample) 
quietly {
	ivregress 2sls have_haven ln_pemployees ln_nhemployees (aveemp_nhtax = instr_2001) Djhr* if d_serv == 1, vce(robust)
	}
xtsum have_haven if e(sample) 

***	Appendix Table C.1
eststo sumsfull: estpost tabstat have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001, statistics(N mean sd) columns(statistics)
eststo sumsmanu: estpost tabstat have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001, statistics(N mean sd) columns(statistics)
eststo sumsserv: estpost tabstat have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001, statistics(N mean sd) columns(statistics) 
eststo difffull: estpost ttest have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001, by(have_haven) unequal
eststo diffmanu: estpost ttest have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001, by(have_haven) unequal
eststo diffserv: estpost ttest have_haven pm6_k ln_pemployees nonh_emp_k ln_nhemployees ///
	aveemp_nhtax instr_2001, by(have_haven) unequal

esttab sumsfull sumsmanu sumsserv, nonumber mtitle("Full Sample" "Manufacturing firms" "Service firms") compress label cells("count mean(fmt(3)) sd(fmt(3))") obslast 
esttab difffull diffmanu diffserv, nonumber mtitle("Full Sample" "Manufacturing firms" "Service firms") compress label cells("mu_1(fmt(3)) mu_2(fmt(3)) p(fmt(3))") obslast 
 
********************************************************************************

***	Figures 1+2 ****************************************************************

use Data_toUse.dta, clear 

keep if d_manu == 1 | d_serv == 1

reg have_haven ln_pemployees ln_nhemployees aveemp_nhtax, vce(robust)
keep if e(sample)
keep if count_lan > 1

label variable aveemp_nhtax "Average foreign non-haven tax rate"
label variable have_haven "Tax haven use"

qui {
	summarize aveemp_nhtax if d_manu == 1, detail
}
lpoly have_haven aveemp_nhtax if d_manu == 1 & aveemp_nhtax >= r(p1) & aveemp_nhtax <= r(p99), ci noscatter title("") legend(off) note("") caption("")

qui {
	summarize aveemp_nhtax if d_serv == 1, detail
}
lpoly have_haven aveemp_nhtax if d_serv == 1 & aveemp_nhtax >= r(p1) & aveemp_nhtax <= r(p99), ci noscatter title("") legend(off) note("") caption("")

********************************************************************************
********************************************************************************
