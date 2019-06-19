use diffs_Placebos_Killed_P90.dta,  clear
sort  Placebo  YearsFromLD

local P90_events "26 37	41	44	54	56	79	80	85	87	91	99	107	117	127	134	138	140	141	146	156	176"

foreach num of numlist `P90_events' {

	gen SPE_`num' = diff_b100_`num'^2  if YearsFromLD>=-11 & YearsFromLD<=-1
	egen MSPE_`num' = mean(SPE_`num')  if YearsFromLD>=-11 & YearsFromLD<=-1, by( Placebo )
 	gen RMSPE_`num' = sqrt(MSPE_`num')
	egen RMSPE_`num'full = max(RMSPE_`num') , by (Placebo)

}

#delimit ;

mkmat RMSPE_26full
	RMSPE_37full
	RMSPE_41full
	RMSPE_44full
	RMSPE_54full
	RMSPE_56full
	RMSPE_79full
	RMSPE_80full
	RMSPE_85full
	RMSPE_87full
	RMSPE_91full
	RMSPE_99full
	RMSPE_107full
	RMSPE_117full
	RMSPE_127full
	RMSPE_134full
	RMSPE_138full
	RMSPE_140full
	RMSPE_141full
	RMSPE_146full
	RMSPE_156full
	RMSPE_176full if Placebo==0 & YearsFromLD==-1, matrix(RMSPE);

#delimit cr
		  
	matrix list RMSPE

local j = 1

foreach num of numlist `P90_events' {
	gen badmatch_`num' = (RMSPE_`num'full > RMSPE[1,`j'])
	replace diff_b100_`num'=. if badmatch_`num'==1
	local j = `j' + 1
}

#delimit ;

keep  YearsFromLD Placebo diff_b100_26
diff_b100_37
diff_b100_41
diff_b100_44
diff_b100_54
diff_b100_56
diff_b100_79
diff_b100_80
diff_b100_85
diff_b100_87
diff_b100_91
diff_b100_99
diff_b100_107
diff_b100_117
diff_b100_127
diff_b100_134
diff_b100_138
diff_b100_140
diff_b100_141
diff_b100_146
diff_b100_156
diff_b100_176;

#delimit cr

