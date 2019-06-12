* Loading data, requiring user's personal file pathway
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
* District of Columbia not used in the multivariate analysis
drop if state=="District of Columbia"
* command for Table 1
sum cerscore charterfactor neafactor gradratechange diffusion gradrateaveragechange reducedenroll reducedteachers dempercent governor reduceddeficit gsp citizenideo
* commands for Table 2
* "Initial year model" column of Table 2
gen charterXgrad = charterfactor * gradratechange
reg cerscore charterfactor gradratechange charterXgrad diffusion dempercent governor reducedenroll reducedteachers reduceddeficit gsp if downcer==1 & afterdummy==1, cluster(state)
* "Baseline model" column of Table 2
xtmixed cerscore charterfactor gradratechange diffusion gradrateaveragechange dempercent governor reducedenroll reducedteachers reduceddeficit gsp if downcer==1 || stateid: citizenideo, mle
* "Full model" column of Table 2
gen diffXgrad = diffusion * gradrateaveragechange
xtmixed cerscore charterfactor gradratechange charterXgrad diffusion gradrateaveragechange diffXgrad dempercent governor reducedenroll reducedteachers reduceddeficit gsp if downcer==1 || stateid: citizenideo, mle
* commands for Table 3
* "Initial year model" column of Table 3
gen neaXgrad = neafactor * reversedgradratechange
reg cerscore neafactor reversedgradratechange neaXgrad diffusion dempercent governor reducedenroll reducedteachers reduceddeficit gsp if upcer==1 & afterdummy==1, cluster(state)
* "Baseline model" column of Table 3
xtmixed cerscore neafactor reversedgradratechange diffusion gradrateaveragechange dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if upcer==1, mle
* "Full model" column of Table 3
xtmixed cerscore neafactor reversedgradratechange neaXgrad diffusion gradrateaveragechange diffXgrad dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if upcer==1, mle
* "Binary interaction" column of Table 3
gen neaXfall = neafactor * fallinggradrates
xtmixed cerscore neafactor fallinggradrates neaXfall diffusion gradrateaveragechange diffXgrad dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if upcer==1, mle
* commands for Table 4
* "Baseline model" column of Table 4
xtmixed cerscore diffusion gradrateaveragechange charterfactor neafactor dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if middlethird==1, mle
* "Full model" column of Table 4
xtmixed cerscore diffusion gradrateaveragechange diffXgrad charterfactor neafactor dempercent governor reducedenroll reducedteachers reduceddeficit gsp || stateid: citizenideo if middlethird==1, mle
