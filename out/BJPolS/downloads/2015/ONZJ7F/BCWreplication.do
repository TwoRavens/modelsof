insheet using BCWreplication.csv, clear
sort kgcid year
xtset kgcid year

*Table 2
logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s  l.indir_diplo_s l.indir_diplo_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s  l.indir_diplo_s l.indir_diplo_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1& prevcivilwar==0, robust
logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s  l.indir_force_new_s l.indir_force_new_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s  l.indir_force_new_s l.indir_force_new_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1& prevcivilwar==0, robust
logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s  l.indir_sanction_s l.indir_sanction_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s  l.indir_sanction_s l.indir_sanction_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1& prevcivilwar==0, robust

*Table A2
logit civilwaronset l.dir_condemn_s l.dir_condemn_other_s  l.indir_condemn_s l.indir_condemn_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_condemn_s l.dir_condemn_other_s  l.indir_condemn_s l.indir_condemn_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis  c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1& prevcivilwar==0, robust
logit civilwaronset l.dir_force_reup_s l.dir_force_reup_other_s  l.indir_force_reup_s l.indir_force_reup_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_reup_s l.dir_force_reup_other_s  l.indir_force_reup_s l.indir_force_reup_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1& prevcivilwar==0, robust

*Table A3
logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s  l.indir_diplo_s l.indir_diplo_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime coldwar eeurop ssafrica asia if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s  l.indir_force_new_s l.indir_force_new_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime coldwar eeurop ssafrica asia if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s  l.indir_sanction_s l.indir_sanction_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime coldwar eeurop ssafrica asia if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_condemn_s l.dir_condemn_other_s  l.indir_condemn_s l.indir_condemn_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime coldwar eeurop ssafrica asia if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_reup_s l.dir_force_reup_other_s  l.indir_force_reup_s l.indir_force_reup_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime coldwar eeurop ssafrica asia if ongoingcivilwar!=1, cluster(kgcid)

*Table A4
logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s  l.indir_diplo_s l.indir_diplo_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime pko if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s  l.indir_force_new_s l.indir_force_new_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime pko if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s  l.indir_sanction_s l.indir_sanction_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime pko if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_condemn_s l.dir_condemn_other_s  l.indir_condemn_s l.indir_condemn_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime pko if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_reup_s l.dir_force_reup_other_s  l.indir_force_reup_s l.indir_force_reup_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime pko if ongoingcivilwar!=1, cluster(kgcid)

*Table A5
logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s  l.indir_diplo_s l.indir_diplo_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime groupsizepercent oilgascount if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s  l.indir_force_new_s l.indir_force_new_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime groupsizepercent oilgascount if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s  l.indir_sanction_s l.indir_sanction_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime groupsizepercent oilgascount if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_condemn_s l.dir_condemn_other_s  l.indir_condemn_s l.indir_condemn_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime  groupsizepercent oilgascount if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_reup_s l.dir_force_reup_other_s  l.indir_force_reup_s l.indir_force_reup_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime  groupsizepercent oilgascount if ongoingcivilwar!=1, cluster(kgcid)

*Table A7
sureg (civilwaronset l.dir_diplo_s l.dir_diplo_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime) (l.dir_diplo_s l.dir_diplo_other_s sumactive_indir  l.logfactions l.prevconcessions_l l.democracy l.kin l.loggdppc l.numgrps l.avgecdis l.coldwar l.western l.p5 l.p5ally) if ongoingcivilwar!=1 &prevcivilwar==0, corr 
sureg (civilwaronset l.dir_sanction_s l.dir_sanction_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime) (l.dir_sanction_s l.dir_sanction_other_s sumactive_indir  l.logfactions l.prevconcessions_l l.democracy l.kin l.loggdppc l.numgrps l.avgecdis l.coldwar l.western l.p5 l.p5ally) if ongoingcivilwar!=1 &prevcivilwar==0, corr 

*Table A8
logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_condemn_s l.dir_condemn_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.dir_force_reup_s l.dir_force_reup_other_s sumactive_indir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)

*Table A9
logit civilwaronset l.indir_diplo_s l.indir_diplo_other_s sumactive_dir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.indir_force_new_s l.indir_force_new_other_s sumactive_dir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.indir_sanction_s l.indir_sanction_other_s sumactive_dir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.indir_condemn_s l.indir_condemn_other_s sumactive_dir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)
logit civilwaronset l.indir_force_reup_s l.indir_force_reup_other_s sumactive_dir logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis c.risktime c.risktime#c.risktime c.risktime#c.risktime#c.risktime if ongoingcivilwar!=1, cluster(kgcid)


*Figure1
*Note that these will only genderate if the simqi.ado file is replaced by the modified one that Travis Braidwood has created: http://travisbraidwood.altervista.org/dataverse.html

clear all
set seed 0210 
set more off, perm  

insheet using BCWreplication.csv, clear
sort kgcid year
xtset kgcid year

estsimp logit civilwaronset l.dir_diplo_s l.dir_diplo_other_s  l.indir_diplo_s l.indir_diplo_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis risktime risktime2 risktime3 if ongoingcivilwar!=1, cluster(kgcid)
preserve
local a =0 

setx mean 
setx l.dir_diplo_s (`a')  democracy 0 kin 1 risktime 2 risktime2 4 risktime3 8 
simqi
macro list
scalar list 

postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 1  {
qui simqi 
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+.1 
setx l.dir_diplo_s (`a') 
display "." _c 
}
display ""

postclose mypost 
use simresults, clear 

sum
gen MV = 0+0.1*(_n-1) 
gsort prediction upper lower -MV 


version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(gs6) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(gs6) sort ///
		ytitle("Predicted Probability of Civil War") xtitle("UNSC Direct Diplomacy Weight") scheme(s1color) legend(off)
		
******************		
clear all
set seed 0210 
set more off, perm  

insheet using BCWreplication.csv, clear
sort kgcid year
xtset kgcid year

estsimp logit civilwaronset l.dir_force_new_s l.dir_force_new_other_s  l.indir_force_new_s l.indir_force_new_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis risktime risktime2 risktime3 if ongoingcivilwar!=1, cluster(kgcid)
preserve
local a =0 

setx mean 
setx l.indir_force_new_s (`a')  democracy 0 kin 1 risktime 2 risktime2 4 risktime3 8 
simqi
macro list
scalar list 

postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 1  {
qui simqi 
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+.1 
setx l.indir_force_new_s (`a') 
display "." _c 
}
display ""

postclose mypost 
use simresults, clear 

sum
gen MV = 0+0.1*(_n-1) 
gsort prediction upper lower -MV 


version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(gs6) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(gs6) sort ///
		ytitle("Predicted Probability of Civil War") xtitle("UNSC Indirect New Force Weight") scheme(s1color) legend(off)

*************
clear all
set seed 0210 
set more off, perm  

insheet using BCWreplication.csv, clear
sort kgcid year
xtset kgcid year

estsimp logit civilwaronset l.dir_sanction_s l.dir_sanction_other_s  l.indir_sanction_s l.indir_sanction_other_s logfactions prevconcessions_l democracy kin loggdppc numgrps avgecdis risktime risktime2 risktime3 if ongoingcivilwar!=1, cluster(kgcid)
preserve
local a =0 

setx mean 
setx l.indir_sanction_s (`a')  democracy 0 kin 1 risktime 2 risktime2 4 risktime3 8 
simqi
macro list
scalar list 

postutil clear
postfile mypost prediction upper lower using simresults, replace 
noisily display "start"
set obs 10000 
while `a' <= 1  {
qui simqi 
scalar prediction= Pr
scalar upper = PrU
scalar lower = PrL
post mypost (prediction) (upper) (lower)
scalar drop prediction upper lower
local a = `a'+.1 
setx l.indir_sanction_s (`a') 
display "." _c 
}
display ""

postclose mypost 
use simresults, clear 

sum
gen MV = 0+0.1*(_n-1) 
gsort prediction upper lower -MV 


version 11
graph twoway  line prediction MV, clwidth(medium) clcolor(black) clpattern(solid) sort ///
        || line lower MV, clpattern(dash) clwidth(thin) clcolor(gs6) sort ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(gs6) sort ///
		ytitle("Predicted Probability of Civil War") xtitle("UNSC Indirect Sanctions Weight") scheme(s1color) legend(off)
		

