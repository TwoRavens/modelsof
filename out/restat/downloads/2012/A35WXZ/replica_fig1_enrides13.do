capture log close
log using replica_fig1_enrides13.log,replace

*       REPLICA_FIG1_ENRIDES13.LOG

*       FIRST VERSION   JUNE 20, 2006
*       THIS VERSION    AUGUST 2, 2012

*       LAST REVISOR    AI

*       INPUT FILE:             BASE12_6.DTA
*       OUTPUT FILE:            ANALYSIS OF FUORI CORSO  OUTCOME
*
*
*		REPLICA FOR FIGURE 1

version 9.0

di "log file printed on $S_DATE at $S_TIME"

set more 1
clear
program drop _all
macro drop _all
scalar drop _all

# delimit ;

set scheme s1color;
set memory 300000; 
set matsize 250;
tempfile tmpf1 tmpf2 tmpf3 tmpf4;

use base12_6, clear;



********************************************
********************************************

MOTIVAZIONE

;

* DESCRIZIONE  FENOMENO FUORI CORSO

		Italia		economia	bocconi  

Iscritti 99-00	1684993		237893		8298
% FC		41.1%		43.6		28.9

Laureati 99-00	171806		28106		1182
% FC		83.5%		89.9		81.2


5.8 years to graduate instead of 4 on average for laureati in 99-00

;

tab fc if anac==1999;

tab tfc if anac==1999;

tab fc if anaclau==1999;
tab fc if anaclau==1999 & anac ==1999;

tab aniscr if anaclau==1999 & anac ==1999;

sum aniscr if anaclau==1999 & anac ==1999, detail;
sum aniscr if anaclau==1999 & anac ==1999&aniscr>4, detail;

* DESCRIZIONE DI CHI VA FUORI CORSO
see /cirm_data/fcdet9.dp for other descriptive stats
;

tab fc if aniscr==1;



tab female fc if aniscr==1, col;

tab outmil fc if aniscr==1, col;

gen topvoto = votodi==1;
tab topvoto fc if aniscr==1, col;

bysort fc: sum y if aniscr==1;
sum y if aniscr==1;


* generate dummy liceo from  tipo diploma;
gen typedip =  cod_tit_dipl ==1 ;

tab typedip fc if aniscr==1, col;

gen topvl = votolau>110;
tab topvl fc if aniscr==1, col;






********************************************
********************************************

NOSTRA ANALISI SU TASSE E FUORICORSO

;

* KEEP MEDIA PRIMO ANNO;
sort id anac;
qui by id: gen gpa_1 = gpa[1]; 


* SELEZIONE DEL CAMPIONE;
* keep studenti in corso regolare al 4 anno;
keep if real_status==4&aniscr==4&posizione==14 ;


* DESCRIZIONE DEGLI STUDENTI AL 4 ANNO;

tab fascia_teo fc, row;



tab aniscr posizione;


* VARIABILI NECESSARIE;

tab anac, gen(daa);

gen y2 = y*y;
gen y3 = y*y2;
gen y4 = y*y3;

label var y "Real income - thousands of Euros, base 2000";

tab fascia_teo, gen(dfa);

gen yd2 = yd*yd;
gen yd3 = yd2*yd;
gen yd4 = yd3*yd;

label var yd "Distance from nearest discontinuity in 1000 euros";




*DESCRIZIONE DEL SISTEMA DI TASSAZIONE;

gen sanac = anac-1990;


*INIZIO LOG OFF;




preserve;

collapse tteo sanac , by(anac y);
egen tteo95 = mean(tteo) if anac==1995, by(tteo);
label var tteo95 "tuition structure in 1995";
egen tteo02 = mean(tteo) if anac==2002, by(tteo);
label var tteo02 "tuition structure in 2002";

twoway line  tteo95 y ||line  tteo02  y, lpattern(--)
l1("Real tuition in thousands of Euros ") 
saving(fig_1, replace) title("Tuition as a function of real income")
;
*graph export fin_tteo.eps, replace logo(off);
graph export fig_1.eps, replace logo(off);

restore;




log close;






