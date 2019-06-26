*do file to replicate analyses in "Settlements, Outcomes, and the Recurrence of Conflict," by Quackenbush and Venteicher

#delimit ;
clear;
set memory 250m ;
set more off ;

use "U:\settlement and outcome\Quackenbush and Venteicher JPR replication data.dta", clear ;

*Table I crosstab ;

tab2 tabsettleraw taboutcmeraw if mid==1 & tabsettleraw!=4 & tabsettleraw!=-9 & unclearoutraw==0, chi2 row ;

*settlement only model - Model 1 (Table II, IV) and Model 5 (Table V) ;

stcox negot none mindem logrelpw logrpdif contigdi war midcount2 if unclearsettle==0, nohr cluster(dyadid) 
	scaledsch(sca*) schoenfeld(sch*) ;
estat phtest, rank detail ;
stcox negot none mindem logrelpw logrpdif contigdi war midcount2  demxlndmo powxlndmo pwdfxlndmo contigxlndmo 
	warxlndmo midcntxlndmo if unclearsettle==0, nohr cluster(dyadid) ;
drop sca* sch* ;

*outcome only model - Model 2 (Table II, IV) and Model 6 (Table V) ;

stcox decisive compromise mindem logrelpw logrpdif contigdi war midcount2 if unclearoutcme==0, nohr cluster(dyadid) 
	scaledsch(sca*) schoenfeld(sch*) ;
estat phtest, rank detail ;
stcox decisive compromise mindem logrelpw logrpdif contigdi war midcount2  compxlndmo demxlndmo powxlndmo pwdfxlndmo 
	contigxlndmo warxlndmo midcntxlndmo if unclearoutcme==0, nohr cluster(dyadid) ;
drop sca* sch* ;

*settlement and outcomes together model - Model 3 (Table II, IV) and Model 7 (Table V);

stcox negot none decisive compromise mindem logrelpw logrpdif contigdi war midcount2 if unclearsettle==0 & 
	unclearoutcme==0, nohr cluster(dyadid) scaledsch(sca*) schoenfeld(sch*) ;
estat phtest, rank detail ;
stcox negot none decisive compromise mindem logrelpw logrpdif contigdi war midcount2  compxlndmo demxlndmo powxlndmo 
	pwdfxlndmo contigxlndmo warxlndmo midcntxlndmo if unclearsettle==0 & unclearoutcme==0, nohr cluster(dyadid) ;
drop sca* sch* ;

*integrated model - Model 4 (Table III, IV) and Model 8 (Table III);

stcox impxdec negxdec nonexdec negxcomp mindem logrelpw logrpdif contigdi war midcount2 if unclearsettle==0 & 
	unclearoutcme==0, nohr cluster(dyadid) scaledsch(sca*) schoenfeld(sch*) ;
estat phtest, rank detail ;
stcox impxdec negxdec nonexdec negxcomp mindem logrelpw logrpdif contigdi war midcount2  negcompxlndmo demxlndmo powxlndmo 
	pwdfxlndmo contigxlndmo warxlndmo midcntxlndmo if unclearsettle==0 & unclearoutcme==0, nohr cluster(dyadid) ;
drop sca* sch* ;

* Figure 1 ;

drop basesurv ;
stcox impxdec negxdec nonexdec negxcomp mindem logrelpw logrpdif contigdi war midcount2  negcompxlndmo demxlndmo powxlndmo 
	pwdfxlndmo contigxlndmo warxlndmo midcntxlndmo if unclearsettle==0 & unclearoutcme==0, nohr cluster(dyadid) basesurv(basesurv) ;

stcurve, survival at1(impxdec=1 negxdec=0 nonexdec=0 negxcomp=0 negcompxlndmo=0) at2(impxdec=0 negxdec=1 nonexdec=0 negxcomp=0 negcompxlndmo=0) at3(impxdec=0 
  negxdec=0 nonexdec=1 negxcomp=0 negcompxlndmo=0) range(0 360) yscale(range(0 1)) ylabel(0(.25)1) legend(label(1 "Imposed/Decisive") label(2 "Negotiated/Decisive") 
  label(3 "None/Decisive")) xtitle(Duration in Months) scheme(sj) ;

* Multinomial logit analysis - Table VI ;

mlogit settleraw  decraw compraw  mindem contigdi relpow midcount2 territory hostlevraw if mid==1 & settleraw!=4 & 
	settleraw!=-9 & unclearoutraw==0, cluster(dyadid) ;
mlogit settleraw  decraw compraw  mindem contigdi relpow midcount2 territory hostlevraw if mid==1 & settleraw!=4 & 
	settleraw!=-9 & unclearoutraw==0, cluster(dyadid) base(2) ;



