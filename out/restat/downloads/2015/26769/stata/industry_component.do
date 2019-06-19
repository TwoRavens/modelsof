#delim;
qui{;

pause on;
set more off;
/**************************************************************************/
global path2    ="~\project\data\";
global path3    ="~\project\code\";
global temppath ="~\project\temp";
/**************************************************************************/
/*----------------------------------------------------*/
global namein  "nld_industries";
global nameout="$namein"+"_tfpwithshares";
global id "icode";
global yr "year";
global ind "sbi4";
global phi "sharei4";
global tau = "TFPva_I_NL";
/*----------------------------------------------------*/
local fname1 ="$path2"+"$namein";

/**********************/
use "`fname1'", clear;

rename code sbi;
sort sbi $year;

gen $ind=.;
replace $ind=11 if sbi=="15t16" | sbi=="17t19" | sbi=="36t37";
replace $ind=12 if sbi=="20" | sbi=="21t22" | sbi=="23" | sbi=="24" |
			sbi=="25" | sbi=="26" | sbi=="27t28";

replace $ind=13 if sbi=="29" | sbi=="34t35";
replace $ind=14 if sbi=="30t33";

drop if sbi=="D";
keep icode sbi $ind year VA_NL VA_QI_NL_g TFPva_I_NL TFPva_I_NL_g;

/*four baselines*/
by $ind $yr, sort: egen x =total(VA_NL);
by	  $yr, sort: egen xm=total(VA_NL);
gen sharei4 = VA_NL/x;
gen share4m = x/xm;
gen shareim = VA_NL/xm;
sort $ind sbi year;

rename sbi code;
gen touse =1;

loc fnameout="$path2"+"$nameout";
save "`fnameout'", replace;
noi run "$path3\outsiders\gen_decomp_industrycomp.do";

sort $ind $yr;
keep $ind $yr lntau_a logdiff_ag decomp; rename logdiff_ag dlntau_ind;
*gr tw sc dlntau_ind decomp;
drop lntau_a decomp;

reshape wide dlntau_ind, i($yr) j($ind);
sort $yr;
/*get euklems aggregates for overall manufacturing */
merge $yr using "$path2\tomatlab_va_ex2bayes.dta", 
			keep(VA_NL_g euk_man_va_g CAP_QI_NL_g LAB_QI_NL_g);
drop if _merge==2; drop _merge;
save "`fnameout'_final", replace;

}; /*end of qui block*/
