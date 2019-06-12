
*NOTE: TO RUN, CHANGE THE DIRECTORY PATH BELOW TO INDICATE THE LOCATION OF THE DATA FILES
cd "C:\YOUR\DIRECTORY\GOES\HERE"

*PROGRAM TO BOOTSTRAP SE ON DIFFERENCES BETWEEN FE and OLS
capture program drop resamp
program define resamp , eclass
	syntax [varlist] [if] [, absorb(string)]
	display "help"
	tokenize `varlist'
	reg `varlist' `if'
	local b_naive = _b[`2']
	ereturn scalar b_naive =`b_naive'
	if ("`absorb'"!=""){ 
		local ab ", absorb(`absorb')" 
		areg `varlist' `if' `ab'
	}
	else {
		reg `varlist' `if'
	}
	local b_fe = _b[`2']
	ereturn scalar b_fe =`b_fe'
	local b_diff = `b_fe'-`b_naive'
	ereturn scalar b_diff=`b_diff'
end

*PROGRAM TO GENERATE TABLE ENTRIES
capture program drop compareregs 
program define compareregs, eclass
	syntax varlist [if] [, absorb(string) cluster(passthru)]
	tokenize `varlist'
	
	if ("`cluster'"!=""){
		local commacluster " , `cluster'"
	}
	reg  `varlist'  `if' `commacluster'
	matrix b = _b[`2'] , _se[`2']
	matrix NN =  e(N)
	
	if ("`absorb'"!=""){ 
		local ab ", absorb(`absorb')" 
		areg `varlist' `if' `ab' `cluster'
	}
	else {
		reg `varlist'  `if' `commacluster'
	}
	matrix b =  b\ _b[`2'], _se[`2']
	matrix NN = NN , e(N)
	*display in red "`varlist' `if' `ab'"
	bootstrap e(b_diff), `cluster' rep(200): resamp `varlist' `if' `ab'
	matrix b =  b\ _b[_bs_1] , _se[_bs_1]	

	macro shift 
	reg `*' `if' `commacluster' 		/*regresses z on "certain" covariates (X2 in the paper)*/
	local r2zw = e(r2)
	matrix NN = NN , e(N)
	if ("`absorb'"!=""){ 
		areg `*' `if' `ab' `cluster'
		matrix NN = NN , e(N)
	}
	if ("`3'"==""){
		local U = (1-e(r2))*b[2,1]
		local A = b[2,1]-`U'
		local X = b[1,1]-`U'
	}
	else{
		local U = (1-e(r2))*b[2,1]/(1-`r2zw')
		local A = b[2,1]-`U'
		local X = b[1,1]-`U'
	}
	matrix b = b\ `U', . 	\ `A', . \ `X', .
	matrix b = b'
	ereturn matrix bet = b
	ereturn matrix NN = NN
end


*OPEN DATA FOR FIRST FOUR EXPENDITURE SCHEMES
use "REPLICATION_TABLE 3_DAT_PREP_V04.dta", clear

*DEFINE THE OUTCOME MEASURES
global outcomes " sss_ashray_exp_1000 css_iay_exp_1000 sss_amb_hous_exp_1000 css_nregs_exp_1000 total_water_p1_1000 latr_ach_p1 comlatr_ach_p1"
global covars " expenditure tot_p p_sc p_st p_lit  tot_work_p "

*RUN THE ANALYSES AND SAVE OUTPUTS
capture matrix drop sv_
capture matrix drop sv_2
capture matrix drop sv_N
capture matrix drop sv_N2
foreach outcome in $outcomes {
	preserve
	keep if `outcome' != .
	compareregs `outcome' reserved_scst_2007 , absorb(dist_taluk) cluster(dist_taluk)
	matrix sv_ = nullmat(sv_)\e(bet)
	matrix sv_N=nullmat(sv_N)\e(NN)
	compareregs `outcome' reserved_scst_2007  $covars , absorb(dist_taluk) cluster(dist_taluk)
	matrix sv_2 = nullmat(sv_2)\e(bet)
	matrix sv_N2=nullmat(sv_N2)\e(NN)
	restore
}


forvalues i = 1/6 {
	forvalues j = 1/14 {
		matrix sv_[`j', `i']= round(sv_[`j', `i'] , 0.1) 
		matrix sv_2[`j', `i']= round(sv_2[`j', `i'] , 0.1) 

	}
}
matrix rownames sv_= "Ashraya" "." "IAY" "." "Ambedkar" "."  "MGNREGA" "." "Water" "." "Latrines" "." "ComLatrines" "." 
matrix rownames sv_2= "Ashraya" "." "IAY" "." "Ambedkar" "."  "MGNREGA" "." "Water" "." "Latrines" "." "ComLatrines" "." 
matrix colnames sv_ ="OLS (SE)" "FE (SE)" "Diff (SE)" "upsilon" "alpha" "chi" 
matrix colnames sv_2 ="OLS (SE)" "FE (SE)" "Diff (SE)" "upsilon" "alpha" "chi" 

matrix list sv_
matrix list sv_2

matrix tmp = sv_ \ sv_2

ssc install outtable
outtable using Table3Latex, mat(tmp) replace format(%10.1f)

