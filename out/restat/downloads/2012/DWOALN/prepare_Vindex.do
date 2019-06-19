#delimit cr
clear
global strcdin "U:/USER6/oh33/NBER/consp2010/REStat_accepted"
global strcdout "U:/USER6/oh33/NBER/consp2010/REStat_accepted/"
local today = string(date("`c(current_date)'","DMY"),"%tdCCYYNNDD")
global tables_version = "`today'"
global mypath "${strcdout}vindex/"
cd "${mypath}${tables_version}"
di c(pwd)
set mem 8m
set more off
foreach subgroup in "_" "black" "non_black" "be50" "up50" "married" "non_married" "hi_inc" "lo_inc" {

	use "${strcdin}/Heffetz_Visibility_Survey.dta", clear

	***********************************************************************
	* create demographics table 

	cap drop d_* 
	#delimit;
	recode RSEX (2=100) (1=0) (else=.) , gen(d_sex); ta RSEX d_sex,miss; /* d_sex = 100 if female */
	recode BYEAR (-2/2 = .), gen(d_age); replace d_age = 104 - d_age; *ta d_age,miss; /* 104 for year 2004 */ label var d_age "Age";
		replace d_age = d_age + 1 if RESPN>=301; /* these were collected in 2005. */ 
	recode OPEN11A (9 = .), gen(d_hh_size); ta d_hh_size, miss; /* !NOTICE: hh size above 8 is top coded at 8! */
	recode OPEN11 (9 = .), gen(d_over18); ta d_over18, miss; label var d_over18  "HH size (adults)";
	gen d_under18 = d_hh_size - d_over18; ta d_under18,miss; label var d_under18 "HH size (children)";
		replace d_over18 = . if d_under18==-2; replace d_hh_size = . if d_under18==-2; recode d_under18 (-2 = .); ta d_under18,miss;
	gen d_race = 100 if RACE_2 == 1; 
		replace d_race = 0 if RACE_2 == 0 & (RACE_1 == 1 | RACE_3 == 1 | RACE_4 == 1 | RACE_5 == 1);    
	gen d_educ_middle=0 if EDUC<20; replace d_educ_m = 100 if EDUC==10;
	gen d_educ_high=0 if EDUC<20; replace d_educ_h = 100 if EDUC>=11 & EDUC<=13;
	gen d_educ_college=0 if EDUC<20; replace d_educ_c = 100 if EDUC>=14 & EDUC<=16;
	gen d_educ_grad=0 if EDUC<20; replace d_educ_g = 100 if EDUC>=17 & EDUC<=19;
	gen d_income_0_20 = 0 if INCOME<10; replace d_income_0_20 = 100 if INCOME==1;
	gen d_income_20_40 = 0 if INCOME<10; replace d_income_20_40 = 100 if INCOME==2;
	gen d_income_40_60 = 0 if INCOME<10; replace d_income_40_60 = 100 if INCOME==3;
	gen d_income_60_100 = 0 if INCOME<10; replace d_income_60_100 = 100 if INCOME>=4 & INCOME<=5;
	gen d_income_100_inf = 0 if INCOME<10; replace d_income_100_inf = 100 if INCOME>=6 & INCOME<=9;

	* (notice that r_ variables are not currently used (other than for creating d_ variables below).);
	gen r_d_reg_Northeast = 0 if reg~=""; replace r_d_reg_Northeast = 1 if region == "Northeast"; label var r_d_reg_N "Northeast"; gen d_reg_N = r_d_reg_N*100;
	gen r_d_reg_Midwest = 0 if reg~=""; replace r_d_reg_Midwest = 1 if region == "Midwest"; label var r_d_reg_M "Midwest"; gen d_reg_M = r_d_reg_M*100;
	gen r_d_reg_South = 0 if reg~=""; replace r_d_reg_South = 1 if region == "South"; label var r_d_reg_S "South"; gen d_reg_S = r_d_reg_S*100;
	gen r_d_reg_West = 0 if reg~=""; replace r_d_reg_West = 1 if region == "West"; label var r_d_reg_W "West"; gen d_reg_W = r_d_reg_W*100;

	gen r_d_hispanic = 0 if HISPANIC ==2; replace r_d_hispanic = 1 if HISPANIC == 1; label var r_d_hisp "Hispanic";  gen d_hispanic = r_d_hispanic*100;
	gen r_d_married = 0 if MARSTAT <=6; replace r_d_married = 1 if MARSTAT == 1; label var r_d_marr "Married"; gen d_married = r_d_married*100;
	gen r_d_emp_employed = 0 if EMPLOY <=6; replace r_d_emp_employed = 1 if EMPLOY == 1; 
		label var r_d_emp_empl "Employed"; gen d_emp_employed = r_d_emp_employed*100;	
	
	* cen_ variables are calculated based on data as stated in the "References" section of the paper (Census 2000).;
	local cen_age = 45.2; 
	local cen_race = 12.3; local cen_sex = 50.9; local cen_hh_size = 2.6;
	local cen_under18 = 0.7; 
	local cen_educ_m = 7.5; local cen_educ_h = 40.7; local cen_educ_c = 42.8; local cen_educ_g = 8.9; 	
	local cen_hispanic = 12.5; local cen_married = 54.4 /* pop 15 yrs and over */; local cen_employed = 63.4 /* pop 16 yrs and over, civilian labor force */;
	local cen_inc_0_20 = 9.5+6.3+6.3;
	local cen_inc_20_40 = 6.6+6.4+6.4+5.9;
	local cen_inc_40_60 = 5.7+5.0+9.0;
	local cen_inc_60_100 = 10.4+10.2;
	local cen_inc_100_inf = 5.2+2.5+2.2+2.4;
	local cen_US = 281421906/100; local cen_reg_N = 53594378/`cen_US'; local cen_reg_M = 64392776/`cen_US';
	local cen_reg_S = 100236820/`cen_US'; local cen_reg_W = 63197932/`cen_US';

	*** break down by groups:;
	if     		 ("`subgroup'" == "black") keep if d_race==100;
	else if      ("`subgroup'" == "non_black") keep if d_race==0;
	else if      ("`subgroup'" == "be50") keep if d_age < 50;
	else if      ("`subgroup'" == "up50") keep if d_age >= 50 & d_age ~=.;
	else if      ("`subgroup'" == "married") keep if d_married==100;
	else if      ("`subgroup'" == "non_married") keep if d_married==0;
	else if      ("`subgroup'" == "hi_inc") keep if d_income_60==100 | d_income_100==100;
	else if      ("`subgroup'" == "lo_inc") keep if d_income_0==100 | d_income_20==100 | d_income_40==100;

	#delimit cr
	version 8
	tabstat d_hh_size d_under18 d_sex d_race d_age d_educ_m d_educ_h d_educ_c d_educ_g /*
		*/ d_income_0 d_income_2 d_income_4 d_income_6 /*
		*/ d_hispanic d_married d_emp_employed d_reg_N d_reg_M d_reg_S d_reg_W d_income_100 /*
		   14         15        16             17      18      19      20      21
		*/ ,stats(n mean min max semean sd) save
	matrix matdemog = r(StatTot)
	capture drop demog*
	svmat double matdemog, name(demog)
	version 11
	quietly{ 
		capture log close
		log using TableDemographics${tables_version}`subgroup'.txt, text replace
		noisily di "% TableDemographics${tables_version}`subgroup'.txt"
		noisily di "\rule{0pt}{6pt}"
		noisily di "\emph{Mean values:} & & & & \" "\[6pt]"
		noisily di "\ \  Age\footnote{In Census: %
		noisily di "estimated age of population 18 years and over.} & " demog5[1] " & " %2.1f demog5[2]  " & (" %2.1f demog5[5] ") & " `cen_age' "\" "\"
		noisily di "\ \  Household size\footnote{Top-coded at 8 (in visibility survey).} & " 
		noisily di demog1[1] " & " %2.1f demog1[2]  " & (" %2.1f demog1[5] ") & " `cen_hh_size' "\" "\"
		noisily di "\ \  Children under 18 in household & " demog2[1] " & " %2.1f demog2[2]  " & (" %2.1f demog2[5] ") & " %2.1f `cen_under18' "\" "\[6pt]"
		noisily di "\hline"
		noisily di "\rule{0pt}{6pt}"
		noisily di "\emph{Percent distribution:} & & & & \" "\[6pt]"
		noisily di "\ \ Female & " demog3[1] " & " %2.1f demog3[2] " & (" %2.1f demog3[5] ") & `cen_sex'  \" "\"
		noisily di "\ \ Black & " demog4[1] " & " %2.1f demog4[2] " & (" %2.1f demog4[5] ") & `cen_race' \" "\"
		noisily di "\ \ Hispanic & " demog14[1] " & " %2.1f demog14[2] " & (" %2.1f demog14[5] ") & `cen_hispanic' \" "\"
		noisily di "\ \ Married\footnote{In Census: %
		noisily di "marital status of population 15 years and over.} & " demog15[1] " & " %2.1f demog15[2] " & (" %2.1f demog15[5] ") & `cen_married' \" "\"
		noisily di "\ \ Employed\footnote{In Census: %
		noisily di "employment status of population 16 years and over (civilian labor force).} %
		noisily di "& " demog16[1] " & " %2.1f demog16[2] " & (" %2.1f demog16[5] ") & `cen_employed' \" "\[6pt]"
		noisily di "\ \ Education:\footnote{In Census: %
		noisily di "educational attainment of population 25 years and over.} & " demog6[1] " & & & \" "\"
		noisily di "\ \ \ \ Elementary (0-8) & & " %2.1f demog6[2] " & (" %2.1f demog6[5] ") & `cen_educ_m' \" "\"
		noisily di "\ \ \ \ High school (9-12) & & " %2.1f demog7[2] " & (" %2.1f demog7[5] ") & `cen_educ_h' \" "\"
		noisily di "\ \ \ \ College (13-16) &  & " %2.1f demog8[2] " & (" %2.1f demog8[5] ") & " %2.1f `cen_educ_c' "\" "\"
		noisily di "\ \ \ \ Graduate school (17 or more) & & " %2.1f demog9[2]   " & (" %2.1f demog9[5] ") & " %2.1f `cen_educ_g' "\" "\[6pt]"
		noisily di "\ \ Total household income: & " demog10[1] " & & & \" "\"
		noisily di "\ \ \ \ Less than \" "$20,000 & & " %2.1f demog10[2] " & (" %2.1f demog10[5] ") & " %2.1f `cen_inc_0_20' " \" "\"
		noisily di "\ \ \ \ \" "$20,000 to \" "$40,000 & & " %2.1f demog11[2] " & (" %2.1f demog11[5] ") & " %2.1f `cen_inc_20_40' " \" "\"
		noisily di "\ \ \ \ \" "$40,000 to \" "$60,000 & & " %2.1f demog12[2] " & (" %2.1f demog12[5] ") & " %2.1f `cen_inc_40_60' " \" "\"
		noisily di "\ \ \ \ \" "$60,000 to \" "$100,000 & & " %2.1f demog13[2] " & (" %2.1f demog13[5] ") & " %2.1f `cen_inc_60_100' " \" "\"
		noisily di "\ \ \ \ \" "$100,000 or more & & " %2.1f demog21[2] " & (" %2.1f demog21[5] ") & " %2.1f `cen_inc_100_inf' " \" "\[6pt]"
		noisily di "\ \ Region: & " demog17[1] " & & & \" "\"
		noisily di "\ \ \ \ Northeast  & & " %2.1f demog17[2] " & (" %2.1f demog17[5] ") & " %2.1f `cen_reg_N' " \" "\"
		noisily di "\ \ \ \ Midwest  & & " %2.1f demog18[2] " & (" %2.1f demog18[5] ") & " %2.1f `cen_reg_M' " \" "\"
		noisily di "\ \ \ \ South  & & " %2.1f demog19[2] " & (" %2.1f demog19[5] ") & " %2.1f `cen_reg_S' " \" "\"
		noisily di "\ \ \ \ West  & & " %2.1f demog20[2] " & (" %2.1f demog20[5] ") & " %2.1f `cen_reg_W' " \" "\"

		log close 
	}
	** end of demographics table creation
	***********************************************************************

	if _N < 31 set obs 31

	cap gen ncats = _n
	* create labels for categories 
	label define cats3 1  FdH 2  FdO 3  Cig  4  AlH 5  AlO 6  Clo 7  Und 8  Lry 9  Jwl 10 Brb 
	label define cats3 11 Hom 12 Htl 13 Fur 14 Utl 15 Tel  16 Cel 17 HIn 18 Med 19 Fee 20 LIn, add
	label define cats3 21 Car 22 CMn 23 Gas 24 CIn 25 Bus 26 Air 27 Bks 28 Ot1 29 Ot2 30 Edu 31 Cha, add 
	label values ncats cats3
	decode ncats, generate(ncats3)
	* create longer labels 
	label define cats4 1 "food home" 2 "food out" 3 "cigarettes" 4 "alcohol home" 5 "alcohol out" 6 "clothing"
	label define cats4 7 "underwear" 8 "laundry" 9 "jewelry" 10 "barbers etc", add
	label define cats4 11 "rent/home" 12 "hotels etc" 13 "furniture" 14 "home utilities" 15 "home phone" 16 "cell phone", add
	label define cats4 17 "home insur." 18 "health care" 19 "legal fees" 20 "life insur.", add
	label define cats4 21 "cars" 22 "car repair" 23 "gasoline" 24 "car insur." 25 "public trans." 26 "air travel", add
	label define cats4 27 "books etc" 28 "recreation 1" 29 "recreation 2" 30 "education" 31 "charities", add
	label values ncats cats4
	decode ncats, generate(ncats4)

	#delimit cr
	** Simple mean of 1 - 5 categories.

	cap gen catsb = 0
	cap gen catsse = 0
	cap gen frac12b = 0
	cap gen frac12se = 0
	cap gen dummy12 = 0
	cap gen frac45b = 0
	cap gen frac45se = 0
	cap gen dummy45 = 0
	cap gen reply1 = 0
	cap gen reply2 = 0
	cap gen reply3 = 0
	cap gen reply4 = 0
	cap gen reply5 = 0
	cap gen reply8 = 0
	cap gen reply9 = 0


	local icat=1
	while `icat'<=31 {
	  quietly{

	*	compute mean and SE:

		capture drop bvector
		capture drop Vvector
		reg Q1_`icat' if Q1_`icat' < 8
		matrix b = e(b)
		matrix V = e(V)
		svmat double b, name(bvector)
		svmat double V, name(Vvector)
		replace catsb = bvector[1] if ncats==`icat'
		replace catsse = (Vvector[1])^.5 if ncats==`icat'

	*	compute fraction who replied 1 or 2:

		replace dummy12 = 0
		replace dummy12 = 1 if Q1_`icat' == 1 | Q1_`icat' == 2 
		capture drop bvector
		capture drop Vvector
		reg dummy12 if Q1_`icat' < 8
		matrix b = e(b)
		matrix V = e(V)
		svmat double b, name(bvector)
		svmat double V, name(Vvector)
		replace frac12b = bvector[1] if ncats==`icat'
		replace frac12se = (Vvector[1])^.5 if ncats==`icat'

	*	compute fraction who replied 4 or 5:

		replace dummy45 = 0
		replace dummy45 = 1 if Q1_`icat' == 4 | Q1_`icat' == 5 
		capture drop bvector
		capture drop Vvector
		reg dummy45 if Q1_`icat' < 8
		matrix b = e(b)
		matrix V = e(V)
		svmat double b, name(bvector)
		svmat double V, name(Vvector)
		replace frac45b = bvector[1] if ncats==`icat'
		replace frac45se = (Vvector[1])^.5 if ncats==`icat'

	*    count how many of each reply there are:

		count if Q1_`icat' == 1
		replace reply1 = 100*r(N)/_N if ncats==`icat'
		count if Q1_`icat' == 2
		replace reply2 = 100*r(N)/_N if ncats==`icat'
		count if Q1_`icat' == 3
		replace reply3 = 100*r(N)/_N if ncats==`icat'
		count if Q1_`icat' == 4
		replace reply4 = 100*r(N)/_N if ncats==`icat'
		count if Q1_`icat' == 5
		replace reply5 = 100*r(N)/_N if ncats==`icat'
		count if Q1_`icat' == 8
		replace reply8 = 100*r(N)/_N if ncats==`icat'
		count if Q1_`icat' == 9
		replace reply9 = 100*r(N)/_N if ncats==`icat'

	  }
	  local icat = `icat' + 1
	}


	* save results as a Tex Table

	quietly{ 
		capture log close
		log using TableDistribution${tables_version}`subgroup'.txt, text replace
		noisily di "% TableDistribution${tables_version}`subgroup'.txt"
		local icat=1
		while `icat'<=31 {
			noisily di %4s ncats3[`icat'] " (" ncats4[`icat'] ") & " %2.1f reply1[`icat'] " & " %2.1f reply2[`icat'] " & " /*
				*/  %2.1f reply3[`icat']  " & " /*
				*/  %2.1f reply4[`icat']  " & " %2.1f reply5[`icat']  " & " %2.1f reply8[`icat'] /*
				*/   " & " %2.1f reply9[`icat'] "\" "\"
			local icat = `icat' + 1
		}
		log off
	}

	quietly { 		
		cap drop tr1 tr2 tr3 tr4 tr5 tr8 tr9
		egen tr1 = sum(reply1) in 1/31
		local t1 = tr1/31
		egen tr2 = sum(reply2) in 1/31
		local t2 = tr2/31
		egen tr3 = sum(reply3) in 1/31
		local t3 = tr3/31
		egen tr4 = sum(reply4) in 1/31
		local t4 = tr4/31
		egen tr5 = sum(reply5) in 1/31
		local t5 = tr5/31
		egen tr8 = sum(reply8) in 1/31
		local t8 = tr8/31
		egen tr9 = sum(reply9) in 1/31
		local t9 = tr9/31
		log on
		noisily di "\hline"
		noisily di "Total & " %2.1f `t1' " & " %2.1f `t2' " & " %2.1f `t3' " & " %2.1f `t4' /*
			*/  " & " %2.1f `t5' " & " %2.1f `t8' " & " %2.1f `t9' "\" "\"
		log close
		
	}

	* normalize indices and create rankings:

	sort frac12b in 1/31
	cap gen frac12n = 0
	replace frac12n = 32-_n in 1/31

	replace frac45b=1-frac45b in 1/31
	sort frac45b in 1/31
	cap gen frac45n = 0
	replace frac45n = 32-_n in 1/31

	replace catsb=(5-catsb)/4
	replace catsse=catsse/4 /* never forget to normalize SE's! */
	sort catsb in 1/31
	cap gen catsn = 0
	replace catsn = 32-_n in 1/31
	sort catsn in 1/31

	* save results as another Tex Table

	quietly{
		capture log close
		log using TableIndices${tables_version}`subgroup'.txt, text replace
		noisily di "% TableIndices${tables_version}`subgroup'.txt"
		local icat=1
		while `icat'<=31 {
			noisily di %3s ncats3[`icat'] " (" ncats4[`icat'] ")&" %3.2f catsb[`icat'] "&(" %3.2f catsse[`icat'] ")&[" /*
				*/    %2.0f catsn[`icat'] "] & " %3.2f frac12b[`icat'] "&(" %3.2f frac12se[`icat'] ")&[" /*
				*/    %2.0f frac12n[`icat'] "] & " %3.2f frac45b[`icat'] " & (" %3.2f frac45se[`icat'] ") & [" /*
				*/    %2.0f frac45n[`icat'] "] \" "\"       
			local icat = `icat' + 1
		}
		log close
	}

	* save STATA file with indices, ready to be merged:

	preserve
	keep ncats ncats3 ncats4 catsb catsse catsn frac12b frac12se frac12n frac45b frac45se frac45n
	gen n_obs`subgroup' = _N
	keep in 1/31
	rename ncats ncats`subgroup'
	rename ncats3 ncats3`subgroup'
	rename ncats4 ncats4`subgroup'
	rename catsb catsb`subgroup'
	rename catsse catsse`subgroup'
	rename catsn catsn`subgroup'
	rename frac12b frac12b`subgroup'
	rename frac12se frac12se`subgroup'
	rename frac12n frac12n`subgroup'
	rename frac45b frac45b`subgroup'
	rename frac45se frac45se`subgroup'
	rename frac45n frac45n`subgroup'

	gen lcatsb`subgroup' = catsb`subgroup'-catsse`subgroup'
	gen hcatsb`subgroup' = catsb`subgroup'+catsse`subgroup'

	sort ncats`subgroup'
	save Vindices${tables_version}`subgroup', replace
	restore
	sort nsort
	*/

} /* of the global foreach loop */

* merge vindices and create figure

global pathdate "${tables_version}"
global strb = "catsb_"
global strn = "catsn_"
use Vindices${tables_version}_.dta, clear
foreach igroup in "Age" "Status" "Race" "Income" {
	if "`igroup'" == "Age" {
*		global pathdate "20090121"
		global gr1 "up50"
		local lab1 = "50 and up"
		global gr2 "be50"
		local lab2 = "Below 50"
	}
	else if "`igroup'" == "Race" {
*		global pathdate "20081107"
		global gr1 "non_black"
		local lab1 = "Non-black"
		global gr2 "black"
		local lab2 = "Black"
	}
	else if "`igroup'" == "Status" {
*		global pathdate "20090127"
		global gr1 "married"
		local lab1 = "Married"
		global gr2 "non_married"
		local lab2 = "Non-married"
	}
	else if "`igroup'" == "Income" {
*		global pathdate "20090201"
		global gr1 "hi_inc"
		local lab1 = "Above $60,000"
		global gr2 "lo_inc"
		local lab2 = "Below $60,000"
	}
	rename  ncats_  ncats${gr1}
	merge ncats${gr1} using Vindices${tables_version}${gr1}.dta
	ta _m
	drop _m
	sort ncats${gr1}
	rename  ncats${gr1}  ncats${gr2}
	merge ncats${gr2} using Vindices${tables_version}${gr2}.dta
	ta _m
	drop _m

	foreach gr in "${gr1}" "${gr2}" {
		local t = invttail(n_obs`gr'[1]-2,0.025)
		di "`igroup': `gr' n= " n_obs`gr' "  tstat = `t'"
		gen hi`gr' = catsb`gr'+(`t'*catsse`gr') // 95% conf interval.
		gen lo`gr' = catsb`gr'-(`t'*catsse`gr')
	}

	twoway /// 
		scatter catsn_ catsb${gr1}, mc(gs4) m(d) || ///
		scatter catsn_ catsb${gr2}, mc(gs7) m(t) || ///
		rcap hi${gr1} lo${gr1} catsn_, lc(gs4) horizontal || ///
		rcap hi${gr2} lo${gr2} catsn_, lc(gs7) horizontal ||  ///
		(scatter catsn_ catsb_, mc(gs0) m(x) mlabel(ncats3${gr1}) mlabp(9) mlabg(*10) mlabang(0)) ///
		,name(`igroup',replace) ///
		legend(col(1) ring(0) pos(11) order(5 "All" 1 "`lab1'" 2 "`lab2'") subtitle("`igroup':",bex j(left)) textwidth(*3.2) )  ///
		title($mytitle) ytitle(Visibility Ranking (All)) xtitle(Visibility Indices) ///
		xscale(range(0.03 .8)) xlabel(.1(.1).8) ///
		yscale(reverse) ylabel(1 10 20 30, angle(horizontal)) ytick(1(1)31) scheme(sj)
	rename  ncats${gr2} ncats_ 
	so ncats_
	global strb = "$strb catsb${gr1} catsb${gr2}"
	global strn = "$strn catsn${gr1} catsn${gr2}"
}
corr $strn $strb
save Vindices${tables_version}_all, replace

graph combine Age Status Race Income,cols(2) xcom ycom name(combed2, replace) iscale(0.5) xsize(6.5) ysize(8.3) scheme(sj) 
graph export FigureVinDemogs_se_${tables_version}.eps, logo(off) fontface(Times) replace



