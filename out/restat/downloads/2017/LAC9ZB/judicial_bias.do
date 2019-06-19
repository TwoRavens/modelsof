
#delimit ; 

set mem 2g ; 
set matsize 5000 ; 

*ssc install ./cgmwildboot, replace ; 
*ssc install oaxaca, replace ; 
*ssc install carryforward, replace ; 
*ssc install graphexportpdf, replace ; 
*ssc install groups, replace ; 
*ssc install cmogram, replace ; 
*ssc install estout, replace ; 

global data     "put relevant path here" ; 

***********************************************************************; 
* This is to see if there are any duplicates in any given year of data ; 
*  - Only 1 duplicate case in 1998.	       	    	    	  ;  

program define dupes ; 

 use $data/ksfy`1'datademo ; 
  duplicates list id ; 
   clear ; 

 use $data/ksfy`1'data ; 
  duplicates list id ; 
   clear ; 

end ; 

/*
dupes 98 ; 
dupes 99 ; 
dupes 00 ; 
dupes 01 ; 
dupes 02 ; 
dupes 03 ; 
*/ 

*******************; 
* Demographic Data ; 

program define tabulations ;   

 use $data/ksfy`1'datademo ; 
  d ; 

  foreach x of varlist race gender ethnic { ; 
   tab `x' ; 
   tab `x', nolabel ; 
  } ; 

end ; 

/*
tabulations 98 ; 
tabulations 99 ; 
tabulations 00 ; 
tabulations 01 ; 
tabulations 02 ;  
tabulations 03 ; 
*/ 

************************************; 
* Sentencing-Case Data 		  ; 
*  - To construct a data dictionary ; 

program define case_tabs ; 

 use $data/ksfy`1'data ; 
   d ; 

  *tab judge ; 
  *tab judge, nolabel ; 

  *tab preoffen ; 
  *tab preoffen, nolabel ; 

  *foreach x of varlist counsel trial pretrial crimhist criobjet ifyes courtrul
   count0 purpose fel_misd pernper selvel drgndrg off_non presumpt sentimpo prisonmo
   lifer jaildays jailmo probatmo underpri guidline specrule speother
   postrel oldminum oldmaxum prob_to probcond corrcamp departur d_reasn1
   d_reasn2 d_reasn3 d_reasn4 d_reasn5 d_other procon1-procon13 pcother jailcrdt senbegda concons
   goodtime newtrial acquital addoff1 adcount1 offdate1 adchap1 adsect1
   adsub1_1 adsub1_2 adsub1_3 adpurp1 adf_m1 adp_n1 adlevel1 addnd1 adofno1
   adprest1 adsimpo1 adpmo1 adlifer1 adjday1 adjmo1 adprbmo1 adguide1 adrule1
   adrelmo1 adcccs1 addoff2 adcount2 adpurp2 adf_m2 adp_n2 adlevel2 addnd2
   adofno2 adprest2 adsimpo2 adpmo2 adlifer2 adjday2 adguide2 adrule2 adrelmo2
   adcccs2 addoff3 adcount3 adpurp3 adf_m3 adp_n3 adlevel3 addnd3 adofno3
   adprest3 adsimpo3 adpmo3 adjday3 adjmo3 adprbmo3 adguide3 adrule3 adrelmo3
   adcccs3 addoff4 adcount4 adpurp4 adf_m4 adp_n4 adlevel4 addnd4 adofno4
   adprest4 adsimpo4 adpmo4 adjday4 adjmo4 adprbmo4 adguide4 adrule4 adrelmo4
   adcccs4 addoff5 adcount5 adpurp5 adf_m5 adp_n5 adlevel5 addnd5 adofno5
   adprest5 adsimpo5 adprbmo5 adguide5 adrule5 adrelmo5 adcccs5 adtotal
   { ; 
   *tab `x' ; 
   *tab `x', nolabel ; 
  *} ;  

end ; 

********************************; 
* Sentencing-Case EXTENDED Data ;
*  - Additional years of data   ;  

program define case_tabs_ext ; 

 use $ext_data/ksfy`1'sentencingdata ; 
   d ; 

  *tab section ; 

  *tab preoffen ; 
  *tab preoffen, nolabel ; 

  *foreach x of varlist counsel trial pretrial crimhist criobjet courtrul
   count_ purpose fel_misd pernper selvel drgndrg off_non presumpt sentimpo
   lifer guidline specrule departur d_reasn1 d_reasn2 d_reasn3 d_reasn4
   d_reasn5 county judge county race ethnic gender
   { ; 
   *tab `x' ; 
   *tab `x', nolabel ; 
  *} ;  

end ; 

/*
case_tabs 98 ; 
case_tabs 99 ; 
case_tabs 00 ; 
case_tabs 01 ; 
case_tabs 02 ; 
case_tabs 03 ; 

case_tabs_ext 2004 ; 
case_tabs_ext 2005 ; 
case_tabs_ext 2006 ; 
case_tabs_ext 2007 ; 
case_tabs_ext 2008 ; 
case_tabs_ext 2009 ; 
case_tabs_ext 2010 ; 
case_tabs_ext 2011 ;  
endstata ;  
*/ 

******************************************************; 
* Merge the Demographic Files to the Sentencing Files ;
*  - This is for the 1998-2003 data. 		      ; 
*  - The 2004-2011 data includes demographic vars.    ;  

global vars "birthdat case0 counsel count0 county crimhist criobjet departur drgndrg ethnic fel_misd
	     gender guidline id judge kbi0 newtrial off_non offdate ori0 pernper preoffen
	     presumpt pretrial prisonmo probatmo race selvel senbegda sentdate sentimpo
  	     specrule speother trial underpri year adtotal chapter section procon1 procon2
	     addoff1 addoff2 addoff3 addoff4 addoff5 
	     adpmo1 adpmo2 adpmo3 adpmo4 adpmo5 adcccs1 adcccs2 adcccs3 adcccs4 adcccs5 concons cnslidat 
	     ct_cost fines restitut convicda" ; 

program define merge_data ; 
 
 clear ;  

 use $data/ksfy`1'datademo ; 
  sort id ; 
  
  tempfile demo ; 
  save "`demo'" ; 

 use $data/ksfy`1'data ; 
  sort id ; 
 
  merge id using `demo' ; 
   tab _merge ; 
    drop _merge ;

 gen year = 1900 + `1' ; 
  replace year = year + 100 if year < 1950 ; 
   tab year ; 

  keep $vars totalfee ;  

  save _`1', replace ; 
 
end ; 

********************************************************; 
* Create temporary 2004-2011 files so that I can append ; 
* then erase. 	   	     	      	     	 	; 

program define data_ext ; 

 clear ; 

  use $ext_data/ksfy20`1'sentencingdata ; 
   rename case_ case0 ; 
   rename count_ count0 ; 
   rename kbi_ kbi0 ; 
   rename ori_ ori0 ; 

   gen year = 2000 + `1' ; 
    tab year ; 

   if `1' < 5 { ; 
    keep $vars totalfee ;  
   } ; 

   else if `1' == 5 { ; 
    keep $vars probfee bids kbifee totalfee ;  
   } ; 

   else if `1' == 6 { ; 
    keep $vars probfee bids kbifee totlcost ;  
   } ; 
 
   else if `1' == 7 { ; 
    keep $vars t_doc t_jail t_undpri t_prbmon t_exprbm t_drgtrt t_pstrel totl_imp probfee bids kbifee totlcost ; 
   } ; 

   else if `1' == 8 { ; 
    keep $vars t_doc t_jail t_undpri t_contrl t_pstrel t_prbmon t_drgtrt t_crcamp t_other probfee bids kbifee totlcost ; 
   } ; 

   else { ; 
    keep $vars t_doc t_jail t_undpri t_prongt t_pstrel t_prbmon t_drgtrt t_crcamp t_exprbm t_other probfee bids kbifee totlcost ; 
   } ; 
   
   drop section ; 

   save _`1', replace ; 

end ; 

/*

*****************; 
* Merge the Data ; 

merge_data 98 ; 
merge_data 99 ; 
merge_data 00 ; 
merge_data 01 ; 
merge_data 02 ; 
merge_data 03 ; 

data_ext 04 ; 
data_ext 05 ; 
data_ext 06 ; 
data_ext 07 ; 
data_ext 08 ; 
data_ext 09 ; 
data_ext 10 ; 
data_ext 11 ;  

**********************; 
* Append the Datasets ; 

append using _98 _99 _00 _01 _02 _03 _04 _05 _06 _07 _08 _09 _10, force ; 
 save sentencing_data, replace ; 
  erase _98.dta ; 
  erase _99.dta ; 
  erase _00.dta ; 
  erase _01.dta ; 
  erase _02.dta ; 
  erase _03.dta ; 
  erase _04.dta ; 
  erase _05.dta ; 
  erase _06.dta ; 
  erase _07.dta ; 
  erase _08.dta ; 
  erase _09.dta ; 
  erase _10.dta ; 
  erase _11.dta ; 

tab year ; 
tab section ; 
d ; 

endstata ; 

*/ 

********************************************************************** ; 
********************************************************************** ; 
********************************************************************** ; 

*************************; 
* KANSAS SENTENCING DATA ; 

program define data_clean ; 

use sentencing_data ; 

d ; 

*******************************; 
* Fines, Court Costs, and Etc. ; 

/*
foreach x of varlist ct_cost fines restitut totalfee totlcost probfee bids kbifee { ; 
 by year, sort: su `x' ; 
} ; 
*/ 

*******************; 
* Roster of Judges ; 

tab judge ; 
tab judge, nolabel ; 

*********************; 
* Judicial Districts ; 

gen district = . ; 
 replace district = 1  if inlist(county,3,52) ;	                 * Atchison, Leavenworth ; 
 replace district = 2  if inlist(county,43,44,75,99) ;           * Jackson, Jefferson, Pottawatomie, Wabaunsee ; 
 replace district = 3  if inlist(county,89) ; 	                 * Shawnee ; 
 replace district = 4  if inlist(county,2,16,30,70) ;            * Anderson, Coffey, Franklin, Osage ; 
 replace district = 5  if inlist(county,9,56) ;                  * Chase, Lyon ; 
 replace district = 6  if inlist(county,6,54,61) ;               * Bourbon, Linn, Miami ; 
 replace district = 7  if inlist(county,23) ; 	          	 * Douglas ; 
 replace district = 8  if inlist(county,21,31,57,64) ;   	 * Dickinson, Geary, Marion, Morris ; 
 replace district = 9  if inlist(county,40,59) ;     	  	 * Harvey, McPherson ; 
 replace district = 10 if inlist(county,46) ; 	        	 * Johnson ; 
 replace district = 11 if inlist(county,11,19,50) ;     	 * Cherokee, Crawford, Labette ; 
 replace district = 12 if inlist(county,15,45,53,62,79,101) ;    * Cloud, Jewell, Lincoln, Mitchell, Republic, Washington ; 
 replace district = 13 if inlist(county,8,25,37) ; 	         * Butler, Elk, Greenwood ; 
 replace district = 14 if inlist(county,10,63) ;                 * Chautauqua, Montgomery ; 
 replace district = 15 if inlist(county,12,55,90,91,97,100,77) ; * Cheyenne, Logan, Sherman, Sheridan, Thomas, Wallace, Rawlins ; 
 replace district = 16 if inlist(county,13,17,29,35,60,49) ;     * Clark, Comanche, Ford, Gray, Meade, Kiowa ; 
 replace district = 17 if inlist(county,20,33,69,71,74,92) ;     * Decatur, Graham, Norton, Osborne, Phillips, Smith ;  
 replace district = 18 if inlist(county,87) ; 	           	 * Sedgwick ; 
 replace district = 19 if inlist(county,18) ; 	        	 * Cowley ; 
 replace district = 20 if inlist(county,5,27,80,84,93) ;         * Barton, Ellsworth, Rice, Russell, Stafford ; 
 replace district = 21 if inlist(county,14,81) ; 	         * Clay, Riley ; 
 replace district = 22 if inlist(county,7,22,58,66) ; 	         * Brown, Doniphan, Marshall, Nemaha ; 
 replace district = 23 if inlist(county,26,82,98) ; 	         * Ellis, Rooks, Trego ; 
 replace district = 24 if inlist(county,24,42,51,68,73,83) ;     * Edwards, Hodgeman, Lane, Ness, Pawnee, Rush ; 
 replace district = 25 if inlist(county,28,38,47,86,102,36) ;    * Finney, Hamilton, Kearny, Scott, Wichita, Greeley ; 
 replace district = 26 if inlist(county,34,41,65,88,94,95) ;     * Grant, Haskell, Morton, Seward, Stanton, Stevens ; 
 replace district = 27 if inlist(county,78) ; 	           	 * Reno ; 
 replace district = 28 if inlist(county,72,85) ; 	         * Ottawa, Salina ; 
 replace district = 29 if inlist(county,105) ; 	        	 * Wyandotte ; 
 replace district = 30 if inlist(county,4,39,48,76,96) ;         * Barber, Harper, Kingman, Pratt, Sumner ; 
 replace district = 31 if inlist(county,1,67,103,104) ;          * Allen, Neosho, Wilson, Woodson ; 

tab district ; 

**************************************************************************************************************************; 
* Off or Non-Grid Crimes												  ; 
*  - Examples of Off-Grid Crimes: Crimes of capital murder (K.S.A. 21-3439), murder in the first degree (K.S.A. 21-3401), ;
*    treason (K.S.A. 21-3801) and several specific sex offenses involving victims less than 14 years of age.		  ; 
*  - Examples of Non-Grid Crimes: Felony DUI, Felony Domestic Battery, and Animal Cruelty.     	     			  ;  
gen off_grid = 0 ; 
 replace off_grid = 1 if inlist(off_non,1,2) ; 
 
su off_grid ; 

*******************; 
* Criminal History ; 

tab crimhist year, col ; 

gen crimhist2 = . ; 
 replace crimhist2 = 1 if crimhist == "a" ; 
 replace crimhist2 = 2 if crimhist == "b" ; 
 replace crimhist2 = 3 if crimhist == "c" ; 
 replace crimhist2 = 4 if crimhist == "d" ; 
 replace crimhist2 = 5 if crimhist == "e" ; 
 replace crimhist2 = 6 if crimhist == "f" ; 
 replace crimhist2 = 7 if crimhist == "g" ; 
 replace crimhist2 = 8 if crimhist == "h" ; 
 replace crimhist2 = 9 if crimhist == "i" ; 

 drop crimhist ; 
 rename crimhist2 crimhist ; 

******************************************************************; 
* Dropping obs with missing Severity Levels or Criminal Histories ; 
* Most of these cases are Felony DUI and are sentenced off-grid.  ;
* Focus on cases that are sentenced via the grid.      		  ; 

gen R1 = 0 ; 
 replace R1 = 1 if selvel == . | crimhist == . ; 

tab off_grid R1 ; 

drop if R1 == 1 ; * RESTRICTION ; 

*************************************; 
* Race - Keep Only Blacks and Whites ; 
* Revision - Keep Hispanics as well. ;
*  - 11-29-2011.  	       	     ;  

tab race ;
tab race ethnic ; 

gen racegrp = . ; 
 replace racegrp = 1 if race == 1 & ethnic == 2 ; * Non-Hispanic Whites ; 
 replace racegrp = 2 if race == 2 & ethnic == 2 ; * Non-Hispanic Blacks ; 
 replace racegrp = 3 if      	    ethnic == 1 ; * Hispanics ; 

keep if inlist(racegrp,1,2,3) ; * RESTRICTION ; 

**************************; 
* Usual 0 and 1 variables ; 

gen unity = 1 ; 
gen zero  = 0 ; 

********************************************************************************;
* From Kunlun on judge's having variation in district:				;
* "Some district court judges recuse themselves if a conflict of		;
* interest exists (i.e., one party to an action is golfing buddies, party       ;
* helped with judge's retention campaign, spouse works for defendant company,   ;
* etc.) and neighboring judges from another district will hear the matter.      ;
* Not too frequent, but it does happen."     	     	       	   		;

sort judge ; 

by judge: gen f_judge = _n == 1 ; 

egen mode_district = mode(district), by(judge) ; 

gen i_out_of_dist = 0 ; 
 replace i_out_of_dist = 1 if district ~= mode_district ; 
 
drop district ; 
rename mode_district district ; 

egen avg_out_of_dist = mean(i_out_of_dist), by(judge) ; 

su avg_out_of_dist if f_judge == 1, d ; 

************************************************************** ; 
************************************************************** ; 
************************************************************** ; 

***************; 
* Offense Date ; 

gen off_day = day(offdate) ; 
gen off_yr  = year(offdate) ; 
gen off_mth = month(offdate) ; 

tab off_mth ; 

************************************************************** ; 
************************************************************** ; 
************************************************************** ; 

* Conviction Date ; 

/*
gen convic_day = day(convicda) ; 
gen convic_yr  = year(convicda) ; 
gen convic_mth = month(convicda) ; 

gen cdate = mdy(convic_mth,convic_day,convic_yr) ; 
*/ 

* Sentencing Dates ; 

gen sent_day = day(sentdate) ; 
gen sent_yr  = year(sentdate) ; 
gen sent_mth = month(sentdate) ; 

gen sdate = mdy(sent_mth,sent_day,sent_yr) ; 
tab sent_yr ; 

****************************************************************************; 
* OTHER Demographic & Sentencing Variables				    ; 
*  - Ask Kunlun why there are younger than 15 year olds in the data. 	    ; 
*  - It's because of extended jurisdiction juvenile prosecution. 	    ; 
*    "Under K.S.A. 2008 Supp. 38-2364(a), if an extended jurisdiction 	    ; 
*     juvenile prosecution results in a guilty plea or finding of guilt, the;
*     court shall; (1) impose one or more juvenile sentences under K.S.A.   ; 
*     2008 Supp. 38-2361 and, (2) impose an adult criminal sentence, the    ;
*     execution of which shall be stayed on the condition that the juvenile ; 
*     offender does not violate the provisions of the juvenile sentence and ;
*     does not commit a new offense. An adult felony Journal Entry of 	    ; 
*     Judgment must be completed for these cases."    	     	   	    ;

gen female = (gender == 2) ; 
 replace female = . if gender == . ; 

gen male   = (female == 0) ; 

gen age = (sentdate - birthdat)/365.25 ; 
 replace age = floor(age) ; 
 replace age = 15 if age < 15 ; 
  su age, d ; 
  tab age ; 

gen agegrp = . ; 
 replace agegrp = 1  if age >  0  & age < 15 ; 
 replace agegrp = 2  if age >= 15 & age < 18 ; 
 replace agegrp = 3  if age >= 18 & age < 21 ; 
 replace agegrp = 4  if age >= 21 & age < 24 ; 
 replace agegrp = 5  if age >= 24 & age < 27 ; 
 replace agegrp = 6  if age >= 27 & age < 30 ; 
 replace agegrp = 7  if age >= 30 & age < 33 ; 
 replace agegrp = 8  if age >= 33 & age < 36 ; 
 replace agegrp = 9  if age >= 36 & age < 39 ; 
 replace agegrp = 10 if age >= 39 & age < 42 ; 
 replace agegrp = 11 if age >= 42 & age < 45 ; 
 replace agegrp = 12 if age >= 45 & age < 48 ; 
 replace agegrp = 13 if age >= 48 & age < 51 ; 
 replace agegrp = 14 if age >= 51 & age < 54 ; 
 replace agegrp = 15 if age >= 54 & age < 57 ; 
 replace agegrp = 16 if age >= 57 & age < 60 ; 
 replace agegrp = 17 if age >= 60 & age < 63 ; 
 replace agegrp = 18 if age >= 63 & age < 50000 ; 

gen agegrp_wide = . ; 
 replace agegrp_wide = 1 if age > 0   & age < 25 ; 
 replace agegrp_wide = 2 if age >= 25 & age < 35 ; 
 replace agegrp_wide = 3 if age >= 35 & age < 45 ; 
 replace agegrp_wide = 4 if age >= 45 & age < 99999 ; 

gen brth_day = day(birthdat) ; 
gen brth_mth = month(birthdat) ; 
gen brth_yr  = year(birthdat) ; 
 
***********************************************************************; 
* Incarceration Rate						       ;
*  - Sentence Imposed: Mandatory D stands for Mandatory Drug Treatment ; 

tab year sentimpo ; 

gen incar = . ; 
 replace incar = 1 if sentimpo == 1 ; 
 replace incar = 0 if inlist(sentimpo,2,3,4,5,6) ; 

tab incar sentimpo ; 

****************************************; 
* Sentence Length (Prison or Probation) ; 
*  - Need total prison months. 		; 

gen sent_length = . ; 
 replace sent_length = prisonmo if incar == 1 ; 
 replace sent_length = probatmo if incar == 0 ; 

 su sent_length ; 

forvalues i = 1/5 { ; 
 gen adpfx`i' = 0 ; 
  replace adpfx`i' = adpmo`i' if adpmo`i' ~= . ; 
} ;

gen totprisonmo = . ; 
 replace totprisonmo = prisonmo + adpfx1*(adcccs1==2) + adpfx2*(adcccs2==2) + adpfx3*(adcccs3==2) + adpfx4*(adcccs4==2) + adpfx5*(adcccs5==2) ; 
 replace totprisonmo = . if incar == 0 ;       * Only 1 case of this ; 
 replace totprisonmo = . if totprisonmo == 0 ; * Less than a handful of cases like this ; 

 drop adpfx1-adpfx5 ; 

su prisonmo totprisonmo, d ; 

bysort sentimpo: su prisonmo probatmo ; 

tab presumpt ; 

gen log_prisonmo = ln(prisonmo) ; 
gen ltotprisonmo = ln(totprisonmo) ; 

**************************************************************************************; 
* Guideline Range Imposed: Standard (1), Aggravated (2), Mitigated (3), Departure (4) ; 

replace guidline = . if inlist(guidline,6,12,18,11) ; 

tab guidline, gen(guideline) ; 

**********************************; 
* Objections to Criminal History? ; 

tab year criobjet ; 
tab year criobjet, nolabel ; 

gen i_criobjet = 0 ; 
 replace i_criobjet = 1 if criobjet == 1 ; 

**************************; 
* Conditions to Probation ; 

gen eval_men = (procon1 == 3) ; 
gen eval_any = (procon1 >= 1 & procon1 <= 5) ; 

gen treatment = (procon2 >= 1 & procon2 <= 9) ; 

***********; 
* Pretrial ; 

tab year pretrial ; 
tab year pretrial, nolabel ; 

gen i_custody = . ; 
 replace i_custody = 0 if inlist(pretrial,2,3) ; 
 replace i_custody = 1 if inlist(pretrial,1) ; 

gen i_bond = . ; 
 replace i_bond = 0 if pretrial == 1 | pretrial == 3 ; 
 replace i_bond = 1 if pretrial == 2 ; 

gen i_release = (i_custody == 0) ; 

*****************************************************************; 
* Create an indicator variable for different types of departures ; 
*  - Downward durational (1)   	   	     	      		 ; 
*  - Downward dispositional (2) 				 ; 
*  - Upward durational (3)  					 ; 
*  - Upward dispositional (4) 					 ; 
*  - Postrelease supervision (5) 				 ; 
*  - Both down (6) 	     					 ; 
*  - Both up (7) 						 ; 
*  - Up and Down (8) 						 ; 

tab guidline departur ; 

tab departur, gen(departur) ; 

forvalues i = 1/8 { ; 
 *tab departur departur`i' ;  
  replace departur`i' = 0 if departur == . ; 
} ; 

egen i_departure = rowtotal(departur1-departur8), missing ;

tab i_departure ; 
tab departur black if (white == 1 | black == 1) & i_departure == 1, chi2 ; 
tab departur black if  white == 1 | black == 1, chi2 ; 
tab black ; 

su  i_departure ; 
tab i_departure ; 
tab i_departure departur ; 

rename departur1 dep_down_dura ; 
rename departur2 dep_down_disp ; 
rename departur3 dep_up_dura ; 
rename departur4 dep_up_disp ; 
rename departur5 dep_postrel ; 
rename departur6 dep_both_down ; 
rename departur7 dep_both_up ; 
rename departur8 dep_up_and_down ; 

****************************************; 
* Criminal History-Severity Level Cells ; 

egen crim_sev_cell = group(drgndrg selvel crimhist) ; 

********************************************************************; 
* Type of Counsel: Appointed (1), Retained (2), Self (3), Other (4) ; 

tab counsel ; 
*replace counsel = . if inlist(counsel,11,25) ; 
 replace counsel = 4 if inlist(counsel,5,6,11,25) ; 

qui tab counsel, gen(counsel) ; 
 rename counsel1 publ_counsel ; 
 rename counsel2 priv_counsel ; 
 rename counsel3 self_counsel ;
 rename counsel4 othe_counsel ;  

*********************************************************; 
* Person or Non-Person Crime: Person (1), Non-Person (2) ; 

tab pernper, gen(person) ; 
 rename person1 person ; 
 rename person2 non_person ; 

tab person drgndrg ; 

*************************************; 
* Special Sentencing Rules           ;
*  - LEO --> Law Enforcement Officer ;  
 
gen special_rule = . ; 
 replace special_rule = 1  if specrule == 1 ;					  * Person Felony Committed with a Firearm ; 
 replace special_rule = 2  if specrule == 2 ;   	      	       		  * Aggravated Battery LEO ; 
 replace special_rule = 3  if specrule == 3 ;   		       		  * Aggravated Assault LEO ; 
 replace special_rule = 4  if specrule == 4 ;   		       	 	  * Crime Committed for Benefit of Criminal Gang ; 
 replace special_rule = 5  if specrule == 5  & year <= 1999 ;          	          * Felony DUI ; 
 replace special_rule = 5  if specrule == 6  & year >= 2000 ;			  * Felony DUI ; 
 replace special_rule = 6  if specrule == 7  & year <= 1999 ;			  * Felony Domestic Battery ; 
 replace special_rule = 6  if specrule == 8  & year >= 2000 ;     	 	  * Felony Domestic Battery ; 
 replace special_rule = 7  if specrule == 8  & year <= 1999 ;     	 	  * Crime Committed While On Probation or Parole ; 
 replace special_rule = 7  if specrule == 9  & year >= 2000 ;     		  * Crime Committed While On Probation or Parole ; 
 replace special_rule = 8  if specrule == 5  & year >= 2000 ;     		  * Persistent Sex Offender (Not a category in 1998-99) ; 
 replace special_rule = 9  if specrule == 10 & year >= 2000 ;     	     	  * Crime Committed While on Felony Bond (Not a category in 1998-99) ; 
 replace special_rule = 10 if inlist(specrule,9,10) & year <= 1999 ;   		  * Other ; 
 replace special_rule = 10 if (specrule > 10 & specrule < 100)  & year >= 2000 ;  * Other ; 

tab specrule 	 if year == 2011 ; 
tab special_rule if year == 2011 ; 

tab special_rule, gen(spec_rule) ; 

tab special_rule black, chi2 ; 

qui su special_rule, d ; 
 local smax = r(max) ; 

forvalues i = 1(1)`smax' { ; 
 replace spec_rule`i' = 0 if special_rule == . ; 
} ; 

egen i_spec_rule = rowtotal(spec_rule1-spec_rule`smax'), missing ;
 tab i_spec_rule ;  

gen no_spec_rule = (i_spec_rule == 0) ; 

gen excl_sr1_10 = 1 ; 
 replace excl_sr1_10 = 0 if inlist(special_rule,1,10) ; 

***************************************************; 
* Special Rules, 2004-2011 Data		           ;
*  - sr1 Person Felony Comitted With a Firearm     ; 
*  - sr2 Aggravated Battery LEO        	           ; 
*  - sr3 Aggravated Assault LEO		           ; 
*  - sr4 Crime Committed for Benefit of Criminal   ;
*  - sr5 Persistent Sex Offender     		   ; 
*  - sr6 Felony DUI 				   ; 
*  - sr7 Felony Domestic Battery		   ; 
*  - sr8 Crime Committed While on Probation, par   ; 
*  - sr9 Crime Committed While on Felony Bond	   ; 
*  - sr10 Extended Juvenile Jurisdiction Imposed   ;	  
*  - sr11 Resident Burglary with a Prior Resid, No ;	  
*  - sr12 Second Forgery    	      	    	   ;	  
*  - sr13 Third Or Subsequent Forgery		   ; 
*  - sr14 Other	   	      			   ; 

gen sr = specrule ; 
 replace sr = 99 if inlist(specrule,7,12,14,15,18,21,24,26,27,28,29,31,32,34,35) ; 

tab specrule if year == 2011 ; 
tab sr, gen(sr) ; 

forvalues i = 1(1)14 { ; 
 replace sr`i' = 0 if sr == . ; 
 replace sr`i' = . if year >= 1930 & year <= 2003 ; 
} ; 

**********************************************************; 
* Type of Trial: Bench (1), Jury (2), Plea (3), Other (4) ; 
*  - Nolo Contendere Plea: a defendant does not accept or ; 
*    deny responsibility for the charges but agrees to 	  ; 
*    accept punishment.      	 	     	    	  ; 

gen trial_type = . ; 
 replace trial_type = 1 if trial == 1 ;		  * Bench Trial ; 
 replace trial_type = 2 if trial == 2 ;		  * Jury Trial ; 
 replace trial_type = 3 if inlist(trial,3,4) ;	  * Plea and No Contest Plea ; 
 replace trial_type = 4 if inlist(trial,13,63) ;  * Other ; 
  tab trial_type, gen(trial) ; 

 tab trial_type sentimpo ; 

 rename trial1 bench ; 
 rename trial2 jury ; 
 rename trial3 plea ; 
 rename trial4 trial_other ; 

 gen non_plea = (plea == 0) ; 

*************************************************; 
* Drug or Non-Drug Crime: Non-Drug (1), Drug (2) ; 

tab drgndrg, gen(drug_crime) ; 

count if drgndrg == . ; 

rename drug_crime1 ndc ; 
rename drug_crime2  dc ; 

***************; 
* Total Counts ; 

rename count0 counts ; 
 su counts, d ;

gen counts1  = (counts == 1) ; 
gen countsp11 = (counts > 1) ; 

*******************************************************; 
* Primary Offense of Conviction (i.e. Type of Crime)   ;  
*  - See the Data Dictionary for preoffen codes.       ; 

* Crime Type ; 

gen ct_murder  = (preoffen >= 28 & preoffen <= 35 | inlist(preoffen,63,3501,3502,3503,6302,6306,9006)) ; 
gen ct_assault = (inlist(preoffen,37,38)) ; 
gen ct_battery = ((preoffen >= 40 & preoffen <= 50) | preoffen == 4002) ;
gen ct_crimthr = (inlist(preoffen,51,303)) ; 
gen ct_kidnapp = (inlist(preoffen,52,53,5201,5202,5203)) ; 
gen ct_robbery = (inlist(preoffen,56,57)) ; 
gen ct_sexcrim = ((preoffen >= 65 & preoffen <= 82) | (preoffen >= 85 & preoffen <= 90) | (preoffen >= 414 & preoffen <= 418) | inlist(preoffen,9001,9002,9003,9008,420,421)) ;  
gen ct_aggburg = (preoffen == 120) ; 
gen ct_arson   = (inlist(preoffen,124,125)) ; 
gen ct_crimwea = ((preoffen >= 183 & preoffen <= 185) | (preoffen >= 191 & preoffen <= 193) | (preoffen >= 288 & preoffen <= 293)) ;
gen ct_forgery = (preoffen == 105) ; 
gen ct_theft0  = (preoffen == 113) ; * Theft between 1 and 25k ; 

egen ct_violent = rowtotal(ct_*) ; 

sort preoffen ; 
egen cell_count = total(unity), by(preoffen) ; 

*******************************************; 
* Presumptive or Guideline Sentence Length ; 

gen gsent = . ; 
 replace gsent = 620 if selvel == 1 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 586 if selvel == 1 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 272 if selvel == 1 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 253 if selvel == 1 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 234 if selvel == 1 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 214 if selvel == 1 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 195 if selvel == 1 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 176 if selvel == 1 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 155 if selvel == 1 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 467 if selvel == 2 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 438 if selvel == 2 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 205 if selvel == 2 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 190 if selvel == 2 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 174 if selvel == 2 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 160 if selvel == 2 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 146 if selvel == 2 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 131 if selvel == 2 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 117 if selvel == 2 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 233 if selvel == 3 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 216 if selvel == 3 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 102 if selvel == 3 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 94 if selvel == 3 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 88 if selvel == 3 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 79 if selvel == 3 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 72 if selvel == 3 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 66 if selvel == 3 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 59 if selvel == 3 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 162 if selvel == 4 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 154 if selvel == 4 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 71 if selvel == 4 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 66 if selvel == 4 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 60 if selvel == 4 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 56 if selvel == 4 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 50 if selvel == 4 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 45 if selvel == 4 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 41 if selvel == 4 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 130 if selvel == 5 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 120 if selvel == 5 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 57 if selvel == 5 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 52 if selvel == 5 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 49 if selvel == 5 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 44 if selvel == 5 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 41 if selvel == 5 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 36 if selvel == 5 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 32 if selvel == 5 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 43 if selvel == 6 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 39 if selvel == 6 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 36 if selvel == 6 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 34 if selvel == 6 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 30 if selvel == 6 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 27 if selvel == 6 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 24 if selvel == 6 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 20 if selvel == 6 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 18 if selvel == 6 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 32 if selvel == 7 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 29 if selvel == 7 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 27 if selvel == 7 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 24 if selvel == 7 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 21 if selvel == 7 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 18 if selvel == 7 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 16 if selvel == 7 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 13 if selvel == 7 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 12 if selvel == 7 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 21 if selvel == 8 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 19 if selvel == 8 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 18 if selvel == 8 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 16 if selvel == 8 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 14 if selvel == 8 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 12 if selvel == 8 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 10 if selvel == 8 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 10 if selvel == 8 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 8 if selvel == 8 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 16 if selvel == 9 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 14 if selvel == 9 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 12 if selvel == 9 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 12 if selvel == 9 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 10 if selvel == 9 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 9 if selvel == 9 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 8 if selvel == 9 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 7 if selvel == 9 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 6 if selvel == 9 & crimhist == 9 & drgndrg == 1 ;
 replace gsent = 12 if selvel == 10 & crimhist == 1 & drgndrg == 1 ;
 replace gsent = 11 if selvel == 10 & crimhist == 2 & drgndrg == 1 ;
 replace gsent = 10 if selvel == 10 & crimhist == 3 & drgndrg == 1 ;
 replace gsent = 9 if selvel == 10 & crimhist == 4 & drgndrg == 1 ;
 replace gsent = 8 if selvel == 10 & crimhist == 5 & drgndrg == 1 ;
 replace gsent = 7 if selvel == 10 & crimhist == 6 & drgndrg == 1 ;
 replace gsent = 6 if selvel == 10 & crimhist == 7 & drgndrg == 1 ;
 replace gsent = 6 if selvel == 10 & crimhist == 8 & drgndrg == 1 ;
 replace gsent = 6 if selvel == 10 & crimhist == 9 & drgndrg == 1 ;

 replace gsent = 194 if selvel == 1 & crimhist == 1 & drgndrg == 2 ;
 replace gsent = 186 if selvel == 1 & crimhist == 2 & drgndrg == 2 ;
 replace gsent = 178 if selvel == 1 & crimhist == 3 & drgndrg == 2 ;
 replace gsent = 170 if selvel == 1 & crimhist == 4 & drgndrg == 2 ;
 replace gsent = 162 if selvel == 1 & crimhist == 5 & drgndrg == 2 ;
 replace gsent = 158 if selvel == 1 & crimhist == 6 & drgndrg == 2 ;
 replace gsent = 154 if selvel == 1 & crimhist == 7 & drgndrg == 2 ;
 replace gsent = 150 if selvel == 1 & crimhist == 8 & drgndrg == 2 ;
 replace gsent = 146 if selvel == 1 & crimhist == 9 & drgndrg == 2 ;
 replace gsent = 78 if selvel == 2 & crimhist == 1 & drgndrg == 2 ;
 replace gsent = 73 if selvel == 2 & crimhist == 2 & drgndrg == 2 ;
 replace gsent = 68 if selvel == 2 & crimhist == 3 & drgndrg == 2 ; 
 replace gsent = 64 if selvel == 2 & crimhist == 4 & drgndrg == 2 ;
 replace gsent = 59 if selvel == 2 & crimhist == 5 & drgndrg == 2 ;
 replace gsent = 56 if selvel == 2 & crimhist == 6 & drgndrg == 2 ;
 replace gsent = 54 if selvel == 2 & crimhist == 7 & drgndrg == 2 ;
 replace gsent = 51 if selvel == 2 & crimhist == 8 & drgndrg == 2 ;
 replace gsent = 49 if selvel == 2 & crimhist == 9 & drgndrg == 2 ;
 replace gsent = 49 if selvel == 3 & crimhist == 1 & drgndrg == 2 ; 
 replace gsent = 44 if selvel == 3 & crimhist == 2 & drgndrg == 2 ;
 replace gsent = 40 if selvel == 3 & crimhist == 3 & drgndrg == 2 ;
 replace gsent = 34 if selvel == 3 & crimhist == 4 & drgndrg == 2 ;
 replace gsent = 30 if selvel == 3 & crimhist == 5 & drgndrg == 2 ;
 replace gsent = 24 if selvel == 3 & crimhist == 6 & drgndrg == 2 ;
 replace gsent = 22 if selvel == 3 & crimhist == 7 & drgndrg == 2 ; 
 replace gsent = 18 if selvel == 3 & crimhist == 8 & drgndrg == 2 ;
 replace gsent = 15 if selvel == 3 & crimhist == 9 & drgndrg == 2 ;
 replace gsent = 40 if selvel == 4 & crimhist == 1 & drgndrg == 2 ;
 replace gsent = 34 if selvel == 4 & crimhist == 2 & drgndrg == 2 ; 
 replace gsent = 30 if selvel == 4 & crimhist == 3 & drgndrg == 2 ;
 replace gsent = 24 if selvel == 4 & crimhist == 4 & drgndrg == 2 ;
 replace gsent = 20 if selvel == 4 & crimhist == 5 & drgndrg == 2 ;
 replace gsent = 17 if selvel == 4 & crimhist == 6 & drgndrg == 2 ;
 replace gsent = 15 if selvel == 4 & crimhist == 7 & drgndrg == 2 ;
 replace gsent = 13 if selvel == 4 & crimhist == 8 & drgndrg == 2 ;
 replace gsent = 11 if selvel == 4 & crimhist == 9 & drgndrg == 2 ;

gen gsent_sq  = gsent*gsent ; 
gen gsent_ndc = gsent*ndc ; 
gen gsent_dc  = gsent*dc ; 

*************************************************; 
* KBI Numbers - these identify individual felons ; 
*  - Missing for a large fraction of obs. 	      ; 

gen miss_kbi = (kbi0 == .) ; 
 tab miss_kbi ; 

by district, sort: su miss_kbi ; 
by year, sort: su miss_kbi ; 

************************************************************** ; 
************************************************************** ; 
************************************************************** ; 

***********************************************************************; 
* Change the ordering of criminal history and severity levels so that  ; 
* the low values represent the low severity levels and 'good' criminal ; 
* histories. 	  	    	    	     	    	       	       ; 

gen crimhist_dep = (crimhist - 10)*-1 ; 
gen ch_ndc       = (crimhist - 10)*-1 if drgndrg == 1 ;
gen ch_dc        = (crimhist - 10)*-1 if drgndrg == 2 ;

gen sev_ndc = (selvel - 11)*-1 if drgndrg == 1 ; 
gen sev_dc  = (selvel - 5)*-1  if drgndrg == 2 ;   

gen sev_dep = (selvel - 11)*-1 ; 
 tab sev_dep selvel ; 

************************************************************** ; 
************************************************************** ; 
************************************************************** ; 

save sent_clean, replace ; 

end ; 

/*
data_clean ; 
endstata ; 
*/ 

*************************************************************************************************** ; 
*************************************************************************************************** ; 
*************************************************************************************************** ; 

**************************; 
* KEY SUMMARY STATISTICS	; 

program define ro_data_prep ; 

 use sent_clean, clear ; 

 **************; 
 * RESTRICTION ; 

 drop if hispa == 1 ;

 ***************************************************; 
 * Judge level descriptives (i.e. # of cases, etc.) ; 

 sort district judge year ; 
 
 by district	      , sort: gen f_d   = (_n == 1) ;  
 by district judge     , sort: gen f_dj  = (_n == 1) ; 
 by district judge year, sort: gen f_djt = (_n == 1) ; 
 
 egen num_cases_jt  = total(unity), by(district judge year) ; 
 egen num_cases_j   = total(unity), by(district judge) ; 

 egen num_yrs_jx    = count(year) if f_djt == 1, by(district judge) ; 
 egen num_yrs_j     = mode(num_yrs_jx)	    , by(district judge) ; 

 egen num_blk_j     = total(black), by(district judge) ; 
 egen num_whi_j     = total(white), by(district judge) ; 

 tab num_yrs_j if f_dj == 1 ; 
 tab district  if f_dj == 1 & num_yrs_j == 14 ; 

 su district ; 
  local Nd = r(max) ; 

 ***********************************************************; 
 * RESTRICTION						; 

 keep if inlist(num_yrs_j,10,11,12,13,14) ; 
 keep if inlist(district,3,10,18,29) ; 
 drop if judge == 192 | judge == 83 ; * Pro tem Judge ; 

 drop f_d f_dj f_djt ; 

 by district	      , sort: gen f_d   = (_n == 1) ;  
 by district judge     , sort: gen f_dj  = (_n == 1) ; 
 by district judge year, sort: gen f_djt = (_n == 1) ; 

 sort district judge sent_yr ; 
 list district judge sent_yr num_cases_j if f_dj == 1 ; 
 su num_cases_j if f_dj == 1, d ; 

 *****************************************; 
 * Table 1: Judicial Caseload by District ; 

 by district, sort: su num_cases_j if f_dj == 1, d ; 
 by district, sort: su num_blk_j   if f_dj == 1, d ; 
 by district, sort: su num_whi_j   if f_dj == 1, d ; 

 save ro_data, replace ;  

end ; 

/*
ro_data_prep ; 
endstata ;    
*/ 

*************************************************************************************************** ; 
*************************************************************************************************** ; 
*************************************************************************************************** ; 

******************************************; 
* Table 2: Descriptive Statistics By Race ; 

program define cell_gaps ;

 use ro_data, clear ; 

 qui reg black age ; 
  outreg2 using cell_gaps, se replace excel bdec(3) ;

 local xs  "gsent female age agegrp counts person i_spec_rule priv_counsel plea selvel crimhist " ;  
 local dx  "incar totprisonmo probatmo age female gsent sev_ndc ch_ndc sev_dc ch_dc counts person dc i_spec_rule priv_counsel plea " ; 

egen miss = rowmiss(`xs') ; 
  tab miss ; 
  drop if miss > 0 ; 

 foreach y of varlist `dx' { ; 
  qui reg `y' black ; 
    outreg2 using cell_gaps, se append excel bdec(3) ;

  qui reg `y' white ; 
    outreg2 using cell_gaps, se append excel bdec(3) ;

  qui reg `y' ; 
    outreg2 using cell_gaps, se append excel bdec(3) ;
 } ; 

end ; 

/*
cell_gaps ; 
endstata ; 
*/ 

*************************************************************************************************** ; 
*************************************************************************************************** ; 
*************************************************************************************************** ; 

*****************************************************************; 
* Figure 6: Distribution of Presumptive Sentence Length (Topeka) ; 

program define balance ; 

use ro_data, clear ; 

gen lgsent = log(gsent) ; 

local r "if district == 3 & ndc == 1" ; 

kdensity lgsent `r', lcolor(maroon) lwidth(thin) addplot(kdensity lgsent `r' & judge == 4,   lcolor(black) lpattern(longdash_dot) ||
					 	         kdensity lgsent `r' & judge == 35,  lcolor(gs2)   lpattern(dash)         || 
	 	      	       	         		 kdensity lgsent `r' & judge == 45,  lcolor(gs4)   lpattern(dot)          ||
					 		 kdensity lgsent `r' & judge == 104, lcolor(gs6)   lpattern(dash_dot)     ||
					 		 kdensity lgsent `r' & judge == 139, lcolor(gs8)   lpattern(shortdash)    ||
					 		 kdensity lgsent `r' & judge == 174, lcolor(gs10)  lpattern(longdash)) 
					  ylabel(, nogrid) ytitle("") xtitle("Log(Presumptive Sentence Length)") title("")  
					  legend(order(1 "Overall" 2 "A" 3 "B" 4 "C" 5 "D" 6 "E" 7 "F") symxsize(*.5) rows(1)) ; 
  graph save gden, replace ; 
  graph use gden ; 
  graphexportpdf gden, dropeps ; 

end ; 

*ro_data_prep ; 
 balance ; 
 endstata ; 

*************************************************************************************************** ; 
*************************************************************************************************** ; 
*************************************************************************************************** ; 

*************************; 
* Rank-Order Descriptive ; 

program define ro_race ; 

 **************************************************; 
 * Read in only variables we need - save some time ; 
 
 local vars "incar drug_crime non_drug_crime dc ndc district judge female agegrp agegrp1-agegrp4 agegrp_wide1-agegrp_wide4 counts person i_spec_rule priv_counsel plea 
       	     i_selvel1-i_selvel10 crimhist1-crimhist8 black white selvel crimhist racegrp num_cases_j yrfx1-yrfx14 gsent gsent_ndc unity year num_ndrug_j" ; 

 *****************************; 
 * Read in data + RESTRICTION ; 

 use `vars' if `1' == 1		   & inlist(district,3,10,18,29) using ro_data, clear ;   
*use `vars' if non_drug_crime == 1 & inlist(district,3,10,18,29) using ro_data, clear ;   
*use `vars' if 	       	      	     inlist(district,3,10,18,29) using ro_data, clear ;   

 *****************************; 
 * District-Specific Judge ID ; 

 sort district judge ;
  egen judgeid     = group(district judge) ;
  egen min_judgeid = min(judgeid), by(district) ;
   qui su judgeid ;
    local Nj = r(max) ;
 
*drop f_dj ; 
 by district judge, sort: gen f_dj = _n == 1 ; 

  list district judgeid min_judgeid if f_dj == 1, clean noobs compress ;

  replace judgeid = judgeid - min_judgeid + 1 ;

  list district judgeid min_judgeid if f_dj == 1, clean noobs compress ;

 ************************************; 
 * Judge-Specific Black IR, White IR ; 

 local xs  "female agegrp2-agegrp4	     counts person i_spec_rule priv_counsel plea i_selvel1-i_selvel10 crimhist1-crimhist8" ;  
 local xs0 "female agegrp_wide2-agegrp_wide4 counts person i_spec_rule priv_counsel plea c.gsent##i.ndc      i.year ib0.black##ib1.judgeid" ;  
 local xs1 "female agegrp_wide2-agegrp_wide4 counts person i_spec_rule priv_counsel plea c.gsent##i.ndc	     i.year ib0.white##ib1.judgeid" ;  
 local xs2 "female agegrp_wide2-agegrp_wide4 counts person i_spec_rule priv_counsel plea c.gsent##i.ndc	     i.year" ;  

 gen b_ir      = 0 ; 
 gen w_ir      = 0 ; 
 gen bw_ir     = 0 ; 
 gen wgt_b_ir  = 0 ; 
 gen wgt_w_ir  = 0 ; 
 gen wgt_bw_ir = 0 ; 
 
 **********************; 
 * Number of Districts ; 
 
 egen did = group(district) ; 
  su did ; 
   local Nd = r(max) ; 

 tab district did ; 

 ***************************************; 
 * Estimate w and b incarceration rates ; 

*foreach i of numlist 3 10 18 29 { ; 
 forvalues i = 1/`Nd' { ; 
 *forvalues i = 1/1 { ; 
  
  qui su judgeid if did == `i' ;
   local Nj_d`i' = r(max) ;
  
 *qui reg incar `xs0' if did == `i' ; 
      reg incar `xs0' if did == `i' ; 
   forvalues k = 2(1)`Nj_d`i'' { ; 
    replace w_ir  = _b[`k'.judgeid]		       if did == `i' & judgeid  == `k' ; 
    replace bw_ir = _b[1.black#`k'.judgeid]    	       if did == `i' & judgeid  == `k' ; 

    replace wgt_w_ir  = 1/(_se[`k'.judgeid]^2)	       if did == `i' & judgeid  == `k' ; 
    replace wgt_bw_ir = 1/(_se[1.black#`k'.judgeid]^2) if did == `i' & judgeid  == `k' ; 
   } ; 

  qui reg incar `xs1' if did == `i' ; 
   forvalues k = 2(1)`Nj_d`i'' { ; 
    replace b_ir     = _b[`k'.judgeid]	      if did == `i' & judgeid  == `k' ; 
    replace wgt_b_ir = 1/(_se[`k'.judgeid]^2) if did == `i' & judgeid  == `k' ; 
   } ; 

 } ; 

 ************************; 
 * Assign Judicial Ranks ; 

 egen rank_wir = rank(w_ir) if f_dj == 1, by(did) ;
 egen rank_w   = max(rank_wir), by(did judge) ; 
  tab rank_w, gen(rw) ; 
 
 egen rank_bir = rank(b_ir) if f_dj == 1, by(did) ; 
 egen rank_b   = max(rank_bir), by(did judge) ; 
  tab rank_b, gen(rb) ; 

 *******************************************; 
 * Graph the Ranks for Descriptive Evidence ; 
 * Figure 7: Rank-Order Violations by Race  ; 

 twoway scatter rank_w rank_b if f_dj == 1 & district == 3, msymbol(circle) mcolor(black) xlabel(1(1)6) ylabel(1(1)6, nogrid) 
   	   	      		     	       ytitle("White IR Rank") xtitle("Black IR Rank" " " "(a) Topeka") legend(off) || 
	function y = x 	      if f_dj == 1, range(0 6) lwidth(vthin) lcolor(blue) ;  
  graph save rank_d3.gph, replace ; 
  graph use rank_d3 ; 
  graphexportpdf rank_d3 ; 

 twoway scatter rank_w rank_b if f_dj == 1 & district == 10, msymbol(circle) mcolor(black) xlabel(1(1)6) ylabel(1(1)6, nogrid) 
   	   	      		     	       ytitle("White IR Rank") xtitle("Black IR Rank" " " "(b) Overland Park") legend(off) || 
	function y = x 	      if f_dj == 1, range(0 6) lwidth(vthin) lcolor(blue) ;  
  graph save rank_d10.gph, replace ; 
  graph use rank_d10 ; 
  graphexportpdf rank_d10 ; 

 twoway scatter rank_w rank_b if f_dj == 1 & district == 18, msymbol(circle) mcolor(black) xlabel(1(1)13) ylabel(1(1)13, nogrid) 
   	   	      		     	       ytitle("White IR Rank") xtitle("Black IR Rank" " " "(c) Wichita") legend(off) || 
	function y = x 	      if f_dj == 1, range(0 13) lwidth(vthin) lcolor(blue) ;  
  graph save rank_d18.gph, replace ; 
  graph use rank_d18 ; 
  graphexportpdf rank_d18 ; 

 twoway scatter rank_w rank_b if f_dj == 1 & district == 29, msymbol(circle) mcolor(black) xlabel(1(1)9) ylabel(1(1)9, nogrid) 
   	   	      		     	       ytitle("White IR Rank") xtitle("Black IR Rank" " " "(d) Kansas City") legend(off) || 
	function y = x 	      if f_dj == 1, range(0 9) lwidth(vthin) lcolor(blue) ;  
  graph save rank_d29.gph, replace ; 
  graph use rank_d29 ; 
  graphexportpdf rank_d29 ; 

  graph combine rank_d3.gph 
  		rank_d10.gph 
		rank_d18.gph 
		rank_d29.gph ; 
  graph save rank_dall_v1, replace ; 
  graph use rank_dall_v1 ; 
  graphexportpdf rank_dall_v1, dropeps ; 

end ; 

*ro_race unity ; 
*ro_race ndc ; 
*ro_race  dc ; 
*endstata ;   

************************************************************************************ ; 
************************************************************************************ ; 
************************************************************************************ ; 

*****************************************************************; 
* Getting residualized data - Judicial Incarceration Rates       ; 
*  - Estimates the gamma_j^r partialling out case characeristics ;
*  - Read the gamma_j^r's into Matlab. 			     ;  

program define R_data_prep ; 

use if district == `1' & `2' == 1 using sim_data_race, clear ; 

egen cell = group(white judgeid) ; 
tab cell, gen(cell) ; 
tab cell white ; 
tab cell judgeid ; 

su cell ; 
 local Ncell = r(max) ; 

local xs_unity "female agegrp2-agegrp4 counts person i_spec_rule priv_counsel plea gsent ndc gsent_ndc yrfx2-yrfx14" ;  
local xs_ndc   "female agegrp2-agegrp4 counts 	     i_spec_rule priv_counsel plea gsent     	       yrfx2-yrfx14" ;  
local xs_dc    "female agegrp2-agegrp4 counts 	     i_spec_rule priv_counsel plea gsent	       yrfx2-yrfx14" ;  

qui reg incar `xs_`2'' ; 
 predict rincar, r ; 

forvalues i = 1/`Ncell' { ; 
 qui reg cell`i' `xs_`2'' ; 
 predict rcell`i', r ; 
} ; 

su judgeid ; 
 local Nj = r(max) ; 

forvalues i = 1/`Nj' { ; 
 local j = `Nj' + `i' ; 
  *gen b`i' = rcell`i' ;
  *gen w`i' = rcell`j' ; 
   gen b`i' = cell`i' ;
   gen w`i' = cell`j' ; 
} ; 


*keep rincar b1-b`Nj' w1-w`Nj' rcell1-rcell`Ncell' ; 
 keep  incar b1-b`Nj' w1-w`Nj' judgeid cell ; 
saveold d`1'_data_`2', replace version(12) ; 

outsheet incar b1-b`Nj' w1-w`Nj' judgeid cell using d`1'_data_`2'.csv, comma replace ; 

reg incar b2-b`Nj' w1-w`Nj' ; 

end ; 

/*
R_data_prep 3  unity ; 
R_data_prep 10 unity ; 
R_data_prep 18 unity ; 
R_data_prep 29 unity ; 

R_data_prep 3  ndc ; 
R_data_prep 10 ndc ; 
R_data_prep 18 ndc ; 
R_data_prep 29 ndc ; 

R_data_prep 3  dc ; 
R_data_prep 10 dc ; 
R_data_prep 18 dc ; 
R_data_prep 29 dc ; 
*/ 

************************************************************************************ ; 
************************************************************************************ ; 
************************************************************************************ ; 

***********************************************************************; 
* MATLAB code - Rank Order Test for District 3 - Topeka - All Offenses ; 
*  - Code for other districts are nearly identical.  		   ;
*  - Table 3: Rank-Order Results by Type of Crime			  ; 
*  - Practioner needs to construct constraint functions which will depend ; 
*    on the outcome of the GMS pre-test procedure. 			   ; 

clear
format long

%% Import data 

raw=xlsread('d3_data.xlsx','A2:M4048');
Y=raw(:,1);
b1=raw(:,2);
w1=raw(:,3);
b2=raw(:,4);
w2=raw(:,5);
b3=raw(:,6);
w3=raw(:,7);
b4=raw(:,8);
w4=raw(:,9);
b5=raw(:,10);
w5=raw(:,11);
b6=raw(:,12);
w6=raw(:,13);
X=[ones(size(b2)),b2,b3,b4,b5,b6,w1,w2,w3,w4,w5,w6];

%% General parameters setup

[n,k]=size(X); % n-number of observations; k-number of beta parameters;
nctr=(k/2)*(k/2-1)/2; % nctr is the number of constraints

%% Unrestricted model - i.e. model without inequality constraints

betaUR=regress(Y,X);
resUR=Y-X*betaUR;
ssrUR=sum(resUR.*resUR);

opts = optimset('Display','iter','Algorithm','sqp',...
                'MaxFunEval',inf,'MaxIter',Inf);

%% Restricted model - optimizartion with inequality constraints

fun=@(x)sum((Y-X*x).*(Y-X*x)); %Define objective function
lb=[];  %No lower bound on coefficients
ub=[];  %No upper bound on coefficients
A=[];   %No linear constraints
b=[];   %No linear constraints
Aeq=[]; %No linear constraints
beq=[]; %No linear constraints
x0=zeros(k,1); %initial point satisfying all constraints

nonlcon = @constraint; %non-linear constraints defined in constraint function
betaR=fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,opts); % Solve optimization/minimization problem

resR=Y-X*betaR;
ssrR=sum(resR.*resR);

% F-statistic (actual)

fstat=((ssrR-ssrUR)/nctr)/(ssrUR/(n-k));

%% Pre-test and critical values of sampling distribution
% Bootstrap a regression model by resampling the residuals

bootmat1=bootstrp(1000,@(boot)regress(X*betaUR+boot,X),resUR);

bootmat2=[(bootmat1(:,1)-bootmat1(:,2)).*(bootmat1(:,7)-bootmat1(:,8)),...
    (bootmat1(:,1)-bootmat1(:,3)).*(bootmat1(:,7)-bootmat1(:,9)),...
    (bootmat1(:,1)-bootmat1(:,4)).*(bootmat1(:,7)-bootmat1(:,10)),...
    (bootmat1(:,1)-bootmat1(:,5)).*(bootmat1(:,7)-bootmat1(:,11)),...
    (bootmat1(:,1)-bootmat1(:,6)).*(bootmat1(:,7)-bootmat1(:,12)),...
    (bootmat1(:,2)-bootmat1(:,3)).*(bootmat1(:,8)-bootmat1(:,9)),...
    (bootmat1(:,2)-bootmat1(:,4)).*(bootmat1(:,8)-bootmat1(:,10)),...
    (bootmat1(:,2)-bootmat1(:,5)).*(bootmat1(:,8)-bootmat1(:,11)),...
    (bootmat1(:,2)-bootmat1(:,6)).*(bootmat1(:,8)-bootmat1(:,12)),...
    (bootmat1(:,3)-bootmat1(:,4)).*(bootmat1(:,9)-bootmat1(:,10)),...
    (bootmat1(:,3)-bootmat1(:,5)).*(bootmat1(:,9)-bootmat1(:,11)),...
    (bootmat1(:,3)-bootmat1(:,6)).*(bootmat1(:,9)-bootmat1(:,12)),...
    (bootmat1(:,4)-bootmat1(:,5)).*(bootmat1(:,10)-bootmat1(:,11)),...
    (bootmat1(:,4)-bootmat1(:,6)).*(bootmat1(:,10)-bootmat1(:,12)),...
    (bootmat1(:,5)-bootmat1(:,6)).*(bootmat1(:,11)-bootmat1(:,12))];

%standard error of the sampling distribution

sd=std(bootmat2); 

% Vector of constraints calculated based on the actual sample

ctr=[-(betaUR(1)-betaUR(2))*(betaUR(7)-betaUR(8));
    -(betaUR(1)-betaUR(3))*(betaUR(7)-betaUR(9));
    -(betaUR(1)-betaUR(4))*(betaUR(7)-betaUR(10));
    -(betaUR(1)-betaUR(5))*(betaUR(7)-betaUR(11));
    -(betaUR(1)-betaUR(6))*(betaUR(7)-betaUR(12));
    -(betaUR(2)-betaUR(3))*(betaUR(8)-betaUR(9));
    -(betaUR(2)-betaUR(4))*(betaUR(8)-betaUR(10));
    -(betaUR(2)-betaUR(5))*(betaUR(8)-betaUR(11));
    -(betaUR(2)-betaUR(6))*(betaUR(8)-betaUR(12));
    -(betaUR(3)-betaUR(4))*(betaUR(9)-betaUR(10));
    -(betaUR(3)-betaUR(5))*(betaUR(9)-betaUR(11));
    -(betaUR(3)-betaUR(6))*(betaUR(9)-betaUR(12));
    -(betaUR(4)-betaUR(5))*(betaUR(10)-betaUR(11));
    -(betaUR(4)-betaUR(6))*(betaUR(10)-betaUR(12));
    -(betaUR(5)-betaUR(6))*(betaUR(11)-betaUR(12))];

%tunning parameter

tuningstat=ctr'./sd;
kappa=(log(n))^0.5;
tuning=ones(1,nctr)*kappa;

% Generalized Moment Selection

selection=tuningstat<tuning; % binding returns 1; non-binding returns 0;

% Optimizartion with GMS constraints

gmsctr = @gmsconstraint; %non-linear constraints defined in constraint function
betaGMS=fmincon(fun,x0,A,b,Aeq,beq,lb,ub,gmsctr,opts); % Solve optimization/minimization problem

% Recenter the data using betaGMS

resGMS=Y-X*betaGMS;
resGMS2=datasample(resGMS,length(resGMS));
Y2=X*betaGMS+resGMS2;
ssrGMS=sum(resGMS.*resGMS);

%% Approximate sample distribution
% f-stat of the "original" recentered data (haven't done resampling yet)

fun2=@(x)sum((Y2-X*x).*(Y2-X*x)); %Refine objective function using recentered data
betaBoot=fmincon(fun2,x0,A,b,Aeq,beq,lb,ub,nonlcon,opts); % Solve optimization/minimization problem

resBoot=Y2-X*betaBoot;
ssrBoot=sum(resBoot.*resBoot);
fstatBoot=((ssrBoot-ssrUR)/nctr)/(ssrUR/(n-k));

% Bootstrapping from the recentered data and redo optimization m times

m=1000; % Number of resampling
betabootR=ones(k,m); % pre-populate estimator matrices
ssrbootR=ones(m,1);  % pre-populate estimator matrices
betabootUR=ones(k,m); % pre-populate estimator matrices
ssrbootUR=ones(m,1);  % pre-populate estimator matrices
fstatboot=ones(m,1);% pre-populate estimator matrices

for i=1:1:m;
    restemp=datasample(resGMS, length(resGMS)); % Randomly sample data from the recented dataset with replacement 
    Ytemp=X*betaGMS+restemp;
    % Repeat the same calculation for each resample to get the f-stat
    funi=@(x)sum((Ytemp-X*x).*(Ytemp-X*x)); 
    betabootR(:,i)=fmincon(funi,x0,A,b,Aeq,beq,lb,ub,nonlcon,opts);
    resbootR=Ytemp-X*betabootR(:,i);
    ssrbootR(i)=sum(resbootR.*resbootR);

    betabootUR(:,i)=regress(Ytemp,X);
    resbootUR=Ytemp-X*betabootUR(:,i);
    ssrbootUR(i)=sum(resbootUR.*resbootUR);
 
    fstatboot(i)=((ssrbootR(i)-ssrbootUR(i))/nctr)/(ssrbootUR(i)/(n-k));
end

%% Determine the sample distribution of f-stat based on the calculation of estimators
% Sort/rank the bootstrapped statistics:
% Read in the vector of fstatboot into boot_F.csv to graph the empirical distributions in Stata

distr=sort(fstatboot);
crt=distr(0.95*m);
pval=sum(fstatboot>=fstat)/m;

************************************************************************** ; 
************************************************************************** ; 
************************************************************************** ; 

************************************************************************************; 
* Figure 8: Rank-Order Test Results - Empirical Distribution of the Fbar Statistics ; 
*  - Practioner needs to extract the vector of Fbar statistics from Matlab output   ; 
*    and then construct a .csv file with the data. 				       ; 

program define graph_boot_f ; 

 local t3  "(a) Topeka" ; 
 local t10 "(b) Overland Park" ; 
 local t18 "(c) Wichita" ; 
 local t29 "(d) Kansas City" ; 

 local a3  = 0.046 ; 
 local a10 = 0.426 ; 
 local a18 = 0.097 ; 
 local a29 = 0.082 ; 

 insheet using boot_F.csv, comma ; 

 foreach i of numlist 3 10 18 29 { ; 

   qui su d`i', d ; 
    local c`i' = r(p95) ; 

   kdensity d`i', gen(x y) ; 
    graph twoway line y x || area y x if x > `c`i'', 
    	  title("") ytitle("") xtitle("`t`i''") legend(off) saving(_b`i', replace) xline(`a`i'', lpattern(dash) lwidth(vthin) lcolor(maroon)) ylabel(,nogrid) ; 
   
   drop x y ; 

 } ;  

 graph combine _b3.gph _b10.gph _b18.gph _b29.gph ; 
  graph save _fstatb, replace ; 
  graph use _fstatb ; 
  graphexportpdf _fstatb, dropeps ; 

end ; 

/*
graph_boot_f ; 
end ; 
*/ 

************************************************************** ; 
************************************************************** ; 
************************************************************** ; 
