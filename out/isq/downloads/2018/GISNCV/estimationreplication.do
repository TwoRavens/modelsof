/*****************************************************/
/*This do file replicates tables A-1 and A-2 from ****/
/*Hegre et al 2013 "Predicting Armed Conflict 2010 - */
/* 2050.											 */
/*It calls on the dataset estimationaset_withlags.dta*/
/*the table contains 9 estimated models, this do file*/
/*replicates these 9 models one by one				 */
/*Estimation is done in STATA version 11.2			 */
/*****************************************************/

capture log close
clear all
set mem 1g
pwd

use estimationdata_withlags.dta, clear 

/*Define constraints*/

/* Constraints for PKO paper */
constraint define 1 [1]ltsc2 = 0
constraint define 2 [2]ltsc1 = 0
constraint define 11 [1]let = [2]let
constraint define 12 [1]lyo = [2]lyo
constraint define 13 [1]lpos0 = [2]lpos0
constraint define 14 [1]leds0 = [2]leds0
constraint define 15 [1]lyon = [2]lyon
constraint define 16 [1]lnc1 = [2]lnc1
constraint define 17 [1]lnc1c1 = [2]lnc1c1
constraint define 18 [1]lnc1c2 = [2]lnc1c2
constraint define 19 [1]r4 = [2]r4
constraint define 20 [1]r7 = [2]r7


/* Constraints for history variables */
constraint define 99 [1]ltsc2 = 0
constraint define 100 [2]ltsc1 = 0


/*With changes names*/
/*Baseline Model*/
constraint define 103 [1]lli = 0
constraint define 104 [2]lli = 0
constraint define 105 [1]led = 0
constraint define 106 [2]led = 0
constraint define 107 [1]loi = 0
constraint define 108 [2]loi = 0
constraint define 109 [1]let = 0
constraint define 110 [2]let = 0
constraint define 111 [1]lyo = 0
constraint define 112 [2]lyo = 0
constraint define 113 [1]llpo = 0
constraint define 114 [2]llpo = 0
constraint define 115 [1]llin = 0
constraint define 116 [2]llin = 0
constraint define 117 [1]ledn = 0
constraint define 118 [2]ledn = 0
constraint define 119 [1]lyon = 0
constraint define 120 [2]lyon = 0
constraint define 121 [1]limc1 = 0
constraint define 122 [2]limc1 = 0
constraint define 123 [1]limc2 = 0
constraint define 124 [2]limc2 = 0
constraint define 125 [1]lims0 = 0
constraint define 126 [2]lims0 = 0
constraint define 127 [1]lyoc1 = 0
constraint define 128 [2]lyoc1 = 0
constraint define 129 [1]lyoc2 = 0
constraint define 130 [2]lyoc2 = 0
constraint define 131 [1]lyos0 = 0
constraint define 132 [2]lyos0 = 0
constraint define 133 [1]lpoc1 = 0
constraint define 134 [2]lpoc1 = 0
constraint define 135 [1]lpoc2 = 0
constraint define 136 [2]lpoc2 = 0
constraint define 137 [1]lpos0 = 0
constraint define 138 [2]lpos0 = 0
constraint define 139 [1]ledc1 = 0
constraint define 140 [2]ledc1 = 0
constraint define 141 [1]ledc2 = 0
constraint define 142 [2]ledc2 = 0
constraint define 143 [1]leds0 = 0
constraint define 144 [2]leds0 = 0
constraint define 145 [1]loic1 = 0
constraint define 146 [2]loic1 = 0
constraint define 147 [1]loic2 = 0
constraint define 148 [2]loic2 = 0
constraint define 149 [1]lois0 = 0
constraint define 150 [2]lois0 = 0
constraint define 151 [1]letc1 = 0
constraint define 152 [2]letc1 = 0
constraint define 153 [1]letc2 = 0
constraint define 154 [2]letc2 = 0
constraint define 155 [1]lets0 = 0
constraint define 156 [2]lets0 = 0
constraint define 157 [1]lnc1 = 0
constraint define 158 [2]lnc1 = 0
constraint define 159 [1]lnc1c1 = 0
constraint define 160 [2]lnc1c1 = 0

/*B) alle same in both equations*/
/*101-102*/
/*Limr*/
constraint define 180 [1]lli = [2]lli
constraint define 181 [1]limc1 = [2]limc1
constraint define 182 [1]limc2 = [2]limc2
constraint define 183 [1]lims0 = [2]lims0
/*youth*/
constraint define 185 [1]lyo = [2]lyo
constraint define 186 [1]lyoc1 = [2]lyoc1
constraint define 187 [1]lyoc2 = [2]lyoc2
constraint define 188 [1]lyos0 = [2]lyos0
/*lpop*/
constraint define 190 [1]llpo = [2]llpo
constraint define 191 [1]lpoc1 = [2]lpoc1
constraint define 192 [1]lpoc2 = [2]lpoc2
constraint define 193 [1]lpos0 = [2]lpos0
/*edu*/
constraint define 195 [1]led = [2]led
constraint define 196 [1]ledc1 = [2]ledc1
constraint define 197 [1]ledc2 = [2]ledc2
constraint define 198 [1]leds0 = [2]leds0
/*limrn*/
constraint define 200 [1]llin = [2]llin
/*edun*/
constraint define 201 [1]ledn = [2]ledn
/*youtn*/
constraint define 202 [1]lyon = [2]lyon
/*oil*/
constraint define 205 [1]loi = [2]loi
constraint define 206 [1]loic1 = [2]loic1
constraint define 207 [1]loic2 = [2]loic2
constraint define 208 [1]lois0 = [2]lois0
/*etdo4590*/
constraint define 210 [1]let = [2]let
constraint define 211 [1]letc1 = [2]letc1
constraint define 212 [1]letc2 = [2]letc2
constraint define 213 [1]lets0 = [2]lets0
/*neighbor*/
constraint define 214 [1]lnc1 = [2]lnc1
constraint define 215 [1]lnc1c1 = [2]lnc1c1
constraint define 216 [1]lnc1ts0 = [2]lnc1ts0

/*END OF Part, Constraints*/

/*Model m23*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
	 llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(103/112 115/156 99/100)
	 
/*Model m43*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(107/110 115/120 145/156 99/100)

/*Model m45*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(107/110 119/120 145/156 99/100)

/*Model m48*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons( 99/100)

/*Model m66*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(121/156 99/100)

/*Model m67*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(121/126 180 99/100)

/*Model m96*/

mlogit conflict  c1 c2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(121/156 157 159 118 99/100)

/*Model m97*/

mlogit conflict  c1 c2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
     llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	 if year >= 1970 & year <= 2009,baseoutcome(0) cons(107/110 119/120 145/156 121 111 131 136 138 116 190 201 214/216 99/100)

/*Model m98*/

mlogit conflict lc1 lc2 ltsc0 ltsc1 ltsc2 loi loic1 loic2 lois0 let letc1 letc2 lets0 lli limc1 limc2 lims0 lyo lyoc1 lyoc2 lyos0 ///
    llpo lpoc1 lpoc2 lpos0 led ledc1 ledc2 leds0 llin ledn lyon lnc1 lnc1c1 lnc1c2 lnc1ts0 r4 r6 r7 ///
	if year >= 1970 & year <= 2009,baseoutcome(0) cons(121/156 157 159 118 99/100)


/*END OF Do-File, estimationreplication*/


