*** probit AND NESTED probit REGRESSIONS ***


clear
clear matrix
clear mata
capture log close
set more on
set mem 300m
set matsize 800

#delimit ;

log using 3segment_class,replace;

use 3BcarinstDrop25, replace;
*use 3BcarinstDrop10, replace;

*0. VARIABLE DEFINITION;


*** Define the panel dimension of the dataset (model and yema);

egen yema=group(year ma);
xtset model yema;


*** Define additive dummies to control for market / year ;

tab year, gen (year);

*** Define trend ;
gen time=year-1997;

***** Linear;

gen time1=time*ma1;
gen time2=time*ma2;
gen time3=time*ma3;
gen time4=time*ma4;
gen time5=time*ma5;
gen time6=time*ma6;
gen time7=time*ma7;
gen time8=time*ma8;
gen time9=time*ma9;

***** Squared;

gen time21=time1^2;
gen time22=time2^2;
gen time23=time3^2;
gen time24=time4^2;
gen time25=time5^2;
gen time26=time6^2;
gen time27=time7^2;
gen time28=time8^2;
gen time29=time9^2;

***** Cubic;

gen time31=time1^3;
gen time32=time2^3;
gen time33=time3^3;
gen time34=time4^3;
gen time35=time5^3;
gen time36=time6^3;
gen time37=time7^3;
gen time38=time8^3;
gen time39=time9^3;

local characteristics "hp eurokm wi he";


***************************************************************;

*SUMSTATS;
gen ngdppop=eurongdp/pop;
gen locprice=princ*ngdppop;
gen eurprice=locprice;
replace eurprice=locprice/newexr if ma==4;

table year ma,c(mean ngdppop );
table year ma,c(mean eurprice);
table year ma,c(sum q);

table Fclass,c(mean hp mean li mean wi mean he);

forvalues x=1/7 {;
	
		forvalues y=1/7 {;
			qui gen Fclass`x'`y'=.;qui replace Fclass`x'`y'=0 if Fclass==`x';qui replace Fclass`x'`y'=1 if Fclass==`y';
			*probit Fclass`x'`y' hp li wi he ;
			*estat classification ;
        };
		};

probit Fclass12 hp eurokm wi he;
estat classification;
probit Fclass13 hp eurokm wi he;
estat classification;
probit Fclass14 hp eurokm wi he;
estat classification;
*probit Fclass15 hp eurokm wi he; *100% correct;
*estat classification;
probit Fclass16 hp eurokm wi he;
estat classification;
probit Fclass17 hp eurokm wi he;
estat classification;

probit Fclass23 hp eurokm wi he;
estat classification;

// PROBIT DOES NOT WORK! use logit instead
logit Fclass24 hp eurokm wi he;
estat classification;
probit Fclass25 hp eurokm wi he;
estat classification;
probit Fclass26 hp eurokm wi he;
estat classification;
probit Fclass27 hp eurokm wi he;
estat classification;


probit Fclass34 hp eurokm wi he;
estat classification;
probit Fclass35 hp eurokm wi he;
estat classification;
probit Fclass36 hp eurokm wi he;
estat classification;
probit Fclass37 hp eurokm wi he;
estat classification;

probit Fclass45 hp eurokm wi he;
estat classification;
probit Fclass46 hp eurokm wi he;
estat classification;
probit Fclass47 hp eurokm wi he;
estat classification;

probit Fclass56 hp eurokm wi he;
estat classification;
probit Fclass57 hp eurokm wi he;
estat classification;

probit Fclass67 hp eurokm wi he;
estat classification;


exit;

ttest hp if Fclass==1|Fclass==2,by(Fclass);
ttest hp if Fclass==2|Fclass==3,by(Fclass);
ttest hp if Fclass==3|Fclass==4,by(Fclass);
ttest hp if Fclass==4|Fclass==5,by(Fclass);
ttest hp if Fclass==5|Fclass==6,by(Fclass);
ttest hp if Fclass==6|Fclass==7,by(Fclass);

ttest li if Fclass==1|Fclass==2,by(Fclass);
ttest li if Fclass==2|Fclass==3,by(Fclass);
ttest li if Fclass==3|Fclass==4,by(Fclass);
ttest li if Fclass==4|Fclass==5,by(Fclass);
ttest li if Fclass==5|Fclass==6,by(Fclass);
ttest li if Fclass==6|Fclass==7,by(Fclass);


ttest wi if Fclass==1|Fclass==2,by(Fclass);
ttest wi if Fclass==2|Fclass==3,by(Fclass);
ttest wi if Fclass==3|Fclass==4,by(Fclass);
ttest wi if Fclass==4|Fclass==5,by(Fclass);
ttest wi if Fclass==5|Fclass==6,by(Fclass);
ttest wi if Fclass==6|Fclass==7,by(Fclass);

ttest he if Fclass==1|Fclass==2,by(Fclass);
ttest he if Fclass==2|Fclass==3,by(Fclass);
ttest he if Fclass==3|Fclass==4,by(Fclass);
ttest he if Fclass==4|Fclass==5,by(Fclass);
ttest he if Fclass==5|Fclass==6,by(Fclass);
ttest he if Fclass==6|Fclass==7,by(Fclass);


gggggg
***************************************************************;


*** 1. probit;

**** 1.1 - do not include i_nhome and if_nhome;

***************** 
old specification
*****************;

xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he if_num cpr) 
				hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe;
*  ELASTICITIES;

matrix B=e(b); 						
	*creates the matrix of coefficients (constant included);
gen alpha=B[1,1]; 					
	*coefficient of price;
gen ejj = alpha*(princ)*(1-sj);			
	*own-price elasticity: how market share sj varies with price pj;
gen ejk = (-1)*alpha*(princ)*sj; 			
	*cross-price elasticity: how market share sj varies with price pk;
	
sort Fclass; by Fclass: sum ejj ejk;
sum ejj ejk;
table Fclass ma if year==2006, c(mean ejj mean ejk);
table ma if year==2006, c(mean ejj);


drop alpha ejj ejk;

************************************ 
Nested probit instruments that I used
before and that do work with nested
probit but NOT with probit
elasticities too low
************************************;

**** 1.2 - probit with OLD nested probit instruments;

xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he if_num
						is_hp is_eurokm is_wi is_he is_num
						ids_hp ids_eurokm ids_wi ids_he ids_num
			 			cpr) 
				hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe;
				

**xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num if_hp if_eurokm if_wi if_he if_num is_hp is_eurokm is_wi is_he is_num ids_hp ids_eurokm ids_wi ids_he ids_num cpr) hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe;
**xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num if_hp if_eurokm if_wi if_he if_num ifs_hp ifs_eurokm ifs_wi ifs_he ifs_num ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num cpr) hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe;


*  ELASTICITIES;

matrix B=e(b); 						
	*creates the matrix of coefficients (constant included);
gen alpha=B[1,1]; 					
	*coefficient of price;
gen ejj = alpha*(princ)*(1-sj);			
	*own-price elasticity: how market share sj varies with price pj;
gen ejk = (-1)*alpha*(princ)*sj; 			
	*cross-price elasticity: how market share sj varies with price pk;
	
sort Fclass; by Fclass: sum ejj ejk;
sum ejj ejk;
table Fclass ma if year==2006, c(mean ejj);

table ma if year==2006, c(mean ejj);
drop alpha ejj ejk;




**** 1.3 - probit with FIRM market/segment/subsegment;

xtivreg lsj  (princ =   if_hp   if_eurokm   if_wi   if_he   if_num	
						ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
						ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
						cpr) 
				hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe;


*xtivreg lsj  (princ =  if_hp   if_eurokm   if_wi   if_he   if_num ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num cpr) hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe
*xtivreg2 lsj  (princ = if_hp   if_eurokm   if_wi   if_he   if_num ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num i_hp i_eurokm i_wi i_he i_num if_hp if_eurokm if_wi if_he if_num is_hp is_eurokm is_wi is_he is_num ids_hp ids_eurokm ids_wi ids_he ids_num cpr) hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe
*is_hp is_eurokm is_wi is_he is_num 
*xtivreg2 lsj  (princ = if_hp   if_eurokm   if_wi   if_he   if_num ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num i_hp i_eurokm i_wi i_he i_num if_hp if_eurokm if_wi if_he if_num ids_hp ids_eurokm ids_wi ids_he ids_num cpr) hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe
*xtivreg2 lsj  (princ = if_hp   if_eurokm   if_wi   if_he   if_num ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num ids_hp ids_eurokm ids_wi ids_he ids_num cpr) hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe

*  ELASTICITIES;

matrix B=e(b); 						
	*creates the matrix of coefficients (constant included);
gen alpha=B[1,1]; 					
	*coefficient of price;
gen ejj = alpha*(princ)*(1-sj);			
	*own-price elasticity: how market share sj varies with price pj;
gen ejk = (-1)*alpha*(princ)*sj; 			
	*cross-price elasticity: how market share sj varies with price pk;
	
sort Fclass; by Fclass: sum ejj ejk;
sum ejj ejk;
table Fclass ma if year==2006, c(mean ejj);

table ma if year==2006, c(mean ejj);
drop alpha ejj ejk;

**** 2.	TWO-LEVEL NESTED probit;

**** 1- without nhome instruments : it works (preferred option);

xtivreg lsj		(princ lsjdg lsdg = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									is_hp is_eurokm is_wi is_he is_num
									ids_hp ids_eurokm ids_wi ids_he ids_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe;

testparm lsjdg lsdg, equal;

* Elasticity;

		scalar alpha=_coef[princ];
		scalar sigmahg=_coef[lsjdg];
		scalar sigmag=_coef[lsdg];

		gen help1= ((1/(1-sigmahg)) - (1/(1-sigmag)));
		gen help2= (sigmag/(1-sigmag));

		gen ejj_2nl 	= 	alpha*(princ)*((1/(1-sigmahg))-(help1* sjdg) - (help2*sjg)-sj);
		gen ejk_2nl 	= 	(-1)*alpha*(princ)*((help1* sjdg) + (help2*sjg) + sj);
		gen ejk1_2nl 	= 	(-1)*alpha*(princ)* ((help2*sjg) + sj);
		gen ejk2_2nl 	= 	(-1)*alpha*(princ)* sj;

		sort Fclass;
		by Fclass: sum ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl if year==2006;
		sum ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl if year==2006;

		table Fclass ma if year==2006,c(mean ejj_2nl);
		table Fclass ,c(mean ejj_2nl);
		table ma if year==2006, c(mean ejj_2nl);
		drop help1 help2 ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl;

xtivreg lsj		(princ lsjdg lsdg = if_hp   if_eurokm   if_wi   if_he   if_num	
									ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
									ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe;
ffffffffff
*** Add cubic trend does not improve things;				
xtivreg lsj		(princ lsjdg lsdg = if_hp   if_eurokm   if_wi   if_he   if_num	
									ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
									ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 time31-time39 nhome, fe;

testparm lsjdg lsdg, equal;

* Elasticity;

		scalar alpha=_coef[princ];
		scalar sigmahg=_coef[lsjdg];
		scalar sigmag=_coef[lsdg];

		gen help1= ((1/(1-sigmahg)) - (1/(1-sigmag)));
		gen help2= (sigmag/(1-sigmag));

		gen ejj_2nl 	= 	alpha*(princ)*((1/(1-sigmahg))-(help1* sjdg) - (help2*sjg)-sj);
		gen ejk_2nl 	= 	(-1)*alpha*(princ)*((help1* sjdg) + (help2*sjg) + sj);
		gen ejk1_2nl 	= 	(-1)*alpha*(princ)* ((help2*sjg) + sj);
		gen ejk2_2nl 	= 	(-1)*alpha*(princ)* sj;

		sort Fclass;
		by Fclass: sum ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl if year==2006;
		sum ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl if year==2006;

		table Fclass ma if year==2006,c(mean ejj_2nl);
		table Fclass ,c(mean ejj_2nl);
		table ma if year==2006, c(mean ejj_2nl);
		drop help1 help2 ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl;


xtivreg2 lsj		(princ lsjdg lsdg = if_hp   if_eurokm   if_wi   if_he   if_num	
									ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
									ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, gmm fe;

testparm lsjdg lsdg, equal;

* Elasticity;

		scalar alpha=_coef[princ];
		scalar sigmahg=_coef[lsjdg];
		scalar sigmag=_coef[lsdg];

		gen help1= ((1/(1-sigmahg)) - (1/(1-sigmag)));
		gen help2= (sigmag/(1-sigmag));

		gen ejj_2nl 	= 	alpha*(princ)*((1/(1-sigmahg))-(help1* sjdg) - (help2*sjg)-sj);
		gen ejk_2nl 	= 	(-1)*alpha*(princ)*((help1* sjdg) + (help2*sjg) + sj);
		gen ejk1_2nl 	= 	(-1)*alpha*(princ)* ((help2*sjg) + sj);
		gen ejk2_2nl 	= 	(-1)*alpha*(princ)* sj;

		sort Fclass;
		by Fclass: sum ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl if year==2006;
		sum ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl if year==2006;

		table Fclass ma if year==2006,c(mean ejj_2nl);
		table Fclass ,c(mean ejj_2nl);
		table ma if year==2006, c(mean ejj_2nl);
		drop help1 help2 ejj_2nl ejk_2nl ejk1_2nl ejk2_2nl;

***********************************
Try with model group fixed effects
***********************************;

iis model_group;
tis yema;


xtivreg lsj		(princ = if_hp   if_eurokm   if_wi   if_he   if_num	
									ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
									ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe i(model_group);

xtivreg lsj		(princ lsjdg lsdg = if_hp   if_eurokm   if_wi   if_he   if_num	
									ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
									ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe i(model_group);

xtivreg lsj		(princ lsjdg lsdg = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									is_hp is_eurokm is_wi is_he is_num
									ids_hp ids_eurokm ids_wi ids_he ids_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe;
iis brand;
tis yema;

********************************************************
Try with brand fixed effects - different instrument sets
********************************************************
;
xtivreg lsj		(princ = if_hp   if_eurokm   if_wi   if_he   if_num	
						 ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
						 ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
						 cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe i(brand);

xtivreg lsj		(princ lsjdg lsdg = if_hp   if_eurokm   if_wi   if_he   if_num	
									ifs_hp  ifs_eurokm  ifs_wi  ifs_he  ifs_num
									ifds_hp ifds_eurokm ifds_wi ifds_he ifds_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe i(brand);

xtivreg lsj		(princ = i_hp i_eurokm i_wi i_he i_num 
						 if_hp if_eurokm if_wi if_he if_num
						 is_hp is_eurokm is_wi is_he is_num
						 ids_hp ids_eurokm ids_wi ids_he ids_num
						 cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe;				

xtivreg lsj		(princ lsjdg lsdg = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									is_hp is_eurokm is_wi is_he is_num
									ids_hp ids_eurokm ids_wi ids_he ids_num
									cpr )
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe;

testparm lsjdg lsdg, equal;

exit;
