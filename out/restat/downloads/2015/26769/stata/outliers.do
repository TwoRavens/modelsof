#delim;
qui {;

set more off;
pause on;
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-14-2009*/ 
/*outliers (IQR method since distributions are skewed)*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/***** FILEPATH/NAME DECLARATIONS *****/
/*      Same as in levpet_by_ind      */
/**************************************/

tempvar v1; tempvar v2; tempvar v3;
gen `v1'=exp($cap-$depvar);
gen `v2'=exp($proxy-$depvar);
tempvar emp1;
gen `emp1'=exp($emp);
gen `v3'=$pay/`emp1';

forvalues num=1/3 {;
	gen out`num'=0;
	by $ind $yr, sort: egen q25_`num'=pctile(`v`num''), p(25);
	by $ind $yr, sort: egen q75_`num'=pctile(`v`num''), p(75);
	by $ind $yr, sort: egen iqr_`num'=iqr(`v`num'');
	replace out`num'= 1 if `v`num''<q25_`num'-1.5*iqr_`num' | `v`num''>q75_`num'+1.5*iqr_`num' | `v`num''==.;
};
gen out=0;
replace out=1 if out1==1 | out2==1 | out3==1 | $ind==0;
replace out=1 if $ind==0;
/*noi tab out1; noi tab out2; noi tab out3; noi tab out;*/

drop q25_1 q75_1 iqr_1 q25_2 q75_2 iqr_2 q25_3 q75_3 iqr_3;

sort $id $yr;

}; /*end of main qui block*/
