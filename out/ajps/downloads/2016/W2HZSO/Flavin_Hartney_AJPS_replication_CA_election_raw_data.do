*Data files for California elections (from the California Elections Data Archive) for individual years for 2004-2013 in .xls format are available at: http://www.csus.edu/isr/projects/ceda.html 
*USER NOTE: Some of the entries in the CEDA files contained errors, the corrections are documented below
*USER NOTE: Because CEDA reports elections that are in a single county vs. multiple counties differently, two data files (one for single county, one for multi-county) are saved for each year and then appended together

**********************************************
clear
import excel "CEDA2004Data.xls", sheet("Candidates2004") firstrow allstring
drop YEAR
gen year=2004
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/2/2004"
///Drop LOOMIS UNION ELEMENTARY because it was actually for a seat in a new district that didn't exist yet (see:http://www.auburnjournal.com/article/atkins-and-foster-join-loomispenryn-board)
drop if Multi_RaceID=="200401137" | Multi_RaceID=="200401138"
*Start with single county elections (keep only single county elections)
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
*Merge in stata file that allows us to highlight and then delete any observations that are for community college districts and county offices of education
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
sort CO PLACE
*Merge in unique identifier for each district (merging by county and place name in CEDA data)
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save file as completed 2004 file for all single county incumbent observations
save "CEDA_BoardIncumbents_2004s.dta", replace
///MultiCounty 2004 (repeat same as above now, but for multi-county races)
clear
import excel "CEDA2004Data.xls", sheet("Candidates2004") firstrow allstring
drop YEAR
gen year=2004
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/2/2004"
///Drop LOOMIS UNION ELEMENTARY because it was actually for a seat in a new district that didn't exist yet (see:http://www.auburnjournal.com/article/atkins-and-foster-join-loomispenryn-board)
drop if Multi_RaceID=="200401137" | Multi_RaceID=="200401138"
*Keep only single county elections
keep if Multi_CO=="1"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
keep if meani==0 | meani==1
drop meani i
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
sort CO PLACE
*Keep incumbents only
keep if INCUMB=="Y"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Now combine single and multi for 2004 to create completed 2004 incumbent observations
save "CEDA_BoardIncumbents_2004m.dta", replace
append using "CEDA_BoardIncumbents_2004s.dta"
save "CEDA_BoardIncumbents_2004.dta", replace
***********************************************************

clear
import excel "CEDA2005Data.xls", sheet("Candidates2005") firstrow allstring
drop YEAR
gen year=2005
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/8/2005"
*Fix error in Shoreline Unified (it is a multi county race that wasn't coded that way)
replace Multi_RaceID="200500538" if Multi_RaceID=="200500417"
replace Multi_CO="1" if Multi_RaceID=="200500538"
replace Multi_CandID="200502269" if Multi_CandID=="200501768"
replace Rindivto="1" if Multi_CandID=="200502269" 
replace newelected="1" if Multi_CandID=="200502269"
replace indivtotal_votes="1412" if Multi_CandID=="200502269"
replace multitotal_votes="4100" if Multi_RaceID=="200500538"
replace newtotvotes="4112" if Multi_RaceID=="200500538"
*Drop race that is wrongly coded as a school district (it is a community college race, CEDA mistake)
drop if Multi_RaceID=="200500452"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
sort CO PLACE
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2005
save "CEDA_BoardIncumbents_2005s.dta", replace

///2005 Multi County
clear
import excel "CEDA2005Data.xls", sheet("Candidates2005") firstrow allstring
drop YEAR
gen year=2005
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/8/2005"
*Fix error in Shoreline Unified (it is a multi county race that wasn't coded that way)
replace Multi_RaceID="200500538" if Multi_RaceID=="200500417"
replace Multi_CO="1" if Multi_RaceID=="200500538"
replace Multi_CandID="200502269" if Multi_CandID=="200501768"
replace Rindivto="1" if Multi_CandID=="200502269" 
replace newelected="1" if Multi_CandID=="200502269"
replace indivtotal_votes="1412" if Multi_CandID=="200502269"
replace multitotal_votes="4100" if Multi_RaceID=="200500538"
replace newtotvotes="4112" if Multi_RaceID=="200500538"
*Drop race that is wrongly coded as a school district (it is a community college race, CEDA mistake)
drop if Multi_RaceID=="200500452"
*Keep only single county elections
keep if Multi_CO=="1"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
keep if meani==0 | meani==1
drop i meani

keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
sort CO PLACE
*Keep incumbents only
keep if INCUMB=="Y"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
save "CEDA_BoardIncumbents_2005m.dta", replace
append using "CEDA_BoardIncumbents_2005s.dta"
save "CEDA_BoardIncumbents_2005.dta", replace
***********************************************************

clear
import excel "CEDA2006Data.xls", sheet("Candidates2006") firstrow allstring
drop YEAR
gen year=2006
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/7/2006"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
*2006 Fix Errata
///1 Multi_RaceID# 200601611 lists 6 candidates contesting for 3 seats. However, only 5 candidates are included
///in the data. After consulting county elections office found that there were indeed 6 candidates. The "win"
///variable needs to be corrected here as well. However, upon further investigation it appears all of the
///candidates were appointed incumbents. The district had been created in 2005 so this observation should
///probably be dropped. 
drop if Multi_RaceID=="200601611"
sort CO PLACE
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2006
save "CEDA_BoardIncumbents_2006s.dta", replace

////Clean 2006 MultiCounty
clear
import excel "CEDA2006Data.xls", sheet("Candidates2006") firstrow allstring
drop YEAR
gen year=2006
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/7/2006"
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
*Get rid of charter districts
drop if PLACE=="KINGSBURG ELEMENTARY CHARTER"
*Keep only multi county elections
keep if Multi_CO=="1"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*2006 Errata
///Multi_RaceID# 200601611 lists 6 candidates contesting for 3 seats. However, only 5 candidates are included
///in the data. After consulting county elections office found that there were indeed 6 candidates. The "win"
///variable needs to be corrected here as well. However, upon further investigation it appears all of the
///candidates were appointed incumbents. The district had been created in 2005 so this observation should
///probably be dropped. 
drop if Multi_RaceID=="200601611"
///1 Fix errors in Modoc Joint 
replace indivtotal_votes="1604" if Multi_CandID=="200603918"
replace Rindivto="1" if Multi_CandID=="200603918"
replace Rindivto="2" if Multi_CandID=="200604028"
///2 Fix errors in Grant Joint Union
replace indivtotal_votes="11556" if Multi_CandID=="200604199"
replace newelected="1" if Multi_CandID=="200604199"
replace Rindivto="2" if Multi_CandID=="200604199"
replace Rindivto="3" if Multi_CandID=="200604337"
replace Rindivto="4" if Multi_CandID=="200604336"
replace Rindivto="5" if Multi_CandID=="200604335"
replace Rindivto="6" if Multi_CandID=="200604334"
replace newelected="2" if Multi_CandID=="200604336"
///3 *David Read is not an incumbent in the Bass Lake race in 2006 (confirmed in county voter statement)
replace  INCUMB="N" if Multi_CandID=="200604014"
///4 *Discrepancy in incumbency status for 4 candidates (drop them) Duarte, Funtas, Wells, Wyllie
drop if Multi_CandID=="200604282"
drop if Multi_CandID=="200604283"
drop if Multi_CandID=="200604286"
drop if Multi_CandID=="200604294"
drop if Multi_CandID=="200604327"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
*Keep incumbents only
keep if INCUMB=="Y"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
save "CEDA_BoardIncumbents_2006m.dta", replace
append using "CEDA_BoardIncumbents_2006s.dta"
save "CEDA_BoardIncumbents_2006.dta", replace
*************************
*************************
*************************
*BEGIN 2007
clear
import excel "CEDA2007Data.xls", sheet("Candidates2007") firstrow allstring
drop YEAR
gen year=2007
*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Fix this:
replace Multi_CO="1" if Multi_RaceID=="200700279" | Multi_RaceID=="200700511"
replace Multi_RaceID="200700279" if Multi_RaceID=="200700511"
replace Multi_CandID="200701055" if Multi_CandID=="200701918" 
replace Multi_CandID="200701057" if Multi_CandID=="200701920" 
replace indivtotal_votes="91" if Multi_CandID=="200701055"
replace indivtotal_votes="66" if Multi_CandID=="200701057"
replace multitotal_votes="219" if Multi_RaceID=="200700279"
replace newtotvotes="219" if Multi_RaceID=="200700279"
replace Rindivto="1" if Multi_CandID=="200701055" 
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/6/2007"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
*Save as cleaned single county file for 2007
sort CO PLACE
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
save "CEDA_BoardIncumbents_2007s.dta", replace


///2007 MultiCounty
clear
import excel "CEDA2007Data.xls", sheet("Candidates2007") firstrow allstring
drop YEAR
gen year=2007
*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Fix this:
replace Multi_CO="1" if Multi_RaceID=="200700279" | Multi_RaceID=="200700511"
replace Multi_RaceID="200700279" if Multi_RaceID=="200700511"
replace Multi_CandID="200701055" if Multi_CandID=="200701918" 
replace Multi_CandID="200701057" if Multi_CandID=="200701920" 
replace indivtotal_votes="91" if Multi_CandID=="200701055"
replace indivtotal_votes="66" if Multi_CandID=="200701057"
replace multitotal_votes="219" if Multi_RaceID=="200700279"
replace newtotvotes="219" if Multi_RaceID=="200700279"
replace Rindivto="1" if Multi_CandID=="200701055" 

*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/6/2007"
*Keep only single county elections
keep if Multi_CO=="1"
*Fix incumbent discrepancies
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
drop if meani==.5
drop meani i 
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
*Bring in CDS
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Save as cleaned multi county file for 2007
save "CEDA_BoardIncumbents_2007m.dta", replace
append using "CEDA_BoardIncumbents_2007s.dta"
save "CEDA_BoardIncumbents_2007.dta", replace

*************************
*************************
*************************
*BEGIN 2008
clear
import excel "CEDA2008Data.xls", sheet("Candidates2008") firstrow allstring
drop YEAR
gen year=2008
*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Fix this:
replace Multi_CO="1" if Multi_RaceID=="200801375" | Multi_RaceID=="200801116"
replace Multi_RaceID="200801375" if Multi_RaceID=="200801116"
replace Multi_CandID="200804701" if Multi_CandID=="200803766" 
replace indivtotal_votes="1223" if Multi_CandID=="200804701"
replace multitotal_votes="2400" if Multi_RaceID=="200804701"
replace newtotvotes="2406" if Multi_RaceID=="200804701"
replace newelected="1" if Multi_CandID=="200804701"
replace Rindivto="1" if Multi_CandID=="200804701"
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/4/2008"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop charter
drop if PLACE=="PIONEER UNION ELEMENTARY" & CO=="16"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
sort CO PLACE
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
save "CEDA_BoardIncumbents_2008s.dta", replace

///2008 MultiCounty
clear
import excel "CEDA2008Data.xls", sheet("Candidates2008") firstrow allstring
drop YEAR
gen year=2008
*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Fix this:
replace Multi_CO="1" if Multi_RaceID=="200801375" | Multi_RaceID=="200801116"
replace Multi_RaceID="200801375" if Multi_RaceID=="200801116"
replace Multi_CandID="200804701" if Multi_CandID=="200803766" 
replace indivtotal_votes="1223" if Multi_CandID=="200804701"
replace multitotal_votes="2400" if Multi_RaceID=="200804701"
replace newtotvotes="2406" if Multi_RaceID=="200804701"
replace newelected="1" if Multi_CandID=="200804701"
replace Rindivto="1" if Multi_CandID=="200804701"
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/4/2008"
*Keep only single county elections
keep if Multi_CO=="1"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Drop charter
drop if PLACE=="PIONEER UNION ELEMENTARY" & CO=="16"
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
keep if meani==0 | meani==1
drop meani i
keep if INCUMB=="Y"
///Errata 2008
///1 Fix error in Gregory Schoonard's (Candidate ID: 200803727) file which failed to add together his votes across counties properly
replace indivtotal_votes="5130" if Multi_CandID=="200803727"
replace Rindivto="3" if Multi_CandID=="200803727"
replace newelected="1" if Multi_CandID=="200803727"
///2 Fix error in Christine Wilder's (Candidate ID: 200803737) file which failed to add together her votes across counties properly
replace Rindivto="2" if Multi_CandID=="200803737"
///3 Fix error in Ross Swindelhurst's (Candidate ID: 200804189) file which failed to add together his votes across counties properly
replace indivtotal_votes="917" if Multi_CandID=="200804189"
replace newelected="1" if Multi_CandID=="200804189"
replace Rindivto="1" if Multi_CandID=="200804189"
///4 Fix error in Tom Hawkins (Candidate ID: 200803280) file which failed to add together his votes across counties properly
replace indivtotal_votes="14787" if Multi_CandID=="200803280"
replace newelected="1" if Multi_CandID=="200803280"
replace Rindivto="1" if Multi_CandID=="200803280"
///5 Fix error in Rhonda Johnson-Goodwater's (Candidate ID:200804714) file which failed to add her votes across counties properly
replace indivtotal_votes="8345" if Multi_CandID=="200804714"
replace newelected="1" if Multi_CandID=="200804714"
replace Rindivto="2" if Multi_CandID=="200804714"
///6 Fix error in Juan Gonzalez's (Candidate ID: 200804957) file which failed to add his votes across counties properly
replace indivtotal_votes="168" if Multi_CandID=="200804957"
replace newelected="2" if Multi_CandID=="200804957"
replace Rindivto="4" if Multi_CandID=="200804957"
///7 Fix error in Total Vote (denominator) observations for Race ID:200801375
replace total_writein="6" if Multi_RaceID=="200801375"
replace multitotal_votes="2400" if Multi_RaceID=="200801375"
replace newtotvotes="2406" if Multi_RaceID=="200801375"
save "CEDA_BoardIncumbents_2008m.dta", replace
***Collapse to single obs per multicounty race
keep if Multi_CO=="1"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
save "CEDA_BoardIncumbents_2008m.dta", replace
append using "CEDA_BoardIncumbents_2008s.dta"
save "CEDA_BoardIncumbents_2008.dta", replace

*************************
*************************
*************************
*BEGIN 2009
clear
import excel "CEDA2009Data.xls", sheet("Candidates2009") firstrow allstring
drop YEAR
gen year=2009
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/3/2009"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2009
save "CEDA_BoardIncumbents_2009s.dta", replace


///2009 MultiCounty
clear
import excel "CEDA2009Data.xls", sheet("Candidates2009") firstrow allstring
drop YEAR
gen year=2009
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/3/2009"
*Keep only single county elections
keep if Multi_CO=="1"
*Fix incumbent discrepancies
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
drop if meani==.5
drop meani i 
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
***Collapse to single obs per multicounty race
keep if Multi_CO=="1"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Save as cleaned multi county file for 2009
save "CEDA_BoardIncumbents_2009m.dta", replace
append using "CEDA_BoardIncumbents_2009s.dta"
save "CEDA_BoardIncumbents_2009.dta", replace

*************************
*************************
*************************
*BEGIN 2010
clear
import excel "CEDA2010Data.xls", sheet("Candidates2010") firstrow allstring
drop YEAR
gen year=2010
*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Rick Adams is the candidate in Laton Unified which covers 2 counties!. Fix this:
replace Multi_RaceID="201001291" if Multi_RaceID=="201001361"
replace Multi_CO="1" if Multi_RaceID=="201001361"
replace Multi_CandID="201003922" if Multi_CandID=="201004186"
replace indivtotal_votes="326" if Multi_CandID=="201003922"
replace multitotal_votes="1253" if Multi_RaceID=="201001291"
replace newtotvotes="1254" if Multi_RaceID=="201001291"
replace newelected="2" if Multi_CandID=="201003922"
replace Rindivto="3" if Multi_CandID=="201003922"
replace Multi_CO="1" if Multi_RaceID=="201001291" 
*Fix error in data where Keith and Ken Dawes confused as same candidate (generate unique candidate ID for Ken)
replace Multi_CandID="201005705" if FIRST=="Ken" & LAST=="Dawes"
*Drop charter
drop if PLACE=="PIONEER UNION ELEMENTARY" & CO=="16" 
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/2/2010"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort Multi_CandID: egen meani=mean(i)
drop meani i
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2010
save "CEDA_BoardIncumbents_2010s.dta", replace

///2010 MultiCounty
clear
import excel "CEDA2010Data.xls", sheet("Candidates2010") firstrow allstring
drop YEAR
gen year=2010
*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Rick Adams is the candidate in Laton Unified which covers 2 counties!. Fix this:
replace Multi_RaceID="201001291" if Multi_RaceID=="201001361"
replace Multi_CO="1" if Multi_RaceID=="201001361"
replace Multi_CandID="201003922" if Multi_CandID=="201004186"
replace indivtotal_votes="326" if Multi_CandID=="201003922"
replace multitotal_votes="1253" if Multi_RaceID=="201001291"
replace total_writein="1" if Multi_RaceID=="201001291" 
replace newtotvotes="1254" if Multi_RaceID=="201001291"
replace newelected="2" if Multi_CandID=="201003922"
replace Rindivto="3" if Multi_CandID=="201003922"
replace Multi_CO="1" if Multi_RaceID=="201001291" 
*Fix error in data where Keith and Ken Dawes confused as same candidate (generate unique candidate ID for Ken)
replace Multi_CandID="201005705" if FIRST=="Ken" & LAST=="Dawes"
*Drop charter
drop if PLACE=="PIONEER UNION ELEMENTARY" & CO=="16"
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/2/2010"
*Keep only single county elections
keep if Multi_CO=="1"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE Num_Inc RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE  CNTYNAME
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort Multi_CandID: egen meani=mean(i)
drop meani i
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"

///Errata 2010
///1 Fix error relating to Fullerton Joint election (MultiRace ID: 201001414) 
///Problem is that the district (which is multi county, Orange and LA County) has combined vote totals in CEDA. Oddly...
///The LA County results report the combined totals for Orange and LA rather than just LA votes. So, when the .do file
///coding combined them (as it should) it overinflated the # of votes. 

replace TOTVOTES="10637" if CO=="19" & Multi_RaceID=="201001414"
replace SUMVOTES="10637" if CO=="19" & Multi_RaceID=="201001414"
replace VOTES="2374" if CO=="19" & Multi_CandID=="201004377"
replace VOTES="2578" if CO=="19" & Multi_CandID=="201004379"
replace VOTES="2420" if CO=="19" & Multi_CandID=="201004381"

replace indivtotal_votes="26778" if Multi_CandID=="201004377"
replace indivtotal_votes="27439" if Multi_CandID=="201004379"
replace indivtotal_votes="27712" if Multi_CandID=="201004381"

replace multitotal_votes="118080" if Multi_RaceID=="201001414"
replace newtotvotes="118080" if Multi_RaceID=="201001414"

replace Rindivto="1" if Multi_CandID=="201004381"
replace Rindivto="2" if Multi_CandID=="201004379"
replace Rindivto="3" if Multi_CandID=="201004377"

///2 Fix error relating to Santa Bonita. Santa Barbara is the main county. CEDA mistakenly doubles the denominators. There's only
///1 precinct in San Luis Obispo. 
///First deal with Oliver
replace indivtotal_votes="6379" if Multi_CandID=="201005279"
drop if Multi_CandID=="201005279" & CO=="40"
///Now deal with Brunello
replace indivtotal_votes="5932" if Multi_CandID=="201005278"
drop if Multi_CandID=="201005278" & CO=="40"
replace multitotal_votes="19018" if Multi_RaceID=="201001631"
replace newtotvotes="19018" if Multi_RaceID=="201001631"
drop if Multi_RaceID=="201001631" & CO=="40"

***Collapse to single obs per multicounty race
replace PLACE="LATON JOINT UNIFIED" if PLACE=="LATON UNIFIED"
keep if Multi_CO=="1"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Save as cleaned multi county file for 2010
save "CEDA_BoardIncumbents_2010m.dta", replace
append using "CEDA_BoardIncumbents_2010s.dta"
save "CEDA_BoardIncumbents_2010.dta", replace

*************************
*************************
*************************
*BEGIN 2011
clear
import excel "CEDA2011Data.xlsx", sheet("Candidates2011") firstrow allstring
drop YEAR
gen year=2011
rename Newelected newelected
rename Newtotvotes newtotvotes
rename Indivtotal_votes indivtotal_votes
rename Totalwritein_votes total_writein
rename Multitotal_votes multitotal_votes
replace TOTVOTES=SUMVOTES if TOTVOTES=="#NULL!"
replace WRITEIN="0" if WRITEIN=="#NULL!"
replace total_writein="0" if total_writein=="#NULL!"

*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/8/2011"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2011
save "CEDA_BoardIncumbents_2011s.dta", replace


///2011 MultiCounty
clear
import excel "CEDA2011Data.xlsx", sheet("Candidates2011") firstrow allstring
drop YEAR
gen year=2011
rename Newelected newelected
rename Newtotvotes newtotvotes
rename Indivtotal_votes indivtotal_votes
rename Totalwritein_votes total_writein
rename Multitotal_votes multitotal_votes
replace TOTVOTES=SUMVOTES if TOTVOTES=="#NULL!"
replace WRITEIN="0" if WRITEIN=="#NULL!"
replace total_writein="0" if total_writein=="#NULL!"
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/8/2011"
*Keep only single county elections
keep if Multi_CO=="1"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME

///Errata 2011
///1 Fix error relating to combined county vote totals (CEDA raw data mistakenly doubles them)
replace multitotal_votes="35" if Multi_RaceID=="201100225"
replace newtotvotes="36" if Multi_RaceID=="201100225"

///2 Fix error relating to combined county vote totals (CEDA raw data mistakenly doubles them)
replace multitotal_votes="17105" if Multi_RaceID=="201100340"
replace newtotvotes="17143" if Multi_RaceID=="201100340"

///3 Fix error relating to combined county vote totals (CEDA raw data mistakenly doubles them)
replace multitotal_votes="8551" if Multi_RaceID=="201100374"
replace newtotvotes="8559" if Multi_RaceID=="201100374"

///4 Fix error relating to multi county race in Kern/LA. Appears only votes came from LA County.
///Upshot is: need to fix denominator vote totals which are overinflated/double counted
///First drop Kern results
drop if RecordID=="201100968"
replace multitotal_votes="29342" if Multi_RaceID=="201100244"
replace newtotvotes="29342" if Multi_RaceID=="201100244"
replace indivtotal_votes="8230" if Multi_CandID=="201100968"

***Collapse to single obs per multicounty race
keep if Multi_CO=="1"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Save as cleaned multi county file for 2011
save "CEDA_BoardIncumbents_2011m.dta", replace
append using "CEDA_BoardIncumbents_2011s.dta"
save "CEDA_BoardIncumbents_2011.dta", replace

*************************
*************************
*************************
*BEGIN 2012
clear
import excel "CEDA2012Data.xlsx", sheet("Candidates2012") firstrow allstring
drop YEAR
gen year=2012
rename Newelected newelected
rename Newtotvotes newtotvotes
rename Indivtotal_votes indivtotal_votes
rename Totalwritein_votes total_writein
rename Multitotal_votes multitotal_votes

*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Fix this:
replace Multi_RaceID="201201028" if Multi_RaceID=="201201143"
replace Multi_CO="1" if Multi_RaceID=="201201028"
replace VOTE="4" if Multi_RaceID=="201201028"
replace Multi_CandID="201203432" if Multi_CandID=="201203797"
replace Multi_CandID="201203430" if Multi_CandID=="201203817"
replace indivtotal_votes="1177" if Multi_CandID=="201203432"
replace indivtotal_votes="882" if Multi_CandID=="201203430"
replace newelected="1" if Multi_CandID=="201203430"
replace Rindivto="4" if Multi_CandID=="201203430"
replace Rindivto="2" if Multi_CandID=="201203432"
replace newelected="1" if Multi_CandID=="201203432"
replace multitotal_votes="5796" if Multi_RaceID=="201201028"
replace newtotvotes="5813" if Multi_RaceID=="201201028"

*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Coachella Unified. Fix this:
replace Multi_RaceID="201201071" if Multi_RaceID=="201201242"
replace Multi_CO="1" if Multi_RaceID=="201201071"
replace Multi_CandID="201203566" if Multi_CandID=="201204106"
replace indivtotal_votes="6819" if Multi_CandID=="201203566"
replace newelected="1" if Multi_CandID=="201203566"
replace Rindivto="1" if Multi_CandID=="201203566"
replace multitotal_votes="11140" if Multi_RaceID=="201201071"
replace newtotvotes="11140" if Multi_RaceID=="201201071"

*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Davis Joint. Fix this:
replace Multi_RaceID="201201499" if Multi_RaceID=="201201439"
replace Multi_CO="1" if Multi_RaceID=="201201499"
replace Multi_CandID="201205001" if Multi_CandID=="201204812"
replace indivtotal_votes="11382" if Multi_CandID=="201205001"
replace newelected="1" if Multi_CandID=="201205001"
replace Rindivto="1" if Multi_CandID=="201205001"
replace multitotal_votes="42701" if Multi_RaceID=="201201499"
replace newtotvotes="42701" if Multi_RaceID=="201201499"

///Fix Errors in Raw Data in Snowline Joint Unified (failure to assign consistent candidate ID's across county lines, total votes added wrong)
replace Multi_CandID="201204224" if Multi_CandID=="201203749"
replace indivtotal_votes="6023" if Multi_CandID=="201204224"
replace Rindivto="1" if Multi_CandID=="201204224"
replace newelected="1" if Multi_CandID=="201203749"
replace multitotal_votes="16227" if Multi_RaceID=="201201126"
replace newtotvotes="16227" if Multi_RaceID=="201201126"
replace Rindivto="2" if Multi_CandID=="201203748"

///Fix Errors in Raw Data in East Nicholas (failure to assign consistent candidate ID's across county lines, total votes added wrong)
replace Multi_CandID="201204058" if Multi_CandID=="201204864"
replace indivtotal_votes="255" if Multi_CandID=="201204058"
replace Rindivto="5" if  Multi_CandID=="201204058"
replace multitotal_votes="2653" if Multi_RaceID=="201201218"
replace newtotvotes="2656" if Multi_RaceID=="201201218"

*Fix error in raw data. This one is weird. Same candidates appear twice in different neighboring districts.
///Confirmed via raw vote records that this is a mistake in the CEDA data. Delete the candidates who never ran
///Keep the candidates in the right district in which they ran. See Caruthers Unified and Central Unified in 2012!
drop if Multi_RaceID=="201201050" | Multi_RaceID=="201201044" | Multi_RaceID=="201201054"

*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/6/2012"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2012
save "CEDA_BoardIncumbents_2012s.dta", replace

///2012 MultiCounty
clear
import excel "CEDA2012Data.xlsx", sheet("Candidates2012") firstrow allstring
drop YEAR
gen year=2012
rename Newelected newelected
rename Newtotvotes newtotvotes
rename Indivtotal_votes indivtotal_votes
rename Totalwritein_votes total_writein
rename Multitotal_votes multitotal_votes

///Fix problems in nearly all denominators in 2012 multi county
gen WRITEIN2=WRITEIN
destring WRITEIN2, replace
bysort  Multi_CandID: egen wi=sum(WRITEIN2)
gen TOTVOTES2=TOTVOTES
destring TOTVOTES2, replace
bysort  Multi_CandID: egen sv=sum(TOTVOTES2)
gen mv=sv+wi
tostring mv, gen(mv2)
replace multitotal_votes=mv2
tostring sv, gen(sv2)
replace newtotvotes=sv2
drop sv2 sv WRITEIN2 mv mv2 TOTVOTES2 wi

*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Dos Palos. Fix this:
replace Multi_RaceID="201201028" if Multi_RaceID=="201201143"
replace Multi_CO="1" if Multi_RaceID=="201201028"
replace VOTE="4" if Multi_RaceID=="201201028"
replace Multi_CandID="201203432" if Multi_CandID=="201203797"
replace Multi_CandID="201203430" if Multi_CandID=="201203817"
replace Multi_CandID="201203798" if Multi_CandID=="201203433"
replace indivtotal_votes="1177" if Multi_CandID=="201203432"
replace indivtotal_votes="882" if Multi_CandID=="201203430"
replace newelected="1" if Multi_CandID=="201203430"
replace Rindivto="4" if Multi_CandID=="201203430"
replace Rindivto="2" if Multi_CandID=="201203432"
replace newelected="1" if Multi_CandID=="201203432"
replace multitotal_votes="5796" if Multi_RaceID=="201201028"
replace newtotvotes="5813" if Multi_RaceID=="201201028"

*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Coachella Unified. Fix this:
replace Multi_RaceID="201201071" if Multi_RaceID=="201201242"
replace Multi_CO="1" if Multi_RaceID=="201201071"
replace Multi_CandID="201203566" if Multi_CandID=="201204106"
replace indivtotal_votes="6819" if Multi_CandID=="201203566"
replace newelected="1" if Multi_CandID=="201203566"
replace Rindivto="1" if Multi_CandID=="201203566"
replace multitotal_votes="11140" if Multi_RaceID=="201201071"
replace newtotvotes="11140" if Multi_RaceID=="201201071"

*Fix error in raw data (there's an election which should be listed as "multi county" in CEDA, but it is listed as 2 
///separate single-county races. Davis Joint. Fix this:
replace Multi_RaceID="201201499" if Multi_RaceID=="201201439"
replace Multi_CO="1" if Multi_RaceID=="201201499"
replace Multi_CandID="201205001" if Multi_CandID=="201204812"
replace indivtotal_votes="11382" if Multi_CandID=="201205001"
replace newelected="1" if Multi_CandID=="201205001"
replace Rindivto="1" if Multi_CandID=="201205001"
replace multitotal_votes="42701" if Multi_RaceID=="201201499"
replace newtotvotes="42701" if Multi_RaceID=="201201499"

*Fix error in Modoc Joint (candidate was improperly given 2 different ID's even though he's the same guy)
replace Multi_CandID="201203837" if Multi_CandID=="201203722"
replace indivtotal_votes="1579" if Multi_CandID=="201203837"
replace multitotal_votes="6326" if Multi_RaceID=="201201112"
replace newtotvotes="6373" if Multi_RaceID=="201201112"
replace indivtotal_votes="1261" if Multi_CandID=="201203705"
replace newelected="1" if Multi_CandID=="201203705"
replace Rindivto="3" if Multi_CandID=="201203705"
replace Rindivto="2" if Multi_CandID=="201203837"
replace newelected="1" if Multi_CandID=="201203837"

///Fix Errors in Raw Data in Snowline Joint Unified (failure to assign consistent candidate ID's across county lines, total votes added wrong)
replace Multi_CandID="201204224" if Multi_CandID=="201203749"
replace indivtotal_votes="6023" if Multi_CandID=="201204224"
replace Rindivto="1" if Multi_CandID=="201204224"
replace newelected="1" if Multi_CandID=="201203749"
replace multitotal_votes="16227" if Multi_RaceID=="201201126"
replace newtotvotes="16227" if Multi_RaceID=="201201126"
replace Rindivto="2" if Multi_CandID=="201203748"

///Fix Errors in Raw Data in East Nicholas (failure to assign consistent candidate ID's across county lines, total votes added wrong)
replace Multi_CandID="201204058" if Multi_CandID=="201204864"
replace indivtotal_votes="255" if Multi_CandID=="201204058"
replace Rindivto="5" if  Multi_CandID=="201204058"
replace multitotal_votes="2653" if Multi_RaceID=="201201218"
replace newtotvotes="2656" if Multi_RaceID=="201201218"

*Fix error in raw data. This one is weird. Same candidates appear twice in different neighboring districts.
///Confirmed via raw vote records that this is a mistake in the CEDA data. Delete the candidates who never ran
///Keep the candidates in the right district in which they ran. See Caruthers Unified and Central Unified in 2012!
drop if Multi_RaceID=="201201050" | Multi_RaceID=="201201044" | Multi_RaceID=="201201054"

*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE==" 11/6/2012"
*Keep only single county elections
keep if Multi_CO=="1"

*Keep only incumbents (after making sure no disagreements about who is an incumbent)
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
keep if meani==0 | meani==1
drop meani i
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME

*ERRATUM IN VOTE DENOMINATORS
///1)Livermore Valley Joint has error
replace Rindivto="2" if Multi_CandID=="201203194"

***Collapse to single obs per multicounty race
keep if Multi_CO=="1"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max( SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Save as cleaned multi county file for 2012
save "CEDA_BoardIncumbents_2012m.dta",replace
append using "CEDA_BoardIncumbents_2012s.dta"
save "CEDA_BoardIncumbents_2012.dta",replace


*************************
*************************
*************************
*BEGIN 2013
clear
import excel "CEDA2013Data.xlsx", sheet("Candidates2013") firstrow allstring
drop YEAR
gen year=2013
rename INC INCUMB
drop RACEID
rename Newelected newelected
rename Newtotvotes newtotvotes
rename Indivtotal_votes indivtotal_votes
rename Total_writein total_writein
rename Multitotal_votes multitotal_votes
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE=="05nov2013"
*There are errors in 2 races for 2 separate districts (errors in the raw CEDA data).
///These 2 districts are Las Virgenes Unified & Point Arena Joint Union High
///First off, both are listed as single-county races, when in fact, both are multi-county races
///Second, in Las Virgenes one county lists 6 candidates running. The other county lists just 5. 
///Looks like 5 is the right # to count. Also this district is just weird in general. See:
///http://ballotpedia.org/Las_Virgenes_Unified_School_District_elections_(2013) (Westlake Village is a sep entity within the dist)
///Consequently I've used the #'s, vote totals, & rank-order from Smartvoter.
///1) Fixes to Las Virgenes:
replace Multi_RaceID="201300332" if Multi_RaceID=="201300439" 
replace Multi_CO="1" if Multi_RaceID=="201300332" 
replace CAND="5" if Multi_RaceID=="201300332"
replace Multi_CandID="201301294" if Multi_CandID=="201301709"
replace indivtotal_votes="3236" if Multi_CandID=="201301294"
replace multitotal_votes="13188" if Multi_RaceID=="201300332"
replace newtotvotes="13188" if Multi_RaceID=="201300332"
///2) Fixes to Point Arena:
replace Multi_RaceID="201300417" if Multi_RaceID=="201300369"
replace Multi_CO="1" if Multi_RaceID=="201300417"
replace multitotal_votes="3767" if Multi_RaceID=="201300417"
replace newtotvotes="3786" if Multi_RaceID=="201300417"
replace Multi_CandID="201301470" if Multi_CandID=="201301642"
replace Multi_CandID="201301641" if Multi_CandID=="201301467"
replace indivtotal_votes="539" if Multi_CandID=="201301470"
replace Rindivto="5" if Multi_CandID=="201301470"
replace newelected="2" if Multi_CandID=="201301470"
replace indivtotal_votes="773" if Multi_CandID=="201301641"
replace Rindivto="2" if Multi_CandID=="201301641"
replace newelected="1" if Multi_CandID=="201301641"
*Keep only single county elections
keep if Multi_CO=="0"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
///gen i=1 if INCUMB=="Y"
///replace i=0 if INCUMB=="N"
///bysort  Multi_CandID: egen meani=mean(i)
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME
merge m:1 CO PLACE using "PlaceNamesForSingleCO.dta"
drop if _merge==2
drop _merge
rename Status status
*Save as cleaned single county file for 2011
save "CEDA_BoardIncumbents_2013s.dta", replace

///2013 MultiCounty
clear
import excel "CEDA2013Data.xlsx", sheet("Candidates2013") firstrow allstring
drop YEAR
gen year=2013
rename INC INCUMB
drop RACEID
rename Newelected newelected
rename Newtotvotes newtotvotes
rename Indivtotal_votes indivtotal_votes
rename Total_writein total_writein
rename Multitotal_votes multitotal_votes
*Keep only school board elections
keep if RECODE_OFFICE=="3"
*Keep only full terms
keep if TERM=="Full"
*Keep only November elections
keep if DATE=="05nov2013"
*There are errors in 2 races for 2 separate districts (errors in the raw CEDA data).
///These 2 districts are Las Virgenes Unified & Point Arena Joint Union High
///First off, both are listed as single-county races, when in fact, both are multi-county races
///Second, in Las Virgenes one county lists 6 candidates running. The other county lists just 5. 
///Looks like 5 is the right # to count. Also this district is just weird in general. See:
///http://ballotpedia.org/Las_Virgenes_Unified_School_District_elections_(2013) (Westlake Village is a sep entity within the dist)
///Consequently I've used the #'s, vote totals, & rank-order from Smartvoter.
///1) Fixes to Las Virgenes:
replace Multi_RaceID="201300332" if Multi_RaceID=="201300439" 
replace Multi_CO="1" if Multi_RaceID=="201300332" 
replace CAND="5" if Multi_RaceID=="201300332"
replace Multi_CandID="201301294" if Multi_CandID=="201301709"
replace indivtotal_votes="3236" if Multi_CandID=="201301294"
replace multitotal_votes="13188" if Multi_RaceID=="201300332"
replace newtotvotes="13188" if Multi_RaceID=="201300332"
///2) Fixes to Point Arena:
replace Multi_RaceID="201300417" if Multi_RaceID=="201300369"
replace Multi_CO="1" if Multi_RaceID=="201300417"
replace multitotal_votes="3767" if Multi_RaceID=="201300417"
replace newtotvotes="3786" if Multi_RaceID=="201300417"
replace Multi_CandID="201301470" if Multi_CandID=="201301642"
replace Multi_CandID="201301641" if Multi_CandID=="201301467"
replace indivtotal_votes="539" if Multi_CandID=="201301470"
replace Rindivto="5" if Multi_CandID=="201301470"
replace newelected="2" if Multi_CandID=="201301470"
replace indivtotal_votes="773" if Multi_CandID=="201301641"
replace Rindivto="2" if Multi_CandID=="201301641"
replace newelected="1" if Multi_CandID=="201301641"
*Keep only single county elections
keep if Multi_CO=="1"
*Keep only incumbents (after making sure no disagreements about who is an incumbent)
gen i=1 if INCUMB=="Y"
replace i=0 if INCUMB=="N"
bysort  Multi_CandID: egen meani=mean(i)
keep if meani==0 | meani==1
drop i meani
///If no discrepancy meani should be all 0's and all 1's
keep if INCUMB=="Y"
*Drop uncontested races
gen cands_run=CAND
destring cands_run, replace
gen seats_up=VOTE
destring seats_up, replace
*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested cands_run seats_up
*Get rid of variables that just aren't needed
drop RECODE_OFFNAME JUR CSD OFFICE RECODE_OFFICE PERCENT
gen place=upper(PLACE)
drop PLACE
rename place PLACE
sort PLACE
merge m:1 PLACE using "Colleges and COEs.dta"
drop if _merge==2
drop _merge
drop if COLLEGE==1
drop if COE==1
drop if CHARTER==1
drop COLLEGE COE CHARTER
move PLACE CNTYNAME
///2013 Erratum
///Rowland Unified (multi-county race) has an inflated denominator. Fix this:
replace multitotal_votes="11789" if Multi_RaceID=="201300349"
replace newtotvotes="11789" if Multi_RaceID=="201300349"
***Collapse to single obs per multicounty race
keep if Multi_CO=="1"
gen SUMVOTES2=SUMVOTES
destring SUMVOTES2, replace
bysort  Multi_RaceID: egen maxvotes=max(SUMVOTES2)
gen diff=maxvotes-SUMVOTES2
keep if diff==0
drop maxvotes diff SUMVOTES2
sort PLACE
merge m:1 PLACE using "PlaceNamesForMultiCO.dta"
drop if _merge==2
drop _merge
*Save as cleaned multi county file for 2012
save "CEDA_BoardIncumbents_2013m.dta", replace
append using "CEDA_BoardIncumbents_2013s.dta"
save "CEDA_BoardIncumbents_2013.dta", replace

*Append all years together into a single data file
append using "CEDA_BoardIncumbents_2012.dta"
append using "CEDA_BoardIncumbents_2011.dta"
append using "CEDA_BoardIncumbents_2010.dta"
append using "CEDA_BoardIncumbents_2009.dta"
append using "CEDA_BoardIncumbents_2008.dta"
append using "CEDA_BoardIncumbents_2007.dta"
append using "CEDA_BoardIncumbents_2006.dta"
append using "CEDA_BoardIncumbents_2005.dta"
append using "CEDA_BoardIncumbents_2004.dta"


*Drop 2 charter districts (not sure how it got in)
drop if cds7=="1062240"
drop if cds7=="5071100"

*Merge in contextual data from CA Dept of Ed on district type (elementary, high, or unified)
///Note slight challenge with 2 districts that did not merge cleanly
///Point Arena and Modesto are not unified districts, however 1 single board governs them
///Rather than lose the data, I propose that we average API scores 
gen cds=cds7
destring cds7, replace
sort cds7
rename cds7 cds7numeric
merge m:1 cds7numeric using "Database_from_CDE_July2015_ClassifyDists.dta"
drop if _merge==2
drop _merge

*Gen Variables
gen cands_run=CAND
destring cands_run, replace

gen seats_up=VOTE
destring seats_up, replace

*Gen uncontested
gen uncontested=cands_run-seats_up
drop if uncontested==0
drop uncontested

*Create percent vote share (0-100) for candidates 
destring  indivtotal_votes, replace 
destring newtotvotes, replace
gen percent_vote=indivtotal_votes/newtotvotes*100
sum percent_vote

*# of candidates - # of seats up
gen cands_per_seat=cands_run/seats_up
sum cands_per_seat

*# of candidates minus # of seats
gen cands_minus_seat=cands_run-seats_up

replace DATE="11/05/2013" if DATE=="05nov2013"
replace DATE="04/02/2013" if DATE=="02apr2013"
replace DATE="03/05/2013" if DATE=="05mar2013"
replace DATE="04/09/2013" if DATE=="09apr2013"
replace DATE="12/17/2013" if DATE=="17dec2013"
replace DATE="02/26/2013" if DATE=="26feb2013"
replace DATE="06/06/2006" if DATE=="  6/6/2006"
replace DATE="02/07/2012" if DATE=="  2/7/2012"
replace DATE="03/04/2008" if DATE=="  3/4/2008"
replace DATE="03/06/2007" if DATE=="  3/6/2007"
replace DATE="03/08/2011" if DATE=="  3/8/2011"
replace DATE="04/03/2007" if DATE=="  4/3/2007"
replace DATE="04/05/2011" if DATE=="  4/5/2011"
replace DATE="04/07/2009" if DATE=="  4/7/2009"
replace DATE="04/08/2008" if DATE=="  4/8/2008"
replace DATE="06/03/2008" if DATE=="  6/3/2008"
replace DATE="06/05/2012" if DATE=="  6/5/2012"
replace DATE="06/08/2010" if DATE=="  6/8/2010"
replace DATE="11/02/2010" if DATE==" 11/2/2010"
replace DATE="11/03/2009" if DATE==" 11/3/2009"
replace DATE="11/04/2008" if DATE==" 11/4/2008"
replace DATE="11/06/2007" if DATE==" 11/6/2007"
replace DATE="11/06/2012" if DATE==" 11/6/2012"
replace DATE="11/07/2006" if DATE==" 11/7/2006"
replace DATE="11/08/2011" if DATE==" 11/8/2011"
replace DATE="02/22/2011" if DATE==" 2/22/2011"
replace DATE="02/24/2009" if DATE==" 2/24/2009"
replace DATE="03/10/2009" if DATE==" 3/10/2009"
replace DATE="04/10/2012" if DATE==" 4/10/2012"
replace DATE="04/11/2006" if DATE==" 4/11/2006"
replace DATE="04/13/2010" if DATE==" 4/13/2010"
replace DATE="04/17/2007" if DATE==" 4/17/2007"
replace DATE="04/19/2011" if DATE==" 4/19/2011"
replace DATE="04/21/2009" if DATE==" 4/21/2009"
replace DATE="05/15/2007" if DATE==" 5/15/2007"
replace DATE="06/19/2009" if DATE==" 6/19/2009"
 
gen month=substr(DATE,1,2)
gen offcycle=1 if year==2013 | year==2011  | year==2009 | year==2007 | year==2005 | year==2003 | year==2001
replace offcycle=0 if offcycle==.

rename cds7numeric cds7

///1 Fix errors in Modoc Joint 
replace indivtotal_votes=1604 if Multi_CandID=="200603918"
replace Rindivto="1" if Multi_CandID=="200603918"
replace Rindivto="2" if Multi_CandID=="200604028"
///2 Fix errors in Grant Joint Union
replace indivtotal_votes=11556 if Multi_CandID=="200604199"
replace newelected="1" if Multi_CandID=="200604199"
replace Rindivto="2" if Multi_CandID=="200604199"
replace Rindivto="3" if Multi_CandID=="200604337"
replace Rindivto="4" if Multi_CandID=="200604336"
replace Rindivto="5" if Multi_CandID=="200604335"
replace Rindivto="6" if Multi_CandID=="200604334"
replace newelected="2" if Multi_CandID=="200604336"

///By Hand (missing)
replace cds7=373981 if PLACE=="ORO MADRE UNIFIED" & year==2004
replace cds7=2075606 if PLACE=="CHAWANAKEE JOINT ELEM.-SIERRA VIEW" & year==2004
replace cds7=2075606 if PLACE=="CHAWANAKEE JOINT ELEM.-NORTH FOLK" & year==2004
replace cds7=1275515 if PLACE=="EUREKA CITY ELEMENTARY" & year>2008
replace cds7=1176562 if PLACE=="HAMILTON UNION HIGH" & year==2010
replace cds7=5075564 if PLACE=="OAKDALE JOINT UNION HIGH"
replace cds7=4940246 if PLACE=="PETALUMA JOINT UNION HIGH" & year>2009
replace cds7=4940253 if PLACE=="SANTA ROSA HIGH" & year>2009
replace cds7=3975499 if PLACE=="TRACY JOINT UNION HIGH" & year==2008
replace cds7=5075739 if PLACE=="TURLOCK JOINT UNION HIGH" & year==2005
replace cds7=3775614 if PLACE=="VALLEY CENTER UNION ELEMENTARY" & year==2004
replace cds7=5075572 if PLACE=="WATERFORD ELEMENTARY"

*Save as a single data file
*Unique idenifier variable for each school district is "cds7" 
