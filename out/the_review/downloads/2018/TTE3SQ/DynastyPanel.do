use dta/DataPrep, clear

gen initial = regexs(1) if regexm(firstname,"(^[A-ZÅÆØ])" )
sort seat year party lastname firstname
merge seat year party lastname firstname using dta/ImportNorwayMPs
tab _merge if seat==1

*log using OnlyInUsing.txt, text replace
/* these are candidates winning seats, but for non-main lists */
*bysort year: li year party district candidatename_ed firstname lastname if _merge==2
*log close
drop if _merge==2  /* these are candidates winning seats, but for non-main lists */

*log using OnlyInMaster.txt, text replace
*bysort year: li year party district candidatename_ed firstname lastname if seat==1 & mpprecede==.
*log close
gen check=0
replace check=1 if seat==1 & mpprecede==.
assert check==0

replace mpsucceed=0 if mpsucceed==. /* non-elected candidates, set this preliminary to zero */
replace mpprecede=0 if mpprecede==. /* non-elected candidates, set this preliminary to zero */
*egen max_mpprecede=max(mpprecede), by(id)
egen max_mpprecede=max(mpprecede), by(candidatename_ed)
egen max_mpsucceed=max(mpsucceed), by(candidatename_ed)
replace mpprecede=max_mpprecede
replace mpsucceed=max_mpsucceed
replace ever_cabinet=0 if ever_cabinet==. /* non-elected candidates, set this preliminary to zero */

foreach var in mpcabinet {
egen max_`var'=max(`var'), by(candidatename_ed)
*replace `var'=1 if max_`var'==1
replace max_`var'=0 if max_`var'==.
}

******** MANUALLY ADDING mpprecede mpsuccede FOR A CANDIDATES NOT WINNING SEAT IN THE ELECTION ***********

replace mpprecede=1 if candidatename_ed=="Jorunn Steensnæs"  /* mother of Einar Steensnæs */
replace mpprecede=1 if candidatename_ed=="Joakim Ingemann Kosmo" /* father of Jørgen Hårek Kosmo */
replace mpprecede=1 if candidatename_ed=="Per Høybråten" /* non-elected (in rd window) --> father of Dagfinn Høybråten https://no.wikipedia.org/wiki/Per_H%C3%B8ybr%C3%A5ten */
replace mpprecede=1 if candidatename_ed=="Liv Leirstein" /* non-elected (in rd window, but for 1985) --> mother of Ulf Isak Leirstein */
replace mpprecede=1 if candidatename_ed=="Kirsten Aasen" /* non-elected --> mother of Marianne Aasen */
replace mpprecede=1 if candidatename_ed=="Nils Svarstad"  /*Nils Svarstad ran from 1957-1969 in Hordaland for KrF, but never won. He is the father of Valgerd Svarstad Haugland, KrF MP for Akershus 1993-2005. He is also the son of Hans Svarstad, KrF MP for Hordaland 1945-1953, and his father’s cousin, Paul Svarstad, was also an MP for Høyre in Sogn og Fjordane from 1965-1973, so he is mpsucceed = 1. */
replace mpprecede=1 if candidatename_ed=="Kristin Høegh Krohn Devold" /* Kristin Høegh Krohn Devold was vara for Høyre in Møre og Romsdal 1989-1993. Her daughter Kristin Margrethe was elected in Oslo from Høyre 1993-2005.*/
replace mpprecede=1 if candidatename_ed=="Eli Arnstad" /* Eli Arnstad was vara for Sp in Nord-Trøndelag 1989-1993. Her twin sister Marit Arnstad was Sp MP for Nord-Trøndelag from 1993-present. Her grand uncle, Johan A. Vikan, was Sp MP in Nord-Trøndelag from 1969-1977, so she is also mpsucceed = 1.*/
replace mpprecede=1 if candidatename_ed=="Vibeke Limi"  /* Vibeke Limi was FrP vara for Oslo 1989-1993. She is the wife of Hans Andreas Limi since 1984. He first ran in 1985 and was first elected in 2013.  */
replace mpprecede=1 if candidatename_ed=="Birgit Bryhni" /* Birgit Bryhni is the aunt of MP Marianne Aasen and sister of Kristin Aasen (vara). She was vara for Høyre in Sør-Trøndelag from 1969-1977.  */
replace mpprecede=1 if candidatename_ed=="Arnfinn Johs Stein" /* Marginal candidate in 1981, his daughter Bente Stein Mathisen got elected in 2013, so Arnfinn is mpprecede */
replace mpprecede=1 if candidatename_ed=="Heming Olaussen" /* Heming is a marginal loser in 1997, Inga Marthe (daughter) wins in 2001 */
replace mpprecede=1 if candidatename_ed=="Milly Frost" /* Milly Frost (marginal loser) was married to Ola Frost (hopeless candidate), they have a daughter ho become an MP Siri Frost Sterri - so Milly and Ola are both mpprecede. */
replace mpprecede=1 if candidatename_ed=="Ola Frost" /* Milly Frost (marginal loser) was married to Ola Frost (hopeless candidate), they have a daughter ho become an MP Siri Frost Sterri - so Milly and Ola are both mpprecede. */

replace mpsucceed=1 if candidatename_ed=="Odd Gunnar Jære Hoel"  /* Oddmund Hoel (mp=1) was a relative) */
replace mpsucceed=1 if candidatename_ed=="Per Kristian Skulberg"  /* Anton Skulberg (mp=1) was father */
replace mpsucceed=1 if candidatename_ed=="Erik Lahnstein"  /* Anne Enger Lahnstein (mp=1) is mother */
replace mpsucceed=1 if candidatename_ed=="Geir Lahnstein"  & year==1989 /* Anne Enger Lahnstein (former wife) won in 1985 */
replace mpsucceed=1 if candidatename_ed=="Ragnhild S Stolt-Nielsen"  /* Mother Inger Stolt-Nielsen won seat in 1997 */
replace mpsucceed=1 if candidatename_ed=="Nils Svarstad"  /*Nils Svarstad ran from 1957-1969 in Hordaland for KrF, but never won. He is the father of Valgerd Svarstad Haugland, KrF MP for Akershus 1993-2005. He is also the son of Hans Svarstad, KrF MP for Hordaland 1945-1953, and his father’s cousin, Paul Svarstad, was also an MP for Høyre in Sogn og Fjordane from 1965-1973, so he is mpsucceed = 1. */
replace mpsucceed=1 if candidatename_ed=="Kristin Høegh Krohn Devold" /*  Her cousin-in-law was the spouse of Inger Koppernæs, cabinet minister and MP for Møre og Romsdal 1981-1989, so she is also mpsucceed = 1. */
replace mpsucceed=1 if candidatename_ed=="Eli Arnstad" /* Eli Arnstad was vara for Sp in Nord-Trøndelag 1989-1993. Her twin sister Marit Arnstad was Sp MP for Nord-Trøndelag from 1993-present. Her grand uncle, Johan A. Vikan, was Sp MP in Nord-Trøndelag from 1969-1977, so she is also mpsucceed = 1.*/
replace mpsucceed=1 if candidatename_ed=="Ådne Cappelen" /* Hopeless candidate in 1997, was son of Andreas, so he is mpsucceed */
replace mpsucceed=1 if candidatename_ed=="Astri Rynning" /* Marginal loser in 1965, Wikepedia says that father was MP, but this seems to be wrong. He only ran for Storting in 1930, but did not get elected. Her grandfather, however, Carl Ingwart Theodor Rynning, served in 1880s, so she is mpsucceed */
replace mpsucceed=1 if candidatename_ed=="Bjørn Reinert Stordrange" /* Son of MP Kolbjørn Stordrange (1924–2004), so he is mpsucceed */
replace mpsucceed=1 if candidatename_ed=="Jon Lyng" /* Son of MP John Daniel Lyng , so he is mpsucceed */
replace mpsucceed=1 if candidatename_ed=="Lars Kirkeby-Garstad" /* Son of MP Ivar Kirkeby-Garstad , so he is mpsucceed */
replace mpsucceed=1 if candidatename_ed=="Odd Bondevik" /* Son of MP Kjell Bondevik , so he is mpsucceed */

******** Update after 2017 election ***********
replace mpprecede=1 if candidatename_ed=="Oddvard Nilsen" /* Oddvard served as MP 1993-2005, his son Tom-Christer was deputy in 2013, but then won a seat in 2017 */
replace mpsucceed=1 if candidatename_ed=="Tom-Christer Nilsen" /* Son of MP Oddvard Nilsen , so he is mpsucceed */


/* dec 2016 */
** not necessary, when replacing with max-mpsucceed replace mpsucceed=1 if candidatename_ed=="Torild Skard" /* Through her mother, she is a granddaughter of the historian and former minister of foreign affairs Halvdan Koht, and great granddaughter of MP Paul Steenstrup Koht*/

*tab candidatename_ed if ever_seat==0 & mpsucceed==1
*tab candidatename_ed if ever_seat==0 & mpsucceed==1

save dta/DynastyPanel_Early.dta, replace  /* for making trends in mpprecede from 1945 onwards */

***************************************************************************************************************
***************************************************************************************************************
************************************* proxy *******************************************************************
***************************************************************************************************************

drop if year<1945
*drop if year>2007

forvalues i=0(1)17 {
replace cand_next`i'=0 if cand_next`i'==.
}

/* ALTERNATIVE FOR FAMILY ID #1 */
*egen family_id=group(last party)  

/* ALTERNATIVE FOR FAMILY ID #2 */
*egen family_id=group(last bloc region2)  

/* ALTERNATIVE FOR FAMILY ID #3 */
egen family_id=group(lastname party region)  

/* ALTERNATIVE FOR FAMILY ID #4 */
*egen family_id=group(last hometown)    /* NEED TO MAKE HOMETOWN EXIST FOR ALL OBS. TO GET THIS TO WORK */

egen max_family_id=max(family_id), by(pid)
replace family_id=max_family_id

gen run=0
replace run=1 if lastname!=""

replace seat=0 if seat==.

*drop terms_served
bysort pid: egen terms_run=sum(run) 
bysort pid: egen terms_served=sum(seat) 
bysort pid: egen terms_rank1=sum(rank1) 

bysort family_id: egen family_terms_run=sum(run)    
bysort family_id: egen family_terms_served=sum(seat) 
bysort family_id: egen family_terms_rank1=sum(rank1) 

*bysort family_id year: gen new_id=0
*by family_id: replace new_id=1 if id!=id[_n-1]
*by family_id: egen family_sum=sum(new_id)

by family_id: egen family_sum2=count(pid)
gen family_members=family_sum2/16
by family_id: egen family_members_max=max(family_members)

***** DESCRIPTIVES *****
tab family_members_max if districtid!=. & main==1

**** SUM CAND_NEXT BY FAMILY ***
forvalues i=1(1)17 {
replace cand_next`i'=0 if cand_next`i'==.
replace seat_next`i'=0 if seat_next`i'==.
replace rank1_next`i'=0 if rank1_next`i'==.

bysort family_id year: egen family_cand_next`i'=max(cand_next`i') 
bysort family_id year: egen family_seat_next`i'=max(seat_next`i')
bysort family_id year: egen family_rank1_next`i'=max(rank1_next`i') 

gen dynasty_cand_next`i'=family_cand_next`i'-cand_next`i'>0
gen dynasty_seat_next`i'=family_seat_next`i'-seat_next`i'>0
gen dynasty_rank1_next`i'=family_rank1_next`i'-rank1_next`i'>0
}

foreach var in cand seat rank1 {
gen dynasty_`var'_ever=dynasty_`var'_next1+dynasty_`var'_next2+dynasty_`var'_next3+dynasty_`var'_next4+dynasty_`var'_next5+dynasty_`var'_next6+dynasty_`var'_next7+dynasty_`var'_next8+dynasty_`var'_next9+dynasty_`var'_next10+dynasty_`var'_next11+dynasty_`var'_next12+dynasty_`var'_next13+dynasty_`var'_next14+dynasty_`var'_next15+dynasty_`var'_next16+dynasty_`var'_next17>0
}

sum dynasty*ever


****************** ADDING LAST NAMES INFORMATION FROM STATISTICS NORWAY *********

drop _merge
sort lastname

merge lastname using dta\LastNamesNorway.dta
drop if _merge==2 /* last names with no candidates */
replace lastCount=0 if lastCount==.
replace lastRank=9999 if lastRank==.

*****************************************************************************************************************************
********************** OCTOBER 2017 USE DATA ON TERMS-SERVED TAKING INTO ACCOUNT TIME SERVED AS DEPUTY **********************
*****************************************************************************************************************************
gen terms_served_OLD=terms_served
drop terms_served
gen terms_served=days/(365*4)
replace terms_served=0 if terms_served==.

save dta\DynastyPanel.dta, replace
