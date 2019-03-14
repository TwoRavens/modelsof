********************************************************
***********ImportNorwayMPs *****************************
********************************************************

import excel "dta\NorwayMPs.xlsx", firstrow clear

********** RE-ORGANIZING CANDIDATENAME PRE WW2 ***********************************
generate splitat = strpos(name,",")
gen firstname="."
gen lastname="."
replace lastname = substr(name,1,splitat - 1)
replace firstname = substr(name,splitat + 1,.)

foreach var in firstname lastname {
replace `var' = subinstr(`var', ".", "",.)
replace `var' = subinstr(`var', ",", "",.)
replace `var' = subinstr(`var', ";", ",",.)
replace `var' = subinstr(`var', "!", "",.)
replace `var' = subinstr(`var', "^", "",.)
replace `var' = subinstr(`var', "'", "",.)
replace `var' = subinstr(`var', "0", "O",.)  /* replacing zero with "O" */
replace `var'=trim(`var')
}

gen candidatename_ed=firstname + " " +lastname 
li name fulln* cand*  /* fullname is erroneous */

gen party="oth"
replace party="frp" if mppartyname=="Anders Langes Parti"
replace party="dna" if mppartyname=="Arbeiderpartiet"
replace party="sp" if mppartyname=="Bondepartiet"
replace party="frp" if mppartyname=="Fremskrittspartiet"
replace party="frp" if mppartyname=="Uavhengig representant" /* FRIDTJOF FRANK GUNDERSEN */
replace party="h" if mppartyname=="Høyre"
replace party="krf" if mppartyname=="Kristelig Folkeparti"
replace party="fol" if mppartyname=="Det Nye Folkeparti"
replace party="kp" if mppartyname=="Kystpartiet"
replace party="kp" if mppartyname=="Tverrpolitisk Folkevalgte (Kystpartiet)"

replace party="sp" if mppartyname=="Senterpartiet"
replace party="nkp" if mppartyname=="Norges Kommunistiske Parti"
replace party="sv" if mppartyname=="Sosialistisk Folkeparti"
replace party="sv" if mppartyname=="Sosialistisk Valgforbund"
replace party="sv" if mppartyname=="Sosialistisk Venstreparti"
replace party="v" if mppartyname=="Venstre"
replace party="vil" if mppartyname=="Framtid for Finnmark" /* AUNELISTA */
replace party="rv" if mppartyname=="Valgallianse" /* Erling Folkvord */
replace party="oth" if mppartyname=="Høyre"  & last=="Bae"  

replace lastname="Nilssen" if candidatename_ed=="Åse Wisløff Nilssen"
replace lastname="Pedersen" if candidatename_ed=="Gustav Natvig Pedersen"
replace firstname="Olav Egil" if candidatename_ed=="Egil Bergsland"

replace firstname="Karl Magnus" if candidatename_ed=="Magnus Johansen"
replace lastname="Løvaas" if candidatename_ed=="Kårstein Eidem Løvås"

replace lastname="Mykland" if candidatename_ed=="Thor-Eirik Gulbrandsen"  /* Thor-Eirik Gulbrandsen Mykland -- https://www.stortinget.no/no/Representanter-og-komiteer/Representantene/Representantfordeling/Representant/?perid=THGU */
replace firstname="Morten" if candidatename_ed=="Finn Morten Stordalen"
replace lastname="Fostervoll" if candidatename_ed=="Kaare Fostervold"

gen initial = regexs(1) if regexm(firstname,"(^[A-ZÅÆØ])" )
rename elecyear year
gen seat=1
sort seat year party lastname initial
replace firstname = word(firstname,1)

egen id=group(candidatename_ed) 
bysort id: egen first_year_winning=min(mpyearin)
bysort id: egen terms_total=max(mpnterms) 
bysort id: egen ever_cabinet=max(mpcabinet) 

sort seat year party lastname firstname

save dta\ImportNorwayMPs.dta, replace
