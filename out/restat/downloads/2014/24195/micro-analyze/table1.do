*** Creates Numbers for Table 1

clear
set mem 500m

capture log close
log using table1.log, replace text

capture program drop doall
program define doall

clear
use ../censusmicro/census`1'

keep if hoursamp==1

if `1'==80 {
   gen perwt = 1
}

egen totwt = sum(perwt), by(Dage Dedu size_a)
egen betab = sum(perwt*lincwgb/totwt), by(Dage Dedu size_a)
gen residb = lincwgb-betab
gen hsb = betab if Dedu==2
gen colb = betab if Dedu==4|Dedu==5

#delimit ;
collapse 
(sd) sdwb=lincwgb sdeb=residb
(p10) p10wb=lincwgb p10eb=residb
(p50) p50wb=lincwgb p50eb=residb
(p90) p90wb=lincwgb p90eb=residb [aw=perwt];
#delimit cr

gen varwb = sdwb^2
gen wb9050 = p90wb-p50wb
gen wb5010 = p50wb-p10wb
gen vareb = sdeb^2
gen eb9050 = p90eb-p50eb
gen eb5010 = p50eb-p10eb

l varwb wb9050 wb5010 vare eb9050 eb5010 

end

doall 80
doall 90
doall 00
doall 07

log close

