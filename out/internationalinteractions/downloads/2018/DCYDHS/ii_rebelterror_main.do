
**** Models from Main Paper and Apendices *** 
***Coding variables for Terrorist targets***

#delimit;
set mem 1000m;
use ii_rebelterror_main_labels.dta;

***Coding for several key variables***
egen exposure=sum(iattacks_t),by(gname year)
egen instotal=sum(iattacks_i),by(gname provstate)
gen insdummy=0
replace insdummy=1 if instotal>=1
egen insother=sum(iattacks_i),by(country_txt provstate year)
replace insother=insother-iattacks_i 
replace loginsother = log(insother)

egen insexposure=sum(iattacks_i),by(gname year)
replace activemax=1 if insexposure>0 | exposure>0
replace activemax=0 if insexposure==0 


gsort + country_txt + gname + provstate - activemax + year;
by country_txt gname provstate: gen active_count = _n if activemax==1;
replace active_count=. if gname == "Bodo Militants" | gname == "National Union for the Total Independence of Angola (UNITA)" | gname == "Revolutionary Armed Forces of Colombia (FARC)" | gname == "Cabinda Rebels" | gname == "Dev Sol" | gname== "Hizb-I-Islami" |gname== "Karen National Union" | gname == "Kashmir Insurgents" | gname == "Khmer Rouge" | gname== "Kurdistan Workers' Party (PKK)" | gname == "Liberation Tigers of Tamil Eelam (LTTE)" | gname == "Moro Militants" | gname == "Nagaland Separatists" | gname == "National Liberation Army of Colombia (ELN)" | gname == "New People's Army (NPA)" | gname == "Shining Path (SL)" | gname=="Sikh Extremists" | gname== " Tupac Amaru Revolutionary Movement (MRTA)" | gname== "United Liberation Front of Assam (ULFA)";

gen grouping = 0;
replace grouping=1 if gname=="Balochi Separatists" | gname=="Bodo Militants" | gname=="Cabinda Rebels" | gname=="Huthis" | gname == "Hutu Rebels" | gname=="Kashmir Insurgents" | gname == "Manipur Separatists" | gname == "Moro Militants" | gname == "Nagaland Separatists" | gname == "Sikh Extremists" | gname == "South Caucasus Rebels" | gname == "Southern Yemen Seaparatists" | gname== "Terai Separatists" | gname=="Tripura Separatists"



***Imputation of Missing data from 1993***
#delimit;
gen iattacks_i = attacks_i;
gen iattacks_t = attacks_t;
sort iso gname provstate year;
bysort panelcode (year) : replace iattacks_t = (iattacks_t[_n+1] + iattacks_t[_n-1])/2 if year==1993;
sort iso gname provstate year;
bysort panelcode (year) : replace iattacks_i = (iattacks_i[_n+1] + iattacks_i[_n-1])/2 if year==1993;
replace iattacks_i=round(iattacks_i,1);
replace iattacks_t=round(iattacks_t,1);

****Replication Instructions for Tables included in Paper and Appendices****

***Table 1 in Main Paper***
#delimit;
tab gname;
* Produces list of groups
tab gname country_txt;
* produces list of countries and where each group operates

*Note: Years of group initiation were taken from the PRIO ACD, cited at the bottom of the table.

***Table 2 in Main Paper***
#delimit;
corr ldeviation lightineq if country_txt == "Colombia";
corr ldeviation lightineq if country_txt == "India";
corr ldeviation lightineq if country_txt == "Philippines";
corr ldeviation lightineq if country_txt == "Russia";
corr ldeviation lightineq if country_txt == "Turkey";
corr ldeviation lightineq;

***Table 3 in Main Paper ****

#delimit;
xi: nbreg iattacks_t lightineq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a1;
xi: nbreg iattacks_t lightineq included  iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping i.gname i.year i.iso if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a2;
xi: nbreg iattacks_t lightineq included  iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a6;
estout a1 a2 a6 using newtab1.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


****APPENDIX****

***Table 1 of the Appendix***

sum iattacks_t lightineq iattacks_i_d population insborder loginsother capitalcity capdist2 elevation2 urbanpct petrodummy diadummy;

***Table 2 of the Appendix***

list provstate lightineq_orig lightineq regionlights regiondens if country=="Nigeria" & year==2013 & groupname=="Boko Haram";

***Table 3 of the Appendix***


***Non-Linear Effects:Appendix***
#delimit;
xi: nbreg iattacks_t lightineqsq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo nl3;
xi: nbreg iattacks_t lightineq lightineqsq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy foreign_support grouping diadummy i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo nl4;
xi: nbreg iattacks_t high_light low_light included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo nl5;
estout nl3 nl4 nl5 using nllights.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***Table 4 of the Appendix***

** Using EPR Data for exclusion **

#delimit;
xi: nbreg iattacks_t excluded included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo epr1;
xi: nbreg iattacks_t excluded included iattacks_i_dummy insborder excluded_border excluded_insurgency population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo epr2;
xi: nbreg iattacks_t excluded included lightineq iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo epr3;
estout epr1 epr2 epr3 using epr.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***Table 5 of the Appendix***

#delimit;
xi: nbreg iattacks_t econineq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo c1;
xi: nbreg iattacks_t econineqsq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo c2;
xi: nbreg iattacks_t econineq econineqsq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo c3;
xi: nbreg iattacks_t lightineq econineq included iattacks_i_d light_attacks_i population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo c4;
xi: nbreg iattacks_t lightineq ldev included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo c5;
estout c1 c2 c3 c4 c5 using apptab1.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***Table 6 of the Appendix***
#delimit;
* Note: This requires the original list of terrorist attacks from GTD, before they were collapsed by country-group-region-year. The file is only necessary for this table.
* To recreate the subsequent tables, it will be necessary to return to the main data file. 
clear;
use gtd_largen_nomil_full;
tab  targtype1_txt;
clear;

***Table 7 of the Appendix***
use ii_rebelterror_main_labels.dta;

***Attacks on the Government or Private Citizens only***
#delimit;
xi: nbreg iattacks_g lightineq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo y1;
xi: nbreg iattacks_g lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo y2;
xi: nbreg iattacks_c lightineq included iattacks_i_d population capitalcity loginsother insborder urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo z1;
xi: nbreg iattacks_c lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo z2;
estout y1 y2 z1 z2 using target.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***Table 8 of the Appendix is identical to Table 1 of the main paper, with the exception of the addition of ACD2EPR data, which was done manually. 

***Table 9 of the Appendix***

***With Identity Kin: Appendix ***;
#delimit;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder  population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy identitykin foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr ;
eststo e1;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy identitykin foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo e2;
estout e1 e2  using apptab3.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***Table 10 of the Appendix***


***Identity Kin predicts More deprivation***;
#delimit;
reg lightineq identitykin  diadummy petrodummy populationpct urbanpct capitalcity elevation2 capdist2, vce(cluster provstate);
eststo reg1;
reg lightineq identitykin  diadummy petrodummy populationpct urbanpct capitalcity elevation2 capdist2 if identitygroup==1, vce(cluster provstate);
eststo reg2;
estout reg1 reg2 using apptab5.tex, replace cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***Table 11 of the Appendix***

***Various Iterations of Threshold for inclusion***
#delimit;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo f1;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if activemax>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo f2;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if insexposure>0 & exposure>0, vce(cluster  provstate) exposure(exposure) irr difficult;
eststo f3;
estout f1 f2 f3 using apptab4.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***Table 12 of the Appendix***


***Zero Inflated Negative Binomial:Appendix****
#delimit;
xi: zinb iattacks_t lightineq included iattacks_i_d population capitalcity loginsother insborder petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , inflate(elevation capdist urbanpct) vce(cluster  provstate) exposure(exposure) irr zip;
eststo b1;
xi: zinb iattacks_t lightineq included iattacks_i_d insborder light_insborder light_attacks_i population capitalcity loginsother petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 , inflate(elevation capdist urbanpct) vce(cluster  provstate) exposure(exposure) irr zip;
eststo b2;
estout b1 b2 using newtab2.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


***Table 13 of the Appendix***

*** Attacks across timing of insurgency ***
#delimit;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count==1 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a10; 
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count>1 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a11;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count<3 & active_count!=0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a20; 
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count>2 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a21;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count>1 & active_count<3 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a22; 
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count<4 & active_count!=0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a30; 
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count>3 ,vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a31;
xi: nbreg iattacks_t lightineq included iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct elevation2 capdist2 petrodummy diadummy foreign_support grouping  i.gname i.year if active>0 & active_count>2 & active_count<4, vce(cluster  provstate) exposure(exposure) irr difficult;
eststo a32;
estout a10 a22 a32 a31 using govresponse.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 

***Table 14 of the Appendix***

***Spatial Lag Negative Binomial Models***
***Note: Must upload Balanced Panel file to replicated***
***Note 2: See R code for detailed calculation procedures for spatial lag and Moran's I***

#delimit;
clear;
use ii_rebelterr_balanced2.dta;
xi: nbreg iattacks_t s_lag i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo sl1;
xi: nbreg iattacks_t s_lag  lightineq included  iattacks_i_dummy capitalcity i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo sl2;
xi: nbreg iattacks_t s_lag  lightineq included  iattacks_i_dummy capitalcity light_attacks_i  i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo sl3;
xi: nbreg iattacks_t s_lag  lightineq included  iattacks_i_dummy insborder light_insborder light_attacks_i population capitalcity loginsother urbanpct capdist2 petrodummy diadummy foreign_support i.gname i.year if active>0 , vce(cluster  provstate) exposure(exposure) irr difficult;
eststo sl4;
estout sl1 sl2 sl3 sl4 using slag.tex, replace eform indicate(Group Fixed Effects = _Igname*,labels("\ding{51}" "")) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend label collabels(none) varlabels(_cons \_cons) style(tex); 


****END APPENDIX TABLES****


***Coding Idetntity Kin Based on GeoEPR Data***
#delimit;
replace identitykin=1 if name_1=="Bengo" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Cabinda" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Cuanza Norte" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Lunda Norte" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Malanje" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Uíge" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Zaire" & gname=="Cabinda Rebels";
replace identitykin=1 if name_1=="Arunachal Pradesh" & gname=="United Liberation Front of Assam (ULFA)";
replace identitykin=1 if name_1=="Assam" & gname=="United Liberation Front of Assam (ULFA)";
replace identitykin=1 if name_1=="Manipur" & gname=="United Liberation Front of Assam (ULFA)";
replace identitykin=1 if name_1=="Meghalaya" & gname=="United Liberation Front of Assam (ULFA)";
replace identitykin=1 if name_1=="Nagaland" & gname=="United Liberation Front of Assam (ULFA)";
replace identitykin=1 if name_1=="West Bengal" & gname=="United Liberation Front of Assam (ULFA)";
replace identitykin=1 if name_1=="Assam" & gname=="Garo National Liberation Army";
replace identitykin=1 if name_1=="Meghalaya" & gname=="Garo National Liberation Army";
replace identitykin=1 if name_1=="Assam" & gname=="Bodo Militants";
replace identitykin=1 if name_1=="Meghalaya" & gname=="Bodo Militants";
replace identitykin=1 if name_1=="Himachal Pradesh" & gname=="Kashmir Insurgents";
replace identitykin=1 if name_1=="Jammu and Kashmir" & gname=="Kashmir Insurgents";
replace identitykin=1 if name_1=="Manipur" & gname=="Kuki Revolutionary Army (KRA)";
replace identitykin=1 if name_1=="Mizoram" & gname=="Kuki Revolutionary Army (KRA)";
replace identitykin=1 if name_1=="Tripura" & gname=="Kuki Revolutionary Army (KRA)";
replace identitykin=1 if name_1=="Manipur" & gname=="Manipur Separatists";
replace identitykin=1 if name_1=="Arunachal Pradesh" & gname=="Nagaland Separatists";
replace identitykin=1 if name_1=="Assam" & gname=="Nagaland Separatists";
replace identitykin=1 if name_1=="Manipur" & gname=="Nagaland Separatists";
replace identitykin=1 if name_1=="Nagaland" & gname=="Nagaland Separatists";
replace identitykin=1 if name_1=="Chandigarh" & gname=="Sikh Extremists";
replace identitykin=1 if name_1=="Haryana" & gname=="Sikh Extremists";
replace identitykin=1 if name_1=="Himachal Pradesh" & gname=="Sikh Extremists";
replace identitykin=1 if name_1=="Jammu and Kashmir" & gname=="Sikh Extremists";
replace identitykin=1 if name_1=="Punjab" & gname=="Sikh Extremists";
replace identitykin=1 if name_1=="Rajasthan" & gname=="Sikh Extremists";
replace identitykin=1 if name_1=="Mizoram" & gname=="Tripura Separatists";
replace identitykin=1 if name_1=="Tripura" & gname=="Tripura Separatists";
replace identitykin=1 if iso=="LKA";
replace identitykin=0 if name_1=="Puttalam";
replace identitykin=1 if name_1=="Ayeyarwady" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Bago" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Kayah" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Kayin" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Magway" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Mandalay" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Mon" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Shan" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Tanintharyi" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Yangon" & gname=="Karen National Union";
replace identitykin=1 if name_1=="Bayelsa" & gname=="Movement for the Emancipation of the Niger Delta (MEND)";
replace identitykin=1 if name_1=="Delta" & gname=="Movement for the Emancipation of the Niger Delta (MEND)";
replace identitykin=1 if name_1=="Edo" & gname=="Movement for the Emancipation of the Niger Delta (MEND)";
replace identitykin=1 if name_1=="Imo" & gname=="Movement for the Emancipation of the Niger Delta (MEND)";
replace identitykin=1 if name_1=="Ondo" & gname=="Movement for the Emancipation of the Niger Delta (MEND)";
replace identitykin=1 if name_1=="Rivers" & gname=="Movement for the Emancipation of the Niger Delta (MEND)";
replace identitykin=1 if name_1=="Adamawa" & gname=="Boko Haram";
replace identitykin=1 if name_1=="Bauchi" & gname=="Boko Haram";
replace identitykin=1 if name_1=="Borno" & gname=="Boko Haram";
replace identitykin=1 if name_1=="Gombe" & gname=="Boko Haram";
replace identitykin=1 if name_1=="Jigawa" & gname=="Boko Haram";
replace identitykin=1 if name_1=="Yobe" & gname=="Boko Haram";
replace identitykin=1 if name_1=="Mahakali" & gname=="Terai Separatists";
replace identitykin=1 if name_1=="Seti" & gname=="Terai Separatists";
replace identitykin=1 if name_1=="Rapti" & gname=="Terai Separatists";
replace identitykin=1 if name_1=="Lumbini" & gname=="Terai Separatists";
replace identitykin=1 if name_1=="Narayani" & gname=="Terai Separatists";
replace identitykin=1 if name_1=="Baluchistan" & gname=="Tehrik-i-Taliban Pakistan (TTP)";
replace identitykin=1 if name_1=="F.A.T.A." & gname=="Tehrik-i-Taliban Pakistan (TTP)";
replace identitykin=1 if name_1=="N.W.F.P." & gname=="Tehrik-i-Taliban Pakistan (TTP)";
replace identitykin=1 if name_1=="PunjabPak" & gname=="Tehrik-i-Taliban Pakistan (TTP)";
replace identitykin=1 if name_1=="Baluchistan" & gname=="Lashkar-e-Islam (Pakistan)";
replace identitykin=1 if name_1=="F.A.T.A." & gname=="Lashkar-e-Islam (Pakistan)";
replace identitykin=1 if name_1=="N.W.F.P." & gname=="Lashkar-e-Islam (Pakistan)";
replace identitykin=1 if name_1=="PunjabPak" & gname=="Lashkar-e-Islam (Pakistan)";
replace identitykin=1 if name_1=="Baluchistan" & gname=="Balochi Separatists";
replace identitykin=1 if name_1=="PunjabPak" & gname=="Balochi Separatists";
replace identitykin=1 if name_1=="Sind" & gname=="Balochi Separatists";
replace identitykin=1 if name_1=="Baluchistan" & gname=="Muttahida Qami Movement (MQM)";
replace identitykin=1 if name_1=="PunjabPak" & gname=="Muttahida Qami Movement (MQM)";
replace identitykin=1 if name_1=="Sind" & gname=="Muttahida Qami Movement (MQM)";
replace identitykin=1 if name_1=="Northern Mindanao (Region X)" & gname=="Moro Militants";
replace identitykin=1 if name_1=="Davao Region (Region XI)" & gname=="Moro Militants";
replace identitykin=1 if name_1=="MIMAROPA (Region IV-B)" & gname=="Moro Militants";
replace identitykin=1 if name_1=="SOCCSKSARGEN (Region XII)" & gname=="Moro Militants";
replace identitykin=1 if name_1=="Zamboanga Peninsula (Region IX)" & gname=="Moro Militants";
replace identitykin=1 if name_1=="Autonomous Region of Muslim Mindanao (ARMM)" & gname=="Moro Militants";
replace identitykin=1 if name_1=="Northern Mindanao (Region X)" & gname=="Abu Sayyaf Group (ASG)";
replace identitykin=1 if name_1=="Davao Region (Region XI)" & gname=="Abu Sayyaf Group (ASG)";
replace identitykin=1 if name_1=="MIMAROPA (Region IV-B)" & gname=="Abu Sayyaf Group (ASG)";
replace identitykin=1 if name_1=="SOCCSKSARGEN (Region XII)" & gname=="Abu Sayyaf Group (ASG)";
replace identitykin=1 if name_1=="Zamboanga Peninsula (Region IX)" & gname=="Abu Sayyaf Group (ASG)";
replace identitykin=1 if name_1=="Autonomous Region of Muslim Mindanao (ARMM)" & gname=="Abu Sayyaf Group (ASG)";
replace identitykin=1 if name_1=="Chechnya" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Dagestan" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Kalmyk" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Ingush" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="North Ossetia" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Stavropol'" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Kabardin-Balkar" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Karachay-Cherkess" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Krasnodar" & gname=="South Caucasus Rebels";
replace identitykin=1 if name_1=="Krabi" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Nakhon Si Thammarat" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Narathiwat" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Pattani" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Phangnga" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Phatthalung" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Phuket" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Satun" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Songkhla" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Surat Thani" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Trang" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Yala" & gname=="Runda Kumpulan Kecil (RKK)";
replace identitykin=1 if name_1=="Adiyaman" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Agri" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Amasya" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Ankara" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Ardahan" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Batman" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Bingöl" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Bitlis" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Diyarbakir" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Elazig" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Erzincan" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Erzurum" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Gaziantep" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Hakkari" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Hatay" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Igdir" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="K. Maras" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Kars" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Kilis" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Konya" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Malatya" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Mardin" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Mus" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Osmaniye" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Sanliurfa" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Siirt" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Sirnak" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Sivas" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Tokat" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Tunceli" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Van" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Yozgat" & gname=="Kurdistan Workers' Party (PKK)";
replace identitykin=1 if name_1=="Adjumani" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Apac" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Arua" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Gulu" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Kaberamaido" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Kamuli" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Katakwi" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Kayunga" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Kitgum" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Kotido" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Lira" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Masindi" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Moyo" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Nakasongola" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Nebbi" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Pader" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="Soroti" & gname=="Lord's Resistance Army (LRA)";
replace identitykin=1 if name_1=="`Adan" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Abyan" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Al Bayda'" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Al Dali'" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Al Hudaydah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Al Mahrah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Al Mahwit" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Amanat Al Asimah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Dhamar" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Hadramawt" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Hajjah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Ibb" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Lahij" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Ma'rib" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Raymah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Sa`dah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if provstate=="Sanaa" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Shabwah" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Ta`izz" & gname=="Al-Qa`ida in the Arabian Peninsula (AQAP)";
replace identitykin=1 if name_1=="Al Bayda" & gname==" Huthis";
replace identitykin=1 if name_1=="Al Dali'" & gname=="Huthis";
replace identitykin=1 if name_1=="Al Hudaydah" & gname=="Huthis";
replace identitykin=1 if name_1=="Al Jawf" & gname=="Huthis";
replace identitykin=1 if name_1=="Al Mahwit" & gname=="Huthis";
replace identitykin=1 if name_1=="Amanat Al Asimah" & gname=="Huthis";
replace identitykin=1 if name_1=="Amran" & gname=="Huthis";
replace identitykin=1 if name_1=="Dhamar" & gname=="Huthis";
replace identitykin=1 if name_1=="Hadramawt" & gname=="Huthis";
replace identitykin=1 if name_1=="Hajjah" & gname=="Huthis";
replace identitykin=1 if name_1=="Ibb" & gname=="Huthis";
replace identitykin=1 if name_1=="Ma'rib" & gname=="Huthis";
replace identitykin=1 if name_1=="Raymah" & gname=="Huthis";
replace identitykin=1 if name_1=="Sa`dah" & gname=="Huthis";
replace identitykin=1 if provstate=="Sanaa" & gname=="Huthis";
replace identitykin=1 if name_1=="Shabwah" & gname=="Huthis";
replace identitykin=1 if name_1=="`Adan" & gname=="Southern Yemen Separatists";
replace identitykin=1 if name_1=="Abyan" & gname=="Southern Yemen Separatists";
replace identitykin=1 if name_1=="Al Mahrah" & gname=="Southern Yemen Separatists";
replace identitykin=1 if name_1=="Hadramawt" & gname=="Southern Yemen Separatists";
replace identitykin=1 if name_1=="Lahij" & gname=="Southern Yemen Separatists";
replace identitykin=1 if name_1=="Shabwah" & gname=="Southern Yemen Separatists";
replace identitykin=1 if name_1=="Al-Anbar" & iso=="IRQ";
replace identitykin=1 if name_1=="Al-Basrah" & iso=="IRQ";
replace identitykin=1 if name_1=="Al-Muthannia" & iso=="IRQ";
replace identitykin=1 if name_1=="Arbil" & iso=="IRQ";
replace identitykin=1 if name_1=="As-Sulaymaniyah" & iso=="IRQ";
replace identitykin=1 if name_1=="At-Ta'mim" & iso=="IRQ";
replace identitykin=1 if name_1=="Babil" & iso=="IRQ";
replace identitykin=1 if name_1=="Baghdad" & iso=="IRQ";
replace identitykin=1 if name_1=="Dihok" & iso=="IRQ";
replace identitykin=1 if name_1=="Diyala" &  iso=="IRQ";
replace identitykin=1 if name_1=="Ninawa" & iso=="IRQ";
replace identitykin=1 if name_1=="Sala ad-Din" & iso=="IRQ";

