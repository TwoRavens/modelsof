clear
set more off

cap program drop regs
program regs
	args outcome yr quart
	
	use vndba_merged, clear
	
	regress `outcome' below md_* ab bc cd de i.date_score vmb22-vt54 if qdate==yq(`yr', `quart') [aw=oweight20], nocons robust cluster(villageid)

	*save output
	g indexnum = _n 
	keep if indexnum==1
	keep indexnum
	g depvar="`outcome'"
	g year=`yr'
	g quarter=`quart'
	g coeff=_b[below]
	g se=_se[below]
	drop ind
	global counter=$counter+1 
	save F$counter, replace
end

do firstclose .2 1 1
keep below md_* ab bc cd de oweight usid villageid qdate vmb22-vt54
rename qdate date_score
merge 1:n usid using vndba_ym
keep if _merge==3
drop _merge
save vndba_merged, replace

global counter=0
use vndba_merged, clear

foreach Y of num 1964 {
	foreach Q of num 2/4 {
		regs en_init `Y' `Q' 
	}
}

foreach Y of num 1965/1969 {
	foreach Q of num 1/4 {
		regs en_init `Y' `Q' 
	}
}

use F1, clear
foreach c of num 2/$counter {
	append using F`c'
}


g period=.

local counter=1

foreach Y of num 1964 {
	foreach Q of num 2/4 {
		replace period=`counter' if (year==`Y' & quarter==`Q')
		local counter=`counter'+1
	}
}
			
foreach Y of num 1965/1969 {
	foreach Q of num 1/4 {
		replace period=`counter' if (year==`Y' & quarter==`Q')
		local counter=`counter'+1
	}
}
g cp5=coeff+1.96*se
g cn5=coeff-1.96*se

g cp10=coeff+1.65*se
g cn10=coeff-1.65*se
outsheet using vndba_rf.csv, comma replace




