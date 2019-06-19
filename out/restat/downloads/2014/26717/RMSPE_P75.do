use diffs_Placebos_Killed_P75.dta,  clear
sort  Placebo  YearsFromLD

local P75_events "11 24	33	34	38	41	51	53	54	56	68	71	76	77	80	82	84	88	91	94	100	107	116	121	123	127	128	129	132	133	141	153	159	173"

foreach num of numlist `P75_events' {

	gen SPE_`num' = diff_b100_`num'^2  if YearsFromLD>=-11 & YearsFromLD<=-1
	egen MSPE_`num' = mean(SPE_`num')  if YearsFromLD>=-11 & YearsFromLD<=-1, by( Placebo )
 	gen RMSPE_`num' = sqrt(MSPE_`num')
	egen RMSPE_`num'full = max(RMSPE_`num') , by (Placebo)

}

#delimit ;

mkmat RMSPE_11full                                                 
	    RMSPE_24full                                                 
	    RMSPE_33full                                                 
	    RMSPE_34full                                                 
	    RMSPE_38full                                                 
	    RMSPE_41full                                                 
	    RMSPE_51full                                                 
	    RMSPE_53full                                                 
	    RMSPE_54full                                                 
	    RMSPE_56full                                                 
	    RMSPE_68full                                                 
	    RMSPE_71full                                                 
	    RMSPE_76full                                                 
	    RMSPE_77full                                                 
	    RMSPE_80full                                                 
	    RMSPE_82full                                                 
	    RMSPE_84full                                                 
	    RMSPE_88full                                                 
	    RMSPE_91full                                                 
	    RMSPE_94full                                                 
	    RMSPE_100full                                                
	    RMSPE_107full                                                
      RMSPE_116full                                                
      RMSPE_121full                                                
      RMSPE_123full                                                
      RMSPE_127full                                                
      RMSPE_128full                                                
      RMSPE_129full                                                
      RMSPE_132full                                                
      RMSPE_133full                                                
      RMSPE_141full                                                
      RMSPE_153full                                                
      RMSPE_159full                                                
      RMSPE_173full if Placebo==0 & YearsFromLD==-1, matrix(RMSPE);


#delimit cr
		  
	matrix list RMSPE

local j = 1

foreach num of numlist `P75_events' {
	gen badmatch_`num' = (RMSPE_`num'full > RMSPE[1,`j'])
	replace diff_b100_`num'=. if badmatch_`num'==1
	local j = `j' + 1
}

#delimit ;

keep  YearsFromLD Placebo diff_b100_11  
                          diff_b100_24  
                          diff_b100_33  
                          diff_b100_34  
                          diff_b100_38  
                          diff_b100_41  
                          diff_b100_51  
                          diff_b100_53  
                          diff_b100_54  
                          diff_b100_56  
                          diff_b100_68  
                          diff_b100_71  
                          diff_b100_76  
                          diff_b100_77  
                          diff_b100_80  
                          diff_b100_82  
                          diff_b100_84  
                          diff_b100_88  
                          diff_b100_91  
                          diff_b100_94  
                          diff_b100_100 
                          diff_b100_107 
                          diff_b100_116 
                          diff_b100_121 
                          diff_b100_123 
                          diff_b100_127 
                          diff_b100_128 
                          diff_b100_129 
                          diff_b100_132 
                          diff_b100_133 
                          diff_b100_141 
                          diff_b100_153 
                          diff_b100_159 
                          diff_b100_173;


#delimit cr

