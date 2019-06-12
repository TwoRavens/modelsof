use "$basein/Student_School_House_Teacher_Char.dta", clear

gen Demoted_T7=(atrgrd_T7<stdgrd_T7) if !missing(Z_hisabati_T7)
gen Demoted_T3=(atrgrd_T3<stdgrd_T3) if !missing(Z_hisabati_T3)


capt prog drop my_ptest
*! version 1.0.0  14aug2007  Ben Jann
program my_ptest, eclass
*clus(clus_var)
syntax varlist [if] [in], by(varname) clus_id(varname numeric) strat_id(varlist numeric) [ * ] /// clus_id(clus_var)  

marksample touse
markout `touse' `by'
tempname mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4 d_p d_p2
capture drop TD*
tab `by', gen(TD)
foreach var of local varlist {
	reg `var' TD1 TD2 TD3 TD4 `if', nocons vce(cluster `clus_id')
	test (_b[TD1] == _b[TD2]== _b[TD3]= _b[TD4])
	mat `d_p'  = nullmat(`d_p'),r(p)
	matrix A=e(b)
	matrix B=e(V)
	mat `mu_1' = nullmat(`mu_1'), A[1,1]
	mat `mu_2' = nullmat(`mu_2'), A[1,2]
	mat `mu_3' = nullmat(`mu_3'), A[1,3]
	mat `mu_4' = nullmat(`mu_4'), A[1,4]
	mat `se_1' = nullmat(`se_1'), sqrt(B[1,1])
	mat `se_2' = nullmat(`se_2'), sqrt(B[2,2])
	mat `se_3' = nullmat(`se_3'), sqrt(B[3,3])
	mat `se_4' = nullmat(`se_4'), sqrt(B[4,4])
	reghdfe `var' TD1 TD2 TD3 TD4 `if',  vce(cluster `clus_id') abs( i.`strat_id')
	test (_b[TD1] == _b[TD2]== _b[TD3]= _b[TD4])
	mat `d_p2'  = nullmat(`d_p2'),r(p)
}
foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4  d_p d_p2 {
	mat coln ``mat'' = `varlist'
}
eret local cmd "my_ptest"
foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4  d_p d_p2 {
	eret mat `mat' = ``mat''
}
end



label var Demoted_T7 "Lower grade than expected (Yr2)"


eststo clear
my_ptest Demoted_T7, by(treatarm) clus_id(SchoolID) strat_id(DistID)
esttab using "$latexcodesfinals/RegRetention_Balance.tex", label replace ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels(none)  ///
cells("mu_1(fmt(%9.2fc)) mu_2(fmt(%9.2fc)) mu_3(fmt(%9.2fc)) mu_4(fmt(%9.2fc)) d_p2(star pvalue(d_p2) fmt(%9.2fc))" "se_1(fmt(%9.2fc) par) se_2(fmt(%9.2fc) par) se_3(fmt(%9.2fc) par) se_4(fmt(%9.2fc) par)  .") ///
addnotes("/specialcell{Standard errors, clustered at the school level, in parenthesis // /sym{*} /(p<0.10/), /sym{**} /(p<0.05/), /sym{***} /(p<0.01/) }") fragment nolines nogaps nomtitles

