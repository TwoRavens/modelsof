
clear
use nber_data

/***********************************/
/*The file nber_data_hits_downloads is available upon application to Daniel Feenberg (feenberg@nber.org) at the NBER.*/
/***********************************/

/*
merge 1:1 nberwpno using nber_data_hits_downloads
drop _merge
*/

/****** choose a local folder here********/
cd  "C:\Users\Patrick\Desktop\checkoutput"



/****************************************************/
/****************************************************/
/*******Constructing ancillary variables ************/
/****************************************************/
/****************************************************/

/************** Take logs of dependent variables ***************/

/*gen lgpdfdown_1=log(pdfdown+1)
gen lghits_1=log(hits+1)*/
gen ln_cites_1=ln(cites+1)


/*********** numeric identifier for week of announcement*****************/

egen cleanweeknum=group(announcementdatestata)

/*********** Construct delay from submission to annoucement ***********/
gen delay=announcementdatestata-submissiondatestata

/********** Construct sample***************************/

gen sample_cites = 1 if year>=2012 & year<=2013 & delay<=50
gen sample_downloads =1 if year>=2013 & year<=2014 & delay<=50

/************ Construct number of programs   **************/

egen nr_programs = rowtotal(AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR PE)


/********** Construct length of lists ************/
gen temp=1
bysort cleanweeknum: egen length=total(temp)
drop temp

gen length20 = 0
replace length20 = 1 if length>=20 & length!=.

/********* Construct dummies for various ranks **********/

gen rank1=0
replace rank1=1 if rank==1
label var rank1 "Rank 1"

gen rank2=0
replace rank2=1 if rank==2
label var rank1 "Rank 1"

bysort cleanweeknum: egen maxrank=max(rank)
gen ranklast=0
replace ranklast=1 if rank==maxrank
label var ranklast "Last rank"

/******** Constuct dummies for day of week when submitted***********/

gen dow=dow(submissiondatestata)
tab dow, gen(dow)
label variable dow1 "Sunday"
label variable dow2 "Monday"
label variable dow3 "Tuesday"
label variable dow4 "Wednesday"
label variable dow5 "Thursday"
label variable dow6 "Friday"
label variable dow7 "Saturday"


/******** Indicator variable for star in paper **************/

gen star5_1 = star5 * rank1
bysort cleanweeknum: egen star5_1st = max(star5_1)



/****************************************************/
/****************************************************/
/******* Paper tables *******************************/
/****************************************************/
/****************************************************/



/******************* Numbers for Table 1: means and standard deviations ********************/

/*sum hits if sample_downloads==1*/ /*** requires hits/downloads data (cf readme file)**/
/*sum pdfdown if sample_downloads==1*/ /*** requires hits/downloads data (cf readme file)**/
sum cites if sample_cites==1


sum maxstockpapers if sample_downloads==1
sum  nr_authors if sample_downloads==1
sum  star5 if sample_downloads==1
sum delay if sample_downloads==1
sum nr_programs if sample_downloads==1

sum dow2 if sample_downloads==1
sum dow3 if sample_downloads==1
sum dow4 if sample_downloads==1
sum dow5 if sample_downloads==1
sum dow6 if sample_downloads==1
sum dow7 if sample_downloads==1

sum AG if sample_downloads==1
sum AP if sample_downloads==1
sum CH if sample_downloads==1
sum CF if sample_downloads==1
sum DEV if sample_downloads==1
sum DAE if sample_downloads==1
sum ED if sample_downloads==1
sum EFG if sample_downloads==1
sum EEE if sample_downloads==1
sum HC if sample_downloads==1

sum HE if sample_downloads==1
sum IO if sample_downloads==1
sum IFM if sample_downloads==1
sum ITI if sample_downloads==1
sum LS if sample_downloads==1
sum LE if sample_downloads==1
sum ME if sample_downloads==1
sum POL if sample_downloads==1
sum PR if sample_downloads==1
sum PE if sample_downloads==1





/*******************************************************/
/************** Table 2 panel A ************************/
/*******************************************************/

/*** requires hits/downloads data (cf readme file)**/

/*
eststo clear
xtreg lghits_1 rank1 maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lghits_1 ranklast maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lghits_1 rank1 rank2 ranklast maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lghits_1 rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo
estadd scalar ar2 =e(r2_a)

esttab using table2_panelA.rtf, order(rank1 rank2 ranklast rank) keep(rank1 rank2 ranklast rank  ///
maxstockpapers star5 nr_authors nr_programs  delay) ///
modelwidth(7) varwidth(22) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("N Nb. of Observations" "N_clust Nb. of Weeks" ) ar2 sfmt(%10.0fc %10.0fc %10.3fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") eqlabels(none) replace
*/

/*******************************************************/
/************** Table 2 panel B ************************/
/*******************************************************/

/*** requires hits/downloads data (cf readme file)**/

/*
eststo clear
xtreg lgpdfdown_1 rank1 maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lgpdfdown_1 ranklast maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lgpdfdown_1 rank1 rank2 ranklast maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lgpdfdown_1 rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

esttab using table2_panelB.rtf, order(rank1 rank2 ranklast rank) keep(rank1 rank2 ranklast rank  ///
maxstockpapers star5 nr_authors nr_programs  delay) ///
modelwidth(7) varwidth(22) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("N Nb. of Observations" "N_clust Nb. of Weeks" ) ar2 sfmt(%10.0fc %10.0fc %10.3fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") eqlabels(none) replace
*/

/*******************************************************/
/************** Table 2 panel C ************************/
/*******************************************************/

eststo clear
xtreg ln_cites_1 rank1 maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 ranklast maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1, fe i(cleanweeknum) r
eststo

esttab using table2_panelC.rtf, order(rank1 rank2 ranklast rank) keep(rank1 rank2 ranklast rank  ///
maxstockpapers star5 nr_authors nr_programs  delay) ///
modelwidth(7) varwidth(22) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("N Nb. of Observations" "N_clust Nb. of Weeks" ) ar2 sfmt(%10.0fc %10.0fc %10.3fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") eqlabels(none) replace



/*** requires hits/downloads data (cf readme file)**/
/*
gen logeduhits_p1=log(eduhits+1)
gen logedupdfdown_p1=log(edupdfdown +1)
*/

gen monthofannouncement=month(announcementdatestata)
tab monthofannouncement

gen summer=0
replace summer=1 if  monthofannouncement==7
replace summer=1 if  monthofannouncement==8




/*********** table 3 panel A ************/

/*** requires hits/downloads data (cf readme file)**/

/*
eststo clear

xtreg lghits_1  rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg logeduhits_p1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo



xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & length20 == 1, fe i(cleanweeknum) r
eststo


xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & length20 ==0, fe i(cleanweeknum) r
eststo

xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & star5_1st == 1, fe i(cleanweeknum) r
eststo


xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & star5_1st ==0, fe i(cleanweeknum) r
eststo


xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & summer == 1, fe i(cleanweeknum) r
eststo


xtreg lghits_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & summer ==0, fe i(cleanweeknum) r
eststo


esttab using table3_panelA.rtf, order(rank1 rank2 ranklast rank) keep(rank1 rank2 ranklast rank)  ///
///
modelwidth(5) varwidth(10) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("subset Sample" "N Nb. of Obs." "N_clust Nb. of Weeks" ) ar2 sfmt(%10.0fc %10.0fc %10.0fc %10.3fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") eqlabels(none) replace
*/

/*********** table 3 panel B ************/

/*** requires hits/downloads data (cf readme file)**/
/*
eststo clear

xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

xtreg logedupdfdown_p1  rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo


xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & length20 == 1, fe i(cleanweeknum) r
eststo


xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & length20 ==0, fe i(cleanweeknum) r
eststo



xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & star5_1st == 1, fe i(cleanweeknum) r
eststo


xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & star5_1st ==0, fe i(cleanweeknum) r
eststo


xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & summer == 1, fe i(cleanweeknum) r
eststo


xtreg lgpdfdown_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1 & summer ==0, fe i(cleanweeknum) r
eststo


esttab using table3_panelB.rtf, order(rank1 rank2 ranklast rank) keep(rank1 rank2 ranklast rank)  ///
///
modelwidth(5) varwidth(10) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("subset Sample" "N Nb. of Obs." "N_clust Nb. of Weeks" ) ar2 sfmt(%10.0fc %10.0fc %10.0fc %10.3fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") eqlabels(none) replace

*/






/************* TABLE 3 panel C *************/

eststo clear

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1 & length20 == 1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1 & length20 ==0, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1 & star5_1st == 1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1 & star5_1st ==0, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1 & summer == 1, fe i(cleanweeknum) r
eststo

xtreg ln_cites_1 rank1 rank2 ranklast rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_cites==1 & summer ==0, fe i(cleanweeknum) r
eststo

esttab using table3_panelC.rtf, order(rank1 rank2 ranklast rank) keep(rank1 rank2 ranklast rank)  ///
///
modelwidth(5) varwidth(10) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("subset Sample" "N Nb. of Obs." "N_clust Nb. of Weeks" ) ar2 sfmt(%10.0fc %10.0fc %10.0fc %10.3fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") eqlabels(none) replace


/************* Appendix table A1 *************/


eststo clear
xtreg rank1 maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo
xtreg rank maxstockpapers star5 nr_authors nr_programs delay ///
dow2-dow7  AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR ///
if sample_downloads==1, fe i(cleanweeknum) r
eststo

esttab using tableA1.rtf, keep(  ///
maxstockpapers star5 nr_authors nr_programs dow2 dow3 dow4 dow5 dow6 dow7 delay AG AP CH CF DEV DAE ED EFG EEE HC HE IO IFM ITI LS LE ME POL PR _cons) ///
varwidth(25) ///
nonumber noobs nogaps nodep label b(%5.3f) se(%5.3f) star(+ 0.10 * 0.05 ** 0.01) ///
compress scalars("N Nb. of Observations" "N_clust Nb. of Weeks") sfmt(%10.0fc %10.0fc %10.0fc %10.3fc) ///
mlabels("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") eqlabels(none) replace


