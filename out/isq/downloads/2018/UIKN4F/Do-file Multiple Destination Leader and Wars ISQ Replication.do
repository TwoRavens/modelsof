/*Bring data*/

#delimit;
set seed 7777777;

#delimit;
use "Data Multiple Destination Leader and War ISQ Replication.dta", clear;

/*Number of leader changes*/
#delimit;
sum year fail;
tab fail;
sum wardur;

#delimit;
preserve;
sort countrywar year month leadid;
by countrywar: egen num_lead_chan=total(fail);
sum num_lead_chan;
qui duplicates drop countrywar, force;
tab num_lead_chan;
display 40+(14*1)+(7*1)+(4*1)+(3*1);
display 40+(14*2)+(7*3)+(4*4)+(3*5);
restore;

/*Durations 1*/
#delimit;
preserve;
sort countrywar year month leadid;
by countrywar: egen leadch=max(fail);
by countrywar: egen sm_wardur= max(wardur);
qui duplicates drop countrywar, force; 
tab leadch exit;
sort ccode year month leadid;
order countrywar year month wardur sm_wardur warend leader leaddur fail leadch;
stset sm_wardur;
stci;
stdes;
stset, clear;
#delimit;
stset sm_wardur if leadch==0;
stci;
stdes;
stset, clear;
#delimit;
stset sm_wardur if leadch==1;
stci;
stdes;
restore;

/*Durations 2: Keep first leader that fails to calculate duration after leader change*/
#delimit;
preserve;
sum wardur;
sort countrywar year month leadid;
by countrywar: egen leadch=max(fail);
by countrywar: egen sm_wardur= max(wardur);
keep if fail==1;
#delimit;
qui duplicates drop countrywar, force;
gen warduraft= sm_wardur-wardur;
sum warduraft;
replace warduraft=.5 if warduraft==0;
stset, clear;
stset warduraft if leadch==1;
stci;
stdes;
restore;


/**********************************************************************/
/****************************** Variables *****************************/
/**********************************************************************/

#delimit;
gen dummyW=0 if W !=.;
replace dummyW=1 if W>=.75 & W !=.;
tab dummyW;

gen Wln_leaddur=W*ln_leaddur;
gen Wln_wardur=W*ln_wardur;

/*More interactions*/
gen w_cinc=W*cinc;
gen avdeaths_W=avdeaths*W;
gen ln_pop=ln(tpop);
inspect ln_pop;

#delimit;
/*OUTCOME OF WARS*/
/*(1 = on winning side, 2 = on losing side, 3 = on side A of a tie,
4 = on side B of a tie, 5 = on side A of ongoing war, 6 = on side B of ongoing war)*/
gen win=0;
replace win=1 if outcome==1;  
gen lose=0; 
replace lose=1 if outcome==2 ; 
gen Wwin=W*win; 
label variable Wwin "Interaction W and win";
gen Wlose=W*lose; 
label variable Wlose "Interaction W and lose";

/*Leader Failure with war outcome*/
gen failwin=0;
#delimit;
replace failwin=1 if fail==1 & win==1;
gen faillose=0;
replace faillose=1 if fail==1 & lose==1;


/**********************************************************************/
/************************** Tabs ****************************/
/**********************************************************************/

sort ccode year month leadid;
order countrywar year month wardur warend leader leaddur fail ;

#delimit;
tab fail exit;
tab exit if fail==1;
tab dummyW exit if fail==1;

/*POSTTENUREFATE indicates the manner with which a leader lost power*/
/*0 OK; 1 Exile; 2 Imprisonment (including house arrest); 3 Death*/
tab exit posttenurefate if fail==1;
display 2/53;
display 6/28;


/**********************************************************************/
/*********************** Multiple Destination *************************/
/**********************************************************************/

/*ENTRY identifies the manner with which a leader reaches power.*/
/*0 Leader reached power through regular means*/
/*1 Leader reached power through irregular means*/ 
/*2 Leader directly imposed by another state*/

/*EXIT indicates the manner with which a leader lost power*/
/*-888 Leader still in power*/ 
/*1 Leader lost power through regular means*/ 
/*2 Leader died of natural causes while in power*/ 
/*2.1 Leader retired due to ill health*/ 
/*2.2 Leader lost office as a result of suicide*/ 
/*3 Leader lost power through irregular means*/ 
/*4 Leader deposed by another state*/

#delimit;
gen fail1=0;
replace fail1=1 if fail==1 & exit==1;
gen fail2=0;
replace fail2=1 if fail==1 & exit==2;
gen fail21=0;
replace fail21=1 if fail==1 & exit==2.1;
gen fail22=0;
replace fail22=1 if fail==1 & exit==2.2;
gen fail3=0;
replace fail3=1 if fail==1 & exit==3;
gen fail4=0;
replace fail4=1 if fail==1 & exit==4;


#delimit;
order year month countrywar wardur warend leader fail exit W;

/**********************************************************************/
/*********************** Appendix 1 *************************/
/**********************************************************************/

/*Pooled Model*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur), 
cluster(countrywar);
estimates store one, title(Model 3);

/*Small W Model*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur)  if W<.75, 
cluster(countrywar);
estimates store two, title(Model 3);


/*Big W Model*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur) if W>=.75, 
cluster(countrywar);
estimates store three, title(Model 3);


#delimit;
estout one two three, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabels(fail LeaderChange ln_pop ln(Population) cinc Capabilities initiate Initiate 
   	parties Participants avdeaths MeanDeaths avdeaths_W (MeanDeaths)(W)
   	ln_wardur ln(WarDuration) Wln_wardur ln(WarDuration)(W) ln_energy_pop ln(EnergyCons.pc)
   	ch_ln_energy_pop $\Delta$ln(EnergyCons.pc) ln_leaddur ln(LeaderDuration)
   	Wln_leaddur ln(LeaderDuration)(W) _cons Intercept) 	///
   	stats(N N_clust ll rho, fmt(%9.4f) label(N Country-Wars LogLikelihood rho)) ///
	style(tex) ;

/**********************************************************************/
/*********************** Appendix 2 *************************/
/**********************************************************************/

/**********************************************************************/
/*********************** Multiple Destination Pooled *************************/
/**********************************************************************/

/*EXIT indicates the manner with which a leader lost power*/
/*-888 Leader still in power*/ 
/*1 Leader lost power through regular means*/ 
/*2 Leader died of natural causes while in power*/ 
/*2.1 Leader retired due to ill health*/ 
/*2.2 Leader lost office as a result of suicide*/ 
/*3 Leader lost power through irregular means*/ 
/*4 Leader deposed by another state*/

/*Pooled Model D1*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail1=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur), 
cluster(countrywar);
estimates store threer, title(Model 3);

/*Pooled Model D3*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail3= ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur), 
cluster(countrywar);
estimates store threei, title(Model 3);

/**********************************************************************/
/*********************** Multiple Destination Autocracies *************************/
/**********************************************************************/


/*Autocracies Model D1*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail1=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur) if W<.75, 
cluster(countrywar);
estimates store fiver, title(Model 3);

/*Autocracies Model D3*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail3=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur) if W<.75, 
cluster(countrywar);
estimates store fivei, title(Model 3);


/**********************************************************************/
/*********************** Multiple Destination Democracies*************************/
/**********************************************************************/

/*Democracies Model D1*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail1=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur) if W>=.75, 
cluster(countrywar);
estimates store fourr, title(Model 3);

/*Democracies Model D3*/
#delimit;
biprobit (warend= ln_pop cinc initiate W parties avdeaths avdeaths_W ln_wardur Wln_wardur) 
(fail3=  ln_energy_pop ch_ln_energy_pop W avdeaths avdeaths_W ln_leaddur Wln_leaddur) if W>=.75, 
cluster(countrywar);
estimates store fouri, title(Model 3);


#delimit;
estout threer fiver fourr, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabels(fail LeaderChange ln_pop ln(Population) cinc Capabilities initiate Initiate 
   	parties Participants avdeaths MeanDeaths avdeaths_W (MeanDeaths)(W)
   	ln_wardur ln(WarDuration) Wln_wardur ln(WarDuration)(W) ln_energy_pop ln(EnergyCons.pc)
   	ch_ln_energy_pop $\Delta$ln(EnergyCons.pc) ln_leaddur ln(LeaderDuration)
   	Wln_leaddur ln(LeaderDuration)(W) _cons Intercept) 	///
   	stats(N N_clust ll rho, fmt(%9.4f) label(N Country-Wars LogLikelihood rho)) ///
	style(tex) ;

#delimit;
estout threei fivei fouri, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabels(fail LeaderChange ln_pop ln(Population) cinc Capabilities initiate Initiate 
   	parties Participants avdeaths MeanDeaths avdeaths_W (MeanDeaths)(W)
   	ln_wardur ln(WarDuration) Wln_wardur ln(WarDuration)(W) ln_energy_pop ln(EnergyCons.pc)
   	ch_ln_energy_pop $\Delta$ln(EnergyCons.pc) ln_leaddur ln(LeaderDuration)
   	Wln_leaddur ln(LeaderDuration)(W) _cons Intercept) 	///
   	stats(N N_clust ll rho, fmt(%9.4f) label(N Country-Wars LogLikelihood rho)) ///
	style(tex) ;








