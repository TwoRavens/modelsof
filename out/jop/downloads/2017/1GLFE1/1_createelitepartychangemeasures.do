
** Identify and measure party unity votes

use "hdemrep35_112_9.dta", clear
drop if congress<73
gen demvote = demyeas/(demyeas+demnays)
gen repvote = repyeas/(repyeas+repnays)

gen partyvote = 0
replace partyvote = 1 if demvote<.5 & repvote>=.5 & demvote!=. & repvote!=.
replace partyvote = 1 if repvote<.5 & demvote>=.5 & demvote!=. & repvote!=.

gen repweight = partyvote*repvote if repvote>=.5
replace repweight = partyvote*(1-repvote) if repvote<.5
gen demweight = partyvote*demvote if demvote>=.5
replace demweight = partyvote*(1-demvote) if demvote<.5

* create weight to weigh votes by party unity rate on winning side
gen iweight = repweight if yeas>nays & repvote>=.5
replace iweight = demweight if yeas>nays & demvote>=.5 & iweight==.
replace iweight = repweight if nays>yeas & repvote<.5 & iweight==.
replace iweight = demweight if nays>yeas & demvote<.5 & iweight==.

gen voteid = congress*10000 + rcnum
sort voteid

rename congress cong
keep cong voteid partyvote iweight 
save "housepartyvotemerge.dta", replace


** Get vote issue codes

clear
use "H01_112_codes_12.dta"
* correct error in data
replace rcnum = 1392 in 52118

drop if cong<73
gen voteid = cong*10000 + rcnum
sort voteid
keep cong voteid clausen-issue2 descrip
save "houseissuecodemerge.dta", replace

** Now summarize cutpoints

clear
use "HC01112_CUT33_PRE_DATES_9.dta"

drop if cong<73
gen newangle = clangle if clangle>=0
replace newangle = clangle + 180 if clangle<0

gen radians = newangle*(_pi/180)
gen sin = sin(radians)
gen cos = cos(radians)
gen voteid = cong*10000 + rcnum
sort voteid
merge voteid using "housepartyvotemerge.dta"
tab _merge
drop _merge

sort voteid
merge voteid using "houseissuecodemerge.dta"
tab _merge
drop _merge

gen date = mdy(month, day, year)
gen quarter = qofd(date)

gen partyvotesin = sin if partyvote==1
gen partyvotecos = cos if partyvote==1
sort cong

* remove unscaled votes
drop if spread1==0 & mid1==0 & spread2==0 & mid2==0

gen partymid1 = mid1 if partyvote==1 
gen partymid2 = mid2 if partyvote==1
gen partyspread1 = spread1 if partyvote==1
gen partyspread2 = spread2 if partyvote==1


replace clausen = . if clausen==0
tab clausen, gen(aage)

gen partyaage1 = aage1 if partyvote==1
gen partyaage2 = aage2 if partyvote==1
gen partyaage3 = aage3 if partyvote==1
gen partyaage4 = aage4 if partyvote==1
gen partyaage5 = aage5 if partyvote==1
gen partyaage6 = aage6 if partyvote==1


** Summarize cut points to calculate circular mean
** From Armstrong et al. 2014, p. 203-204
gen yea1 = partymid1 - partyspread1
gen yea2w = (partymid2 - partyspread2)*0.4088
gen nay1 = partymid1+partyspread1
gen nay2w = (partymid2+ partyspread2)*0.4088
gen a1 = nay1-yea1
gen a2 = nay2w-yea2w
gen alength = sqrt(a1*a1 + a2*a2)
gen n1w = a1/alength
gen n2w = a2/alength
gen change = 1 if n1w<0 
replace n1w=-n1w if change==1
replace n2w=-n2w if change==1
drop change
gen ws = n1w*partymid1 + n2w*partymid2*0.4088
gen xws = ws*n1w
gen yws = ws*n2w

gen coord1x = xws+n2w
gen coord1y = yws-n1w
gen coord2x = xws-n2w
gen coord2y = yws+n1w	

collapse (min) year (count) countparty=partyvote (mean) n1w n2w ws partyvote partyvotesin partyvotecos  coord1x-coord2y partyaage1-partyaage6 [iw=iweight], by(cong)
format year %ty
tsset cong

gen c1 = n2w
gen c2 = -n1w
gen theta =  atan2(c2,c1) 
gen theta4 = theta*(180/_pi)
replace theta4 = 180+theta4 if theta4<0


** Calculate change in agenda composition

gen sb_party_aage = (abs(d.partyaage1) + abs(d.partyaage2) + abs(d.partyaage3) + abs(d.partyaage4) + abs(d.partyaage5) + abs(d.partyaage6))/2   
gen square_party_aage = ((d.partyaage1)^2 + (d.partyaage2)^2 + (d.partyaage3)^2 + (d.partyaage4)^2 + (d.partyaage5)^2 + (d.partyaage6)^2)   

gen partyradian = atan2(partyvotesin,partyvotecos) 
gen partydegree = partyradian*(180/_pi)

gen abschange = abs(d.partydegree)
gen partyideochange = abschange
gen fpartyideochange = f.partyideochange

sum partyideochange if year>=1953
gen stdpartyideochange = partyideochange/r(mean)
label var stdpartyideochange "Ideo. Change in Party Conflict (Std)"
gen stdfpartyideochange = f.stdpartyideochange

gen partyagendachange = square_party_aage*100
gen fpartyagendachange = f.partyagendachange

sum partyagendachange if year>=1953

gen lagpartyvote = l.partyvote


** Change to yearly data to for merging
keep cong year partyvote lagpartyvote partydegree partyideochange fpartyideochange partyagendachange fpartyagendachange partyaage1-partyaage6
sort year
tsset year
tsfill
tsappend, add(1)
sort year
replace cong = l.cong if cong==.

sort cong

by cong: egen meanpartyvote = mean(partyvote)
replace partyvote = meanpartyvote if partyvote==.
by cong: egen meanlagpartyvote = mean(lagpartyvote)
replace lagpartyvote = meanlagpartyvote if lagpartyvote==.

by cong: egen meanideochange = mean(partyideochange)
replace partyideochange = meanideochange if partyideochange==.
by cong: egen meanfideochange = mean(fpartyideochange)
replace fpartyideochange = meanfideochange if fpartyideochange==.

by cong: egen meanaage = mean(partyagendachange)
replace partyagendachange = meanaage if partyagendachange==.
by cong: egen meanfaage = mean(fpartyagendachange)
replace fpartyagendachange = meanfaage if fpartyagendachange==.

drop meanaage
by cong: egen meanaage = mean(partyaage1)
replace partyaage1 = meanaage if partyaage1==.
drop meanaage
by cong: egen meanaage = mean(partyaage2)
replace partyaage2 = meanaage if partyaage2==.
drop meanaage
by cong: egen meanaage = mean(partyaage3)
replace partyaage3 = meanaage if partyaage3==.
drop meanaage
by cong: egen meanaage = mean(partyaage4)
replace partyaage4 = meanaage if partyaage4==.
drop meanaage
by cong: egen meanaage = mean(partyaage5)
replace partyaage5 = meanaage if partyaage5==.
drop meanaage
by cong: egen meanaage = mean(partyaage6)
replace partyaage6 = meanaage if partyaage6==.

keep year cong partydegree partyvote lagpartyvote partyideochange fpartyideochange partyagendachange fpartyagendachange partyaage1 partyaage2 partyaage3 partyaage4 partyaage5 partyaage6

save "1_elitepartychange.dta", replace
** end
