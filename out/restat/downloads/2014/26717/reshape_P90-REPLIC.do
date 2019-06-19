* Graphs
* ======
clear
clear matrix
set more off
set mem 700m
set maxvar 32767

use  synthresults_merged_Killed_P90.dta, clear

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1



preserve
	drop *synth*
	keep  YearsFromLD   gdppccteus_*_*PL*_100


	* Placebo Average Treatment effects
	local placebosfor_P90_26	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_37	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_41	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_44	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_54	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_56	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_79	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	145	164	167	169	170	181	182	192	194			       "
	local placebosfor_P90_80	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_85	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_87	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_91	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_99	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_107	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_117	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_127	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_134	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_138	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_140	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	145	164	167	169	170	181	182	192	194			       "
	local placebosfor_P90_141	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_146	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_156	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_176	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	145	164	167	169	170	181	182	192	194			       "

	* Rename for Reshape
	local P90_events "26 37	41	44	54	56	79	80	85	87	91	99	107	117	127	134	138	140	141	146	156	176"

foreach event of numlist `P90_events' {
	
	rename  gdppccteus_`event'_PL0_100 gdppccteus_b100_`event'_PL0
	foreach pl of numlist `placebosfor_P90_`event''{
			rename  gdppccteus_`event'_PL`pl'_100 gdppccteus_b100_`event'_PL`pl'
	}
}

	#delimit ;

	reshape long  	gdppccteus_b100_26_PL	
					gdppccteus_b100_37_PL	
					gdppccteus_b100_41_PL	
					gdppccteus_b100_44_PL	
					gdppccteus_b100_54_PL	
					gdppccteus_b100_56_PL	
					gdppccteus_b100_79_PL	
					gdppccteus_b100_80_PL	
					gdppccteus_b100_85_PL	
					gdppccteus_b100_87_PL	
					gdppccteus_b100_91_PL	
					gdppccteus_b100_99_PL	
					gdppccteus_b100_107_PL 
					gdppccteus_b100_117_PL 
					gdppccteus_b100_127_PL 
					gdppccteus_b100_134_PL 
					gdppccteus_b100_138_PL 
					gdppccteus_b100_140_PL 
					gdppccteus_b100_141_PL 
					gdppccteus_b100_146_PL 
					gdppccteus_b100_156_PL 
					gdppccteus_b100_176_PL , i(YearsFromLD) j(Placebo) ;

	#delimit cr


	sort  YearsFromLD Placebo
	saveold  gdppccteus_Placebos_Killed_P90.dta, replace

restore

preserve
	keep  YearsFromLD   *PL*synth*_100


	* Placebo Average Treatment effects
	local placebosfor_P90_26	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_37	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_41	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_44	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_54	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_56	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_79	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	145	164	167	169	170	181	182	192	194			       "
	local placebosfor_P90_80	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_85	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_87	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_91	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_99	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_107	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_117	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_127	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	132	135	136	137	139	145	164	167	169	170	181	182	192	194"
	local placebosfor_P90_134	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_138	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_140	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	145	164	167	169	170	181	182	192	194			       "
	local placebosfor_P90_141	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	145	164	167	169	170	181	182	192	194		     "
	local placebosfor_P90_146	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_156	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	137	139	145	164	167	169	170	181	182	192	194	   "
	local placebosfor_P90_176	"8	12	13	16	27	33	36	39	53	57	59	62	64	69	71	74	82	83	86	93	95	120	128	135	136	145	164	167	169	170	181	182	192	194			       "

	* Rename for Reshape

	local P90_events "26 37	41	44	54	56	79	80	85	87	91	99	107	117	127	134	138	140	141	146	156	176"


foreach event of numlist `P90_events' {
	
	rename  gdppccteus_`event'_PL0synth_100 gdppccteus_b100synth_`event'_PL0
	foreach pl of numlist `placebosfor_P90_`event''{
			rename  gdppccteus_`event'_PL`pl'synth_100 gdppccteus_b100synth_`event'_PL`pl'
	}
}



#delimit ;

	reshape long  	gdppccteus_b100synth_26_PL	
					gdppccteus_b100synth_37_PL	
					gdppccteus_b100synth_41_PL	
					gdppccteus_b100synth_44_PL	
					gdppccteus_b100synth_54_PL	
					gdppccteus_b100synth_56_PL	
					gdppccteus_b100synth_79_PL	
					gdppccteus_b100synth_80_PL	
					gdppccteus_b100synth_85_PL	
					gdppccteus_b100synth_87_PL	
					gdppccteus_b100synth_91_PL	
					gdppccteus_b100synth_99_PL	
					gdppccteus_b100synth_107_PL 
					gdppccteus_b100synth_117_PL 
					gdppccteus_b100synth_127_PL 
					gdppccteus_b100synth_134_PL 
					gdppccteus_b100synth_138_PL 
					gdppccteus_b100synth_140_PL 
					gdppccteus_b100synth_141_PL 
					gdppccteus_b100synth_146_PL 
					gdppccteus_b100synth_156_PL 
					gdppccteus_b100synth_176_PL , i(YearsFromLD) j(Placebo) ;

#delimit cr


	sort  YearsFromLD Placebo
	saveold  gdppccteus_Placebos_synthetic_Killed_P90.dta, replace

restore

use gdppccteus_Placebos_Killed_P90.dta
merge YearsFromLD Placebo using gdppccteus_Placebos_synthetic_Killed_P90.dta


local P90_events "26 37	41	44	54	56	79	80	85	87	91	99	107	117	127	134	138	140	141	146	156	176"


* Computes Differences
foreach num of numlist `P90_events'{
		gen diff_b100_`num' = gdppccteus_b100_`num'_PL - gdppccteus_b100synth_`num'_PL
}

keep YearsFromLD Placebo diff_b100_26-diff_b100_176
saveold diffs_Placebos_Killed_P90.dta, replace
