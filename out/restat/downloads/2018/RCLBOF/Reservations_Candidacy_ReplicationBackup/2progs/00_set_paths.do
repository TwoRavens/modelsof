//version 12.0
dis "$root"
assert "$root" !="" //assert root capture worked for user
global data "$root/1data/"
global do "$root/2progs/"
global analysis "$root/3analysis/"
global work "$root/4work/"
global prepdata "$root/5prepdata/"
global date=c(current_date)
global time=subinstr(c(current_time),":","",.)
cd "$work" //default directory to put files, although all outputs should be directed via a global macro
set seed 99


cap program drop repl_conf
program define repl_conf
    gettoken varname 0 : 0, parse(=) 
    confirm var `varname' 
    gettoken eq 0 : 0, parse(=) 
    syntax anything [if] 
    qui count `if'
    if r(N) == 0 {
         di as err "NO MATCHES -- NO REPLACE"
         exit 9
    }
    else {
         qui replace `varname' = `anything' `if'
         noi di "SUCCESSFUL REPLACE of >=1 OBS -- " r(N) " OBS replaced"
    }
end

cap program drop drop_conf
program define drop_conf
    syntax [if] 
    qui count `if'
    if r(N) == 0 {
         di as err "NO MATCHES -- NO DROPS"
         exit 9
    }
    else {
         qui drop `if'
         noi di "SUCCESSFUL DROP of >=1 OBS -- " r(N) " OBS DROPPED"
    }
end


cap program drop checkmergevar
program define checkmergevar
syntax varlist using/
    tokenize `varlist';
    preserve
	keep `varlist'
	duplicates drop
	tempfile file1
	save `file1'
	use "`using'", clear
	keep `varlist'
	duplicates drop
	merge 1:1 `varlist' using `file1'
	cap assert _m==3
	local nvars: word count `varlist'
	if _rc==0 dis "full match" 
	else if `nvars'==1 tab `varlist' _m if _m!=3
	else {
	foreach var of local varlist {
		tab `var' _m if _m!=3
	}
	}
	restore
end
