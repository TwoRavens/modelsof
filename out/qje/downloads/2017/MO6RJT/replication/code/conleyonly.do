set matsize 5000
set logtype text
capture log close
log using conleylog.txt, replace

use data1_regs, clear
replace x = 179.99 if x == -180
gen const = 1
gen year = 1
gen idcell = _n

global agriculture "biomes1 biomes2_3 biomes4 biomes5 biomes6 biomes7_9 biomes8 biomes10 biomes11 biomes12 biomes14 tmp precip growday landsuit lat elv"
global trade "coastal distc harbor25 river25 lake25"
global base "rugged malariaecol"
global allx $base $agriculture $trade

eststo clear
ols_spatial_HAC lrad2010clip_pl_c $allx nats*, lat(y) lon(x) t(year) p(idcell) dist(30) lag(0) disp
eststo

esttab using "output/conley.tex", replace compress title("Conley SE")

log close