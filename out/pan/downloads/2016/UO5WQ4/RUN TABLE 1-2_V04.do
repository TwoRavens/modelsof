
*NOTE: TO RUN, CHANGE THE DIRECTORY PATH BELOW TO INDICATE THE LOCATION OF THE DATA FILES
cd "C:\YOUR\DIRECTORY\GOES\HERE"
clear 
capture set maxvar 10000
set matsize 10000

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
	syntax varlist [if] [, absorb(string) cluster(passthru) w1(string) w2(string)]
	tokenize `varlist'
	
	if ("`w1'"!=""){
		local w1 "[pw = `w1']"
	}
	if ("`w2'"!=""){
		local w2 "[pw = `w2']"
	}
	if ("`cluster'"!=""){
		local commacluster " , `cluster'"
	}
	reg  `varlist'  `w1' `if' `commacluster'
	matrix b = _b[`2'] , _se[`2']
	if ("`absorb'"!=""){ 
		local ab ", absorb(`absorb')" 
		areg `varlist' `w2' `if' `ab' `cluster'
	}
	else {
		reg `varlist'  `w2' `if' `commacluster'
	}
	matrix b =  b\ _b[`2'], _se[`2']
	*display in red "`varlist' `if' `ab'"
	bootstrap e(b_diff), `cluster' rep(200): resamp `varlist' `if' `ab'
	matrix b =  b\ _b[_bs_1] , _se[_bs_1]	

	macro shift
	reg `*' `if' `commacluster'
	local r2zw = e(r2)
	if ("`absorb'"!=""){ 
		areg `*' `if' `ab' `cluster'
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

end


use "REPLICATION_TABLE 1-2_DAT_PREP_V02.dta", clear

*RUN MODELS

**INSTRUMENT AS AMPLIFIER
capture matrix drop sv_
foreach v in 04g 02g 00g 04p 02p 00p {
	compareregs vote`v' phone_contact , absorb(treat_al) cluster(uniqpct)
	matrix sv_ = nullmat(sv_)\ e(bet)
}
compareregs vote04g phone_contact vote04p vote02g vote02p vote00p vote00g, absorb(treat_all) cluster(uniqpct)
matrix sv_ = nullmat(sv_)\ e(bet)
compareregs vote04p phone_contact vote02g vote02p vote00p vote00g, absorb(treat_all) cluster(uniqpct)
matrix sv_ = nullmat(sv_)\ e(bet)
ssc install mat2txt
mat2txt , matrix(sv_) saving(table1_GOTV_amp_Instrument.xls) replace
matrix list sv_

**FIXED EFFECTS AS AMPLIFIERS
capture matrix drop sv_
foreach v in 04g 02g 00g 04p 02p 00p {
	compareregs vote`v' phone_contact , absorb(uniqpct) cluster(uniqpct)
	matrix sv_ = nullmat(sv_)\ e(bet)
}
compareregs vote04g phone_contact vote04p vote02g vote02p vote00p vote00g, absorb(uniqpct) cluster(uniqpct)
matrix sv_ = nullmat(sv_)\ e(bet)
compareregs vote04p phone_contact vote02g vote02p vote00p vote00g, absorb(uniqpct) cluster(uniqpct)
matrix sv_ = nullmat(sv_)\ e(bet)
mat2txt , matrix(sv_) saving(table2_GOTV_amp_FE.xls) replace
matrix list sv_
