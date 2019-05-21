***********************************************************
***********************************************************
*Replication file for Analysis in Gauri, Staton and Vargas*
**********************************************************
***********************************************************



*Open Data File
	clear
	
	cd "..." ///Choose working directory using appropriate path
	
	use "salacomply",clear    ///Open data file


	log using replicate_log, replace

*I. Analysis in the Paper
*1. Table 1
	stcox voteapril, efron cluster(numerodevoto)
	stcox voteapril if votedate<=td(01feb2010)|votedate>=td(01may2010), efron cluster(numerodevoto)
	stcox voteapril if votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(numerodevoto)
	xi: stcox voteapril i.instcode, efron cluster(instcode)


*2. Figure 3 -- Models with control variables
*A. All votes
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(numerodevoto)
	parmest, saving("estimates1.dta",replace)
	use "estimates1.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("All Votes")xline(1) scheme(s1mono) ///
	cap(N=2556 with 2347 failures.)
	graph save "aprilall", replace

*B. 2009-2010
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01dec2010), efron cluster(numerodevoto)
	parmest, saving("estimates2.dta",replace)
	use "estimates2.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2009-2010")xline(1) scheme(s1mono) ///
	cap(N=1875 with 1741 failures.)
	graph save "april2010", replace


*C. Prior to 9/2010
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(numerodevoto)
	parmest, saving("estimates3.dta",replace)
	use "estimates3.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("Prior to 10/2010") xline(1) scheme(s1mono) ///
	cap(N=1540 with 1446 failures.)
	graph save "aprilsept", replace

*D. 2/2010-5/2010
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(numerodevoto)
	parmest, saving("estimates4.dta",replace)
	use "estimates4.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)4) ylabel(1(1)11) ytitle("") title("2/2010-5/2010")xline(1) scheme(s1mono) ///
	cap(N=581 with 549 failures.)
	graph save "aprilsmall", replace


	gr combine "aprilall" "april2010" ///
	"aprilsept" "aprilsmall" ,scheme(s1mono)
	graph save "summary1_cases", replace
	graph export "summary1_cases.pdf", replace

*3. Figure 4 -- Placebo tests
*The thresholds here are all for small windows of observation. If the press release had an effect, we should see differences for ///
*any threshold, if we include the entire sample. We thus focus on changes that might have occurred focusing on cases resolved in the ///
*immediate window around fake conference dates. 

*A. January 
	use "salacomply",clear
	xi: stcox votejan caja msalud obras i.plazoint reqactclear if reqactclear>=0 &votedate>=td(01nov2009)&votedate<=td(01mar2010), efron cluster(numerodevoto)
	parmest, saving("estimates_fakejan.dta",replace)
	use "estimates_fakejan.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "Jan. 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("January")xline(1) scheme(s1mono) ///
	cap(N=726 with 665 failures.)
	graph save "jan_fake", replace

*B. May
	use "salacomply",clear
	xi: stcox votemay caja msalud obras i.plazoint reqactclear if reqactclear>=0 &votedate>=td(01apr2010)&votedate<=td(01jun2010), efron cluster(numerodevoto)
	parmest, saving("estimates_fakemay.dta",replace)
	use "/Users/jkstato/Dropbox/Saladata/LASA2013/estimates9.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "May 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("May")xline(1) scheme(s1mono) ///
	cap(N=317 with 304 failures.)
	graph save "may_fake", replace

*C. August
	use "salacomply",clear
	gen voteaug=1 if votedate>=td(1aug2010)
	replace voteaug =0 if votedate<td(1aug2010)
	replace voteaug =. if votedate==.
	label variable voteaug "Vote After 1 August 2010"
	xi: stcox voteaug caja msalud obras i.plazoint reqactclear if reqactclear>=0 &votedate>=td(01jul2010)&votedate<=td(01sep2010), efron cluster(numerodevoto)
	parmest, saving("estimates_fakeaug.dta",replace)
	use "estimates_fakeaug.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "Sept. 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("August")xline(1) scheme(s1mono) ///
	cap(N=351 with 333 failures.)
	graph save "august_fake", replace

*D.  November
	use "salacomply",clear
	gen votenov=1 if votedate>=td(1nov2010)
	replace votenov =0 if votedate<td(1nov2010)
	replace votenov =. if votedate==.
	label variable votenov "Vote After 1 November 2010"
	xi: stcox votenov caja msalud obras i.plazoint reqactclear if reqactclear>=0 & votedate>=td(01oct2010)&votedate<=td(01dec2010), efron cluster(numerodevoto)
	parmest, saving("estimates_fakenov.dta",replace)
	use "estimates_fakenov.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "Nov. 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("November")xline(1) scheme(s1mono) ///
	cap(N=335 with 295 failures.)
	graph save "nov_fake", replace

	gr combine "jan_fake" ///
	"may_fake" "august_fake" "nov_fake" , colf scheme(s1mono)
	graph save "fake", replace
	graph export "fake.pdf", replace


*II. Appendix
*1. Table 1
	use "salacomply", clear
	tab cgrade if caja==1&votedate>=td(01oct2009)&votedate<=td(01nov2009)&mcount==1
	*Note that probable compliance is treated as compliance by the Constitutional Chamber 
	
*2. Table 2
	use "salacomply", clear
	tab cgrade if votedate<=td(31dec2009)&mcount==1
	tab cgrade if votedate>=td(01jan2010)&votedate<=td(31dec2010)&mcount==1
	tab cgrade if votedate>=td(01jan2011)&mcount==1


*3. Table 3
	*A. Models with errors clustered within cases
	use "salacomply", clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(numerodevoto)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01dec2010), efron cluster(numerodevoto)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(numerodevoto)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(numerodevoto)

	*B. Models with errors clustered within agencies
	use "salacomply", clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01dec2010), efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(instcode)

	*C. Models with errors clustered within periods Pre/Post April
	use "salacomply", clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(voteapril)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01dec2010), efron cluster(voteapril)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(voteapril)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(voteapril)


*4. Figure 2
*A. All votes
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(numerodevoto)
	parmest, saving("estimates1.dta",replace)
	use "estimates1.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("All Votes")xline(1) scheme(s1mono) ///
	cap(N=2556 with 2347 failures.)
	graph save "aprilall", replace

*B. 2009-2010
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(31dec2010), efron cluster(numerodevoto)
	parmest, saving("estimates2.dta",replace)
	use "estimates2.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2009-2010")xline(1) scheme(s1mono) ///
	cap(N=1875 with 1741 failures.)
	graph save "april2010", replace

*C. All votes (Errors clustered within agencies)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(instcode)
	parmest, saving("estimates1b.dta",replace)
	use "estimates1b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("All Votes" (Agencies))xline(1) scheme(s1mono) ///
	cap(N=2556 with 2347 failures.)
	graph save "aprilall_e", replace

*D. 2009-2010 (Errors clustered within agencies)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01dec2010), efron cluster(instcode)
	parmest, saving("estimates2b.dta",replace)
	use "estimates2b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2009-2010" (Agencies))xline(1) scheme(s1mono) ///
	cap(N=1875 with 1741 failures.)
	graph save "april2010_e", replace


	gr combine "aprilall" "aprilall_e" ///
	"april2010" "april2010_e"  ,scheme(s1mono) title(Errors clustered within case or agency)
	graph save "cluster_12a", replace
	graph export "cluster_12a.pdf", replace

*5. Figure 3
*A. Prior to Oct. 2010 (errors clustered on case)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(numerodevoto)
	parmest, saving("estimates3.dta",replace)
	use "estimates3.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("Prior to 10/2010") xline(1) scheme(s1mono) ///
	cap(N=1540 with 1446 failures.)
	graph save "aprilsept", replace

*B. Small Window  (errors clustered on case)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(numerodevoto)
	parmest, saving("estimates4.dta",replace)
	use "estimates4.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)4) ylabel(1(1)11) ytitle("") title("2/2010-5/2010")xline(1) scheme(s1mono) ///
	cap(N=581 with 549 failures.)
	graph save "aprilsmall", replace

*C. Prior to Oct. 2010 (errors clustered on agency)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(instcode)
	parmest, saving("estimates3b.dta",replace)
	use "estimates3b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("Prior to 10/2010" (Agencies)) xline(1) scheme(s1mono) ///
	cap(N=1540 with 1446 failures.)
	graph save "aprilsept_e", replace

*D. Small Window (errors clustered on  agency)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(instcode)
	parmest, saving("estimates4b.dta",replace)
	use "estimates4b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2/2010-5/2010" (Agencies))xline(1) scheme(s1mono) ///
	cap(N=581 with 549 failures.)
	graph save "aprilsmall_e", replace

	gr combine "aprilsept"	"aprilsept_e" 		///
	"aprilsmall" "aprilsmall_e",scheme(s1mono) title(Errors clustered within case or agency)
	graph save "cluster_12b", replace
	graph export "cluster_12b.pdf", replace

*6. Figure 4

*A. All votes (shared frailty among agencies)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron shared(instcode)
	parmest, saving("estimates1c.dta",replace)
	use "estimates1c.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("All Votes, Frailty model")xline(1) scheme(s1mono) ///
	cap(N=2556 with 2347 failures.)
	graph save "aprilall_c", replace
	
*B. 2009-2010 (shared frailty among agencies)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(31dec2010), efron shared(instcode)
	parmest, saving("estimates2c.dta",replace)
	use "estimates2c.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2009-2010, Frailty model")xline(1) scheme(s1mono) ///
	cap(N=2680 with 2491 failures.)
	graph save "april2010_c", replace

*C. All votes (errors clustered on pre and post press conference) 
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0, efron cluster(voteapril)
	parmest, saving("estimates1b.dta",replace)
	use "estimates1b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("All Votes" (Press))xline(1) scheme(s1mono) ///
	cap(N=2556 with 2347 failures.)
	graph save "aprilall_d", replace

*D. 2009-2010 (errors clustered on pre and post press conference)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(31dec2010), efron cluster(voteapril)
	parmest, saving("estimates2b.dta",replace)
	use "estimates2b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2009-2010" (Press))xline(1) scheme(s1mono) ///
	cap(N=1875 with 1741 failures.)
	graph save "april2010_d", replace

		
	gr combine "aprilall_c" "aprilall_d" ///
	"april2010_c" "april2010_d"  ,scheme(s1mono) title(Frailty models and errors clustered within periods)
	graph save "cluster_34a", replace
	graph export "cluster_34a.pdf", replace



*7. Figure 5
*A. Prior to Oct. 2010  (shared frailty among agencies)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron shared(instcode)
	parmest, saving("estimates3c.dta",replace)
	use "estimates3c.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("Prior to 10/2010, Frailty model") xline(1) scheme(s1mono) ///
	cap(N=1540 with 1446 failures.)
	graph save "aprilsept_c", replace

*B. Small Window  (shared frailty among agencies)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron shared(instcode)
	parmest, saving("estimates4c.dta",replace)
	use "estimates4c.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)8) ylabel(1(1)11) ytitle("") title("2/2010-5/2010, Frailty model")xline(1) scheme(s1mono) ///
	cap(N=581 with 549 failures.)
	graph save "aprilsmall_c", replace


*C. Prior to Oct. 2010 (errors clustered on pre and post press conference)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate<=td(01sep2010), efron cluster(voteapril)
	parmest, saving("estimates3b.dta",replace)
	use "estimates3b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("Prior to 10/2010" (Press)) xline(1) scheme(s1mono) ///
	cap(N=1540 with 1446 failures.)
	graph save "aprilsept_d", replace

*D. Small Window (errors clustered on pre and post press conference)
	use "salacomply",clear
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(voteapril)
	parmest, saving("estimates4b.dta",replace)
	use "estimates4b.dta",clear
	sencode parm, gen(parmid)
	label define model 1 "April 2010" 2 "Caja" 3 "Min. Salud" 4 "Obras" 5 "One Week" 6 "Two Weeks" 7 "Month" 8 "One-Six Months" 9 "More Six" 10 "Sin Plazo" 11 "Clear Order"
	label values parmid model
	replace estimate=exp(estimate)
	replace min95=exp(min95)
	replace max95=exp(max95)
	eclplot estimate min95 max95 parmid, hori xtitle(Hazard Ratio) xlabel(0(1)3) ylabel(1(1)11) ytitle("") title("2/2010-5/2010" (Press))xline(1) scheme(s1mono) ///
	cap(N=581 with 549 failures.)
	graph save "aprilsmall_d", replace

	gr combine "aprilsept_c"	"aprilsept_d" 		///
	 "aprilsmall_c" "aprilsmall_d",scheme(s1mono) title(Frailty models and errors clustered within periods)
	graph save "cluster_34b", replace
	graph export "cluster_34b.pdf", replace


*8. Table 4 (Fixed effects models)
**6. Fixed effects models
	use "salacomply",clear
	xi: stcox voteapril i.instcode, efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear i.instcode if reqactclear>=0, efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear i.instcode if reqactclear>=0& votedate<=td(31dec2010), efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear i.instcode if reqactclear>=0& votedate<=td(01sep2010), efron cluster(instcode)
	xi: stcox voteapril caja msalud obras  i.plazoint reqactclear i.instcode if reqactclear>=0& votedate>=td(01feb2010)&votedate<=td(01may2010), efron cluster(instcode)

	log close
