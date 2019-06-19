** construction regressions by decile for figure 3

set trace off
set more 1 
capture log close
clear
clear matrix
set mem 31g
set matsize 11000
set maxvar 32767
set linesize 200
version 9

log using figure3.log, replace

use placeann.dta if sfus~=., clear
drop if dlrgasp1at==. | husf80==.
drop if cbsa==.
drop if micro==1
egen nobs = count(sfus), by(newid)

tab year, gen(y)
tab year if nobs==28
egen msayear = group(cbsa year)
reg sfus dlrgasp1t24up dlrgasp2t24up dlrgasp3t24up dlrgasp4t24up dlrgasp1d dlrgasp2d dlrgasp3d dlrgasp4d dlfrm1t24up dlfrm2t24up dlfrm3t24up dlfrm4t24up  dlgdp1t24up dlgdp2t24up dlgdp3t24up dlgdp4t24up [w=husf80]
keep if e(sample)

egen mark = tag(newid) if e(sample)
xtile temp = avgtime80 if mark==1, nq(10)
table temp, c(m avgtime80)
egen avgtimedec = mean(temp), by(newid)
quietly tab avgtimedec, gen(timed)
quietly for num 2/10: gen dlrgasp1tdX = dlrgasp1*timedX \  gen dlrgasp2tdX = dlrgasp2*timedX\  gen dlrgasp3tdX = dlrgasp3*timedX \ gen dlrgasp4tdX = dlrgasp4*timedX
quietly for num 2/10: gen dlgdp1tdX = dlgdp1*timedX \  gen dlgdp2tdX = dlgdp2*timedX\  gen dlgdp3tdX = dlgdp3*timedX \ gen dlgdp4tdX = dlgdp4*timedX
quietly for num 2/10: gen dlfrm1tdX = dlfrm1*timedX \  gen dlfrm2tdX = dlfrm2*timedX\  gen dlfrm3tdX = dlfrm3*timedX \ gen dlfrm4tdX = dlfrm4*timedX

gen btd = 0 if avgtimedec==1
gen seutd = 0 if avgtimedec==1
gen sedtd = 0 if avgtimedec==1
xi: areg sfus dlrgasp1td2-dlrgasp4td10 dlgdp1td2-dlgdp4td10  dlfrm1td2-dlfrm4td10 dlrgasp1d dlrgasp2d dlrgasp3d dlrgasp4d i.newid [w=husf80], cluster(cbsa) absorb(msayear)
for num 2/10: lincom dlrgasp1tdX+dlrgasp2tdX+dlrgasp3tdX+dlrgasp4tdX \ replace btd = r(estimate) if avgtimedec==X \ replace seutd = btd+2*r(se) if avgtimedec==X\ replace sedtd = btd-2*r(se) if avgtimedec==X
lab var avgtimedec "Decile of Average Commute Time"
drop mark
egen mark = tag(avgtimedec) if btd~=.
sort avgtimedec
gr7 btd seutd sedtd avgtimedec if mark==1, yline(0) ylab(-.1(.02).04) key1(c(l) s(o) "Cumulative 4-year effect") key2(c(l[-]) "+/- 2 standard errors") c(ll[-]l[-]) s(o..) xlab(1(1)10) saving(fig2, replace) l1("Effect on Housing Stock")



quietly log off
quietly log close
set more 0
