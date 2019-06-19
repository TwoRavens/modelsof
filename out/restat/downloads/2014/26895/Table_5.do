/* THIS FILE RUNS THE MAIN REGRESSIONS */
*USING AUTHOR-YEAR-SUBJECT DATA;

#delimit ;
set more 1;

log using "/volumes/ddisk/math/soviet/Table_5.log", replace;


clear;
clear matrix;
clear mata;


use "/volumes/ddisk/math/ams/international/soviet_universe.dta", clear;

keep if soviet==1;
keep unique soviet;
sort unique;

save "/volumes/ddisk/data/junk_soviet_uniques.dta", replace;


use "/volumes/ddisk/math/ams/clean_ams_data.dta", replace;

drop institution_pre modal_institution;

sort unique year subject;
by unique: egen minyear = min(year);

generate good=.;
replace good=1 if year>=1970 & year<=1989;
egen n70=sum(good*papers), by(unique);
drop if n70==0;


rename citations citations_ams;

merge unique using "/volumes/ddisk/data/junk_soviet_uniques.dta";
drop _merge;

keep if soviet==1;
drop soviet;
keep if year >= 1978;

fillin unique year subject;
replace papers = 0 if papers == .;
replace citations_ams = 0 if citations_ams == .;

summ minyear papers;
egen mean_minyear=mean(minyear), by(unique);
replace minyear=mean_minyear if minyear==.;
summ minyear papers;

merge unique using "/volumes/ddisk/math/ams/international/soviet_universe.dta";
drop _merge;

keep if soviet==1;
drop if emigre==1;

drop country;
rename modal_country country;

save /volumes/ddisk/data/junkdata0.dta, replace;


*MAKING SURE THEY ARE IN USSR IN 84-89;
generate soviet_forever=.;
replace soviet_forever=1 if country=="2" | country=="AR" | country=="AZ"
	| country=="BE" | country=="ES" | country=="GE" | country=="KZ"
	| country=="KY" | country=="LA" | country=="LI" | country=="MO"
	| country=="RS" | country=="TJ" | country=="TKM" | country=="UKR"
	| country=="UZ";

*TRYING TO CATCH AS MANY SOVIETS AS POSSIBLE;
generate mix=0;
generate dum=regexm(country,"2");
replace mix=1 if dum==1;
drop dum;
*ACCOUNTS FOR SAUDI ARABIA, WHICH IS SAR, HENCE EASILY CONFUSED WITH AR;
generate dum=regexm(country,"AR");
generate dumsar=regexm(country,"SAR");
replace mix=1 if dum==1 & dumsar==0;
drop dum dumsar;
generate dum=regexm(country,"AZ");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"BE");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"ES");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"GE");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"KZ");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"KY");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"LA");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"LI");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"MO");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"RS");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"TJ");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"TKM");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"UKR");
replace mix=1 if dum==1;
drop dum;
generate dum=regexm(country,"UZ");
replace mix=1 if dum==1;
drop dum;

replace soviet_forever=1 if mix==1;

generate in_ussr=.;
replace in_ussr=1 if soviet_forever==1 ;
replace in_ussr=0 if soviet_forever~=1 & country~="" & country~="NA";

drop good;
generate good=.;
replace good=1 if year>=1984 & year<=1989;
egen pussr=mean(good*in_ussr), by(unique);

*RESTRICT SAMPLE TO THOSE WHO PUBLISHED IN 84-89 AND WHO ARE IN USSR;
*keep if pussr>.5 & pussr<=1;


keep if year>=1982 & year<=2008;

sort unique;
merge unique using "/volumes/ddisk/math/soviet/key_variables5.dta";
drop _merge;

drop if papers==.;
summ papers ;

generate post1992=(year>=1992);

generate inter_shock_ams=post1992*shock_ams;
generate inter_shock1=post1992*shock1;

generate lpapers=log(1+papers);


generate inter_pexp=post1992*pexposed;
generate inter_inst_pexp=post1992*inst_shock_ams;


generate paut1=coauthor_emigre;

generate inter_paut1=post1992*paut1;
generate inter_coauthor=post1992*coauthor_shock_ams;

generate coauthor_sov1=(coauthor_emigre~=.);


generate publish=(papers>0);

replace inter_paut1=0 if inter_paut1==.;
replace inter_coauthor=0 if inter_coauthor==.;

replace quality_coauthors=0 if quality_coauthors==.;
replace quality_coauthors=(quality_coauthors>92);


generate inter_high=quality_coauthors*inter_paut1;
generate inter_low=(1-quality_coauthors)*inter_paut1;
generate inter_high_inst=quality_coauthors*inter_coauthor;



drop if emigre==1;
drop if unique==.;

drop string_year _fillin n70 soviet_forever country mix
	pussr0 pussr2 phdussr degree_year pussr2new pmodal in_ussr good pussr;



tab year, gen(dyear);
compress;

generate exper = year - minyear;
generate exper2 = exper*exper;
generate exper3 = exper2*exper;
generate exper4 = exper3*exper;


keep papers lpapers post1992 exper* year
	unique subject publish quality_coauthor;
keep if year>=1982 & year<=2008;
summ;


sort unique;
merge unique using /volumes/ddisk/math/soviet/shocks_and_instruments.dta;
drop _merge;

rename shock_idea_space shock_idea;
rename shock_geographic_space shock_geographic;
rename shock_coauthor_space shock_coauthor;
rename instrument_idea_space instrument_idea;
rename instrument_geographic_space instrument_geographic;
rename instrument_coauthor_space instrument_coauthor;
rename shock_coauthor_space_high shock_coauthor_high;
rename shock_coauthor_space_low shock_coauthor_low;
rename instrument_coauthor_space_high instrument_coauthor_high;
rename instrument_coauthor_space_low instrument_coauthor_low;

replace shock_coauthor=0 if shock_coauthor==.;
replace shock_coauthor_high=0 if shock_coauthor_high==.;
replace shock_coauthor_low=0 if shock_coauthor_low==.;
replace instrument_coauthor=0 if instrument_coauthor==.;
replace instrument_coauthor_high=0 if instrument_coauthor_high==.;
replace instrument_coauthor_low=0 if instrument_coauthor_low==.;

generate inter_shock_idea=post1992*shock_idea;
generate inter_instrument_idea=post1992*instrument_idea;
generate inter_shock_geographic=post1992*shock_geographic;
generate inter_instrument_geographic=post1992*instrument_geographic;
generate inter_shock_coauthor=post1992*shock_coauthor;
generate inter_instrument_coauthor=post1992*instrument_coauthor;
generate inter_shock_coauthor_high=post1992*shock_coauthor_high;
generate inter_instrument_coauthor_high=post1992*instrument_coauthor_high;
generate inter_shock_coauthor_low=post1992*shock_coauthor_low;
generate inter_instrument_coauthor_low=post1992*instrument_coauthor_low;



save /volumes/ddisk/data/junksubject.dta, replace;



use /volumes/ddisk/data/junksubject.dta, clear;

keep if exper>=0 & exper<=60;

quietly tabulate year, gen(dyear);
	
gen double indicator_category = subject*10000 + year;



sort indicator_category;
by indicator_category: egen m_papers = mean(papers);
by indicator_category: egen m_publish = mean(publish);
by indicator_category: egen m_inter_shock_idea = mean(inter_shock_idea);
by indicator_category: egen m_inter_shock_geographic = mean(inter_shock_geographic);
by indicator_category: egen m_inter_shock_coauthor = mean(inter_shock_coauthor);
by indicator_category: egen m_post1992 = mean(post1992);
by indicator_category: egen m_exper = mean(exper);
by indicator_category: egen m_exper2 = mean(exper2);
by indicator_category: egen m_exper3 = mean(exper3);
by indicator_category: egen m_exper4 = mean(exper4);
replace lpapers = papers - m_papers;
replace publish = publish - m_publish;
replace inter_shock_idea = inter_shock_idea - m_inter_shock_idea;
replace inter_shock_geographic = inter_shock_geographic - m_inter_shock_geographic;
replace inter_shock_coauthor = inter_shock_coauthor - m_inter_shock_coauthor;
replace post1992 = post1992 - m_post1992;
replace exper = exper - m_exper;
replace exper2 = exper2 - m_exper2;
replace exper3 = exper3 - m_exper3;
replace exper4 = exper4 - m_exper4;

by indicator_category: egen m_inter_instrument_idea = mean(inter_instrument_idea);
by indicator_category: egen m_inter_instrument_geographic = mean(inter_instrument_geographic);
by indicator_category: egen m_inter_instrument_coauthor = mean(inter_instrument_coauthor);
replace inter_instrument_idea = inter_instrument_idea - m_inter_instrument_idea;
replace inter_instrument_geographic = inter_instrument_geographic - m_inter_instrument_geographic;
replace inter_instrument_coauthor = inter_instrument_coauthor - m_inter_instrument_coauthor;

by indicator_category: egen m_inter_shock_coauthor_high = mean(inter_shock_coauthor_high);
by indicator_category: egen m_inter_shock_coauthor_low = mean(inter_shock_coauthor_low);
replace inter_shock_coauthor_high = inter_shock_coauthor_high - m_inter_shock_coauthor_high;
replace inter_shock_coauthor_low = inter_shock_coauthor_low - m_inter_shock_coauthor_low;
by indicator_category: egen m_inter_instrument_coauthor_high = mean(inter_instrument_coauthor_high);
by indicator_category: egen m_inter_instrument_coauthor_low = mean(inter_instrument_coauthor_low);
replace inter_instrument_coauthor_high = inter_instrument_coauthor_high - m_inter_instrument_coauthor_high;
replace inter_instrument_coauthor_low = inter_instrument_coauthor_low - m_inter_instrument_coauthor_low;

drop m_*;

compress;


save /volumes/ddisk/data/junkdata.dta, replace;



use /volumes/ddisk/data/junkdata.dta, clear;

sort unique year subject papers;
duplicates drop unique year subject, force;

summ unique papers;

merge 1:1 unique year subject using /volumes/ddisk/math/soviet/english_papers_unique_year_subject2.dta, 
	generate(_merge_english);
drop if _merge_english == 2;
summ unique papers;
gen combined_papers = papers;
summ unique papers combined_papers;
*I ADDED THE FOLLOWING LINE INTO THE CODE;
replace english_papers=0 if english_papers==.;
replace combined_papers = english_papers if year >= 1992;
summ unique papers combined_papers;


generate c_publish=(combined_papers>0);
generate c_papers=combined_papers;

sort indicator_category;
by indicator_category: egen m_c_papers = mean(c_papers);
by indicator_category: egen m_c_publish = mean(c_publish);
replace c_papers = c_papers - m_c_papers;
replace c_publish = c_publish - m_c_publish;


rename inter_instrument_coauthor_high inter_inst_coauthor_high;
rename inter_instrument_coauthor_low inter_inst_coauthor_low;

xtivreg2 publish post1992 exper* 
	(inter_shock_idea = 
	inter_instrument_idea ) , 
	fe i(unique) cluster(unique);
xtivreg2 papers post1992 exper* 
	(inter_shock_idea  = 
	inter_instrument_idea ) , 
	fe i(unique) cluster(unique);
	
xtivreg2 publish post1992 exper* 
	( inter_shock_geographic  = 
	 inter_instrument_geographic ) , 
	fe i(unique) cluster(unique);
xtivreg2 papers post1992 exper* 
	( inter_shock_geographic  = 
	 inter_instrument_geographic ) , 
	fe i(unique) cluster(unique);
	
xtivreg2 publish post1992 exper* 
	(  inter_shock_coauthor= 
	 inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);
xtivreg2 papers post1992 exper* 
	(  inter_shock_coauthor= 
	 inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);
	
xtivreg2 publish post1992 exper* 
	(inter_shock_idea inter_shock_geographic  inter_shock_coauthor= 
	inter_instrument_idea inter_instrument_geographic inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);
xtivreg2 papers post1992 exper* 
	(inter_shock_idea inter_shock_geographic  inter_shock_coauthor= 
	inter_instrument_idea inter_instrument_geographic inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);
	

sort unique year subject;
merge unique year subject using /Volumes/Ddisk/Math/Soviet/outcome_variables_george.dta;
drop _merge;

replace share_of_papers=0 if share_of_papers==.;
replace top_papers=0 if top_papers==.;
generate top_publish=(top_papers>0);

sort indicator_category;
by indicator_category: egen m_share_of_papers = mean(share_of_papers);
by indicator_category: egen m_top_papers = mean(top_papers);
by indicator_category: egen m_top_publish = mean(top_publish);
replace share_of_papers = share_of_papers - m_share_of_papers;
replace top_papers = top_papers - m_top_papers;
replace top_publish = top_publish - m_top_publish;


xtivreg2 share_of_papers post1992 exper* 
	(inter_shock_idea inter_shock_geographic  inter_shock_coauthor= 
	inter_instrument_idea inter_instrument_geographic inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);
xtivreg2 top_publish post1992 exper* 
	(inter_shock_idea inter_shock_geographic  inter_shock_coauthor= 
	inter_instrument_idea inter_instrument_geographic inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);
xtivreg2 top_papers post1992 exper* 
	(inter_shock_idea inter_shock_geographic  inter_shock_coauthor= 
	inter_instrument_idea inter_instrument_geographic inter_instrument_coauthor) , 
	fe i(unique) cluster(unique);


log close;


