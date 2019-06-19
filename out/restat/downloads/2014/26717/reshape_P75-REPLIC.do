* Graphs
* ======
clear
clear matrix
set more off
set mem 700m
set maxvar 32767

use  synthresults_merged_Killed_P75.dta, clear

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1


preserve
	drop *synth*
	keep  YearsFromLD   gdppccteus_*_*PL*_100


	* Placebo Average Treatment effects
	local placebosfor_P75_11		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_24		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_33		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_34		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_38		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_41		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_51		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_53		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_54		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_56		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_68		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_71		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_76		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
	local placebosfor_P75_77		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_80		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_82		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_84		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_88		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_91		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_94		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_100		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_107		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_116		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_121		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_123		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
	local placebosfor_P75_127		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_128		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
	local placebosfor_P75_129		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
	local placebosfor_P75_132		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_133		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_141		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_153		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
	local placebosfor_P75_159		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
	local placebosfor_P75_173		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"


	

	* Rename for Reshape
	local P75_events "11 24	33	34	38	41	51	53	54	56	68	71	76	77	80	82	84	88	91	94	100	107	116	121	123	127	128	129	132	133	141	153	159	173"
	
foreach event of numlist `P75_events' {
	
	rename  gdppccteus_`event'_PL0_100 gdppccteus_b100_`event'_PL0
	foreach pl of numlist `placebosfor_P75_`event''{
			rename  gdppccteus_`event'_PL`pl'_100 gdppccteus_b100_`event'_PL`pl'
	}
}



	#delimit ;

	reshape long  	gdppccteus_b100_11_PL	                              
					        gdppccteus_b100_24_PL	                              
					        gdppccteus_b100_33_PL	                              
					        gdppccteus_b100_34_PL	                              
					        gdppccteus_b100_38_PL	                              
					        gdppccteus_b100_41_PL	                              
					        gdppccteus_b100_51_PL	                              
					        gdppccteus_b100_53_PL	                              
					        gdppccteus_b100_54_PL	                              
					        gdppccteus_b100_56_PL	                              
					        gdppccteus_b100_68_PL	                              
					        gdppccteus_b100_71_PL	                              
					        gdppccteus_b100_76_PL                               
					        gdppccteus_b100_77_PL                               
					        gdppccteus_b100_80_PL                               
					        gdppccteus_b100_82_PL                               
					        gdppccteus_b100_84_PL                               
					        gdppccteus_b100_88_PL                               
					        gdppccteus_b100_91_PL                               
					        gdppccteus_b100_94_PL                               
					        gdppccteus_b100_100_PL                              
					        gdppccteus_b100_107_PL                              
							  gdppccteus_b100_116_PL                              
							  gdppccteus_b100_121_PL                              
							  gdppccteus_b100_123_PL                              
							  gdppccteus_b100_127_PL                              
							  gdppccteus_b100_128_PL                              
							  gdppccteus_b100_129_PL                              
							  gdppccteus_b100_132_PL                              
							  gdppccteus_b100_133_PL                              
							  gdppccteus_b100_141_PL                              
							  gdppccteus_b100_153_PL                              
							  gdppccteus_b100_159_PL                              
							  gdppccteus_b100_173_PL , i(YearsFromLD) j(Placebo) ;

	#delimit cr


	sort  YearsFromLD Placebo
	saveold	 gdppccteus_Placebos_Killed_P75.dta, replace

restore

preserve

	keep  YearsFromLD   *PL*synth*_100


	* Placebo Average Treatment effects
		local placebosfor_P75_11		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_24		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_33		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_34		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_38		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_41		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_51		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_53		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_54		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_56		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_68		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_71		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_76		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
		local placebosfor_P75_77		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_80		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_82		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_84		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_88		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_91		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_94		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_100		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_107		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_116		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_121		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_123		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
		local placebosfor_P75_127		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_128		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
		local placebosfor_P75_129		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
		local placebosfor_P75_132		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_133		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_141		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_153		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"
		local placebosfor_P75_159		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	148	151	152	163	164	175	   "
		local placebosfor_P75_173		"7	12	15	25	30	36	50	59	61	66	79	83	90	110	117	124	125	126	148	151	152	163	164	175"

	    * Rename for Reshape

		local P75_events "11 24	33	34	38	41	51	53	54	56	68	71	76	77	80	82	84	88	91	94	100	107	116	121	123	127	128	129	132	133	141	153	159	173"


foreach event of numlist `P75_events' {
	
	rename  gdppccteus_`event'_PL0synth_100 gdppccteus_b100synth_`event'_PL0
	foreach pl of numlist `placebosfor_P75_`event''{
			rename  gdppccteus_`event'_PL`pl'synth_100 gdppccteus_b100synth_`event'_PL`pl'
	}
}



			#delimit ;

			reshape long  	gdppccteus_b100synth_11_PL	                                                
					        gdppccteus_b100synth_24_PL	                                                
					        gdppccteus_b100synth_33_PL	                                                
					        gdppccteus_b100synth_34_PL	                                                
					        gdppccteus_b100synth_38_PL	                                                
					        gdppccteus_b100synth_41_PL	                                                
					        gdppccteus_b100synth_51_PL	                                                
					        gdppccteus_b100synth_53_PL	                                                
					        gdppccteus_b100synth_54_PL	                                                
					        gdppccteus_b100synth_56_PL	                                                
					        gdppccteus_b100synth_68_PL	                                                
					        gdppccteus_b100synth_71_PL	                                                
					        gdppccteus_b100synth_76_PL                                                  
					        gdppccteus_b100synth_77_PL                                                  
					        gdppccteus_b100synth_80_PL                                                  
					        gdppccteus_b100synth_82_PL                                                  
					        gdppccteus_b100synth_84_PL                                                  
					        gdppccteus_b100synth_88_PL                                                  
					        gdppccteus_b100synth_91_PL                                                  
					        gdppccteus_b100synth_94_PL                                                  
					        gdppccteus_b100synth_100_PL                                                 
					        gdppccteus_b100synth_107_PL                                                 
                  gdppccteus_b100synth_116_PL                                                 
                  gdppccteus_b100synth_121_PL                                                 
                  gdppccteus_b100synth_123_PL                                                 
                  gdppccteus_b100synth_127_PL                                                 
                  gdppccteus_b100synth_128_PL                                                 
                  gdppccteus_b100synth_129_PL                                                 
                  gdppccteus_b100synth_132_PL                                                 
                  gdppccteus_b100synth_133_PL                                                 
                  gdppccteus_b100synth_141_PL                                                 
                  gdppccteus_b100synth_153_PL                                                 
                  gdppccteus_b100synth_159_PL                                                 
                  gdppccteus_b100synth_173_PL , i(YearsFromLD) j(Placebo) ;                   


				#delimit cr

	sort  YearsFromLD Placebo
	saveold  gdppccteus_Placebos_synthetic_Killed_P75.dta, replace
restore

use gdppccteus_Placebos_Killed_P75.dta
merge YearsFromLD Placebo using gdppccteus_Placebos_synthetic_Killed_P75.dta


local P75_events "11 24	33	34	38	41	51	53	54	56	68	71	76	77	80	82	84	88	91	94	100	107	116	121	123	127	128	129	132	133	141	153	159	173"

* Computes Differences
foreach num of numlist `P75_events'{
		gen diff_b100_`num' = gdppccteus_b100_`num'_PL - gdppccteus_b100synth_`num'_PL
}



keep YearsFromLD Placebo diff_b100_11-diff_b100_173
saveold diffs_Placebos_Killed_P75.dta, replace
