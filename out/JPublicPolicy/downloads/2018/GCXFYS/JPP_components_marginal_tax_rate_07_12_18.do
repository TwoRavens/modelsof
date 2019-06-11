#delimit
clear;
set mem 200m;
set matsize 800;
set type double, permanently;


/*Desktop version-adjust this acccordingly*/
cd "C:\Users\dmberk\Desktop\JPP" ;
use "JPP_components_marginal_tax_rate_07_12_18.dta", clear;
save "JPP_marginal_tax_rate_07_12_18.dta", replace;
replace State=State-1 if State>=10;
/*fix State*/
drop if Year>2008;
drop if Year < 1986;
/*drop Nebraska = 27*/
drop if State==27;                                                                                                         
/*PIT (personal income tax) calculation
*exclude States that do not have no PIT (2,9,28,41,43,47,50) = (Alaska, Florida, Nevada, S. Dakota, Texas, Wash and Wyoming)                     
We need to correct Reed et al...they drop AK (State==2). But, Alaska has personal income tax revenues during 1989-2008, so it should be included
for 1984-1988*/
gen PIT=1;
/*replace PIT=0 if State==2 & Year >= 1989 & Year <=2008| State==9 | State==28 | State==41 | State==43 | State==47 | State==50; */
/* here we drop Alaska because it only has five observations and personal income is very low there in those years8*/
replace PIT=0 if State==2 | State==9 | State==28 | State==41 | State==43 | State==47 | State==50;
/*SIMPLER METHOD FOR DOING THIS*/
replace PIT = 0 if taxes_pincome_s == 0;
replace PIT = 0 if taxes_pincome_s == .;
/*generate the interaction variables*/
gen mtr_wages_y = mtr_wages*y_fiscal;
gen mtr_dividends_y = mtr_dividends*y_fiscal;
gen mtr_pension_y = mtr_pension*y_fiscal;

tis Year;
iis State;
xi: reg taxes_pincome_s i.State*y_fiscal mtr_wages mtr_dividends mtr_pension mtr_wages_y  mtr_dividends_y  mtr_pension_y 
if PIT==1 [aweight= y_fiscal^(-0.5)];
/*need to omit missing variables from calculation of MTR.,.. to do this, let PIT=. when PIT==0*/
replace PIT=. if PIT==0;
gen yo = _b[mtr_wages_y]*mtr_wages + _b[mtr_dividends_y]*mtr_dividends + _b[mtr_pension_y]*mtr_pension + _b[y_fiscal]
+  _b[_IStaXy_fi_2 ]*_IState_2*PIT  +  _b[_IStaXy_fi_3 ]*_IState_3*PIT  + _b[_IStaXy_fi_4 ]*_IState_4*PIT + _b[_IStaXy_fi_5 ]*_IState_5*PIT 
+  _b[_IStaXy_fi_6 ]*_IState_6*PIT + _b[_IStaXy_fi_7 ]*_IState_7*PIT +  _b[_IStaXy_fi_8 ]*_IState_8*PIT +  _b[_IStaXy_fi_9 ]*_IState_9*PIT 
+  _b[_IStaXy_fi_10 ]*_IState_10*PIT + _b[_IStaXy_fi_11 ]*_IState_11*PIT  + _b[_IStaXy_fi_12 ]*_IState_12*PIT 
+  _b[_IStaXy_fi_13 ]*_IState_13*PIT + _b[_IStaXy_fi_14 ]*_IState_14*PIT  + _b[_IStaXy_fi_15 ]*_IState_15*PIT 
+  _b[_IStaXy_fi_16 ]*_IState_16*PIT + _b[_IStaXy_fi_17 ]*_IState_17*PIT  + _b[_IStaXy_fi_18 ] *_IState_18*PIT 
+  _b[_IStaXy_fi_19 ]*_IState_19*PIT  + _b[_IStaXy_fi_20 ]*_IState_20*PIT  + _b[_IStaXy_fi_21 ]*_IState_21*PIT 
+  _b[_IStaXy_fi_22 ]*_IState_22*PIT  + _b[_IStaXy_fi_23 ]*_IState_23*PIT  + _b[_IStaXy_fi_24 ]*_IState_24*PIT 
+  _b[_IStaXy_fi_25 ]*_IState_25*PIT  + _b[_IStaXy_fi_26 ]*_IState_26*PIT  + _b[_IStaXy_fi_28 ]*_IState_28*PIT  + _b[_IStaXy_fi_29 ]*_IState_29*PIT 
+  _b[_IStaXy_fi_30 ]*_IState_30*PIT  + _b[_IStaXy_fi_31 ]*_IState_31*PIT  
+  _b[_IStaXy_fi_32 ]*_IState_32*PIT  + _b[_IStaXy_fi_33 ]*_IState_33*PIT  + _b[_IStaXy_fi_34 ]*_IState_34*PIT 
+  _b[_IStaXy_fi_35 ]*_IState_35*PIT  + _b[_IStaXy_fi_36 ]*_IState_36*PIT  +  _b[_IStaXy_fi_37 ]*_IState_37*PIT 
+  _b[_IStaXy_fi_38 ]*_IState_38*PIT  + _b[_IStaXy_fi_39 ]*_IState_39*PIT  + _b[_IStaXy_fi_40 ]*_IState_40*PIT  + _b[_IStaXy_fi_41]*_IState_41*PIT  +  _b[_IStaXy_fi_42 ]*_IState_42*PIT 
+  _b[_IStaXy_fi_43 ]*_IState_43*PIT  + _b[_IStaXy_fi_44 ]*_IState_44*PIT  + _b[_IStaXy_fi_45 ]*_IState_45*PIT 
+  _b[_IStaXy_fi_46 ]*_IState_46*PIT  + _b[_IStaXy_fi_47 ]*_IState_47*PIT  + _b[_IStaXy_fi_48 ]*_IState_48*PIT  + _b[_IStaXy_fi_49 ]*_IState_49*PIT + _b[_IStaXy_fi_50 ]*_IState_50*PIT ;
gen MTR_pincome_s = yo*PIT; 
/*we have all the observations for pincome_s => when MTR_pincome_s = . for a particular state-year, that means that there is no personal income tax collected then, and so that MTR_pincome_s is 0*/
replace MTR_pincome_s = 0 if MTR_pincome_s==.;

/* clean file */
drop _I*;
drop mtr_wages_y - yo;
drop PIT;

 
  
  /*SIT calculation
exclude states that do have sales tax (2,8,26,29,37) = (Alaska, Delaware, Montana, New Hampshire, Oregon) */
gen SIT=1;
replace SIT=0 if taxes_sales_s==0;
/*get the interaction variables*/
gen Rate_Food_y = Rate_Food*y_fiscal;
gen Rate_sales_y = Rate_sales*y_fiscal;
tis Year;
iis State;
xi: reg taxes_sales_s i.State*y_fiscal Rate_Food Rate_sales Rate_Food_y Rate_sales_y
if SIT==1 [aweight= y_fiscal^(-0.5)];
/*need to omit variables from calculation of MTR when there is no sales tax collection.,.. to do this, let SIT=. when SIT==0*/
replace SIT=. if SIT==0;
gen yo = _b[Rate_Food_y]*Rate_Food + _b[Rate_sales_y]*Rate_sales + _b[y_fiscal]
+  _b[_IStaXy_fi_2 ]*_IState_2*SIT  +  _b[_IStaXy_fi_3 ]*_IState_3*SIT  + _b[_IStaXy_fi_4 ]*_IState_4*SIT + _b[_IStaXy_fi_5 ]*_IState_5*SIT 
+  _b[_IStaXy_fi_6 ]*_IState_6*SIT + _b[_IStaXy_fi_7 ]*_IState_7*SIT +  _b[_IStaXy_fi_8 ]*_IState_8*SIT +  _b[_IStaXy_fi_9 ]*_IState_9*SIT 
+  _b[_IStaXy_fi_10 ]*_IState_10*SIT + _b[_IStaXy_fi_11 ]*_IState_11*SIT  + _b[_IStaXy_fi_12 ]*_IState_12*SIT 
+  _b[_IStaXy_fi_13 ]*_IState_13*SIT + _b[_IStaXy_fi_14 ]*_IState_14*SIT  + _b[_IStaXy_fi_15 ]*_IState_15*SIT 
+  _b[_IStaXy_fi_16 ]*_IState_16*SIT + _b[_IStaXy_fi_17 ]*_IState_17*SIT  + _b[_IStaXy_fi_18 ] *_IState_18*SIT 
+  _b[_IStaXy_fi_19 ]*_IState_19*SIT  + _b[_IStaXy_fi_20 ]*_IState_20*SIT  + _b[_IStaXy_fi_21 ]*_IState_21*SIT 
+  _b[_IStaXy_fi_22 ]*_IState_22*SIT  + _b[_IStaXy_fi_23 ]*_IState_23*SIT  + _b[_IStaXy_fi_24 ]*_IState_24*SIT 
+  _b[_IStaXy_fi_25 ]*_IState_25*SIT  + _b[_IStaXy_fi_26 ]*_IState_26*SIT  + _b[_IStaXy_fi_28 ]*_IState_28*SIT  + _b[_IStaXy_fi_29 ]*_IState_29*SIT 
+  _b[_IStaXy_fi_30 ]*_IState_30*SIT  + _b[_IStaXy_fi_31 ]*_IState_31*SIT  
+  _b[_IStaXy_fi_32 ]*_IState_32*SIT  + _b[_IStaXy_fi_33 ]*_IState_33*SIT  + _b[_IStaXy_fi_34 ]*_IState_34*SIT 
+  _b[_IStaXy_fi_35 ]*_IState_35*SIT  + _b[_IStaXy_fi_36 ]*_IState_36*SIT  +  _b[_IStaXy_fi_37 ]*_IState_37*SIT 
+  _b[_IStaXy_fi_38 ]*_IState_38*SIT  + _b[_IStaXy_fi_39 ]*_IState_39*SIT  + _b[_IStaXy_fi_40 ]*_IState_40*SIT  + _b[_IStaXy_fi_41]*_IState_41*SIT  +  _b[_IStaXy_fi_42 ]*_IState_42*SIT 
+  _b[_IStaXy_fi_43 ]*_IState_43*SIT  + _b[_IStaXy_fi_44 ]*_IState_44*SIT  + _b[_IStaXy_fi_45 ]*_IState_45*SIT 
+  _b[_IStaXy_fi_46 ]*_IState_46*SIT  + _b[_IStaXy_fi_47 ]*_IState_47*SIT  + _b[_IStaXy_fi_48 ]*_IState_48*SIT  + _b[_IStaXy_fi_49 ]*_IState_49*SIT + _b[_IStaXy_fi_50 ]*_IState_50*SIT ;

gen MTR_sales_s = yo*SIT; 
/*we have all the observations for pincome_s => when MTR_pincome_s = . for a particular state-year, that means that there is no personal income tax collected then, and so that MTR_pincome_s is 0*/
replace MTR_sales_s = 0 if MTR_sales_s==.;

/* clean file */
drop _I*;
drop Rate_Food_y - yo;
drop SIT;

    /*clean the file and move onto corporate taxes*/
  
  
  /*CIT calculation
exclude states that do have CIT (28,43,47,50) = (Nevada, Texas, Washington, Wyoming) */

gen CIT=1;
replace CIT=0 if taxes_cincome_s==0;
/*get the interaction variables*/
gen number_cbrackets_y = number_cbrackets*y_fiscal;
gen max_crate_y = max_crate*y_fiscal;
tis Year;
iis State;

xi: reg taxes_cincome_s i.State*y_fiscal number_cbrackets max_crate number_cbrackets_y max_crate_y 
if CIT==1 [aweight= y_fiscal^(-0.5)];
replace CIT=. if CIT==0;

gen yo = _b[number_cbrackets_y]*number_cbrackets + _b[max_crate_y]*max_crate + _b[y_fiscal]
+  _b[_IStaXy_fi_2 ]*_IState_2*CIT  +  _b[_IStaXy_fi_3 ]*_IState_3*CIT  + _b[_IStaXy_fi_4 ]*_IState_4*CIT + _b[_IStaXy_fi_5 ]*_IState_5*CIT 
+  _b[_IStaXy_fi_6 ]*_IState_6*CIT + _b[_IStaXy_fi_7 ]*_IState_7*CIT +  _b[_IStaXy_fi_8 ]*_IState_8*CIT +  _b[_IStaXy_fi_9 ]*_IState_9*CIT 
+  _b[_IStaXy_fi_10 ]*_IState_10*CIT + _b[_IStaXy_fi_11 ]*_IState_11*CIT  + _b[_IStaXy_fi_12 ]*_IState_12*CIT 
+  _b[_IStaXy_fi_13 ]*_IState_13*CIT + _b[_IStaXy_fi_14 ]*_IState_14*CIT  + _b[_IStaXy_fi_15 ]*_IState_15*CIT 
+  _b[_IStaXy_fi_16 ]*_IState_16*CIT + _b[_IStaXy_fi_17 ]*_IState_17*CIT  + _b[_IStaXy_fi_18 ] *_IState_18*CIT 
+  _b[_IStaXy_fi_19 ]*_IState_19*CIT  + _b[_IStaXy_fi_20 ]*_IState_20*CIT  + _b[_IStaXy_fi_21 ]*_IState_21*CIT 
+  _b[_IStaXy_fi_22 ]*_IState_22*CIT  + _b[_IStaXy_fi_23 ]*_IState_23*CIT  + _b[_IStaXy_fi_24 ]*_IState_24*CIT 
+  _b[_IStaXy_fi_25 ]*_IState_25*CIT  + _b[_IStaXy_fi_26 ]*_IState_26*CIT  + _b[_IStaXy_fi_28 ]*_IState_28*CIT  + _b[_IStaXy_fi_29 ]*_IState_29*CIT 
+  _b[_IStaXy_fi_30 ]*_IState_30*CIT  + _b[_IStaXy_fi_31 ]*_IState_31*CIT  
+  _b[_IStaXy_fi_32 ]*_IState_32*CIT  + _b[_IStaXy_fi_33 ]*_IState_33*CIT  + _b[_IStaXy_fi_34 ]*_IState_34*CIT 
+  _b[_IStaXy_fi_35 ]*_IState_35*CIT  + _b[_IStaXy_fi_36 ]*_IState_36*CIT  +  _b[_IStaXy_fi_37 ]*_IState_37*CIT 
+  _b[_IStaXy_fi_38 ]*_IState_38*CIT  + _b[_IStaXy_fi_39 ]*_IState_39*CIT  + _b[_IStaXy_fi_40 ]*_IState_40*CIT  + _b[_IStaXy_fi_41]*_IState_41*CIT  +  _b[_IStaXy_fi_42 ]*_IState_42*CIT 
+  _b[_IStaXy_fi_43 ]*_IState_43*CIT  + _b[_IStaXy_fi_44 ]*_IState_44*CIT  + _b[_IStaXy_fi_45 ]*_IState_45*CIT 
+  _b[_IStaXy_fi_46 ]*_IState_46*CIT  + _b[_IStaXy_fi_47 ]*_IState_47*CIT  + _b[_IStaXy_fi_48 ]*_IState_48*CIT  + _b[_IStaXy_fi_49 ]*_IState_49*CIT + _b[_IStaXy_fi_50 ]*_IState_50*CIT ;

gen MTR_cincome_s = yo*CIT; 
replace MTR_cincome_s=0 if MTR_cincome_s==.;

  /*clean the file and move onto property taxes*/
  
drop _IState_2-yo;
drop CIT;  

gen PT = 1;
replace PT=0 if taxes_property_s==0;

 

/*get the interaction variables*/
gen Rate_property_y = Rate_property*y_fiscal;
tis Year;
iis State;
xi: reg taxes_property_s i.State*y_fiscal Rate_property Rate_property_y[aweight= y_fiscal^(-0.5)] if PT==1;

replace PT=. if PT==0;

gen yo = _b[Rate_property_y]*Rate_property + _b[y_fiscal]*PT 
+  _b[_IStaXy_fi_2 ]*_IState_2*PT  +  _b[_IStaXy_fi_3 ]*_IState_3*PT  + _b[_IStaXy_fi_4 ]*_IState_4*PT + _b[_IStaXy_fi_5 ]*_IState_5*PT 
+  _b[_IStaXy_fi_6 ]*_IState_6*PT + _b[_IStaXy_fi_7 ]*_IState_7*PT +  _b[_IStaXy_fi_8 ]*_IState_8*PT +  _b[_IStaXy_fi_9 ]*_IState_9*PT 
+  _b[_IStaXy_fi_10 ]*_IState_10*PT + _b[_IStaXy_fi_11 ]*_IState_11*PT  + _b[_IStaXy_fi_12 ]*_IState_12*PT 
+  _b[_IStaXy_fi_13 ]*_IState_13*PT + _b[_IStaXy_fi_14 ]*_IState_14*PT  + _b[_IStaXy_fi_15 ]*_IState_15*PT 
+  _b[_IStaXy_fi_16 ]*_IState_16*PT + _b[_IStaXy_fi_17 ]*_IState_17*PT  + _b[_IStaXy_fi_18 ] *_IState_18*PT 
+  _b[_IStaXy_fi_19 ]*_IState_19*PT  + _b[_IStaXy_fi_20 ]*_IState_20*PT  + _b[_IStaXy_fi_21 ]*_IState_21*PT 
+  _b[_IStaXy_fi_22 ]*_IState_22*PT  + _b[_IStaXy_fi_23 ]*_IState_23*PT  + _b[_IStaXy_fi_24 ]*_IState_24*PT 
+  _b[_IStaXy_fi_25 ]*_IState_25*PT  + _b[_IStaXy_fi_26 ]*_IState_26*PT  + _b[_IStaXy_fi_28 ]*_IState_28*PT  + _b[_IStaXy_fi_29 ]*_IState_29*PT 
+  _b[_IStaXy_fi_30 ]*_IState_30*PT  + _b[_IStaXy_fi_31 ]*_IState_31*PT  
+  _b[_IStaXy_fi_32 ]*_IState_32*PT  + _b[_IStaXy_fi_33 ]*_IState_33*PT  + _b[_IStaXy_fi_34 ]*_IState_34*PT 
+  _b[_IStaXy_fi_35 ]*_IState_35*PT  + _b[_IStaXy_fi_36 ]*_IState_36*PT  +  _b[_IStaXy_fi_37 ]*_IState_37*PT 
+  _b[_IStaXy_fi_38 ]*_IState_38*PT  + _b[_IStaXy_fi_39 ]*_IState_39*PT  + _b[_IStaXy_fi_40 ]*_IState_40*PT  + _b[_IStaXy_fi_41]*_IState_41*PT  +  _b[_IStaXy_fi_42 ]*_IState_42*PT 
+  _b[_IStaXy_fi_43 ]*_IState_43*PT  + _b[_IStaXy_fi_44 ]*_IState_44*PT  + _b[_IStaXy_fi_45 ]*_IState_45*PT 
+  _b[_IStaXy_fi_46 ]*_IState_46*PT  + _b[_IStaXy_fi_47 ]*_IState_47*PT  + _b[_IStaXy_fi_48 ]*_IState_48*PT  + _b[_IStaXy_fi_49 ]*_IState_49*PT + _b[_IStaXy_fi_50 ]*_IState_50*PT ;

replace PT=0 if PT==.;

gen MTR_property_s = yo*PT; 
replace MTR_property_s=0 if MTR_property_s==.;

/*clean the file and move onto other taxes */

drop _IState_2-yo;
drop PT;

/*generate other taxes... this is taxes_total_s - taxes_property_sl - taxes_pincome_s - taxes_cincome_s - taxes_sales_s*/

gen taxes_other_s = taxes_total_s  - taxes_pincome_s  - taxes_sales_s - taxes_cincome_s - taxes_property_s;

tis Year;
iis State;
xi: reg taxes_other_s i.State*y_fiscal [aweight= y_fiscal^(-0.5)];


gen yo = _b[y_fiscal]
+  _b[_IStaXy_fi_2 ]*_IState_2  +  _b[_IStaXy_fi_3 ]*_IState_3  + _b[_IStaXy_fi_4 ]*_IState_4 + _b[_IStaXy_fi_5 ]*_IState_5 
+  _b[_IStaXy_fi_6 ]*_IState_6  +  _b[_IStaXy_fi_7 ]*_IState_7 +  _b[_IStaXy_fi_8 ]*_IState_8 +  _b[_IStaXy_fi_9 ]*_IState_9 
+  _b[_IStaXy_fi_10 ]*_IState_10 + _b[_IStaXy_fi_11 ]*_IState_11  + _b[_IStaXy_fi_12 ]*_IState_12 
+  _b[_IStaXy_fi_13 ]*_IState_13 + _b[_IStaXy_fi_14 ]*_IState_14  + _b[_IStaXy_fi_15 ]*_IState_15 
+  _b[_IStaXy_fi_16 ]*_IState_16 + _b[_IStaXy_fi_17 ]*_IState_17  + _b[_IStaXy_fi_18 ] *_IState_18 
+  _b[_IStaXy_fi_19 ]*_IState_19 + _b[_IStaXy_fi_20 ]*_IState_20 + _b[_IStaXy_fi_21 ]*_IState_21
+  _b[_IStaXy_fi_22 ]*_IState_22 + _b[_IStaXy_fi_23 ]*_IState_23 + _b[_IStaXy_fi_24 ]*_IState_24
+  _b[_IStaXy_fi_25 ]*_IState_25 + _b[_IStaXy_fi_26 ]*_IState_26 + _b[_IStaXy_fi_28 ]*_IState_28 + _b[_IStaXy_fi_29 ]*_IState_29 
+  _b[_IStaXy_fi_30 ]*_IState_30 + _b[_IStaXy_fi_31 ]*_IState_31 
+  _b[_IStaXy_fi_32 ]*_IState_32 + _b[_IStaXy_fi_33 ]*_IState_33 + _b[_IStaXy_fi_34 ]*_IState_34
+  _b[_IStaXy_fi_35 ]*_IState_35 + _b[_IStaXy_fi_36 ]*_IState_36 +  _b[_IStaXy_fi_37 ]*_IState_37
+  _b[_IStaXy_fi_38 ]*_IState_38 + _b[_IStaXy_fi_39 ]*_IState_39 + _b[_IStaXy_fi_40 ]*_IState_40 + _b[_IStaXy_fi_41]*_IState_41 +  _b[_IStaXy_fi_42 ]*_IState_42
+  _b[_IStaXy_fi_43 ]*_IState_43 + _b[_IStaXy_fi_44 ]*_IState_44 + _b[_IStaXy_fi_45 ]*_IState_45
+  _b[_IStaXy_fi_46 ]*_IState_46 + _b[_IStaXy_fi_47 ]*_IState_47 + _b[_IStaXy_fi_48 ]*_IState_48 + _b[_IStaXy_fi_49 ]*_IState_49+ _b[_IStaXy_fi_50 ]*_IState_50 ;

gen MTR_other_s = yo; 

replace MTR_other_s = 0 if MTR_other_s==.;

/*clean the file */

drop _IState_2-yo;

des MTR*;

correlate MTR*;

generate MTR_total_s = MTR_pincome_s + MTR_sales_s  + MTR_cincome_s + MTR_property_s +  MTR_other_s;


drop State_label - Rate_property;
drop number - max;
drop Rate taxes;


sum;

save "JPP_marginal_tax_rate_07_12_18.dta", replace;


