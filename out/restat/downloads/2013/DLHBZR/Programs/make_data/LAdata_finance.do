clear

set more 1
set mem 20m
set matsize 800

do x:\ReStat-Programs-Data\Programs\make_data\paths.do

cd ${MAIN}

* create other datasets

do ${DO}/make_data/LAseg.do
do ${DO}/make_data/cnty1960.do
do ${DO}/make_data/LATitlei.do
do ${DO}/make_data/cpi.do
do ${DO}/make_data/LAbirths.do

* This part of the program is commented out for public distribution.
* LA_allvars.dta is a dataset that contains a large number of variables and years that are not used in this project.
* LA_allvars_ReStatExtract.dta contains the variables and years used in this analysis. Those wishing to replicate the analysis can begin with this dataset.

/*get necessary data from main Louisiana finance data file
use year ncesid dname fipscnty county ///
enrwh112 enrwhk12 enrwh np_enrwh112 np_enrwhk12 np_enrwh enrbl112 enrblk12 enrbl np_enrbl112 np_enrblk12 np_enrbl enrto np_enrto ///
expcurr revtot revfed revst revloc revnl revloc_sales revst_psf revfed_t1 revfed_t2 revfed_t3 ///
av av_real teachbl teachwh teach ///
totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent pereduc allotpers miles diffequal teachsal teachallot ///
using x:\LA_projects\LAData\dta\LA_allvars if year<=1980

save ${RAW}\LA_allvars_ReStatExtract, replace
*/
clear
use ${RAW}\LA_allvars_ReStatExtract

* Aggregate to the county level

foreach var in enrwh112 enrwhk12 enrwh np_enrwh112 np_enrwhk12 np_enrwh enrbl112 enrblk12 enrbl np_enrbl112 np_enrblk12 np_enrbl enrto np_enrto ///
expcurr revtot revfed revst revloc revnl revloc_sales revst_psf revfed_t1 revfed_t2 revfed_t3  ///
av av_real teachbl teachwh teach ///
totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent pereduc allotpers miles diffequal teachsal teachallot {
	recode `var' .=0
	egen x=sum(`var'), by(year fipscnty)
	replace `var'=x
	drop x
	*set to missing if missing in all districts in a year
	egen x=max(`var'), by(year)
	recode `var' 0=. if x==0
	drop x
	}

* revfed_t3 was 0 for all districts in 1965
replace revfed_t3=0 if year==1965

* Drop city districts -- these have been aggregated with the county district
drop if ncesid==2201080|ncesid==2202011|ncesid==2200240
drop ncesid

*merge on segregation data (county level OCR)
* Contains Data from the Office of Civil Rights created by LAseg.do
sort fipscnty year
merge fipscnty year using ${DTA}\LAOCR
tab _merge
drop if _merge==2
drop _merge

*merge on segregation data (SERS)
* Contains data from SERS and created by LAseg.do
sort fipscnty year
merge fipscnty year using ${DTA}\LA-sers
tab _merge
drop if _merge==2
drop _merge
*if no desegregated black enrollment was listed in 1960-1964 ==0
recode desegenrbl .=0 if year<=1964
replace perblanywh=desegenrbl/enrbl if year<=1966
*create estimates of exposure of blacks to whites and whites to blacks
/*
exposure of whites to blacks = black share in integrated school (because all whites are in integrated school)
			     = (perbl*perblanywh)/[(1-perbl)+(perbl*perblanywh)]

exposure of blacks to whites = (share of blacks in integrated school) * (white share of integrated school) 
			     = perblanywh * (1-perbl)/[(1-perbl)+(perbl*perblanywh)]
*/
gen perbl=enrbl/(enrbl+enrwh)
replace expbl_wh=(perbl*perblanywh)/((1-perbl)+(perbl*perblanywh)) if year<=1966
replace expwh_bl=perblanywh * (1-perbl)/((1-perbl)+(perbl*perblanywh)) if year<=1966

*merge on county data from census
*created by cnty1960.do
sort fipscnty year
merge fipscnty using ${DTA}\LAcnty1960, keep(perurban6 poptot6 perplumb6 perinclt30006 percapinc6)
tab _merge
drop if _merge==2
drop _merge

*merge lagged birth data
sort fipscnty year
merge fipscnty year using ${DTA}\LAbirths
tab _merge
drop _merge
foreach var in bl wh to {
	gen lnbirth`var'=ln(birthlag_`var')
	}
gen birthperwh=birthlag_wh/birthlag_to
drop mis_*

*merge on Title I eligibles
sort fipscnty
merge fipscnty using ${DTA}\LAti_elig1966
tab _merge
drop _merge

** create outcome variables**********************************************************

***
* Enrollment variables
***

* generate private and public enrollment
gen enrwh_all=enrwh+np_enrwh
label var enrwh_all "Public and Private K-12 White registration"

gen fracprivwh=np_enrwh/enrwh_all
label var fracprivwh "Fraction Private White Registration K-12" 

gen enrwh112_all=enrwh112+np_enrwh112
label var enrwh_all "Public and Private 1-12 White registration"

gen fracprivwh112=np_enrwh112/enrwh112_all
label var fracprivwh "Fraction Private White Registration K-12" 

gen enroll=enrwh+enrbl
label var enroll "K-12 Public registration"

gen enroll112=enrwh112+enrbl112
label var enroll112 "1-12 Public Registration

foreach var in enrwh enrwh_all enrwh112 enrwh112_all enroll enroll112 {
	gen ln`var'=ln(`var')
	}

***
* Finance variables
***

*adjust for inflations to 2007$
*make per-pupil versions
sort year
merge year using ${DTA}\cpi
tab _merge
keep if _merge==3
drop _merge

foreach var in expcurr revtot revfed revst revloc revnl revloc_sales revst_psf revfed_t1 revfed_t2 revfed_t3 av av_real ///
totcost salaries transport admxothcost adj_decl salary_adj totsupport const5mill sevtax rent pereduc teachsal {
	replace `var'=`var'/(cpi_defl*1000)
	gen pp`var'=`var'/enroll
	}

gen revloc_oth=revloc-revloc_sales
gen pprevloc_oth=revloc_oth/enroll
label var revloc_oth "revloc-revloc_sales"

gen revloc_discr=revloc-const5mill-sevtax-rent
label var revloc_discr "revloc-const5mill-sevtax-rent"
gen pprevloc_discr=revloc_discr/enroll

gen revfed_esea=revfed_t1+revfed_t2+revfed_t3
gen pprevfed_esea=revfed_esea/enroll
label var revfed_esea "revfed_t1+revfed_t2+revfed_t3"
*ESEA was 0 before 1965
replace revfed_esea=0 if year<1965

*other non-local rev
gen revnl_oth=revnl-revfed_esea-revst_psf
label var revnl_oth "revnl-revfed_esea-revst_psf"
gen pprevnl_oth=revnl_oth/enroll

***
* AV Variables
***

gen av_nr=av-av_real
label var av_nr "non-real AV: av-av_real"
gen ppav_nr=av_nr/enroll

foreach var in av ppav av_real av_nr ppav_real ppav_nr {
	gen ln`var'=ln(`var')
	}

***
* Teacher Variables
***

replace teach=teachwh+teachbl if teach==.|teach==0

gen strat=enroll/teach
gen stratbl=enrbl/teachbl if year<1966
gen stratwh=enrwh/teachwh if year<1966

*use average value after 1970
replace stratbl=stratbl_ocr if year>=1970
replace stratwh=stratwh_ocr if year>=1970

gen perblteach=100*teachbl/teach
gen fracblteach=teachbl/teach

gen tsrat=100*teach/enroll
gen tsratbl=100*teachbl/enrbl if year<=1965
gen tsratwh=100*teachwh/enrwh if year<=1965

replace tsratbl=tsrat if year>=1970
replace tsratwh=tsrat if year>=1970
replace tsratbl=. if year>=1966&year<1970

label var strat "All Students/All Teachers"
label var stratbl "Black Students/Black Teachers"
label var stratwh "White Students/White Teachers"

*gap between white student-teacher ratio and average student-teacher ratio
gen stratgapwhavg=stratwh-strat
gen tsratgapwhavg=tsratwh-tsrat

*gap between white and black st ration
gen stratgapwhbl=stratwh-stratbl

*average teacher salary per salary schedule
gen avgsalary=teachsal/teachallot

***
* key RHS variables
***

cap drop perbl
gen perbl=100*enrbl/enroll
gen fracbl=enrbl/enroll
gen fracblsq=fracbl^2

***
* did not have transport data for 1965--interpolate from 1964 and 1966
***
gen x=miles if year==1964|year==1966
egen y=mean(x), by(fipscnty)
replace miles=y if year==1965
drop x y

gen ppmiles=miles/enroll

***
* Census variables
***

gen lnpop6=ln(poptot6)
* adjust per-cap income
replace percapinc=percapinc/1000

***
* Title I eligible rate
***
gen x=ti_elig/enroll if year==1966
egen fracti1966=max(x), by(fipscnty)
drop x

***
* pre-program finance variables
***

gen x=ppexpcurr if year==1960|year==1961|year==1962
egen initexp=mean(x), by(fipscnty)
drop x

*drop Cameron Parish
drop if fipscnty==22023

save ${DTA}\LAdata_finance, replace

