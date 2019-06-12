


		
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
* Open politicians data and match by gender and cohort to the percentile values
use "ENGLISH politicians with pol and background data 1988-2011.dta", clear

keep if (year ==2003 | year ==2007 |year ==2011) 
keep if elected==1 | nominated ==1 | elec_parl==1
keep p_id income04 birthyear sex elected nominated partyinitial m_id elec_parl electionyear year
		
* Join with data on appointments
gen valar =electionyear
joinby p_id valar using "uppdrag.dta", unmatched(master)
drop _merge
		

* Join with data on the politicians' own income percentiles
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons
replace year=electionyear+1

joinby birthyear sex year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\inc_pct_panel sex birthyear 1990-2012.dta", unmatched(master) _merge(_merge)
drop _merge
			
* Allocate politicians to their percentile

gen polpct = .
forvalues n = 2(1)100 {
	local i=`n'-1
	replace polpct = `n' if income04 <= p`n' & income04>p`i' & income04!=.					
}

	
replace polpct = 1 if income04<=p1
rop p1-p100
				
		
* Join with data on the partents income percentiles in 1979

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Parents-politicians comparison"
joinby p_id using "Parents income 1979.dta", unmatched(master)
			

***Figures on politicians used for Figure 4		
histogram parpct_f if elected==1 & partyinitial=="S", width(5) start(0) title("Elected")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected S fathers_5w.gph", replace			
histogram parpct_f if kso==1,  width(5) start(0) title("Mayors")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).06, angle(horizontal))
graph save "mayor fathers_5w.gph", replace
	
histogram parpct_f if elec_parl==1,  width(5) start(0) title("Parliamentarians")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).056, angle(horizontal))
graph save "parliamentarian fathers_5w.gph", replace

***Figures on politicians used for Figure A2		
histogram parpct_m if kso==1,  width(5)   start(0) title("Mayors")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).04, angle(horizontal))
graph save "mayor mothers_5w.gph", replace

histogram parpct_m if elec_parl==1,  width(5)  start(0) title("Parliamentarians")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).04, angle(horizontal))
graph save "parliamentarian mothers_5w.gph", replace

histogram parpct_m if elected==1, width(5) start(0) title("Elected politicians")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).04, angle(horizontal))
graph save "elected mothers_5w.gph", replace
		

***Figures used in Figure 5
histogram parpct_f if elected==1 & partyinitial=="S", width(5) start(0) title("Social Democrats")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected S fathers_5w.gph", replace
		
histogram parpct_f if elected==1 & partyinitial=="M", width(5) start(0) title("Conservatives")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected M fathers_5w.gph", replace
		
histogram parpct_f if elected==1 & partyinitial=="C", width(5) start(0) title("Center Party")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected C fathers_5w.gph", replace
		
histogram  polpct if elected==1 & partyinitial=="S", width(5) start(0) title("Social Democrats")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected S 5w.gph", replace
		
histogram  polpct if elected==1 & partyinitial=="M", width(5) start(0) title("Conservatives")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected M 5w.gph", replace
		
histogram polpct if elected==1 & partyinitial=="C", width(5) start(0) title("Center Party")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).05, angle(horizontal))
graph save "elected C 5w.gph", replace


clear

cd  "\\micro.intra\Projekt\P0624$\P0624_Gem\Promotions and divorce"

*Extract occupational data
odbc load, exec("select occ_code=Ssyk4, o_nr=Peorgnr_LopNr, p_id=Person_LopNr from P0624_Lisa_2003") dsn("P0624") clear
gen year=2003
save temp, replace

odbc load, exec("select occ_code=Ssyk4, o_nr=Peorgnr_LopNr, p_id=Person_LopNr from P0624_Lisa_2007") dsn("P0624") clear
gen year=2011
append using temp
save temp, replace

odbc load, exec("select occ_code=Ssyk4, o_nr=Peorgnr_LopNr, p_id=Person_LopNr from P0624_Lisa_2011") dsn("P0624") clear
gen year=2011
append using temp


*Make dummy for Doctors and Ceos
destring occ_code, force replace

gen ceo =occ_code==1210

drop if Sun2000Inr=="721x"


keep if doctor==1 |ceo==1

*Join with data on firm size
joinby o_nr year using "\\micro.intra\projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\firms\firms 20 emp 2001_2012.dta" , unmatched(master)
   

			
* Join with data on the partents income percentiles
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Parents-politicians comparison"
joinby p_id using "Parents income 1979.dta", unmatched(master)
drop _merge
			

*Figures for Figure 4
histogram parpct_f if doctor_exam==1, width(5) start(0) title("Doctors")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).06, angle(horizontal))
graph save "doc fathers_5w.gph", replace
		
histogram parpct_f if ceo==1 & empl>=10 & empl<250,  width(5) start(0) title("CEOs 10-249 emp")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))   ylabel(0(.01).06, angle(horizontal))
graph save "ceo 10_250_fathers_5w.gph", replace
	
histogram parpct_f if ceo==1 & empl>=250 & empl!=.,  width(5) start(0) title("CEOs at least 250 emp.")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))   ylabel(0(.01).06, angle(horizontal))
graph save "ceo 250_fathers_5w.gph", replace
	

*Figures for Figure A2
histogram parpct_m if doctor_exam==1, width(5) start(0) title("Doctors")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(0(.01).04, angle(horizontal))
graph save "doc mothers_5w.gph", replace
	
histogram parpct_m if ceo==1 & empl>=10 & empl<250,  width(5) start(0) title("CEOs 10-249 emp")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))   ylabel(0(.01).04, angle(horizontal))
graph save "ceo 10_250_mothers_5w.gph", replace
	
histogram parpct_m if ceo==1 & empl>=250 & empl!=.,  width(5) start(0) title("CEOs at least 250 emp.")  xtitle(Income Percentile) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))   ylabel(0(.01).04, angle(horizontal))
graph save "ceo 250_mothers_5w.gph", replace
	
	
		