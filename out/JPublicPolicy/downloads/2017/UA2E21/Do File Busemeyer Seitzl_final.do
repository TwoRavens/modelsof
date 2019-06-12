clear
use "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/Datensatz_BA Lina Seitzl.dta"

xtset Statecode Yearcode

/*gen left=spd_ksa+green_ksa+left_ksa
gen eastwest=0
replace eastwest=1 if Statecod==3 | Statecode==4 | Statecod==8 | Statecod==13 | Statecod==14 | Statecod==16
gen citystate=0
replace citystate=1 if Statecod==3 | Statecod==5 | Statecod==6
*/

*standardize variables
egen zexpedu_gdp=std(expedu_gdp)
egen zexpedu_pc=std(expedu_pc)
egen zexpedu_priv_sum=std(expedu_priv_sum)
egen zleft=std(left)
egen zpop30=std(pop30)
egen zfemlab=std(femlab)
egen zpopdens=std(popdens)
egen zgdp_pc=std(gdp_pc)
egen zgrandcoal=std(grandcoal)
gen zleft_grandcoal=zleft*zgrandcoal


*ECM models

xtpcse d.zexpedu_gdp l.zexpedu_gdp d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc eastwest citystate
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable1.doc", word replace

xtpcse d.zexpedu_pc l.zexpedu_pc d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc eastwest citystate
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable1.doc", word append

xtpcse d.zexpedu_priv_sum l.zexpedu_priv_sum d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc eastwest citystate
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable1.doc", word append


*Beck-Katz models
xtpcse zexpedu_gdp l.zexpedu_gdp l.zleft l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable2.doc", word replace

xtpcse zexpedu_pc l.zexpedu_pc l.zleft l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable2.doc", word append

xtpcse zexpedu_priv_sum l.zexpedu_priv_sum l.zleft l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable2.doc", word append


*additional models
xtpcse zexpedu_gdp l.zexpedu_gdp l.zleft l.zgrandcoal l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable3.doc", word replace

xtpcse zexpedu_gdp l.zexpedu_gdp l.zleft l.zgrandcoal l.zleft_grandcoal l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable3.doc", word append

xtpcse zexpedu_priv_sum l.zexpedu_priv_sum l.zleft l.zgrandcoal l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable3.doc", word append

xtpcse zexpedu_priv_sum l.zexpedu_priv_sum l.zleft l.zgrandcoal l.zleft_grandcoal l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/revtable3.doc", word append



*appendix table(s): with and without FE
xtpcse d.zexpedu_gdp l.zexpedu_gdp d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable1.doc", word replace

xtpcse d.zexpedu_gdp l.zexpedu_gdp d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable1.doc", word append

xtpcse d.zexpedu_pc l.zexpedu_pc d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable1.doc", word append

xtpcse d.zexpedu_pc l.zexpedu_pc d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable1.doc", word append

xtpcse d.zexpedu_priv_sum l.zexpedu_priv_sum d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable1.doc", word append

xtpcse d.zexpedu_priv_sum l.zexpedu_priv_sum d.zleft l.zleft d.zpop30 l.zpop30 d.zfemlab l.zfemlab d.zpopdens l.zpopdens d.zgdp_pc l.zgdp_pc i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable1.doc", word append



xtpcse zexpedu_gdp l.zexpedu_gdp l.zleft l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc l.zexpedu_priv_sum i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable2.doc", word replace

xtpcse zexpedu_pc l.zexpedu_gdp l.zleft l.zpop30 l.zfemlab l.zpopdens l.zgdp_pc l.zexpedu_priv_sum i.Statecode
outreg2 using "/Users/mbusemeyerALT/Documents/Meine Dateien/Projekte/Laufende Projekte/paper lina/apptable2.doc", word append



