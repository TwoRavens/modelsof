*** LOGIT AND NESTED LOGIT REGRESSIONS ***


clear
clear matrix
clear mata
capture log close
set more on
set mem 300m
set matsize 800

#delimit ;

log using 2est_drop25,replace;

use 3BcarinstDrop25, replace;

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


/*
gen is_num2=is_num-ids_num;


xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he
						is_num
									
						ids_num
					
			 			cpr lr)
						hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , fe;


xtivreg2 lsj		(princ lsjdg lsdg = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									
									is_num
									
									ids_num
									
									cpr)
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, gmm fe;
				
				exit;
*/;
				
*** 1. LOGIT;

*** Logit instruments;
xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he if_num
			 			cpr lr)
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


xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he if_num

			 			cpr lr)
						hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , gmm fe;
						
			
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


*** Nested Logit instruments;

xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he if_num
						is_hp is_eurokm is_wi is_he is_num
						ids_hp ids_eurokm ids_wi ids_he ids_num
			 			cpr lr)
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


xtivreg2 lsj  (princ =  i_hp i_eurokm i_wi i_he i_num 
						if_hp if_eurokm if_wi if_he if_num
						is_hp is_eurokm is_wi is_he is_num
						ids_hp ids_eurokm ids_wi ids_he ids_num
			 			cpr lr)
						hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome , gmm fe;
		
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


**** 2.	TWO-LEVEL NESTED LOGIT;


xtivreg lsj		(princ lsjdg lsdg = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									is_hp is_eurokm is_wi is_he is_num
									ids_hp ids_eurokm ids_wi ids_he ids_num
									cpr lr)
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, fe;
exit;
testparm lsjdg lsdg, equal;				
matrix V=get(VCE);
matrix list V;


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

xtivreg2 lsj		(princ lsjdg lsdg = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									is_hp is_eurokm is_wi is_he is_num
									ids_hp ids_eurokm ids_wi ids_he ids_num
									cpr lr)
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, gmm fe;

testparm lsjdg lsdg, equal;				

matrix V=get(VCE);
matrix list V;

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

*** Restrict sigmahg=sigmag	;	

gen restriction = lsjdg+lsdg;

xtivreg2 lsj		(princ  restriction = i_hp i_eurokm i_wi i_he i_num 
									if_hp if_eurokm if_wi if_he if_num
									is_hp is_eurokm is_wi is_he is_num
									ids_hp ids_eurokm ids_wi ids_he ids_num
									cpr lr)
			    hp eurokm wi he md1-md11 ma1-ma8 time1-time9 time21-time29 nhome, gmm fe;

matrix V=get(VCE);
matrix list V;

* Elasticity;

		scalar alpha=_coef[princ];
		scalar sigmahg=_coef[restriction];
		scalar sigmag=_coef[restriction];

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
		
		
