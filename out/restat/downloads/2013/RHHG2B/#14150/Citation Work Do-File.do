/*** Citation Work ***/

/* This Do-File allows for the replication of all patent-data based results in the paper. All source files not included with this do-file
were downloaded from NBER's Patent Data Project website, available at the following URL address: https://sites.google.com/site/patentdataproject/ */
/* Some parts of the do-file below are "commented out" because they rely on the large source data files from the NBER's website. The purpose for including
them in the do-file below is to allow the user to see the steps that were taken in manipulating them. */ 

/* 
Further Instructions:
1. Download the do-file and all required data files into the folder "C:/Stata/#14150/"
2. In order to run the entire do-file, including the currently "commented out" sections (see above), remove the appropriate comment expressions
*/

clear
set mem 600m, perm
set more off

/*

/*** Creating Figure 1 ***/

/* Prepare Citation File */

use "C:/Stata/#14150/cite76_06.dta", clear
drop ncites
rename cited patent
sort patent
merge patent using "C:/Stata/#14150/sof_it_patents.dta"
keep if _merge==3
drop _merge
rename patent cited
rename citing patent
sort patent
rename software_patent software_patent_cited
rename it_patent it_patent_cited
saveold "C:/Stata/#14150/cite76_06_int.dta", replace

/* Prepare IT/Sof File */

use "C:/Stata/#14150/pat76_06_assg.dta", clear
duplicates drop patent, force
keep patent appyear gyear cat subcat
sort patent 
merge patent using "C:/Stata/#14150/software_patents_newdef_76_06.dta"
drop if _merge==2
rename _merge software_patent
replace software_patent=0 if software_patent==1
replace software_patent=1 if software_patent==3
gen it_patent=0
replace it_patent=1 if cat==2
replace it_patent=1 if subcat==41
replace it_patent=1 if subcat==46
keep patent software_patent it_patent
sort patent
saveold "C:/Stata/#14150/sof_it_patents.dta", replace


/** Putting Figure 1 Together **/

use "C:/Stata/#14150/pat76_06_assg.dta", clear
duplicates drop patent, force
keep patent appyear gyear cat subcat

/* Check if Software Patent */

sort patent 
merge patent using "C:/Stata/#14150/software_patents_newdef_76_06.dta"
drop if _merge==2
rename _merge software_patent
replace software_patent=0 if software_patent==1
replace software_patent=1 if software_patent==3

/* Check if IT patent */

gen it_patent=0
replace it_patent=1 if cat==2
replace it_patent=1 if subcat==41
replace it_patent=1 if subcat==46

/* Check if non-software IT patent */

gen nonsof_it_patent=0
replace nonsof_it_patent=1 if it_patent==1 & software_patent==0

/* Add Inventor Location Data & Citations Data */

sort patent
merge patent using "C:/Stata/#14150/inv_location_patents.dta"
keep if _merge==3
drop cat subcat _merge
sort patent
merge patent using "C:/Stata/#14150/cite76_06_int.dta", nokeep
drop cited
gen citation=0
replace citation=1 if _merge==3
drop _merge
drop software_patent
keep if nonsof_it_patent==1
gen software_citation=0
replace software_citation=1 if software_patent_cited==1 & it_patent_cited==1
sort gyear nonsof_it_patent location_firstinventor
collapse (sum) citation (sum) software_citation, by(gyear nonsof_it_patent location_firstinventor)
sort location_firstinventor nonsof_it_patent gyear
keep if gyear>=1983 & gyear<=2004
saveold "C:/Stata/#14150/dataset_figure_1.dta", replace

*/
/* The resulting dataset above allows for replication of Figure 1. */





/* Creating Table I: Citation Functions */

/* 

/* Prepare Citing Dataset */

use "C:/Stata/#14150/pat76_06_assg.dta", clear
duplicates drop patent, force
keep patent appyear gyear cat subcat
sort patent 
merge patent using "C:/Stata/#14150/software_patents_newdef_76_06.dta"
drop if _merge==2
rename _merge software_patent
replace software_patent=0 if software_patent==1
replace software_patent=1 if software_patent==3
gen it_patent=0
replace it_patent=1 if cat==2
replace it_patent=1 if subcat==41
replace it_patent=1 if subcat==46
gen nonsof_it_patent=0
replace nonsof_it_patent=1 if it_patent==1 & software_patent==0
sort patent
merge patent using "C:/Stata/#14150/inv_location_patents.dta"
keep if _merge==3 /* Keeping Only Patents with US and/or JP Inventors */
drop _merge
sort patent
gen jp_invented=0
replace jp_invented=1 if location_firstinventor=="JP" & location_allinventors=="JP"
drop if location_firstinventor=="Other"
drop if location_allinventors=="Both"
drop location_allinventors location_firstinventor
keep if nonsof_it_patent==1 /* Keeping Non Software IT Patents */
drop it_patent software_patent nonsof_it_patent
drop appyear /* Using Gyear */
keep if gyear>=1990 & gyear<=2003
sort patent
saveold "C:/Stata/#14150/Citing Patent Dataset.dta", replace

/* Prepare Cited Dataset */

use "C:/Stata/#14150/pat76_06_assg.dta", clear
duplicates drop patent, force
keep patent appyear gyear cat subcat
sort patent 
merge patent using "C:/Stata/#14150/software_patents_newdef_76_06.dta"
drop if _merge==2
rename _merge software_patent /* Using Broad Software Patent Definition */
replace software_patent=0 if software_patent==1
replace software_patent=1 if software_patent==3
drop subcat cat
drop appyear /* Using Gyear */
keep if gyear>=1989 & gyear<=2002
sort patent
saveold "C:/Stata/#14150/Cited Patent Dataset.dta", replace

/* Create Citation Files For Function Estimation */

use "C:/Stata/#14150/cite76_06.dta", clear
drop ncites7606
rename citing patent
sort patent
merge patent using "C:/Stata/#14150/Citing Patent Dataset.dta"
keep if _merge==3
drop _merge
drop cat
rename gyear p_gyear
rename jp_invented p_jp
rename subcat p_type
rename patent citing
rename cited patent
sort patent
merge patent using "C:/Stata/#14150/Cited Patent Dataset.dta"
keep if _merge==3
drop _merge
rename gyear a_gyear
rename software_patent a_software 
rename patent cited
saveold "C:/Stata/#14150/Citations For CF.dta", replace

/* Generating Dataset of Potentially Citing Patents */

use "C:/Stata/#14150/Citing Patent Dataset.dta", clear
gen ena=1
collapse (sum) ena, by(gyear jp_invented subcat)
rename gyear p_gyear
rename jp_invented p_jp
rename subcat p_type
rename ena p_number
sort p_gyear p_jp p_type
saveold "C:/Stata/#14150/Potentially Citing Patents For CF.dta", replace

/* Generating Dataset of Potentially Cited Patents */

use "C:/Stata/#14150/Cited Patent Dataset.dta", clear
gen ena=1
collapse (sum) ena, by(gyear software_patent)
rename gyear a_gyear
rename software_patent a_software
sort a_gyear a_software
rename ena a_number
saveold "C:/Stata/#14150/Potentially Cited Patents For CF.dta", replace

*/

/*
/* Generating Grid */
/* done manually */

clear
edit
replace var1 = 1990 in 1
replace var1 = 1991 in 2
replace var1 = 1992 in 3
replace var1 = 1993 in 4
replace var1 = 1994 in 5
replace var1 = 1995 in 6
replace var1 = 1996 in 7
replace var1 = 1997 in 8
replace var1 = 1998 in 9
replace var1 = 1999 in 10
replace var1 = 2000 in 11
replace var1 = 2001 in 12
replace var1 = 2002 in 13
replace var1 = 2003 in 14
rename var1 p_gyear
sort p_gyear
saveold "C:/Stata/#14150/CF Grid - Citing Trend.dta", replace

clear
edit
replace var1 = 1989 in 1
replace var1 = 1990 in 2
replace var1 = 1991 in 3
replace var1 = 1992 in 4
replace var1 = 1993 in 5
replace var1 = 1994 in 6
replace var1 = 1995 in 7
replace var1 = 1996 in 8
replace var1 = 1997 in 9
replace var1 = 1998 in 10
replace var1 = 1999 in 11
replace var1 = 2000 in 12
replace var1 = 2001 in 13
replace var1 = 2002 in 14
rename var1 a_gyear
sort a_gyear
saveold "C:/Stata/#14150/CF Grid - Cited Trend.dta", replace

clear
edit
replace var1 = 0 in 1
replace var1 = 1 in 2
rename var1 p_jp
sort p_jp
saveold "C:/Stata/#14150/CF Grid - p_jp.dta", replace

clear
edit
replace var1 = 0 in 1
replace var1 = 1 in 2
rename var1 a_software
sort a_software
saveold "C:/Stata/#14150/CF Grid - a_software.dta", replace

clear
edit
replace var1 = 21 in 1
replace var1 = 22 in 2
replace var1 = 23 in 3
replace var1 = 24 in 4
replace var1 = 25 in 5
replace var1 = 41 in 6
replace var1 = 46 in 7
rename var1 p_type
sort p_type
saveold "C:/Stata/#14150/CF Grid - p_type.dta", replace

use "C:/Stata/#14150/CF Grid - Citing Trend.dta", clear
cross using "C:/Stata/#14150/CF Grid - Cited Trend.dta"
drop if a_gyear>=p_gyear
cross using "C:/Stata/#14150/CF Grid - p_jp.dta"
cross using "C:/Stata/#14150/CF Grid - p_type.dta"
cross using "C:/Stata/#14150/CF Grid - a_software.dta"
sort p_gyear p_jp p_type a_gyear a_software
saveold "C:/Stata/#14150/CF Grid - Grid.dta", replace
*/

/* Generating the Citation Function Dataset */
/* Citing: Non-Software IT patents 1990-2003 by gyear including JP dummy and technology type */
/* Cited: Patents 1989-2002 by gyear including software patent dummy */

use "C:/Stata/#14150/Citations For CF.dta", clear
gen ena=1
collapse (sum) ena, by(p_gyear p_jp p_type a_gyear a_software)
sort p_gyear p_jp p_type a_gyear a_software
merge p_gyear p_jp p_type a_gyear a_software using "C:/Stata/#14150/CF Grid - Grid.dta"
drop if _merge==1
replace ena=0 if _merge==2
drop _merge
rename ena citations
sort p_gyear p_jp p_type
merge p_gyear p_jp p_type using "C:/Stata/#14150/Potentially Citing Patents For CF.dta"
drop _merge
sort a_gyear a_software
merge a_gyear a_software using "C:/Stata/#14150/Potentially Cited Patents For CF.dta"
drop _merge
gen ratio=citations/(p_number*a_number)
gen sqrtcc=sqrt(p_number*a_number)
tab p_gyear, gen(p_gyear_)
drop p_gyear_1
rename p_gyear_2 p_gyear_91
rename p_gyear_3 p_gyear_92
rename p_gyear_4 p_gyear_93
rename p_gyear_5 p_gyear_94
rename p_gyear_6 p_gyear_95
rename p_gyear_7 p_gyear_96
rename p_gyear_8 p_gyear_97
rename p_gyear_9 p_gyear_98
rename p_gyear_10 p_gyear_99
rename p_gyear_11 p_gyear_00
rename p_gyear_12 p_gyear_01
rename p_gyear_13 p_gyear_02
rename p_gyear_14 p_gyear_03
tab a_gyear, gen(a_gyear_)
drop a_gyear_1
rename a_gyear_2 a_gyear_90
rename a_gyear_3 a_gyear_91
rename a_gyear_4 a_gyear_92
rename a_gyear_5 a_gyear_93
rename a_gyear_6 a_gyear_94
rename a_gyear_7 a_gyear_95
rename a_gyear_8 a_gyear_96
rename a_gyear_9 a_gyear_97
rename a_gyear_10 a_gyear_98
rename a_gyear_11 a_gyear_99
rename a_gyear_12 a_gyear_00
rename a_gyear_13 a_gyear_01
rename a_gyear_14 a_gyear_02
tab p_type, gen(p_type_)
saveold "C:/Stata/#14150/CF Estimation Dataset.dta", replace

log using "C:/Stata/#14150/results-log.smcl", replace

program 	nlestimation_table1_1
		version 10.0

		if "`1'"=="?" {                
		    global S_1 " D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 D26 D27 D28 D29 D30 D31 D32 D33 D34 D35 B1 B2"
			    global D1 = 0
                global D2 = 0.1
                global D3 = 0.2
                global D4 = 0.3
                global D5 = 0.4
                global D6 = 0.5
                global D7 = 0.6
                global D8 = 0.7
                global D9 = 0.8
                global D10 = 0.9
                global D11 = 1
                global D12 = 1.1
                global D13 = 1.2
                global D14 = 0
                global D15 = 0
                global D16 = 0
                global D17 = 0
                global D18 = 0
                global D19 = 0
                global D20 = 0
                global D21 = 0
                global D22 = 0
                global D23 = 0
                global D24 = 0
                global D25 = 0
                global D26 = 0
				global D27 = -0.3
                global D28 = 10
                global D29 = -6
				global D30 = 0
				global D31 = 0
				global D32 = 0
				global D33 = 0
				global D34 = 0
				global D35 = 0
				global B1 = 0.3    
				global B2 = 0           
				exit
   }

   replace `1' = ( 1 + /*	
                */ $D1*p_gyear_91 + /*
                */ $D2*p_gyear_92 + /*
                */ $D3*p_gyear_93 + /*
                */ $D4*p_gyear_94 + /*
                */ $D5*p_gyear_95 + /*
                */ $D6*p_gyear_96 + /*
                */ $D7*p_gyear_97 + /*
                */ $D8*p_gyear_98 + /*
                */ $D9*p_gyear_99 + /*
			    */ $D10*p_gyear_00 + /*
                */ $D11*p_gyear_01 + /*
                */ $D12*p_gyear_02 + /*
                */ $D13*p_gyear_03) * /*
                */ ( 1 + /*
                */ $D14*a_gyear_90 + /*
                */ $D15*a_gyear_91 + /*
                */ $D16*a_gyear_92 + /*
                */ $D17*a_gyear_93 + /*
                */ $D18*a_gyear_94 + /*
                */ $D19*a_gyear_95 + /*
                */ $D20*a_gyear_96 + /*
                */ $D21*a_gyear_97 + /*
                */ $D22*a_gyear_98 + /*
                */ $D23*a_gyear_99 + /*
                */ $D24*a_gyear_00 + /*
                */ $D25*a_gyear_01 + /*
                */ $D26*a_gyear_02 ) * /*
                */ ( 1 + /*
                */ $D27*p_jp + /*
                */ $D28*a_software + /*
                */ $D29*p_jp*a_software ) * /*
		        */ ( 1 + /*
                */ $D30*p_type_2 + /*
                */ $D31*p_type_3 + /*
                */ $D32*p_type_4 + /*
                */ $D33*p_type_5 + /*
                */ $D34*p_type_6 + /*
                */ $D35*p_type_7 ) * /*		
                */ exp(-$B1*lag)*(1-exp(-$B2*lag))
end

gen lag=p_gyear-a_gyear

nl estimation_table1_1 ratio [weight=sqrtcc] if lag>0



program 	nlestimation_table1_2
		version 10.0

		if "`1'"=="?" {                
		    global S_1 " D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 D26 D27 D28 D29 D30 D31 D32 D33 B1 B2"
			    global D1 = 0
                global D2 = 0.1
                global D3 = 0.2
                global D4 = 0.3
                global D5 = 0.4
                global D6 = 0.5
                global D7 = 0.6
                global D8 = 0.7
                global D9 = 0.8
                global D10 = 0.9
                global D11 = 1
                global D12 = 1.1
                global D13 = 1.2
                global D14 = 0
                global D15 = 0
                global D16 = 0
                global D17 = 0
                global D18 = 0
                global D19 = 0
                global D20 = 0
                global D21 = 0
                global D22 = 0
                global D23 = 0
                global D24 = 0
				global D25 = 0
                global D26 = 0
                global D27 = -0.6
                global D28 = 0
                global D29 = 0
				global D30 = 0
				global D31 = 0
				global D32 = 0
				global D33 = 0
				global B1 = 0.3    
				global B2 = 0           
				exit
   }

   replace `1' = ( 1 + /*	
                */ $D1*p_gyear_91 + /*
                */ $D2*p_gyear_92 + /*
                */ $D3*p_gyear_93 + /*
                */ $D4*p_gyear_94 + /*
                */ $D5*p_gyear_95 + /*
                */ $D6*p_gyear_96 + /*
                */ $D7*p_gyear_97 + /*
                */ $D8*p_gyear_98 + /*
                */ $D9*p_gyear_99 + /*
			    */ $D10*p_gyear_00 + /*
                */ $D11*p_gyear_01 + /*
                */ $D12*p_gyear_02 + /*
                */ $D13*p_gyear_03) * /*
                */ ( 1 + /*
                */ $D14*a_gyear_90 + /*
                */ $D15*a_gyear_91 + /*
                */ $D16*a_gyear_92 + /*
                */ $D17*a_gyear_93 + /*
                */ $D18*a_gyear_94 + /*
                */ $D19*a_gyear_95 + /*
                */ $D20*a_gyear_96 + /*
                */ $D21*a_gyear_97 + /*
                */ $D22*a_gyear_98 + /*
                */ $D23*a_gyear_99 + /*
                */ $D24*a_gyear_00 + /*
                */ $D25*a_gyear_01 + /*
                */ $D26*a_gyear_02 ) * /*
		        */ ( 1 + /*
                */ $D27*p_jp) * /*
		        */ ( 1 + /*
                */ $D28*p_type_2 + /*
                */ $D29*p_type_3 + /*
                */ $D30*p_type_4 + /*
                */ $D31*p_type_5 + /*
                */ $D32*p_type_6 + /*
                */ $D33*p_type_7 ) * /*		
                */ exp(-$B1*lag)*(1-exp(-$B2*lag))
end

nl estimation_table1_2 ratio [weight=sqrtcc] if lag>0 & a_software==1

log off
log close

