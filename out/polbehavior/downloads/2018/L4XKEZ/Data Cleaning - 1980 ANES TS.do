clear all
capture log close
set more off 
use "NES80INT (raw).dta"

*Survey
	rename VIN2001 survey
	label def surv 1 "Major Panel" 2 "Minor Panel" 3 "Time Series"
	label values survey surv


*****Interest & Education: so that 'informed' placements can be obtained for below'
	*follow politics*
		gen follow = . 
		replace follow = 1 if VIN1305 == 4
		replace follow = 2 if VIN1305 == 3
		replace follow = 3 if VIN1305 == 2
		replace follow = 4 if VIN1305 == 1
		label var follow "Follow Politics" 
		label def fol 1 "Hardly at All" 4 "Most of the Time"
		label values follow fol
		summ follow 
		gen follow01 = (follow - r(min))/(r(max)-r(min))
		label var follow01 "Follow Politics"
		
	*Education*
		gen educ = . 
		replace educ = 1 if VIN1490 >= 1 & VIN1490 <= 4
		replace educ = 2 if VIN1490 >= 5 & VIN1490 <= 6
		replace educ = 3 if VIN1490 >= 7 & VIN1490 <= 8
		replace educ = 4 if VIN1490 >= 9 & VIN1490 <= 10
		label var educ "Education" 
		label def ed 1 "< HS" 2 "HS" 3 "Some College" 4 "College+" 
		label values educ ed

		summarize educ
		gen educ01 = (educ - r(min))/(r(max)-r(min))

		gen educ1 = . 
		replace educ1 = 1 if VIN1490 >= 1 & VIN1490 <= 4
		replace educ1 = 2 if VIN1490 >= 5 & VIN1490 <= 6
		replace educ1 = 3 if VIN1490 >= 7 & VIN1490 <= 8
		replace educ1 = 4 if VIN1490 >= 9 & VIN1490 <= 10
		replace educ1 = 5 if educ == . 
		label var educ1 "Education" 
		label def ed1 1 "< HS" 2 "HS" 3 "Some College" 4 "College+" 5 "Missing Education"
		label values educ1 ed1

			

**********Dependent Variable: Vote Choice****************
		gen vote = . 
		replace vote = 1 if VIN0379 == 1
		replace vote = 0 if VIN0379 == 2
		label def v8 1 "Reagan" 0 "Carter" 
		label values vote v8
		label var vote "Vote Choice"


**********Main Ind. Variable: Policy Attitude, Importance, Proximity****************
	
******************************
*******Defense Spending*******
******************************

	**Attitude, Extremity, Importance*
		rename VIN1081 defense80
		mvdecode defense80 , mv(0 = . \ 8 = . \ 9 = .) 
		label def def 1 "Greatly Decrease" 7 "Greatly Increase"
		label values defense80 def
		label var defense80 "Defense Spending Attitude"

		gen defense80ext = . 
		replace defense80ext = 4  if defense80 == 7
		replace defense80ext = 4  if defense80 == 1
		replace defense80ext = 3  if defense80 == 2
		replace defense80ext = 3  if defense80 == 6
		replace defense80ext = 2  if defense80 == 3
		replace defense80ext = 2  if defense80 == 5
		replace defense80ext = 1  if defense80 == 4
		label var defense80ext "Defense Spending: Extremity"

		summarize defense80ext
		gen defense80ext01 = (defense80ext - `r(min)')/(`r(max)'-`r(min)')
		label var defense80ext01 "Defense Spending: Extremity"

		rename VIN1092 defense80imp
		mvdecode defense80imp , mv(888 = . \ 998 = . \ 999 = .)
		label var defense80imp "Defense Spending: Importance"

		gen defense80imp_square = defense80imp*defense80imp

		gen defense80imp_cat = . 
		replace defense80imp_cat = 1 if defense80imp >= 0 & defense80imp <= 59
		replace defense80imp_cat = 2 if defense80imp >= 60 & defense80imp <= 89
		replace defense80imp_cat = 3 if defense80imp >= 90 & defense80imp <= 99
		replace defense80imp_cat = 4 if defense80imp == 100
		label var defense80imp_cat "Defense Spending: Importance (Categorical)"

	**Candidate Placements*
		*Reagan*
		rename VIN1083 reagandefense80
		mvdecode reagandefense80, mv(0 = . \ 8 = . \ 9 = .) 
		label var reagandefense80 "Reagan Placement: Defense"
		*Carter*
		rename VIN1082 carterdefense80
		mvdecode carterdefense80, mv(0 = . \ 8 = . \ 9 = .) 
		label var carterdefense80 "Carter Placement: Defense"

	**Proximity Scores*
		*City Block: Sample Mean
			summarize reagandefense80 carterdefense80
			*Regan mean: 5.25765**
 			*Carter mean: 4.110299	

			gen defense80prox = abs(defense80 - 4.110299) - abs(defense80 - 5.25765)
			label var defense80prox "Proximity: Defense Spending"

		**City Block: informed mean
			summarize reagandefense80 carterdefense80 if follow == 4 & educ == 4
			*cater: 4.283088 
			*regan: 5.714286

			gen defense80prox_info = abs(defense80 - 4.283088) - abs(defense80 - 5.714286)
			label var defense80prox_info "Proximity: Defense Spending (Informed Placement)"

		**City Block: Self-placement*
			gen defense80prox_self = abs(defense80 - carterdefense80) - abs(defense80 - reagandefense80)
			label var defense80prox_self "Prox: Defense (Self-Placement)"

		*euclidean
			gen defense80prox_euclid1 = [(defense80 - 4.110299)*(defense80 - 4.110299)] - [(defense80 - 5.25765)*(defense80 - 5.25765)]
			gen defense80prox_euclid2 = [(defense80 - 4.283088)*(defense80 - 4.283088)] - [(defense80 - 5.714286)*(defense80 - 5.714286)]
			gen defense80prox_euclid3 = [(defense80 - carterdefense80)*(defense80 - carterdefense80)] - [(defense80 - reagandefense80)*(defense80 - reagandefense80)]

	*creating 0-1 scales and standarizations*
		foreach var in defense80imp defense80prox defense80imp_cat defense80imp_square defense80prox_info defense80prox_self ///
				defense80prox_euclid1 defense80prox_euclid2 defense80prox_euclid3  {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

			}
	
		label var defense80prox01 "Defense: Prox"
		label var defense80prox_info01 "Defense: Prox (Informed)"
		label var defense80prox_self01 "Defense: prox (Self)"
		label var defense80prox_euclid101 "Defense: Prox (Euclid)"
		label var defense80prox_euclid201 "Defense: Prox (Euclid:Info)"
		label var defense80prox_euclid301 "Defense: Prox (Euclid:Self)"

******************************
*****Spending & Services******
******************************
		
	*Self and Candidate Placements*
		gen spend80 = . 
		replace spend80 = 1 if VIN1114 == 7
		replace spend80 = 2 if VIN1114 == 6
		replace spend80 = 3 if VIN1114 == 5
		replace spend80 = 4 if VIN1114 == 4
		replace spend80 = 5 if VIN1114 == 3
		replace spend80 = 6 if VIN1114 == 2
		replace spend80 = 7 if VIN1114 == 1

		gen carterspend80 = . 
		replace carterspend80 = 1 if VIN1115 == 7
		replace carterspend80 = 2 if VIN1115 == 6
		replace carterspend80 = 3 if VIN1115 == 5
		replace carterspend80 = 4 if VIN1115 == 4
		replace carterspend80 = 5 if VIN1115 == 3
		replace carterspend80 = 6 if VIN1115 == 2
		replace carterspend80 = 7 if VIN1115 == 1

		gen reaganspend80 = . 
		replace reaganspend80 = 1  if VIN1116 == 7
		replace reaganspend80 = 2  if VIN1116 == 6
		replace reaganspend80 = 3  if VIN1116 == 5
		replace reaganspend80 = 4  if VIN1116 == 4
		replace reaganspend80 = 5  if VIN1116 == 3
		replace reaganspend80 = 6  if VIN1116 == 2
		replace reaganspend80 = 7  if VIN1116 == 1

		label def spen 1 "No Reduction in Spending" 7 "Provide Many Fewer Services"
		label values spend80 spen
		label values carterspend80 spen
		label values reaganspend80 spen


	****Proximity*
		*sample mean
			summarize carterspend80 reaganspend80
			*carter: 3.143243
			*reagan: 4.503513

			gen spend80prox = abs(spend80 - 3.143243) - abs(spend80 - 4.503513)
			label var spend80prox "Proximity: Spending & Services"

		*informed mean*
			summarize carterspend80 reaganspend80 if follow == 4 & educ == 4
			*carter: 2.988764
			*reagan: 5.226721
			gen spend80prox_info = abs(spend80 - 2.988764) - abs(spend80 - 5.226721)

		*self
			gen spend80prox_self = abs(spend80 - carterspend80) - abs(spend80 - reaganspend80)

		*euclidean
			gen spend80prox_euclid1 = [(spend80 - 3.143243)*(spend80 - 3.143243)] - [(spend80 - 4.503513)*(spend80 - 4.503513)]
			gen spend80prox_euclid2 = [(spend80 - 2.988764)*(spend80 - 2.988764)] - [(spend80 - 5.226721)*(spend80 - 5.226721)]
			gen spend80prox_euclid3 = [(spend80 - carterspend80)*(spend80 - carterspend80)] - [(spend80 - reaganspend80)*(spend80 - reaganspend80)]

			summ spend80prox_info spend80prox_self spend80prox_euclid*

		*Attitude Strength*
			gen spend80ext = . 
			replace spend80ext = 4  if spend80 == 7
			replace spend80ext = 4  if spend80 == 1
			replace spend80ext = 3  if spend80 == 2
			replace spend80ext = 3  if spend80 == 6
			replace spend80ext = 2  if spend80 == 3
			replace spend80ext = 2  if spend80 == 5
			replace spend80ext = 1  if spend80 == 4
			label var spend80ext "Spending/Services: Extremity"

			rename  VIN1125 spend80imp
			mvdecode spend80imp , mv(888 = . \ 998 = . \ 999 = .)
			label var spend80imp "Spend/Services: Importance"

			gen spend80imp_square = spend80imp*spend80imp

			gen spend80imp_cat = . 
			replace spend80imp_cat = 1 if spend80imp >= 0 & spend80imp <= 59
			replace spend80imp_cat = 2 if spend80imp >= 60 & spend80imp <= 89
			replace spend80imp_cat = 3 if spend80imp >= 90 & spend80imp <= 99
			replace spend80imp_cat = 4 if spend80imp == 100
			label var spend80imp_cat "Spending & Services: Importance (Categorical)"


		*0-1 scales and standardized versions*
			foreach var in spend80prox spend80ext spend80imp spend80imp_square spend80imp_cat spend80prox_info ///
				spend80prox_self spend80prox_euclid1 spend80prox_euclid2 spend80prox_euclid3 {
					qui sum `var'
					gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
				}
				
			label var spend80prox01 "Spending: Prox"
			label var spend80prox_info01 "Spending: Prox (Informed)"
			label var spend80prox_self01 "Spending: prox (Self)"
			label var spend80prox_euclid101 "Spending: Prox (Euclid)"
			label var spend80prox_euclid201 "Spending: Prox (Euclid:Info)"
			label var spend80prox_euclid301 "Spending: Prox (Euclid:Self)"

******************************
*******Abortion***************
******************************

	*own position, candidate positions*
		gen abortion80 = . 
		replace abortion80 = 1 if VIN1234 == 4
		replace abortion80 = 2 if VIN1234 == 3
		replace abortion80 = 3 if VIN1234 == 2
		replace abortion80 = 4 if VIN1234 == 1
		label var abortion80 "Abortion Attitude"

		gen carterabortion80 = . 
		replace carterabortion80 = 1 if VIN1235 == 4
		replace carterabortion80 = 2 if VIN1235 == 3
		replace carterabortion80 = 3 if VIN1235 == 2
		replace carterabortion80 = 4 if VIN1235 == 1
		label var carterabortion80 "Carter: Abortion"

		gen reaganabortion80 = . 
		replace reaganabortion80 = 1 if VIN1236 == 4
		replace reaganabortion80 = 2 if VIN1236 == 3
		replace reaganabortion80 = 3 if VIN1236 == 2
		replace reaganabortion80 = 4 if VIN1236 == 1
		label var reaganabortion80 "Reagan: Abortion"
		label def abor 1 "Always able to obtain" 4 "never permitted" 
		label values abortion80 abor
		label values carterabortion80 abor
		label values reaganabortion80 abor

	**Proximity*	

		*sample
			summarize carterabortion80 reaganabortion80
			*carter: 2.369985
			*regan: 2.862408
			gen abortion80prox = abs(abortion80 - 2.369985) - abs(abortion80 - 2.862408)
			label var abortion80prox "Abortion: Proximity"

		*informed*
			summarize carterabortion80 reaganabortion80 if follow ==4 & educ == 4
			*carter: 2.169014
			*regan: 2.959184
			gen abortion80prox_info = abs(abortion80 - 2.169014) - abs(abortion80 - 2.959184)

		*self
			gen abortion80prox_self = abs(abortion80 - carterabortion80) - abs(abortion80 - reaganabortion80)

		*euclid
			gen abortion80prox_euclid1 = [(abortion80 - 2.369985)*(abortion80 - 2.369985)] - [(abortion80 - 2.862408)*(abortion80 - 2.862408)]
			gen abortion80prox_euclid2 = [(abortion80 - 2.169014)*(abortion80 - 2.169014)] - [(abortion80 - 2.959184)*(abortion80 - 2.959184)]
			gen abortion80prox_euclid3 = [(abortion80 - carterabortion80)*(abortion80 - carterabortion80)] - [(abortion80 - reaganabortion80)*(abortion80 - reaganabortion80)]

			summarize abortion80prox abortion80prox_info abortion80prox_self abortion80prox_euclid*


	**Attitude Importance***
		rename  VIN1243 abortion80imp
		mvdecode abortion80imp , mv(888 = . \ 998 = . \ 999 = .)
		label var abortion80imp "Abortion: Importance"

		gen abortion80imp_square = abortion80imp*abortion80imp

		gen abortion80imp_cat = . 
		replace abortion80imp_cat = 1 if abortion80imp >= 0 & abortion80imp <= 59
		replace abortion80imp_cat = 2 if abortion80imp >= 60 & abortion80imp <= 89
		replace abortion80imp_cat = 3 if abortion80imp >= 90 & abortion80imp <= 99
		replace abortion80imp_cat = 4 if abortion80imp == 100
		label var abortion80imp_cat "Abortion: Importance (Categorical)"


	*0-1 scales and standardized versions*
		foreach var in abortion80prox abortion80imp abortion80imp_square abortion80imp_cat abortion80prox_info ///
			abortion80prox_self abortion80prox_euclid1 abortion80prox_euclid2 abortion80prox_euclid3 {
			qui sum `var'
			gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
		}
	
		label var abortion80prox01 "Abortion: Prox"
		label var abortion80prox_info01 "Abortion: Prox (Informed)"
		label var abortion80prox_self01 "Abortion: prox (Self)"
		label var abortion80prox_euclid101 "Abortion: Prox (Euclid)"
		label var abortion80prox_euclid201 "Abortion: Prox (Euclid:Info)"
		label var abortion80prox_euclid301 "Abortion: Prox (Euclid:Self)"
	

******************************
*******Aid to Blacks**********
******************************
		
	*own position and candidate placements*
		rename VIN1222 blackaid80
		rename VIN1223 carterblackaid80
		rename VIN1224 reaganblackaid80
		mvdecode blackaid80 carterblackaid80 reaganblackaid80, mv(0 = . \ 8 = . \ 9 = .) 

	***proximity*
		*sample
			summarize carterblackaid80 reaganblackaid80
			*carter: 3.322942
			*reagan: 4.760019
			gen blackaid80prox = abs(blackaid80 - 3.322942) - abs(blackaid80 - 4.760019)
			label var blackaid80prox "Aid to Blacks: Proximity"

		*informed
			summarize carterblackaid80 reaganblackaid80 if follow == 4 & educ == 4
			*carter: 3.0495057
			*reagan: 5.211155
			gen blackaid80prox_info = abs(blackaid80 - 3.0495057) - abs(blackaid80 - 5.211155)
			
		*self
			gen blackaid80prox_self = abs(blackaid80 - carterblackaid80) - abs(blackaid80 - reaganblackaid80)


		*euclid
			gen blackaid80prox_euclid1 = [(blackaid80 - 3.322942)*(blackaid80 - 3.322942)] - [(blackaid80 - 4.760019)*(blackaid80 - 4.760019)]
			gen blackaid80prox_euclid2 = [(blackaid80 - 3.0495057) *(blackaid80 - 3.0495057)] - [(blackaid80 - 5.211155) * (blackaid80 - 5.211155)]
			gen blackaid80prox_euclid3 = [(blackaid80 - carterblackaid80)*(blackaid80 - carterblackaid80)] - [(blackaid80 - reaganblackaid80) * (blackaid80 - reaganblackaid80)]

			summ blackaid80prox blackaid80prox_info blackaid80prox_self blackaid80prox_euclid*


	*Attitude Strength: Imp and Ext*
		gen blackaid80ext = . 
		replace blackaid80ext = 4  if blackaid80 == 7
		replace blackaid80ext = 4  if blackaid80 == 1
		replace blackaid80ext = 3  if blackaid80 == 2
		replace blackaid80ext = 3  if blackaid80 == 6
		replace blackaid80ext = 2  if blackaid80 == 3
		replace blackaid80ext = 2  if blackaid80 == 5
		replace blackaid80ext = 1  if blackaid80 == 4
		label var blackaid80ext "Aid to Blacks: Extremity"

		rename  VIN1233 blackaid80imp
		mvdecode blackaid80imp , mv(888 = . \ 998 = . \ 999 = .)
		label var blackaid80imp "Aid to Blacks: Importance"

		gen blackaid80imp_square = blackaid80imp*blackaid80imp

		gen blackaid80imp_cat = . 
		replace blackaid80imp_cat = 1 if blackaid80imp >= 0 & blackaid80imp <= 59
		replace blackaid80imp_cat = 2 if blackaid80imp >= 60 & blackaid80imp <= 89
		replace blackaid80imp_cat = 3 if blackaid80imp >= 90 & blackaid80imp <= 99
		replace blackaid80imp_cat = 4 if blackaid80imp == 100
		label var blackaid80imp_cat "Spending & Services: Importance (Categorical)"


	*0-1 scales and standardized versions*
		foreach var in blackaid80prox blackaid80ext blackaid80imp blackaid80imp_square blackaid80imp_cat blackaid80prox_info ///
			blackaid80prox_self blackaid80prox_euclid1 blackaid80prox_euclid2 blackaid80prox_euclid3 {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
			}

			
		label var blackaid80prox01 "Aid to Blacks: Prox"
		label var blackaid80prox_info01 "Aid to Blacks: Prox (Informed)"
		label var blackaid80prox_self01 "Aid to Blacks: prox (Self)"
		label var blackaid80prox_euclid101 "Aid to Blacks: Prox (Euclid)"
		label var blackaid80prox_euclid201 "Aid to Blacks: Prox (Euclid:Info)"
		label var blackaid80prox_euclid301 "Aid to Blacks: Prox (Euclid:Self)"

		
******************************
*******Unemployment vs.******* 
*******Inflation**************
******************************

	*own attitude/candidate placements
		gen unemploy80 = . 
		replace unemploy80 = 1  if VIN1048 == 7
		replace unemploy80 = 2  if VIN1048 == 6
		replace unemploy80 = 3  if VIN1048 == 5
		replace unemploy80 = 4  if VIN1048 == 4
		replace unemploy80 = 5  if VIN1048 == 3
		replace unemploy80 = 6  if VIN1048 == 2
		replace unemploy80 = 7  if VIN1048 == 1

		gen carterunemploy80 = . 
		replace carterunemploy80 = 1 if VIN1049 == 7
		replace carterunemploy80 = 2 if VIN1049 == 6
		replace carterunemploy80 = 3 if VIN1049 == 5
		replace carterunemploy80 = 4 if VIN1049 == 4
		replace carterunemploy80 = 5 if VIN1049 == 3
		replace carterunemploy80 = 6 if VIN1049 == 2
		replace carterunemploy80 = 7 if VIN1049 == 1

		gen reaganunemploy80 = .
		replace reaganunemploy80 = 1 if VIN1050 == 7
		replace reaganunemploy80 = 2 if VIN1050 == 6
		replace reaganunemploy80 = 3 if VIN1050 == 5
		replace reaganunemploy80 = 4 if VIN1050 == 4
		replace reaganunemploy80 = 5 if VIN1050 == 3
		replace reaganunemploy80 = 6 if VIN1050 == 2
		replace reaganunemploy80 = 7 if VIN1050 == 1

		label def une 1 "reduce unemployment" 7 "reduce inflation" 
		label values unemploy80 une
		label values carterunemploy80 une
		label values reaganunemploy80 une

	**Proximity*
		summarize carterunemploy80 reaganunemploy80
			*carter: 3.679863
			*reagan* 4.35981
			gen unemploy80prox = abs(unemploy80 - 3.679863) - abs(unemploy80 - 4.35981)
			label var unemploy80prox "Unemployment: Proximity"

		*info
			summarize carterunemploy80 reaganunemploy80 if follow ==4 & educ == 4
			*carter: 3.689655
			*reagan* 5.141509
			gen unemploy80prox_info = abs(unemploy80 - 3.689655) - abs(unemploy80 - 5.141509)

		*self
			gen unemploy80prox_self = abs(unemploy80 - carterunemploy80) - abs(unemploy80 - reaganunemploy80)

		*euclid
			gen unemploy80prox_euclid1 = [(unemploy80 - 3.679863)*(unemploy80 - 3.679863)] - [(unemploy80 - 4.35981) * (unemploy80 - 4.35981)]
			gen unemploy80prox_euclid2 = [(unemploy80 - 3.689655)*(unemploy80 - 3.689655)] - [(unemploy80 - 5.141509) *(unemploy80 - 5.141509)]
			gen unemploy80prox_euclid3 = [(unemploy80 - carterunemploy80)*(unemploy80 - carterunemploy80)] - [(unemploy80 - reaganunemploy80)*(unemploy80 - reaganunemploy80)]

			summ unemploy80prox unemploy80prox_info unemploy80prox_self unemploy80prox_euclid*

	*Attitude Strength**
		gen unemploy80ext = . 
		replace unemploy80ext = 4  if unemploy80 == 7
		replace unemploy80ext = 4  if unemploy80 == 1
		replace unemploy80ext = 3  if unemploy80 == 2
		replace unemploy80ext = 3  if unemploy80 == 6
		replace unemploy80ext = 2  if unemploy80 == 3
		replace unemploy80ext = 2  if unemploy80 == 5
		replace unemploy80ext = 1  if unemploy80 == 4
		label var unemploy80ext "Unemployment: Extremity"

		rename  VIN1059 unemploy80imp
		mvdecode unemploy80imp , mv(888 = . \ 998 = . \ 999 = .)
		label var unemploy80imp "Unemployment: Importance"

		gen unemploy80imp_square = unemploy80imp*unemploy80imp


		gen unemploy80imp_cat = . 
		replace unemploy80imp_cat = 1 if unemploy80imp >= 0 & unemploy80imp <= 59
		replace unemploy80imp_cat = 2 if unemploy80imp >= 60 & unemploy80imp <= 89
		replace unemploy80imp_cat = 3 if unemploy80imp >= 90 & unemploy80imp <= 99
		replace unemploy80imp_cat = 4 if unemploy80imp == 100
		label var unemploy80imp_cat "Unemployment: Importance (Categorical)"


	*0-1 scales and standardized versions*	
		foreach var in unemploy80prox unemploy80imp unemploy80imp_square unemploy80imp_cat unemploy80ext ///
				unemploy80prox_info unemploy80prox_self unemploy80prox_euclid1 unemploy80prox_euclid2 unemploy80prox_euclid3  {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

			}

		label var unemploy80prox01 "Unemployment: Prox"
		label var unemploy80prox_info01 "Unemployment: Prox (Informed)"
		label var unemploy80prox_self01 "Unemployment: prox (Self)"
		label var unemploy80prox_euclid101 "Unemployment: Prox (Euclid)"
		label var unemploy80prox_euclid201 "Unemployment: Prox (Euclid:Info)"
		label var unemploy80prox_euclid301 "Unemployment: Prox (Euclid:Self)"
	
******************************
*******Jobs & SOL*************
******************************

	*Candidate and self placement
		rename VIN1177 jobs80
		rename VIN1178 carterjobs80
		rename VIN1179 reaganjobs80
		mvdecode jobs80 carterjobs80 reaganjobs80, mv(0 = . \ 8 = . \ 9 = .) 
		label def jo 1 "Gov't See to a Job" 7 "Gov't Let Each Person Alone"
		label values jobs80 jo
		label values carterjobs80 jo
		label values reaganjobs80 jo
		
	*Proximity*
		*city block: sample
			summarize carterjobs80 reaganjobs80
			*carter: 3.543441
			*reagan: 4.876177
			gen jobs80prox = abs(jobs80 - 3.543441) - abs(jobs80 - 4.876177)
			label var jobs80prox

		*info
			summarize carterjobs80 reaganjobs80 if follow == 4 & educ == 4
			*carter: 3.344828
			*reagan: 5.466403
			gen jobs80prox_info = abs(jobs80 - 3.344828) - abs(jobs80 - 5.466403)

		*self
			gen jobs80prox_self = abs(jobs80 - carterjobs80) - abs(jobs80 - reaganjobs80)

		*euclid
			gen jobs80prox_euclid1 = [(jobs80 - 3.543441)*(jobs80 - 3.543441)] - [(jobs80 - 4.876177)*(jobs80 - 4.876177)]
			gen jobs80prox_euclid2 = [(jobs80 - 3.344828)*(jobs80 - 3.344828)] - [(jobs80 - 5.466403)*(jobs80 - 5.466403)]
			gen jobs80prox_euclid3 = [(jobs80 - carterjobs80)*(jobs80 - carterjobs80)] - [(jobs80 - reaganjobs80)*(jobs80 - reaganjobs80)]

			summ jobs80prox jobs80prox_info jobs80prox_self jobs80prox_euclid*


	*Attitude Strength**
		gen jobs80ext = . 
		replace jobs80ext = 4  if jobs80 == 7
		replace jobs80ext = 4  if jobs80 == 1
		replace jobs80ext = 3  if jobs80 == 2
		replace jobs80ext = 3  if jobs80 == 6
		replace jobs80ext = 2  if jobs80 == 3
		replace jobs80ext = 2  if jobs80 == 5
		replace jobs80ext = 1  if jobs80 == 4
		label var jobs80ext "Jobs: Extremity"

		rename  VIN1188 jobs80imp
		mvdecode jobs80imp , mv(888 = . \ 998 = . \ 999 = .)
		label var jobs80imp "Jobs: Importance"

		gen jobs80imp_square = jobs80imp*jobs80imp

		gen jobs80imp_cat = . 
		replace jobs80imp_cat = 1 if jobs80imp >= 0 & jobs80imp <= 59
		replace jobs80imp_cat = 2 if jobs80imp >= 60 & jobs80imp <= 89
		replace jobs80imp_cat = 3 if jobs80imp >= 90 & jobs80imp <= 99
		replace jobs80imp_cat = 4 if jobs80imp == 100
		label var jobs80imp_cat "Jobs: Importance (Categorical)"


	*0-1 scales and standardized versions*
		foreach var in jobs80prox jobs80imp jobs80imp_square jobs80imp_cat jobs80ext jobs80prox_info ///
			jobs80prox_self jobs80prox_euclid1 jobs80prox_euclid2 jobs80prox_euclid3 {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

			}
	
		label var jobs80prox01 "Jobs: Prox"
		label var jobs80prox_info01 "Jobs: Prox (Informed)"
		label var jobs80prox_self01 "Jobs: prox (Self)"
		label var jobs80prox_euclid101 "Jobs: Prox (Euclid)"
		label var jobs80prox_euclid201 "Jobs: Prox (Euclid:Info)"
		label var jobs80prox_euclid301 "Jobs: Prox (Euclid:Self)"


******************************
*******Russia*****************
******************************

	*Own and candidate placements	
		rename VIN1189 russia80
		rename VIN1190 carterrussia80
		rename VIN1191 reaganrussia80
		mvdecode russia80 carterrussia80 reaganrussia80, mv(0 = . \ 8 = . \ 9 = .) 
		label def russ 1 "Get Along with Russia" 7 "Big Mistake to Do So"
		label values russia80 russ
		label values carterrussia80 russ
		label values reaganrussia80 russ

	*Proximity*
		*City block: sample
			summarize carterrussia80 reaganrussia80
			*carter: 3.213121
			*reagan: 4.44708
			gen russia80prox = abs(russia80 - 3.213121) - abs(russia80 - 4.44708)
			label var russia80prox

		*info
			summarize carterrussia80 reaganrussia80 if follow == 4 & educ == 4
			*carter: 3.032374
			*reagan: 4.912

			gen russia80prox_info = abs(russia80 - 3.032374) - abs(russia80 - 4.912)

		*self
			gen russia80prox_self = abs(russia80 - carterrussia80) - abs(russia80 - reaganrussia80)

		*euclid
			gen russia80prox_euclid1 = [(russia80 - 3.213121)*(russia80 - 3.213121) ] - [ (russia80 - 4.44708)*(russia80 - 4.44708) ] 
			gen russia80prox_euclid2 = [(russia80 - 3.032374)*(russia80 - 3.032374)  ] - [(russia80 - 4.912)*(russia80 - 4.912)  ] 
			gen russia80prox_euclid3 = [(russia80 - carterrussia80)*(russia80 - carterrussia80)  ] - [(russia80 - reaganrussia80)*(russia80 - reaganrussia80)  ] 

			summ russia80prox*


	*Attitude Strength**
		gen russia80ext = . 
		replace russia80ext = 4  if russia80 == 7
		replace russia80ext = 4  if russia80 == 1
		replace russia80ext = 3  if russia80 == 2
		replace russia80ext = 3  if russia80 == 6
		replace russia80ext = 2  if russia80 == 3
		replace russia80ext = 2  if russia80 == 5
		replace russia80ext = 1  if russia80 == 4
		label var russia80ext "Russia: Extremity"

		rename  VIN1200 russia80imp
		mvdecode russia80imp , mv(888 = . \ 998 = . \ 999 = .)
		label var russia80imp "Russia: Importance"

		gen russia80imp_square = russia80imp*russia80imp


		gen russia80imp_cat = . 
		replace russia80imp_cat = 1 if russia80imp >= 0 & russia80imp <= 59
		replace russia80imp_cat = 2 if russia80imp >= 60 & russia80imp <= 89
		replace russia80imp_cat = 3 if russia80imp >= 90 & russia80imp <= 99
		replace russia80imp_cat = 4 if russia80imp == 100
		label var russia80imp_cat "Russia: Importance (Categorical)"


	*0-1 scales and standardized versions*
		foreach var in russia80prox russia80imp russia80imp_square russia80imp_cat russia80ext russia80prox_info ///
			russia80prox_self russia80prox_euclid1 russia80prox_euclid2 russia80prox_euclid3 {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

			}
	
	label var russia80prox01 "Russia: Prox"
	label var russia80prox_info01 "Russia: Prox (Informed)"
	label var russia80prox_self01 "Russia: prox (Self)"
	label var russia80prox_euclid101 "Russia: Prox (Euclid)"
	label var russia80prox_euclid201 "Russia: Prox (Euclid:Info)"
	label var russia80prox_euclid301 "Russia: Prox (Euclid:Self)"


**********Control Variables****************
*PID*
	gen pid = VIN0801 + 1
	mvdecode pid, mv(8 = . \ 9 = . \ 10 = .)
	label var pid "Party ID"
	label def pi 1 "Str. Democrat" 4 "Pure Ind." 7 "str. Republican"
	label values pid pi
	summarize pid
	gen pid01 = (pid - `r(min)') / (`r(max)'-`r(min)')

*Ideology*
	gen ideology = VIN0944
	mvdecode ideology, mv(0 = . \ 8 = . \ 9 = .)
	label def ideo 1 "Ext. Liberal" 4 "Moderate" 7 "Ext. Conservative" 
	label values ideology ideo
	summarize ideology
	gen ideology1 = (ideology - `r(min)')/(`r(max)'-`r(min)')

	gen ideology2 = VIN0944
	recode ideology2 (8 = 0) (9 = 0)
	recode ideology2 (0 = 8)
	label var ideology "Ideology" 
	label var ideology2 "Ideology (Full)"
	label def ideo1 8 "Haven't Thought Much/DK/NA" 1 "Ext. Liberal"  7 "Ext. Conservative" 4 "Moderate"
	label values ideology2 ideo1
	
	recode VIN0944 (1=1) (2=1) (3=1) (4=2) (5=3) (6=3) (7=3) (8=4) (9=4) (0=4), gen(ideol)
	label var ideol "Ideology"
	label def ida 1 "Liberal" 2 "Moderate" 3 "Conservative" 4 "Haven't Thought/DK/NA"
	label values ideol ida

	recode VIN0944 (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4) (8=1) (9=1) (0=1), gen(ideol_str)
	label var ideol_str "Ideology Str." 
	
	gen ideology_p2 = VIN0957
	mvdecode ideology_p2, mv(0 = . \ 8 = . \ 9 = .)
	label values ideology_p2 ideo

	gen ideology_p21 = VIN0957
	mvdecode ideology_p21, mv(8 = . \ 9 = .)
	recode ideology_p21 (0 = 8) 
	label values ideology_p21 ideo1

	gen ideology_p3c3 = VIN0969
	mvdecode ideology_p3c3, mv(0 = . \ 8 = . \ 9 = .)
	label values ideology_p3c3 ideo

	gen ideology_p3c31 = VIN0969
	mvdecode ideology_p3c31, mv(8 = . \ 9 = .)
	recode ideology_p3c31 (0 = 8) 
	label values ideology_p3c31 ideo1


	*Race*
		gen race = . 
		replace race = 1 if VIN1702 >=2 & VIN1702 <=7
		replace race = 0 if VIN1702 == 1
		label def nonwh1 1 "Non-White" 0 "White" 
		label values race nonwh1
		label var race "Race" 

		gen hispanic = .
		replace hispanic = 1 if VIN1703 >=1 & VIN1703 <= 3
		replace hispanic = 0 if VIN1703 >= 5 & VIN1703 <= 8
		label var hispanic "Hispanic" 
		label def his 1 "Hispanic" 0 "Non-Hispanic"

	*Age*
		rename VIN1454 age
		replace age = . if age == 0
		label var age "Age" 

		foreach var in age {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

			}


	*Gender*
		gen gender = .
		replace gender = 1 if VIN1701 == 2
		replace gender = 0 if VIN1701 == 1
		label var gender "Gender"
		label def gen 1 "Female" 0 "Male"
		label values gender gen

	*Income*
		rename VIN1666 famincome
		rename VIN1667 income
		mvdecode famincome income, mv(0 = . \ 98 = . \ 99 = .) 

		egen income_pct = cut(income), group(10) label
		gen income_miss = . 
		replace income_miss = 1 if income == .
		gen income_pct1 = income_pct 
		replace income_pct1 = 10 if income_miss == 1 & income_pct1 == . 
		label def inc_mis1 10 "Missing Income"


		egen famincome_pct = cut(famincome), group(10) label

		gen famincome_miss = .
		replace famincome_miss = 1 if famincome == . 
		replace famincome_miss = 0 if famincome !=.

		gen famincome_pct1 = famincome_pct 
		replace famincome_pct1 = 11 if famincome_miss == 1 & famincome_pct1 == .
		label def inc_mis2 10 "Missing Income" 
		label values famincome_pct1 inc_mis

		foreach var in income famincome {
				qui sum `var'
				gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

			}

	**Candidate Traits*

	*Carter*
		label def trai 1 "Not Well at All" 4 "Extremely Well"
		gen carter80moral = . 
		replace carter80moral = 1 if VIN0657 == 4
		replace carter80moral = 2 if VIN0657 == 3
		replace carter80moral = 3 if VIN0657 == 2
		replace carter80moral = 4 if VIN0657 == 1
		gen carter80knowl = . 
		replace carter80knowl = 1 if VIN0660 == 4
		replace carter80knowl = 2 if VIN0660 == 3
		replace carter80knowl = 3 if VIN0660 == 2
		replace carter80knowl = 4 if VIN0660 == 1
		gen carter80leader = . 
		replace carter80leader = 1 if VIN0664 == 4
		replace carter80leader = 2 if VIN0664 == 3
		replace carter80leader = 3 if VIN0664 == 2
		replace carter80leader = 4 if VIN0664 == 1
		label values carter80moral trai
		label values carter80knowl trai
		label values carter80leader trai

	*reagan80*
		gen reagan80moral = . 
		replace reagan80moral = 1 if VIN0684 == 4
		replace reagan80moral = 2 if VIN0684 == 3
		replace reagan80moral = 3 if VIN0684 == 2
		replace reagan80moral = 4 if VIN0684 == 1
		gen reagan80knowl = . 
		replace reagan80knowl = 1 if VIN0687 == 4
		replace reagan80knowl = 2 if VIN0687 == 3
		replace reagan80knowl = 3 if VIN0687 == 2
		replace reagan80knowl = 4 if VIN0687 == 1
		gen reagan80leader =  .
		replace reagan80leader = 1 if VIN0691 == 4
		replace reagan80leader = 2 if VIN0691 == 3
		replace reagan80leader = 3 if VIN0691 == 2
		replace reagan80leader = 4 if VIN0691 == 1
		label values reagan80leader trai
		label values reagan80knowl trai
		label values reagan80moral trai

		*Comparative Traits*
			gen moral80 = reagan80moral - carter80moral
			gen knowl80 = reagan80knowl - carter80knowl
			gen leader80 = reagan80leader - carter80leader

			foreach var in carter80moral carter80knowl carter80leader reagan80moral reagan80knowl reagan80leader moral80 knowl80 leader80 {
					qui sum `var'
					gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
				}

	*Retrospective Economic Evaluations* 
		gen econ80 = .
		replace econ80 = 1 if VIN1022 == 5
		replace econ80 = 2 if VIN1022 == 4
		replace econ80 = 3 if VIN1022 == 3
		replace econ80 = 4 if VIN1022 == 2
		replace econ80 = 5 if VIN1022 == 1
		label def eco 1 "Much Worse" 3 "About the Same" 5 "Much Better" 
		label values econ80 eco

		summarize econ80 
		gen econ01 = (econ - r(min))/(r(max)-r(min))





