# delim ; 
clear matrix;

***This code produces the results for 
**Information and Legislative Bargaining: The Political Economy of U.S. Tariff Suspensions* 
**Rodney D. Ludema, Anna Maria Mayda and Prachi Mishra
**CHANGE DIRECTORY ***;
cd "E:\annam\Desktop\AnnaPiuC\ludemamaydamishra\FINAL - SUB - RESTAT";

clear;
set mem 200m;
set more off;

log using tables_restat_FINAL_SUB, t replace;


gl cont0  "  	D_maj tariffrate  lsponsor_freq lnumberofcontactedfirms																	_Icongress*				";
gl cont1  "  				_Ihsection*";
gl cont2  "	 D_maj tariffrate  lsponsor_freq lnumberofcontactedfirms			 	lestimatedrevenueloss extension duplicative 	D_sponsor_comittee  _ID_sponsor*  	 		_Icongress* 	_IconXD_s* 		";


gl cont2b  "	 D_maj tariffrate  lsponsor_freq lnumberofcontactedfirms			 	lestimatedrevenueloss 	   	duplicative	D_sponsor_comittee  _ID_sponsor*   			_Icongress*	_IconXD_s* 		";;

gl cont2d  "	 D_maj tariffrate  lsponsor_freq lnumberofcontactedfirms				lestimatedrevenueloss extension duplicative 	D_sponsor_comittee   			D_sponsor_maj	_Icongress*				";


gl cont2c " lemployees_congress_proponent lemployees_congress_opponent ";


gl cont0ins  "    D_maj lsponsor_freq lnumberofcontactedfirms																	_Icongress*				";
gl cont2ins  "	  D_maj lsponsor_freq lnumberofcontactedfirms			 	lestimatedrevenueloss extension duplicative 	D_sponsor_comittee  _ID_sponsor*  	 		_Icongress* 	_IconXD_s* 		";




gl tt "cells( b(star fmt(%-9.3f)) se(fmt(%-9.3f) par( [ ] )) blank) stats (fsF fsF2 fsF3 fsF4 H N r2, fmt(%9.2f %9.0g)) style(fixed)";

cap program drop fsF;
        program define fsF, eclass;
        matrix a=e(first);
        matrix j=e(jp);
        eret2 scalar fsF=a[3,1];
        eret2 scalar fsF2=a[3,2];
        eret2 scalar fsF3=a[3,3];
		eret2 scalar fsF4=a[3,4];
        eret2 scalar H=j[1,1];
        matrix drop a;
        matrix drop j;
        
end;


****************************************************
***TABLE 1 -- SUMMARY STATS;

use regressionsdataset, replace;
xi i.congress*i.D_sponsor_democ i.hsection;
 reg  tariffreductiongranted   count_opp count_orgopp  D_trade_proponent_broad	$cont0	$cont1				, cl(prod2);
 sum tariffreductiongranted  D_opponent  D_trade_opponent_broad  D_trade_proponent_broad count_opp count_orgopp  $cont2 estimatedrevenueloss sponsor_freq numberofcontactedfirms if e(sample);

reg  tariffreductiongranted   count_opp str_opp str_prop 					$cont0	$cont1 				, cl(prod2); 
sum lobbyexp_specific_opponent llobbyexp_specific_opponent str_opp lobbyexp_specific_proponent llobbyexp_specific_proponent str_prop  if e(sample);

***summary stat

ivreg2  tariffreductiongranted    (count_opp count_orgopp  D_trade_proponent_broad	= 	 instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_opponent D_otherissues_proponent) 		$cont0	$cont1 		, ffirst cl(prod2) partial($cont1)		; fsF;	est sto ivstructuraldum1; 
sum numberofcontactedfirms  instrument_rod1_num instrument_rod2_num instrument_rod4_num  D_otherissues_opponent D_otherissues_proponent if e(sample);

ivreg2  tariffreductiongranted    (count_opp str_opp str_prop				= 	 instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent  )  		$cont1	$cont2	, ffirst cl(prod2) partial($cont1)		; fsF; 	est sto ivstructural2;
sum count_other_issues_proponent count_other_issues_opponent if e(sample);

gen D_opp_morethanone=count_opp>=2;
sum  D_opp_morethanone if D_opponent==1;
gen D_prop_morethanone=count_prop>=2;
sum  D_prop_morethanone;

****Figure 1 *****;
gen D_twomore_opp=count_opp>=2;
gen D_one=count_opp==1;
sum tariffreductiongranted if D_opponent==0;
sum tariffreductiongranted if D_one==1 & D_trade_opponent_broad==0;
sum tariffreductiongranted if D_twomore==1 & D_trade_opponent_broad==0;
sum tariffreductiongranted if D_trade_opponent_broad==1;


************************************
**Table 2: Determinants of Suspensions - Ordinary Least Squares;
use regressionsdataset, replace;
xi i.congress*i.D_sponsor_democ i.hsection;

 reg  tariffreductiongranted   count_opp count_orgopp  D_trade_proponent_broad		$cont0	$cont1			, cl(prod2); est sto structuraldum1;
 reg  tariffreductiongranted   count_opp count_orgopp  D_trade_proponent_broad		$cont1 $cont2  			, cl(prod2); est sto structuraldum2;
 reg  tariffreductiongranted   count_opp str_opp str_prop 							$cont0	$cont1 			, cl(prod2); est sto structural1;
 reg  tariffreductiongranted   count_opp str_opp str_prop 							$cont1	$cont2			, cl(prod2); est sto structural2;


*****************************************
***Table 3: Determinants of Suspensions - Instrumental Variables;
use regressionsdataset, replace;
xi i.congress*i.D_sponsor_democ i.hsection;
 ivreg2  tariffreductiongranted    (count_opp count_orgopp  D_trade_proponent_broad	= 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent) 		$cont0	$cont1 		, ffirst cl(prod2) partial($cont1)		; fsF;	est sto ivstructuraldum1; 
 ivreg2  tariffreductiongranted    (count_opp count_orgopp  D_trade_proponent_broad	=  	instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent) 		$cont1  $cont2 		, ffirst cl(prod2) partial($cont1)		; fsF;	est sto ivstructuraldum2;
 ivreg2  tariffreductiongranted    (count_opp str_opp str_prop				=  	instrument_rod2_num instrument_rod4_num  instrument_rod1_num count_other_issues_opponent count_other_issues_proponent  )  	$cont0 	$cont1		, ffirst cl(prod2) partial($cont1)		; fsF; 	est sto ivstructural1;
 ivreg2  tariffreductiongranted    (count_opp str_opp str_prop				= 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num count_other_issues_opponent count_other_issues_proponent  )  	$cont1	$cont2		, ffirst cl(prod2) partial($cont1)		; fsF; 	est sto ivstructural2;
test count_opp=str_opp;
test count_opp=str_prop;

********************************************
***TABLE  -- IV FIRST STAGES
 ivreg2  tariffreductiongranted    (count_opp count_orgopp  D_trade_proponent_broad	= 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent) 			$cont0	$cont1 		,ffirst cl(prod2) partial($cont1)		; 
 reg count_opp 			instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent 	$cont0  $cont1 if e(sample), cl(prod2); est sto fs1a;
 reg count_orgopp  		instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent 	$cont0  $cont1 if e(sample), cl(prod2); est sto fs1b;
 reg D_trade_proponent_broad	instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent 	$cont0 $cont1 if e(sample), cl(prod2); est sto fs1c;

 ivreg2  tariffreductiongranted    (count_opp count_orgopp  D_trade_proponent_broad	=  	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_opponent D_otherissues_proponent) 			$cont1  $cont2 		,ffirst cl(prod2) partial($cont1)		; 
 reg count_opp 			instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent  	$cont1 $cont2	if e(sample), cl(prod2); est sto fs2a;
 reg count_orgopp  		instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent 	$cont1 $cont2	if e(sample), cl(prod2); est sto fs2b;
 reg D_trade_proponent_broad	instrument_rod2_num instrument_rod4_num  instrument_rod1_num D_otherissues_opponent D_otherissues_proponent 	$cont1 $cont2	if e(sample), cl(prod2); est sto fs2c;

 ivreg2  tariffreductiongranted    (count_opp str_opp str_prop				=  	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent  )  		$cont0 	$cont1		,ffirst cl(prod2) partial($cont1)		; 
 reg count_opp 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent 	$cont0 $cont1 if e(sample), cl(prod2); est sto fs3a;
 reg str_opp 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent 	$cont0 $cont1 if e(sample), cl(prod2); est sto fs3b;
 reg str_prop	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent 	$cont0 $cont1 if e(sample), cl(prod2); est sto fs3c;

 ivreg2  tariffreductiongranted    (count_opp str_opp str_prop				= 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent  )  		$cont1	$cont2		,ffirst cl(prod2) partial($cont1)		; 
 reg count_opp 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent	$cont1 $cont2 if e(sample), cl(prod2); est sto fs4a;
 reg str_opp 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent	$cont1 $cont2 if e(sample), cl(prod2); est sto fs4b;
 reg str_prop	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent	$cont1 $cont2 if e(sample), cl(prod2); est sto fs4c;


********************************************
****Table 4: COLUMNS 1 AND 2: Lobbying + PAC Contributions. Determinants of Suspensions - IV with Broader Measures of Lobbying;

use regressionsdataset, replace;
rename D_trade_proponent_broad_incpac D_trade_proponent_incpac;
xi i.congress*i.D_sponsor_democ i.hsection;
 reg  tariffreductiongranted   count_opp count_orgopp_incpac  D_trade_proponent_incpac	$cont0	$cont1		, cl(prod2); 	est sto pac_structuraldum1;
 reg  tariffreductiongranted   count_opp count_orgopp_incpac  D_trade_proponent_incpac 	$cont1  $cont2		, cl(prod2); 	est sto pac_structuraldum2;
 reg  tariffreductiongranted   count_opp str_opp_pac str_prop_pac 						$cont0	$cont1		, cl(prod2); 	est sto pac_structural1;
 reg  tariffreductiongranted   count_opp str_opp_pac str_prop_pac 						$cont1	$cont2		, cl(prod2); 	est sto pac_structural2;

 ivreg2  tariffreductiongranted    (count_opp count_orgopp_incpac  D_trade_proponent_incpac= 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_opponent D_otherissues_proponent) 		$cont0 	$cont1		, ffirst cl(prod2) partial($cont1) ; 		fsF;	est sto pac_ivstructuraldum1; 
 ivreg2  tariffreductiongranted    (count_opp count_orgopp_incpac  D_trade_proponent_incpac= 	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_opponent D_otherissues_proponent) 		$cont1  $cont2 		, ffirst cl(prod2) partial($cont1) ;  	fsF;	est sto pac_ivstructuraldum2;
 ivreg2  tariffreductiongranted    (count_opp str_opp_pac str_prop_pac=				   	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent  )  	$cont0	$cont1		, ffirst cl(prod2) partial($cont1) ; 		fsF; 	est sto pac_ivstructural1;
 ivreg2  tariffreductiongranted    (count_opp str_opp_pac str_prop_pac=				   	instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_opponent count_other_issues_proponent  )  	$cont1  $cont2		, ffirst cl(prod2) partial($cont1) ;  	fsF; 	est sto pac_ivstructural2;

 ********************************************
****TABLE 4: COLUMNS 3 AND 4: Lobbying in Past, Present and Future Determinants of Suspensions - IV with Broader Measures of Lobbying;

use regressionsdataset, replace;
xi i.congress*i.D_sponsor_democ i.hsection;

 reg  tariffreductiongranted   count_opp count_orgopp_cpf  D_trade_prop_cpf_broad	$cont0	$cont1		, cl(prod2); 	est sto cpf_structuraldum1;
 reg  tariffreductiongranted   count_opp count_orgopp_cpf  D_trade_prop_cpf_broad	$cont1  $cont2		, cl(prod2); 	est sto cpf_structuraldum2;
 reg  tariffreductiongranted   count_opp str_opp_cpf str_prop_cpf 					$cont0	$cont1		, cl(prod2); 	est sto cpf_structural1;
 reg  tariffreductiongranted   count_opp str_opp_cpf str_prop_cpf 					$cont1	$cont2		, cl(prod2); 	est sto cpf_structural2;

 ivreg2  tariffreductiongranted    (count_opp count_orgopp_cpf  D_trade_prop_cpf_broad= instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_cpf_opp D_otherissues_cpf_prop) 		$cont0 $cont1		, ffirst cl(prod2) partial($cont1)			; fsF;	est sto cpf_ivstructuraldum1; 
 ivreg2  tariffreductiongranted    (count_opp count_orgopp_cpf  D_trade_prop_cpf_broad= instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_cpf_opp D_otherissues_cpf_prop) 		$cont1  $cont2 		, ffirst cl(prod2) partial($cont1)			; fsF;	est sto cpf_ivstructuraldum2;
 ivreg2  tariffreductiongranted    (count_opp str_opp_cpf str_prop_cpf=			instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_cpf_opp count_other_issues_cpf_prop ) 		$cont0 $cont1		, ffirst cl(prod2) partial($cont1)			; fsF; 	est sto cpf_ivstructural1;
 ivreg2  tariffreductiongranted    (count_opp str_opp_cpf str_prop_cpf=			instrument_rod2_num instrument_rod4_num  instrument_rod1_num  count_other_issues_cpf_opp count_other_issues_cpf_prop )  	$cont1  $cont2		, ffirst cl(prod2) partial($cont1)			; fsF; 	est sto cpf_ivstructural2;



 *****************************************
**Table 5: Determinants of Suspensions - Number and Size of Opponents ****************;

use regressionsdataset, replace;
xi i.congress*i.D_sponsor_democ i.hsection;
gen D_one=count_opp==1;
gen D_twoormore=count_opp>=2;

reg  tariffreductiongranted   D_one D_twoormore str_opp str_prop 					$cont1	$cont2		, cl(prod2); est sto spline4;
test D_one=D_twoormore;			
		
******************************DOES THE EFFECT VARY BY COMPUSTAT STATUS *****************;
***gen D_comp_prop= assets_congress_proponent~=. |  sales_congress_proponent~=. |  employees_congress_proponent~=.;
gen D_comp_opp= (assets_congress_opponent~=. |  sales_congress_opponent~=. |  employees_congress_opponent~=.) & 
(assets_congress_opponent~=1 |  sales_congress_opponent~=1 |  employees_congress_opponent~=1)
;

replace D_comp_opp=. if D_opponent==0;
tab D_comp_opp, m;


***gen D_comp=( D_comp_prop==1 &  D_comp_opp==1);
gen count_opp_big=count_opp*D_comp_opp;
replace count_opp_big=0 if D_comp_opp==.;

xi i.congress*i.D_sponsor_democ i.hsection;

reg  tariffreductiongranted   count_opp str_opp str_prop 								$cont1	$cont2  if D_comp_opp==0 | D_comp_opp==.				, cl(prod2); 	est sto nocomp4;
reg  tariffreductiongranted   count_opp str_opp str_prop 								$cont1	$cont2 	if D_comp_opp==1 | D_comp_opp==.				, cl(prod2); 	est sto comp4;



******************************DOES THE EFFECT VARY BY SIZE AMONG COMPUSTAT FIRMS*****************;

gen D_opp_size=D_opponent*ln(employees_congress_opponent);
replace D_opp_size=0 if D_opponent==0;


reg  tariffreductiongranted   D_opponent D_opp_size str_opp str_prop 								$cont1	$cont2 			, cl(prod2); 	est sto compsize4;


*****************************DOES THE EFFECT VARY BY COMPUSTAT STATUS -- INTERACTION *****************;
replace D_comp_opp=0 if D_comp_opp==.;
reg  tariffreductiongranted   count_opp count_opp_big D_comp_opp str_opp str_prop 								$cont1	$cont2		, cl(prod2); 	est sto compinter4;


***********************************************
***OUTPUT ALL RESULTS;


estout 			structuraldum1 structuraldum2 structural1 structural2
			using  table2_restat_final.xls, replace 
			keep( count_opp count_orgopp  D_trade_proponent_broad str_opp str_prop  $cont2) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table 2: Determinants of Suspensions - Ordinary Least Squares" );
						
						
estout 			ivstructuraldum1 ivstructuraldum2 ivstructural1 ivstructural2
			using  table3_restat_final.xls, replace 
			keep(count_opp count_orgopp  D_trade_proponent_broad str_opp str_prop) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table 3: Determinants of Suspensions - Instrumental Variables" );



estout 			pac_ivstructuraldum2 pac_ivstructural2 
			using  table4_restat_final.xls, replace 
			keep( count_opp count_orgopp_incpac  D_trade_proponent_incpac str_opp_pac str_prop_pac) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table  5-- Exemptions and Lobbying --INCLUDING PAC CONT" );


estout 			cpf_ivstructuraldum2 cpf_ivstructural2
			using  table4_restat_final.xls, append 
			keep( count_opp count_orgopp_cpf  D_trade_prop_cpf_broad str_opp_cpf str_prop_cpf) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table  6-- Exemptions and Lobbying -- BROAD MEASURE OF ORGANIZED" );

		


estout 		spline4	comp4 compsize4
		 
			using  table5_restat_final.xls, replace 
			keep( D_one D_twoormore count_opp  D_opp_size  D_opponent str_opp str_prop   ) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table 5: Determinants of Suspensions - Number and Size of Opponents" );
			
	

***********************************************
***OUTPUT THE RESULTS FOR ONLINE APPENDIX;
***********************************************;

estout 			ivstructuraldum1 ivstructuraldum2 ivstructural1 ivstructural2
			using  tableA1_restat_final.xls, replace 
			keep(count_opp count_orgopp  D_trade_proponent_broad str_opp str_prop  $cont2) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table A1 -- Determinants of Suspensions --Instrumental Variables Regressions" );
			


estout 			fs1a fs1b fs1c fs2a fs2b fs2c fs3a fs3b fs3c fs4a fs4b fs4c
			using  tableA2_iv_fs_restat_final.xls, replace 
			keep(  instrument_rod2_num instrument_rod4_num  instrument_rod1_num  D_otherissues_opponent D_otherissues_proponent  count_other_issues_opponent count_other_issues_proponent  $cont2) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table A2-- Determinants of Suspensions --First Stage Instrumental Variables Regressions" );
			
estout 			pac_structuraldum1 pac_structuraldum2 pac_structural1 pac_structural2  pac_ivstructuraldum1 pac_ivstructuraldum2 
			pac_ivstructural1 pac_ivstructural2 
			using  tableA3_restat_final.xls, replace 
			keep( count_opp count_orgopp_incpac  D_trade_proponent_incpac str_opp_pac str_prop_pac $cont2 ) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table A3 -- Determinants of Suspensions --Broad Measure of Organization I (including campaign contributions by Political Action Committees)" );


estout 			cpf_structuraldum1 cpf_structuraldum2 cpf_structural1 cpf_structural2  cpf_ivstructuraldum1 cpf_ivstructuraldum2 cpf_ivstructural1 cpf_ivstructural2
			using  tableA4_restat_final.xls, replace 
			keep( count_opp count_orgopp_cpf  D_trade_prop_cpf_broad str_opp_cpf str_prop_cpf $cont2) 
			$tt starlevel ("*" 0.10 "**" 0.05 "***" 0.01) 
			preh(" " "Table A4 --Determinants of Suspensions --Broad Measure of Organization II (inlcuding lobbying in past and future Congresses)" );

		
*****************************************************************************************************
** Figure A3. Scatter Plots between Lobbying Expenditures and Campaign Contributions from Political Action Committees (PACs) at the Firm Level ;
*****************************************************************************************************;

use  data_FigureA3_scatter, replace;

**Scatter plot between PAC cont and lobbying expenditures for trade and related issues ;


twoway (scatter    lgPACcont lglobbyexp_specific),  
	ytitle(PAC contributions by firms (in logs), size(small)) xtitle(Lobbying expenditures on trade and related issues by  firms (in logs), size(small));
graph save  PAC_trade_lobbying_firm, replace;



**OUTPUT THE CORRELATIONS;

reg lgPACcont lglobbyexp_specific, robust;
estimates store OLS2;

estout OLS2
	
		using  output_figures_notes.txt, replace preh(" " "FIGURE 4. PAC AND LOBBYING CORRELATIONS")
		keep(lglobbyexp_specific) 
		cells( b(star fmt(%-9.3f)) se(fmt(%-9.3f) par( [ ] )) blank) stats (N r2, fmt(%9.2f %9.0g)) 
		style(fixed) starlevel ("*" 0.10 "**" 0.05 "***" 0.01);

