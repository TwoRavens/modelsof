use diffs_Placebos_P99-NICA.dta,  clear
sort  Placebo  YearsFromLD

foreach num of numlist 145  {

	gen SPE_`num' = diff_b100_`num'^2  if YearsFromLD>=-11 & YearsFromLD<=-1
	egen MSPE_`num' = mean(SPE_`num')  if YearsFromLD>=-11 & YearsFromLD<=-1, by( Placebo )
 	gen RMSPE_`num' = sqrt(MSPE_`num')
	egen RMSPE_`num'full = max(RMSPE_`num') , by (Placebo)

}
    mkmat RMSPE_145full                                        if Placebo==0 & YearsFromLD==-1, matrix(RMSPE)	
	matrix list RMSPE

local j = 1


  foreach num of numlist 145        {
	gen badmatch_`num' = (RMSPE_`num'full > RMSPE[1,`j'])
	replace diff_b100_`num'=. if badmatch_`num'==1
	local j = `j' + 1
}

  keep  YearsFromLD Placebo diff_b100_145

