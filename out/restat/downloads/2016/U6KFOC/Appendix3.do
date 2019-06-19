version 8.0
clear
cd c:\data\Expect\WE\
set logtype t
set more off
set mem 50m
set matsize 800
cap log close

/*THIS FILE PRODUCES THE RESULTS OF DATA APPENDIX, TABLES A7*/ 
/**** REGRESSIONS WITH TOTAL CONSUMPTION AS OPPOSED TO NONDURABLE CONSUMPTION ****/

log using appendix,replace t

#delimit;
u WE_Data1;

/*****  NB  *****/
gen cn_old=cn;
replace cn=c;
/****************/

replace mu_R=mu_R-1;			/*Net returns because the instruments are net returns*/
replace mu_rbnd=mu_rbnd-1;
replace mu_rf=mu_rf-1;

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

keep nq anno cn c/*
*/ mu_H sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva rotaz x_cas /*
*/ lowcomp verored klima Dexp* /*
*/ mu_R FTSEm_l1-FTSEm_l6 x_bor FTSEmo* /*
*/ mu_rf bank_l1-bank_l6 x_int bankdep* /*
*/ mu_rbnd bonds_l1-bonds_l6 bonds* /*
*/ af af1-af3 ar ar1-ar3 R* /*
*/ ncomp nperc np2 married employed pubblico self small Dpf;
sort nq anno; save databoot,replace;


#delimit cr
capture program drop weeffect
    program define weeffect
            version 7.0
				
			/******FIT H*****/
			qui	heckman mu_H sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
			*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva if rotaz==1 & x_cas==0, /*
			*/ select(lowcomp verored klima Dexp sex sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
			*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva) nolog twostep 

			predict mu_Hh_heck			/*Valabit is missing for a handful of households*/
										/*1ST FITTED REGRESSOR*/

			sort nq anno
			qui by nq: gen mu_H10=mu_H[_n+1]
			lab var mu_H10 "Expected return on housing in 2010 (for those in the panel)"
				
			/******FIT FTSE*****/
			gen x1=FTSEm_l1
			gen x2=FTSEm_l2
			gen x3=FTSEm_l3
			gen x4=FTSEm_l4
			gen x5=FTSEm_l5
			gen x6=FTSEm_l6

			qui heckman mu_R sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ FTSEm_l1 FTSEm_l2 FTSEm_l3 FTSEm_l4 FTSEm_l5 FTSEm_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva if x_bor==0, /*
			*/ select(lowcomp verored klima Dexp2 sex yrsedu whiteco eta A52-A55 com2-com4 lit Dnperc risfin risf2/*
			*/ Daf3 FTSEm_l1 FTSEm_l2 FTSEm_l3 FTSEm_l4 FTSEm_l5 FTSEm_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva) nolog twostep

			replace FTSEm_l1=FTSEmo12
			replace FTSEm_l2=FTSEmo11
			replace FTSEm_l3=FTSEmo10 
			replace FTSEm_l4=FTSEmo9
			replace FTSEm_l5=FTSEmo8
			replace FTSEm_l6=FTSEmo7
			predict mu_Rh_heck if x_bor==0 	/*2ND FITTED REGRESSOR*/

			replace FTSEm_l1=x1
			replace FTSEm_l2=x2
			replace FTSEm_l3=x3 
			replace FTSEm_l4=x4
			replace FTSEm_l5=x5
			replace FTSEm_l6=x6
			drop x1-x6

			/******FIT Bank deposits*****/
			gen x1=bank_l1
			gen x2=bank_l2
			gen x3=bank_l3
			gen x4=bank_l4
			gen x5=bank_l5
			gen x6=bank_l6

			qui heckman mu_rf sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ bank_l1 bank_l2 bank_l3 bank_l4 bank_l5 bank_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva if x_int==0, /*
			*/ select(lowcomp verored klima Dexp1 sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2/*
			*/ Daf3 bank_l1 bank_l2 bank_l3 bank_l4 bank_l5 bank_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva) nolog twostep

			replace bank_l1=bankdep12
			replace bank_l2=bankdep11
			replace bank_l3=bankdep10 
			replace bank_l4=bankdep9
			replace bank_l5=bankdep8
			replace bank_l6=bankdep7
			predict mu_rfh_heck if x_int==0 	/*3RD FITTED REGRESSOR*/

			replace bank_l1=x1
			replace bank_l2=x2
			replace bank_l3=x3 
			replace bank_l4=x4
			replace bank_l5=x5
			replace bank_l6=x6
			drop x1-x6
			
			/******FIT Government bonds*****/
			gen x1=bonds_l1
			gen x2=bonds_l2
			gen x3=bonds_l3
			gen x4=bonds_l4
			gen x5=bonds_l5
			gen x6=bonds_l6

			qui heckman mu_rbnd sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
			*/ bonds_l1 bonds_l2 bonds_l3 bonds_l4 bonds_l5 bonds_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva if x_int==0, /*
			*/ select(lowcomp verored klima Dexp1 sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2/*
			*/ Daf3 bonds_l1 bonds_l2 bonds_l3 bonds_l4 bonds_l5 bonds_l6 hprices06 hpr_ sport04 /*
			*/ trib_inef high_grw va2 avgva) nolog twostep

			replace bonds_l1=bonds12
			replace bonds_l2=bonds11
			replace bonds_l3=bonds10 
			replace bonds_l4=bonds9
			replace bonds_l5=bonds8
			replace bonds_l6=bonds7
			predict mu_rbndh_heck if x_int==0 	/*4TH FITTED REGRESSOR*/

			replace bonds_l1=x1
			replace bonds_l2=x2
			replace bonds_l3=x3 
			replace bonds_l4=x4
			replace bonds_l5=x5
			replace bonds_l6=x6
			drop x1-x6
			
			/**************************************************************************************/

			/********** COMPUTE (1+rho)E08(R09) (expectation)**********/
			#delimit;
			gen exp_R  =(1+0.4558194)*mu_R;
			gen exp_Rhk=(1+0.4558194)*mu_Rh_heck;

			gen exp_bnd  =(1+0.7531304)*mu_rbnd;
			gen exp_bndhk=(1+0.7531304)*mu_rbndh_heck;

			gen exp_rf  =(1+0.739289)*mu_rf;
			gen exp_rfhk=(1+0.739289)*mu_rfh_heck;

			gen exp_Hhk=2*mu_Hh_heck;

			/********NOW CONSTRUCT the regressors**********************/
			/*... unexpected shocks...*/
			gen unexp_af1  =af1*(Rrf-exp_rf);
			gen unexp_af1hk=af1*(Rrf-exp_rfhk);

			gen unexp_af2  =af2*(Rbnd-exp_bnd);		/*Many zeros for non-holders!*/
			gen unexp_af2hk=af2*(Rbnd-exp_bndhk);

			gen unexp_af3  =af3*(RR-exp_R);
			gen unexp_af3hk=af3*(RR-exp_Rhk);

			gen unexp_ar1hk=ar1*(RH-exp_Hhk);

			gen unexp_ar2  =ar2*(RR-exp_R);
			gen unexp_ar2hk=ar2*(RR-exp_Rhk);

			gen unexp_af  =unexp_af1+unexp_af2+unexp_af3;
			gen unexp_ar  =unexp_ar1hk+unexp_ar2;
			gen unexp_afar=unexp_af+unexp_ar;

			gen unexp_afhk=unexp_af1hk+unexp_af2hk+unexp_af3hk;
			gen unexp_arhk=unexp_ar1hk+unexp_ar2hk;
			gen unexp_afarhk=unexp_afhk+unexp_arhk;

			gen unexp_af12  = unexp_af1  +unexp_af2;
			gen unexp_af12hk= unexp_af1hk+unexp_af2hk;

			gen unexp_af3ar2  = unexp_af3  +unexp_ar2;
			gen unexp_af3ar2hk= unexp_af3hk+unexp_ar2hk;

			/* ... and anticipated changes */
			gen exp_af1  =af1*exp_rf;
			gen exp_af1hk=af1*exp_rfhk;

			gen exp_af2  =af2*exp_bnd;
			gen exp_af2hk=af2*exp_bndhk;

			gen exp_af3  =af3*exp_R;
			gen exp_af3hk=af3*exp_Rhk;

			gen exp_ar1hk=ar1*exp_Hhk;

			gen exp_ar2  =ar2*exp_R;
			gen exp_ar2hk=ar2*exp_Rhk;

			gen exp_af  =exp_af1+exp_af2+exp_af3;
			gen exp_ar  =exp_ar1hk+exp_ar2;
			gen exp_afar=exp_af+exp_ar;

			gen exp_afhk=exp_af1hk+exp_af2hk+exp_af3hk;
			gen exp_arhk=exp_ar1hk+exp_ar2hk;
			gen exp_afarhk=exp_afhk+exp_arhk;

			gen exp_af12 =exp_af1 +exp_af2;
			gen exp_af12hk=exp_af1hk+exp_af2hk;

			gen exp_af3ar2  = exp_af3  +exp_ar2;
			gen exp_af3ar2hk= exp_af3hk+exp_ar2hk;

			gen afar=af+ar;
			
			/*2008-2010 panel*/
			drop if (eta<20 | eta>80) & anno==2008;
			sort nq anno; qui by nq: gen N=_N; keep if N==2; drop N;

			sort nq anno; 
			qui by nq: gen delta_cn=(cn[_n+1]-cn)/1000;
			qui by nq: gen cngrw =(cn[_n+1]-cn)/cn;
			drop if cngrw<-0.5 | (cngrw>2 & cngrw!=.); drop cngrw;
			sort nq anno; qui by nq: gen N=_N; keep if N==2; drop N;

			/************************************************************************/
			/****                    WEALTH REGRESSIONS (TABLE A7)                ****/
			/************************************************************************/
			#delimit cr

			/*REGRESSIONS WITH EXPECTATIONS (Sample of respondents)*/
			/*ONE: af+ar*/
			reg delta_cn unexp_afar exp_afar eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
			*outreg unexp_afar exp_afar using table4, se 3aster replace
			
			/*Now, I must save the coefficients*/
			scalar def reg1=_b[unexp_afar]
			scalar def reg2=_b[exp_afar] 
					
			/*NOT INCLUDED IN THE APPENDIX: af12, af3, ar*/
			reg delta_cn unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
			*outreg unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar using table4, se 3aster append
			scalar def reg3=_b[unexp_af12]
			scalar def reg4=_b[exp_af12] 
			scalar def reg5=_b[unexp_af3]
			scalar def reg6=_b[exp_af3]
			scalar def reg7=_b[unexp_ar]
			scalar def reg8=_b[exp_ar]
			
			/*TWO: af, ar*/
			reg delta_cn unexp_af exp_af unexp_ar exp_ar eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
			*outreg unexp_af exp_af unexp_ar exp_ar using table4, se 3aster append
			scalar def reg9=_b[unexp_af]
			scalar def reg10=_b[exp_af]
			scalar def reg11=_b[unexp_ar]
			scalar def reg12=_b[exp_ar]


			/*REGRESSIONS WITH PREDICTIONS*/
			/*Sample of respondents*/
			/*THREE: af+ar*/
			reg delta_cn unexp_afarhk exp_afarhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
			*outreg unexp_afarhk exp_afarhk using table4, se 3aster append
			scalar def reg13=_b[unexp_afarhk]
			scalar def reg14=_b[exp_afarhk] 
			
			/*NOT INCLUDED IN THE APPENDIX: af12, af3, ar*/
			reg delta_cn unexp_af12hk exp_af12hk unexp_af3hk exp_af3hk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
			*outreg unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar using table4, se 3aster append
			scalar def reg15=_b[unexp_af12hk]
			scalar def reg16=_b[exp_af12hk] 
			scalar def reg17=_b[unexp_af3hk]
			scalar def reg18=_b[exp_af3hk]
			scalar def reg19=_b[unexp_arhk]
			scalar def reg20=_b[exp_arhk]

			/*FOUR: af, ar*/
			reg delta_cn unexp_afhk exp_afhk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
			*outreg unexp_af exp_af unexp_arhk exp_arhk using table4, se 3aster append
			scalar def reg21=_b[unexp_afhk]
			scalar def reg22=_b[exp_afhk]
			scalar def reg23=_b[unexp_arhk]
			scalar def reg24=_b[exp_arhk]
							
			/*Whole sample*/
			/*FIVE: af+ar*/
			reg delta_cn unexp_afarhk exp_afarhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & ar<1000 & af3<100, r
			*outreg unexp_afarhk exp_afarhk using table4, se 3aster append
			scalar def reg25=_b[unexp_afarhk]
			scalar def reg26=_b[exp_afarhk] 
			
			/*NOT INCLUDED IN THE APPENDIX:  af12, af3, ar*/
			reg delta_cn unexp_af12hk exp_af12hk unexp_af3hk exp_af3hk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & ar<1000 & af3<100, r
			*outreg unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar using table4, se 3aster append
			scalar def reg27=_b[unexp_af12hk]
			scalar def reg28=_b[exp_af12hk] 
			scalar def reg29=_b[unexp_af3hk]
			scalar def reg30=_b[exp_af3hk]
			scalar def reg31=_b[unexp_arhk]
			scalar def reg32=_b[exp_arhk]

			/*SIX: af, ar*/
			reg delta_cn unexp_afhk exp_afhk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
			*/ if afar>0 & ar<1000 & af3<100, r
			*outreg unexp_af exp_af unexp_arhk exp_arhk using table4, se 3aster append
			scalar def reg33=_b[unexp_afhk]
			scalar def reg34=_b[exp_afhk]
			scalar def reg35=_b[unexp_arhk]
			scalar def reg36=_b[exp_arhk]
			
end


set seed 171202
	u databoot,clear
	bsample
	*bsample, cluster(nquest) id(id) strata(panel)		/*HERE... WHAT?*/

	/*qui*/ weeffect		/*Run the estimation program*/
	
	#delimit;	
	matrix define results=	reg1\reg2\reg3\reg4\reg5\reg6\reg7\reg8\reg9\reg10\reg11\reg12\
	/*K x 1 matrix*/		reg13\reg14\reg15\reg16\reg17\reg18\reg19\reg20\reg21\reg22\reg23\reg24\
							reg25\reg26\reg27\reg28\reg29\reg30\reg31\reg32\reg33\reg34\reg35\reg36;
		
	#delimit cr
	svmat results		/*Creates a variable whose values coincide with the K elements (coefficients) of the matrix*/
	keep results
	keep if results!=.	/*WHY SHOULD THERE BE MISSING?*/
	gen repl=0	
	save rep,replace	/*Dataset of 2 variables (results and repl) and K obs*/

	
cap program drop doit
program def doit
	  local i=1
        while `i' < 1000 {
		u databoot,clear
		bsample
		*bsample, cluster(nquest) id(id) strata(panel)		/*HERE... WHAT?*/
		qui weeffect	/*Run the estimation program*/
		
		#delimit;	
	    matrix define results=	reg1\reg2\reg3\reg4\reg5\reg6\reg7\reg8\reg9\reg10\reg11\reg12\
								reg13\reg14\reg15\reg16\reg17\reg18\reg19\reg20\reg21\reg22\reg23\reg24\
								reg25\reg26\reg27\reg28\reg29\reg30\reg31\reg32\reg33\reg34\reg35\reg36;

		#delimit cr
		svmat results
		keep results
		keep if results!=.
		gen repl=`i'	/*Tracks the number of bootstrap, from 1 to 1000*/
		save rep`i',replace
		u rep,clear
		append using rep`i'
		erase rep`i'.dta
		save rep,replace		/*Dataset of 2 variables and K+iK obs*/
        local i=`i'+1
                }
end
qui doit

u rep,clear
replace repl=repl+1				/*From 1 to 1001*/
gen p=1
sort repl
qui by repl:replace p=sum(p)	/*Running sum of p, by repl (p goes from 1 to k coefficients)*/
ren results1 coeff
reshape wide coeff,i(repl) j(p)
compress
save rep,replace				/*K variables*/

/***************************************************************************************************/
/*Now I compute the P-VALUES!!!*/
/***************************************************************************************************/

u databoot,clear

/******FIT H*****/
qui	heckman mu_H sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva if rotaz==1 & x_cas==0, /*
*/ select(lowcomp verored klima Dexp sex sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ p_prov p_prov2 p_com2-p_com4 p_A5* impacq* manstra anposs anposq Danposs piubagni /*
*/ hprices06 hpr_sq sport04 high_grw trib_inef va2 avgva) nolog twostep 

predict mu_Hh_heck			/*Valabit is missing for a handful of households*/
										/*1ST FITTED REGRESSOR*/

sort nq anno
qui by nq: gen mu_H10=mu_H[_n+1]
lab var mu_H10 "Expected return on housing in 2010 (for those in the panel)"
				
/******FIT FTSE*****/
gen x1=FTSEm_l1
gen x2=FTSEm_l2
gen x3=FTSEm_l3
gen x4=FTSEm_l4
gen x5=FTSEm_l5
gen x6=FTSEm_l6

qui heckman mu_R sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ FTSEm_l1 FTSEm_l2 FTSEm_l3 FTSEm_l4 FTSEm_l5 FTSEm_l6 hprices06 hpr_ sport04 /*
*/ trib_inef high_grw va2 avgva if x_bor==0, /*
*/ select(lowcomp verored klima Dexp2 sex yrsedu whiteco eta A52-A55 com2-com4 lit Dnperc risfin risf2/*
*/ Daf3 FTSEm_l1 FTSEm_l2 FTSEm_l3 FTSEm_l4 FTSEm_l5 FTSEm_l6 hprices06 hpr_ sport04 /*
*/ trib_inef high_grw va2 avgva) nolog twostep

replace FTSEm_l1=FTSEmo12
replace FTSEm_l2=FTSEmo11
replace FTSEm_l3=FTSEmo10 
replace FTSEm_l4=FTSEmo9
replace FTSEm_l5=FTSEmo8
replace FTSEm_l6=FTSEmo7
predict mu_Rh_heck if x_bor==0 	/*2ND FITTED REGRESSOR*/

replace FTSEm_l1=x1
replace FTSEm_l2=x2
replace FTSEm_l3=x3 
replace FTSEm_l4=x4
replace FTSEm_l5=x5
replace FTSEm_l6=x6
drop x1-x6

/******FIT Bank deposits*****/
gen x1=bank_l1
gen x2=bank_l2
gen x3=bank_l3
gen x4=bank_l4
gen x5=bank_l5
gen x6=bank_l6

qui heckman mu_rf sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ bank_l1 bank_l2 bank_l3 bank_l4 bank_l5 bank_l6 hprices06 hpr_ sport04 /*
*/ trib_inef high_grw va2 avgva if x_int==0, /*
*/ select(lowcomp verored klima Dexp1 sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2/*
*/ Daf3 bank_l1 bank_l2 bank_l3 bank_l4 bank_l5 bank_l6 hprices06 hpr_ sport04 /*
*/ trib_inef high_grw va2 avgva) nolog twostep

replace bank_l1=bankdep12
replace bank_l2=bankdep11
replace bank_l3=bankdep10 
replace bank_l4=bankdep9
replace bank_l5=bankdep8
replace bank_l6=bankdep7
predict mu_rfh_heck if x_int==0 	/*3RD FITTED REGRESSOR*/

replace bank_l1=x1
replace bank_l2=x2
replace bank_l3=x3 
replace bank_l4=x4
replace bank_l5=x5
replace bank_l6=x6
drop x1-x6
			
/******FIT Government bonds*****/
gen x1=bonds_l1
gen x2=bonds_l2
gen x3=bonds_l3
gen x4=bonds_l4
gen x5=bonds_l5
gen x6=bonds_l6

qui heckman mu_rbnd sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2 Daf3 /*
*/ bonds_l1 bonds_l2 bonds_l3 bonds_l4 bonds_l5 bonds_l6 hprices06 hpr_ sport04 /*
*/ trib_inef high_grw va2 avgva if x_int==0, /*
*/ select(lowcomp verored klima Dexp1 sex yrsedu whiteco eta A52-A55 com2-com4 Dnperc lit risfin risf2/*
*/ Daf3 bonds_l1 bonds_l2 bonds_l3 bonds_l4 bonds_l5 bonds_l6 hprices06 hpr_ sport04 /*
*/ trib_inef high_grw va2 avgva) nolog twostep

replace bonds_l1=bonds12
replace bonds_l2=bonds11
replace bonds_l3=bonds10 
replace bonds_l4=bonds9
replace bonds_l5=bonds8
replace bonds_l6=bonds7
predict mu_rbndh_heck if x_int==0 	/*4TH FITTED REGRESSOR*/

replace bonds_l1=x1
replace bonds_l2=x2
replace bonds_l3=x3 
replace bonds_l4=x4
replace bonds_l5=x5
replace bonds_l6=x6
drop x1-x6
			
/**************************************************************************************/

/********** COMPUTE (1+rho)E08(R09) (expectation)**********/
#delimit;
gen exp_R  =(1+0.4558194)*mu_R;
gen exp_Rhk=(1+0.4558194)*mu_Rh_heck;

gen exp_bnd  =(1+0.7531304)*mu_rbnd;
gen exp_bndhk=(1+0.7531304)*mu_rbndh_heck;

gen exp_rf  =(1+0.739289)*mu_rf;
gen exp_rfhk=(1+0.739289)*mu_rfh_heck;

gen exp_Hhk=2*mu_Hh_heck;

/********NOW CONSTRUCT the regressors**********************/
/*... unexpected shocks...*/
gen unexp_af1  =af1*(Rrf-exp_rf);
gen unexp_af1hk=af1*(Rrf-exp_rfhk);

gen unexp_af2  =af2*(Rbnd-exp_bnd);		/*Many zeros for non-holders!*/
gen unexp_af2hk=af2*(Rbnd-exp_bndhk);

gen unexp_af3  =af3*(RR-exp_R);
gen unexp_af3hk=af3*(RR-exp_Rhk);

gen unexp_ar1hk=ar1*(RH-exp_Hhk);

gen unexp_ar2  =ar2*(RR-exp_R);
gen unexp_ar2hk=ar2*(RR-exp_Rhk);

gen unexp_af  =unexp_af1+unexp_af2+unexp_af3;
gen unexp_ar  =unexp_ar1hk+unexp_ar2;
gen unexp_afar=unexp_af+unexp_ar;

gen unexp_afhk=unexp_af1hk+unexp_af2hk+unexp_af3hk;
gen unexp_arhk=unexp_ar1hk+unexp_ar2hk;
gen unexp_afarhk=unexp_afhk+unexp_arhk;

gen unexp_af12  = unexp_af1  +unexp_af2;
gen unexp_af12hk= unexp_af1hk+unexp_af2hk;

gen unexp_af3ar2  = unexp_af3  +unexp_ar2;
gen unexp_af3ar2hk= unexp_af3hk+unexp_ar2hk;

/* ... and anticipated changes */
gen exp_af1  =af1*exp_rf;
gen exp_af1hk=af1*exp_rfhk;

gen exp_af2  =af2*exp_bnd;
gen exp_af2hk=af2*exp_bndhk;

gen exp_af3  =af3*exp_R;
gen exp_af3hk=af3*exp_Rhk;

gen exp_ar1hk=ar1*exp_Hhk;

gen exp_ar2  =ar2*exp_R;
gen exp_ar2hk=ar2*exp_Rhk;

gen exp_af  =exp_af1+exp_af2+exp_af3;
gen exp_ar  =exp_ar1hk+exp_ar2;
gen exp_afar=exp_af+exp_ar;

gen exp_afhk=exp_af1hk+exp_af2hk+exp_af3hk;
gen exp_arhk=exp_ar1hk+exp_ar2hk;
gen exp_afarhk=exp_afhk+exp_arhk;

gen exp_af12 =exp_af1 +exp_af2;
gen exp_af12hk=exp_af1hk+exp_af2hk;

gen exp_af3ar2  = exp_af3  +exp_ar2;
gen exp_af3ar2hk= exp_af3hk+exp_ar2hk;

gen afar=af+ar;
			
/*2008-2010 panel*/
drop if (eta<20 | eta>80) & anno==2008;
sort nq anno; qui by nq: gen N=_N; keep if N==2; drop N;

sort nq anno; 
qui by nq: gen delta_cn=(cn[_n+1]-cn)/1000;
qui by nq: gen cngrw =(cn[_n+1]-cn)/cn;
drop if cngrw<-0.5 | (cngrw>2 & cngrw!=.); drop cngrw;
			
sort nq anno; qui by nq: gen N=_N; keep if N==2; drop N;

/************************************************************************/
/****                    WEALTH REGRESSIONS (TABLE A7)                ****/
/************************************************************************/

#delimit cr

/*REGRESSIONS WITH EXPECTATIONS (Sample of respondents)*/
/*ONE: af+ar*/
reg delta_cn unexp_afar exp_afar eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
*outreg unexp_afar exp_afar using table4, se 3aster replace
			
/*Now, I must save the coefficients*/
			scalar def reg1=_b[unexp_afar]
			scalar def reg2=_b[exp_afar] 
					
/*NOT INCLUDED IN THE APPENDIX: af12, af3, ar*/
reg delta_cn unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
*outreg unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar using table4, se 3aster append
			scalar def reg3=_b[unexp_af12]
			scalar def reg4=_b[exp_af12] 
			scalar def reg5=_b[unexp_af3]
			scalar def reg6=_b[exp_af3]
			scalar def reg7=_b[unexp_ar]
			scalar def reg8=_b[exp_ar]
			
/*TWO: af, ar*/
reg delta_cn unexp_af exp_af unexp_ar exp_ar eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
*outreg unexp_af exp_af unexp_ar exp_ar using table4, se 3aster append
			scalar def reg9=_b[unexp_af]
			scalar def reg10=_b[exp_af]
			scalar def reg11=_b[unexp_ar]
			scalar def reg12=_b[exp_ar]


/*REGRESSIONS WITH PREDICTIONS*/
/*Sample of respondents*/
/*THREE: af+ar*/
reg delta_cn unexp_afarhk exp_afarhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
*outreg unexp_afarhk exp_afarhk using table4, se 3aster append
			scalar def reg13=_b[unexp_afarhk]
			scalar def reg14=_b[exp_afarhk] 
			
/*NOT INCLUDED IN THE APPENDIX; af12, af3, ar*/
reg delta_cn unexp_af12hk exp_af12hk unexp_af3hk exp_af3hk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
*outreg unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar using table4, se 3aster append
			scalar def reg15=_b[unexp_af12hk]
			scalar def reg16=_b[exp_af12hk] 
			scalar def reg17=_b[unexp_af3hk]
			scalar def reg18=_b[exp_af3hk]
			scalar def reg19=_b[unexp_arhk]
			scalar def reg20=_b[exp_arhk]

/*FOUR: af, ar*/
reg delta_cn unexp_afhk exp_afhk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & mu_R!=. & mu_rf!=. & afar<2000, r
*outreg unexp_af exp_af unexp_arhk exp_arhk using table4, se 3aster append
			scalar def reg21=_b[unexp_afhk]
			scalar def reg22=_b[exp_afhk]
			scalar def reg23=_b[unexp_arhk]
			scalar def reg24=_b[exp_arhk]
							
/*Whole sample*/
/*FIVE: af+ar*/
reg delta_cn unexp_afarhk exp_afarhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & ar<1000 & af3<100, r
*outreg unexp_afarhk exp_afarhk using table4, se 3aster append
			scalar def reg25=_b[unexp_afarhk]
			scalar def reg26=_b[exp_afarhk] 
			
/*NOT INCLUDED IN THE APPENDIX: af12, af3, ar*/
reg delta_cn unexp_af12hk exp_af12hk unexp_af3hk exp_af3hk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & ar<1000 & af3<100, r
*outreg unexp_af12 exp_af12 unexp_af3 exp_af3 unexp_ar exp_ar using table4, se 3aster append
			scalar def reg27=_b[unexp_af12hk]
			scalar def reg28=_b[exp_af12hk] 
			scalar def reg29=_b[unexp_af3hk]
			scalar def reg30=_b[exp_af3hk]
			scalar def reg31=_b[unexp_arhk]
			scalar def reg32=_b[exp_arhk]

/*SIX: af, ar*/
reg delta_cn unexp_afhk exp_afhk unexp_arhk exp_arhk eta yrsedu* sex ncomp nperc np2 married employed pubblico self A52-A55 small Dpf /*
*/ if afar>0 & ar<1000 & af3<100, r
*outreg unexp_af exp_af unexp_arhk exp_arhk using table4, se 3aster append
			scalar def reg33=_b[unexp_afhk]
			scalar def reg34=_b[exp_afhk]
			scalar def reg35=_b[unexp_arhk]
			scalar def reg36=_b[exp_arhk]

#delimit;	
matrix define true=	reg1\reg2\reg3\reg4\reg5\reg6\reg7\reg8\reg9\reg10\reg11\reg12\
/*K x 1 matrix*/		reg13\reg14\reg15\reg16\reg17\reg18\reg19\reg20\reg21\reg22\reg23\reg24\
						reg25\reg26\reg27\reg28\reg29\reg30\reg31\reg32\reg33\reg34\reg35\reg36;
		
#delimit cr
svmat true
keep true
keep if true!=.
gen repl=0	
gen p=1
sort repl
qui by repl:replace p=sum(p)
ren true coeff
reshape wide coeff,i(repl) j(p)
compress
save true,replace		/*TRUE COEFFICIENT ESTIMATES*/
*/

u rep,clear
append using true
erase true.dta

cap program drop doit
program def doit
	  local i=1
        while `i' < 37 {
		su coeff`i' if repl==0		/*True estimate*/
		scalar def true`i'=r(mean)
		su coeff`i' if repl!=0
		scalar def sd`i'=r(sd)
		scalar def t`i'=(true`i'/sd`i')
		gen tb`i'=(coeff`i'-true`i')/sd`i'
		count if tb`i'>=t`i'		/*Mi sembra che sia sempre 0!!!*/
		scalar def p`i'_up=(r(N)/(_N))
		count if tb`i'<=t`i'
		scalar def p`i'_lo=(r(N)/(_N))
		if p`i'_lo<p`i'_up	{
				scalar def pvalue`i'=2*p`i'_lo
						}
		if p`i'_lo>p`i'_up	{
				scalar def pvalue`i'=2*p`i'_up
						}
		scalar drop true`i' sd`i' t`i' p`i'_lo p`i'_up 
		drop tb`i'
        local i=`i'+1
                }
end
qui doit

#delimit;

scalar drop	reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 reg9 reg10 reg11 reg12 
			reg13 reg14 reg15 reg16 reg17 reg18 reg19 reg20 reg21 reg22 reg23 reg24
			reg25 reg26 reg27 reg28 reg29 reg30 reg31 reg32 reg33 reg34 reg35 reg36;
	
#delimit cr
scalar list 
save,replace

log close
clear

