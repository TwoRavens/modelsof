version 8.0
clear
set logtype t
set more off
set mem 50m
set matsize 800
cap log close

/*THIS FILE PRODUCES THE RESULTS OF DATA APPENDIX, TABLES A1 AND A2*/ 

log using appendix,replace t

#delimit;
u WE_Data1;

replace mu_R=mu_R-1;			/*Net returns because the instruments are net returns*/
replace mu_rbnd=mu_rbnd-1;
replace mu_rf=mu_rf-1;

/*************************FOR TABLE A1********************************/
gen south=A54+A55;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2008;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2008 & mu_R!=.;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2008 & mu_R==.;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2008 & mu_rf!=.;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2008 & mu_rf==.;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2010;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2010 & mu_H!=.;
sum eta sex yrsedu married ncomp employed pubblico self south c cn if anno==2010 & mu_H==.;

/*********************************************************************/

/*Drop ouliers (1%)*/
replace mu_R=. if mu_R<=-0.75 /*| mu_R>.15*/;
replace mu_rf=. if mu_rf<=-0.04 /*| mu_rf>=0.044*/;
replace mu_rbnd=. if mu_rbnd<=0 | mu_rbnd>=0.10;

gen Dexp1=mu_R!=.; replace Dexp1=. if anno==2010;
gen Dexp2=mu_rf!=.; replace Dexp2=. if anno==2010;

/********** COMPUTE REALIZATIONS: R10(1+R09)+R9 **********/

gen RR  = FTSE2010/100   *(1+FTSE2009/100)   +FTSE2009/100;
gen Rbnd= gbnds2010/100  *(1+gbnds2009/100)  +gbnds2009/100;
gen Rrf = bankdep2010/100*(1+bankdep2009/100)+bankdep2009/100;

/*For realized housing returns, I take 2010 SHIW prov/com avg changes in valabit/supab (over previous 2 yrs)*/
ren rH_prov rH_prov2; lab var rH_prov2 "Avg biennial (2009, 2010) return on housing, by iprov";
gen rH_prov=sqrt(rH_prov2+1)-1;
/******NOTA BENE che il rendimento e' il rendimento medio sul biennio/anno precedente!!!*/ 

gen RH = rH_prov*(1+rH_prov)+rH_prov;

/**********************************************************/

keep nq anno cn /*
*/ mu_H sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva rotaz x_cas /*
*/ lowcomp verored klima Dexp* /*
*/ mu_R FTSEm_l1-FTSEm_l6 x_bor FTSEmo* /*
*/ mu_rf bank_l1-bank_l6 x_int bankdep* /*
*/ mu_rbnd bonds_l1-bonds_l6 bonds* /*
*/ af af1-af3 ar ar1-ar3 R* sig*/*
*/ ncomp nperc np2 married employed pubblico self small Dpf;




/*************************FOR TABLE A2********************************/


/****** HOUSE RETURNS *****/
heckman mu_H sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
			*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva if rotaz==1 & x_cas==0, /*
			*/ select(lowcomp verored klima Dexp sex sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
			*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva) nolog twostep 

/****** FTSE *****/
heckman mu_R sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ FTSEm_l1 FTSEm_l2 FTSEm_l3 FTSEm_l4 FTSEm_l5 FTSEm_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva if x_bor==0, /*
			*/ select(lowcomp verored klima Dexp2 sex yrsedu whiteco eta A52-A55 com2-com4 lit Dnperc risfin risf2/*
			*/ Daf3 FTSEm_l1 FTSEm_l2 FTSEm_l3 FTSEm_l4 FTSEm_l5 FTSEm_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva) nolog twostep

/****** BANK DEPOSITS *****/
heckman mu_rf sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ bank_l1 bank_l2 bank_l3 bank_l4 bank_l5 bank_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva if x_int==0, /*
			*/ select(lowcomp verored klima Dexp1 sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2/*
			*/ Daf3 bank_l1 bank_l2 bank_l3 bank_l4 bank_l5 bank_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva) nolog twostep
			
/****** GOVERNMENT BONDS*****/
heckman mu_rbnd sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ bonds_l1 bonds_l2 bonds_l3 bonds_l4 bonds_l5 bonds_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva if x_int==0, /*
			*/ select(lowcomp verored klima Dexp1 sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2/*
			*/ Daf3 bonds_l1 bonds_l2 bonds_l3 bonds_l4 bonds_l5 bonds_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva) nolog twostep

log close
