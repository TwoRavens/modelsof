clear
capture log close
set more 1
set mem 100m

*Prepare estimates from learning model for simulations

cd C:\learning
clear
insheet treatment id2 id learning_delta lamda_f lamda_v psi betaAD_1 betaG_1 ll foo using learningestimates.txt, tab
sort treatment id
save learningestimates, replace
use datdf1, clear
sort treatment id match round
merge treatment id using learningestimates
gen double pg_1 = betag_1/(betag_1+betaad_1)
gen double strength_1 = betag_1+betaad_1
drop if round ~= 1
collapse treatment id2 learning_delta lamda_f lamda_v psi betaad_1 betag_1 ll pg_1 strength_1 coop ocoop _merge, by(id)
rename _merge _merge2
sort treatment id
save learningestimates, replace
replace learning_delta=1 if ll==.
replace lamda_v=0.00000001 if ll==.
replace lamda_v=0 if lamda_v==.
replace lamda_f=0.00000001 if ll==.
replace psi=0 if ll==.
replace betaad_1=10.0e+100 if ll==. & coop==0
replace betag_1=0 if ll==. & coop==0
replace betaad_1=0 if ll==. & coop==1
replace betag_1=10.0e+100 if ll==. & coop==1
replace ll=999 if ll==.
drop id id2 coop ocoop _merge pg_1 strength_1
sort treatment
by treatment: gen id=_n
outsheet treatment id learning_delta lamda_f lamda_v psi betaad_1 betag_1 using learningestimatesall.txt, nonames replace
drop id
drop if ll==999
sort treatment
by treatment: gen id=_n
outsheet treatment id learning_delta lamda_f lamda_v psi betaad_1 betag_1 using learningestimates.txt, nonames replace

