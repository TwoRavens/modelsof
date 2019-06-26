
log using "C:\Documents and Settings\David Sobek\My Documents\Work Folder\Rally_Podesta\JPR_marginals.log", replace
clear
set mem 250m
use "C:\Documents and Settings\David Sobek\My Documents\Work Folder\Rally_Podesta\JPR_data2Rep.dta", clear



set matsize 250

sort dyadid year
iis dyadid
tis year

***************************************
*This examines the Republics set *
***************************************

 xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b   regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

mfx compute, at(linten_a=0) nose
mfx compute, at(linten_a=5) nose
mfx compute, at(linten_a=10) nose
mfx compute, at(linten_a=15) nose
mfx compute, at(linten_a=20) nose
mfx compute, at(linten_a=25) nose
mfx compute, at(linten_a=30) nose
mfx compute, at(linten_a=35) nose
mfx compute, at(linten_a=40) nose
mfx compute, at(linten_a=45) nose
mfx compute, at(linten_a=50) nose
mfx compute, at(linten_a=55) nose
mfx compute, at(linten_a=60) nose
mfx compute, at(linten_a=65) nose
mfx compute, at(linten_a=70) nose

***************************************
*This examines the oligarchs    set *
***************************************
clear
use "C:\Documents and Settings\David Sobek\My Documents\Work Folder\Rally_Podesta\JPR_data2Oli.dta", clear

set matsize 250

sort dyadid year
iis dyadid
tis year


 xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b   regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

mfx compute, at(linten_a=0) nose
mfx compute, at(linten_a=5) nose
mfx compute, at(linten_a=10) nose
mfx compute, at(linten_a=15) nose
mfx compute, at(linten_a=20) nose
mfx compute, at(linten_a=25) nose
mfx compute, at(linten_a=30) nose
mfx compute, at(linten_a=35) nose
mfx compute, at(linten_a=40) nose
mfx compute, at(linten_a=45) nose
mfx compute, at(linten_a=50) nose
mfx compute, at(linten_a=55) nose
mfx compute, at(linten_a=60) nose
mfx compute, at(linten_a=65) nose
mfx compute, at(linten_a=70) nose

log close
clear
