capture log close
log using base12_6b.log,replace

*       BASE12_6B.LOG

*       FIRST VERSION   OCTOBER 19, 2005
*       THIS VERSION    NOVEMBER 13, 2005

*       LAST REVISOR    AI

*       INPUT FILE:             BOCCO12_6.DTA
*       OUTPUT FILE:            DATASET FOR BOCCONI PROJECT
*
*				VERSIONE 6 DEI DATI A 12 FASCE
*
*

version 9.0

di "log file printed on $S_DATE at $S_TIME"

set more 1
clear
program drop _all
macro drop _all
scalar drop _all

# delimit ;

set memory 300000; 
set matsize 250;
tempfile tmpf1 tmpf2 tmpf3 tmpf4;


use bocco12_6, clear;


iis id;
tis anac;
xtdes;

sort id anac;

* RENAME OR GENERATE RELEVANT VARIABLES;

sort id anac;
bysort id (anac): gen aniscr = _n ;
label var aniscr "years since enrolment";

* DROP CASES NOT TO BE CONSIDERED;
drop if id==.;

* drop 2005;
drop if anac ==2005;

* drop foreign students;
keep if stato_res==37;
xtdes;

*drop des students (5 year program);
drop if cod_corso == 4;
xtdes;

* drop students ripetenti;
gen trip = posizione>14;
label var trip "ripetente nell'anno corrente";
egen rip = max(trip) , by(id);
label var rip "ripetente in qualche anno";
tab trip;
tab rip if aniscr==1;
*drop if rip==1;
*drop trip rip;
*xtdes;
*assert durata_corso==4;


* drop esonerati;
gen teso = cod_esonero >0;
label var teso "esonerato dalla tassa nell'anno corrente";
egen eso = max(teso) , by(id);
label var eso "esonerato dalla tassa in qualche anno";
tab teso;
tab eso if aniscr==1;
*drop if teso==1;
*drop teso;
*xtdes;




* RENAME OR GENERATE RELEVANT VARIABLES;

gen age = anac -year(date_birth);
label var age "age";

gen outmil = prov_res!= 15;
label var outmil "residente fuori milano";


* FUORI CORSO OUTCOME;
gen tfc = posizione<14;
label var tfc "fuori corso nell'anno corrente";
egen fc= max(tfc), by(id);
label var fc "studente che andra' o e' fuori corso";

tab posizione fc if aniscr==1;


gen tfc2 = posizione>1 & posizione<14;
label var tfc2 "fuori corso nell'anno corrente";
egen fc2= max(tfc2), by(id);
label var fc2 "studente che andra' o e' fuori corso";

tab posizione fc2 if aniscr==1;



* CUMULATIVE PERFORMANCE VARIABLES;
sort id anac;
tsset id anac;

bysort id (anac): gen tcnexa = sum(nexa) ;
gen lcnexa = l1.tcnexa;
label var lcnexa "number of exams before current year ";


gen vosum = gpa*nexa;
bysort id (anac): gen cvosum = sum(vosum) ;
gen lcvosum =l1.cvosum;

gen lcgpa = lcvosum/lcnexa;
label var  lcgpa "lagged cumulative gpa";

gen lgpa = l1.gpa;
label var lgpa "lagged gpa";

gen lnexa = l1.nexa;
label var lnexa "lagged numero di esami";

sum lcnexa lcgpa lgpa lnexa;

drop tcnexa lcvosum cvosum vosum;

* DROP FASCIA=12 AND FASCIA=11 PER L'ANNO 1992;

* drop reddito missing;
gen tymis = reddito_dic==0|reddito_di==.;
label var tymis "reddito missing (12 fascia) nell'anno in corso";
egen ymis = max(tymis), by(id);
label var ymis "reddito missing (12 fascia) in qualche anno";
drop if tymis==1;
drop tymis;
xtdes;

* drop all sources of fascia teo ==12;
gen tystra = reddito_dic<.01;
label var tystra "reddito smaller than 0.01";
egen ystra = max(tystra), by(id);
label var ystra "reddito smaller than 0.01 in qualche anno";
drop if tystra==1;
drop tystra;
xtdes;

drop if fascia_teo==12;
drop if fascia_teo==11&anac==1992;

xtdes;


* ASSEGNAZIONE SOGLIA PIU' VICINA AD OGNI UNITA';

gen y = reddito_dic/cpi if reddito_dic>0;
label var y "Real income - thousands of Euros";

gen yinf = liminf/cpi;
label var yinf "liminf in real terms";
gen ysup = limsup/cpi;
label var ysup "limsup in real terms";

gen ydinf = .;
gen ydsup = .;
label var ydinf "distanza da soglia inferiore";
label var ydsup "distanza da soglia superiore";
replace ydinf = y - yinf;
replace ydsup = ysup  - y;

assert fascia_teo!=12;

gen yd =.;
replace yd = y - yinf if ydinf<=ydsup&fascia_teo!=1&fascia_teo!=11;
replace yd = y - ysup if ydinf>ydsup&fascia_teo!=1&fascia_teo!=11;

replace yd = y - ysup if fascia_teo==1;

replace yd = y -yinf if fascia_teo==11&anac!=1992;
replace yd = y -yinf if fascia_teo==10&anac==1992;

label var yd "Income difference from nearest discontinuity - 1000 euros";

* indentificazione fascia piu' vicina;

gen neardisc = fascia_teo - 1  if yd==ydinf;
replace neardisc = fascia_teo if yd==-ydsup;
label var neardisc "nearest discontinuity";



sum liminf limsup ydinf ydsup yd;


* TASSE IN TERMINI REALI;

gen tpaid = tax_bocco_net/cpi;
label var tpaid "real tax paid";

gen tteo = tax_teo/cpi; 
label var tteo "real theorical tax based on income";

sum tteo tpaid ;


* DELTA TASSE;

gen dtteo=.;
gen pdtteo=.;
label var dtteo "incrase in tax respect to previous fascia";
label var pdtteo "percent incrase in tax respect to previous fascia";

gen dtteosup=.;
gen pdtteosup=.;
label var dtteosup "incrase between higher fascia and my fascia";
label var pdtteosup "percent incrase between higher fascia and my fascia";

gen tteosup = .;
gen tteoinf = .;
label var tteosup "tassa teorica nella fascia sup"; 
label var tteoinf "tassa teorica nella fascia inf"; 


#delimit cr
forvalues  i= 2(1)11  {
local im1= `i' - 1
local ip1= `i' + 1
replace tteosup = tax_teo`ip1'/cpi if fascia_teo==`i'
replace tteoinf = tax_teo`im1'/cpi if fascia_teo==`i'
replace dtteo = (tax_teo`i'/cpi - tax_teo`im1'/cpi) if fascia_teo==`i'
replace dtteosup = (tax_teo`ip1'/cpi - tax_teo`i'/cpi) if fascia_teo==`i'
replace pdtteo = (tax_teo`i'/cpi - tax_teo`im1'/cpi)/(tax_teo`im1'/cpi) if fascia_teo==`i'
replace pdtteosup = (tax_teo`ip1'/cpi - tax_teo`i'/cpi)/(tax_teo`i'/cpi) if fascia_teo==`i'
}
#delimit ;

* istruzioni specifiche per fascia 1 necessario perche'
il loop parte da 2 e tax_teo0 non esiste.
NB non sono necessarie per fascia 11 perche il loop arriva fino a 11 e
tax_teo12 esiste
;
replace dtteosup = (tax_teo2/cpi - tax_teo1/cpi) if fascia_teo==1;
replace pdtteosup = (tax_teo2/cpi - tax_teo1/cpi)/(tax_teo1/cpi) if fascia_teo==1;

replace tteosup = tax_teo2/cpi if fascia_teo==1;

sum dtteo pdtteo dtteosup pdtteosup tteosup tteoinf ;
 

* VARIABILI PER REGRESSION DISCONTINUITY ANALYSIS;

gen z = yd>=0; 
label var z "income above the threshold";

gen zdt = z*dtteo;
replace zdt=0 if zdt==.&fascia_teo==1;
label var zdt "z times deltatax teo";
sum z zdt;

gen zpdt = z*pdtteo;
replace zpdt=0 if zpdt==.&fascia_teo==1;
label var zpdt "z times percent deltatax teo";
sum z zpdt;

gen tteo1 = tteo if z==1;
gen tteo0 = tteoinf if z==1;
replace tteo1 = tteosup if z==0;
replace tteo0 = tteo if z==0;
label var tteo1 "teo tax sopra la soglia";
label var tteo0 "teo tax sotto la soglia";

compress;

des;

sum;

sum if aniscr==1;



label data "ordinamento 12 fasce - versione 6";
save base12_6, replace;


log close;












