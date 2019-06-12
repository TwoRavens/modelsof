version 14

* set directory here (the folder where the subfolders are located)
* global repldirjop "insert here"
cd "$repldirjop"

use create_continuous_treatment\presscoverage.dta, clear // (Stata 14 dataset)

capture log close
log create_continuous_treatment\using continuous_indicator.log, replace

ren *Zeitung* *Z*
ren *Nachrichten* *N*
ren *Nachri* *N*
ren *Presse* *P*
ren *Tageblatt* *T*
ren *Tag* *T*
ren Süddeutsche* S*
ren *Rundschau* *R*
ren MünchnerAbendzei* MünchnerAZ*


foreach v of var Summe-SZ_aff {
qui sum `v'
gen `v'_insd = `v'/r(sd)
}

cor *aff_insd //  Neumarkter, Nordbayer, Erlanger different
spearman *_aff_insd  // very similar

drop  NeumarkterN* NordbayerischeN* ErlangerN*
drop SummeAlle*

egen affair_cont = rmean(*_aff_insd)

gsort -affair_cont 
list name affair_cont 

log close
