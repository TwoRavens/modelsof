set memory 999999
cd "C:\Users\Daniel de Kadt\Dropbox (Personal)\Projects\SA_cohort_effects\replication"

use  "sasas_ddk12.dta", clear

*************************************
************ SUM STATS **************
*************************************
replace vote=vote*100
replace vote_nr=vote_nr*100
replace registered=registered*100
replace trust_gov = trust_gov*100
replace democ_satis = democ_satis*100
replace vote_duty = vote_duty*100
replace vote_pointless = vote_pointless*100
replace sa_identity  = sa_identity*100
replace sa_race_rel  = sa_race_rel*100
replace vote_anc = vote_anc*100

**Make Summary Stats Tables**
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2, minmax title(Summary Statistics For Full Sample (All Races)) key(fullsumstat) file("results\fullsumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==1, minmax title(Summary Statistics For 2003 Sample (All Races)) key(2003sumstat) file("results\2003sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==2, minmax title(Summary Statistics For 2004 Sample (All Races)) key(2004sumstat) file("results\2004sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==3, minmax title(Summary Statistics For 2005 Sample (All Races)) key(2005sumstat) file("results\2005sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==4, minmax title(Summary Statistics For 2006 Sample (All Races)) key(2006sumstat) file("results\2006sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==5, minmax title(Summary Statistics For 2007 Sample (All Races)) key(2007sumstat) file("results\2007sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==6, minmax title(Summary Statistics For 2008 Sample (All Races)) key(2008sumstat) file("results\2008sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==7, minmax title(Summary Statistics For 2009 Sample (All Races)) key(2009sumstat) file("results\2009sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==8, minmax title(Summary Statistics For 2010 Sample (All Races)) key(2010sumstat) file("results\2010sumstat.tex") replace
sutex vote sex employment income wealth high_school prim_school married health black  coloured  white trust_gov democ_satis vote_pointless vote_duty sa_identity vote_anc if force>-2 & force<2 & time==9, minmax title(Summary Statistics For 2011 Sample (All Races)) key(2011sumstat) file("results\2011sumstat.tex") replace

