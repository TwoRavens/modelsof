

clear all

use $Output_final/main_ct
qui tab country, gen(iccode)
qui tab year,gen(time)
tsset ccode year

cd $log
log using reg_wapp.log, replace


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A1: Summary statistics by decade
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

summ d_pol2_rob pr if year>=1966 & year<=1969
summ d_pol2_rob pr if year>=1970 & year<=1979
summ d_pol2_rob pr if year>=1980 & year<=1989
summ d_pol2_rob pr if year>=1990 & year<=1999
summ d_pol2_rob pr if year>=2000 & year<=2009



*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A3: Non-stationarity commodity prices
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preserve 
sort princ_comm country year
by princ_comm: gen n_comm=_n
keep if n_comm<=48            //keep only one country per commodity

sort princ_comm year
tsset princ_comm year

*AUGMENTED DICKEY-FULLER (1979); KWIATKOWSKI-PHILLIPS-SCHMIDT-SHIN (1992); LO-MACKINLAY (1988)
local group 2 9 13 14 16 23 25 27 28 30 37 42 48 51 52 58 71 73 76 132 133 142 143 145 148 237 241 242 300 301 302
foreach c of local group{
 dfgls price if princ_comm==`c' 
 kpss price if princ_comm==`c' ,not auto
 lomackinlay price if princ_comm==`c', robust  
   }  

restore
  
  
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A5: Futures prices
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xtreg d_pol2_rob pr_fut_1y time* , fe cluster(ccode)

xtreg d_pol2_rob pra_fut_1y prd_fut_1y dem4 time* , fe cluster(ccode)

xtreg d_pol2_rob pra_fut_1y prd_fut_1y pl4a1pr_fut_1y pl4d1pr_fut_1y pl4a1 pl4d1 dem4 time* , fe cluster(ccode)

xtabond2 d_pol2_rob pra_fut_1y prd_fut_1y pl4a1pr_fut_1y pl4d1pr_fut_1y pl4a1 pl4d1 dem4 iccode* time* , gmm(pra_fut_1y prd_fut_1y pl4a1pr_fut_1y pl4d1pr_fut_1y pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A6: NUmber of share observations
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xtreg d_pol2_rob pra prd pl4a15pr pl4d15pr pl4a15 pl4d15 dem4  time* if quart_countshare!=1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a15pr pl4d15pr pl4a15 pl4d15 dem4 iccode* time* if quart_countshare!=1, gmm(dem4 pl4a15 pl4d15 pra prd pl4a15pr pl4d15pr, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_pol2_rob pra prd pl4a16pr pl4d16pr pl4a16 pl4d16 dem4  time* if countshare_86!=0, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a16pr pl4d16pr pl4a16 pl4d16 dem4 iccode* time* if countshare_86!=0, gmm(dem4 pl4a16 pl4d16 pra prd pl4a16pr pl4d16pr, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_pol2_rob pra prd pl4a17pr pl4d17pr pl4a17 pl4d17 dem4  time* if e==0, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a17pr pl4d17pr pl4a17 pl4d17 dem4 iccode* time* if e==0, gmm(dem4 pl4a17 pl4d17 pra prd pl4a17pr pl4d17pr, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A7: alternative treatment of time dimension
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xtreg d_pol2_18 pra prd pl4a18pr pl4d18pr pl4a18 pl4d18 dem4_18 time*, fe cluster(ccode)

xtabond2 d_pol2_18 pra prd pl4a18pr pl4d18pr pl4a18 pl4d18 dem4_18 iccode* time*, gmm(pra prd pl4a18pr pl4d18pr pl4a18 pl4d18 dem4_18, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_pol2_rob3_no pra_g3_no prd_g3_no pl4a1pr_g3_no pl4d1pr_g3_no pl4a1_no pl4d1_no dem4_no time*, fe cluster(ccode)



*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A8: Alternative thresholds
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xtreg d_pol2_rob pra_alt1 prd_alt1 pl4a_alt1pr pl4d_alt1pr pl4a_alt1 pl4d_alt1 dem4_alt1  time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra_alt1 prd_alt1 pl4a_alt1pr pl4d_alt1pr pl4a_alt1 pl4d_alt1 dem4_alt1 iccode* time*, gmm(pra_alt1 prd_alt1 pl4a_alt1pr pl4d_alt1pr pl4a_alt1 pl4d_alt1 dem4_alt1, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra_alt2 prd_alt2 pl4a_alt2pr pl4d_alt2pr pl4a_alt2 pl4d_alt2 dem4_alt2  time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra_alt2 prd_alt2 pl4a_alt2pr pl4d_alt2pr pl4a_alt2 pl4d_alt2 dem4_alt2 iccode* time*, gmm(pra_alt2 prd_alt2 pl4a_alt2pr pl4d_alt2pr pl4a_alt2 pl4d_alt2 dem4_alt2, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra_alt3 prd_alt3 pl4a_alt3pr pl4d_alt3pr pl4a_alt3 pl4d_alt3 dem4_alt3  time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra_alt3 prd_alt3 pl4a_alt3pr pl4d_alt3pr pl4a_alt3 pl4d_alt3 dem4_alt3 iccode* time*, gmm(pra_alt3 prd_alt3 pl4a_alt3pr pl4d_alt3pr pl4a_alt3 pl4d_alt3 dem4_alt3, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra_alt4 prd_alt4 pl4a_alt4pr pl4d_alt4pr pl4a_alt4 pl4d_alt4 dem4_alt4  time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra_alt4 prd_alt4 pl4a_alt4pr pl4d_alt4pr pl4a_alt4 pl4d_alt4 dem4_alt4 iccode* time*, gmm(pra_alt4 prd_alt4 pl4a_alt4pr pl4d_alt4pr pl4a_alt4 pl4d_alt4 dem4_alt4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra_alt5 prd_alt5 pl4a_alt5pr pl4d_alt5pr pl4a_alt5 pl4d_alt5 dem4_alt5 time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra_alt5 prd_alt5 pl4a_alt5pr pl4d_alt5pr pl4a_alt5 pl4d_alt5 dem4_alt5 iccode* time*, gmm(pra_alt5 prd_alt5 pl4a_alt5pr pl4d_alt5pr pl4a_alt5 pl4d_alt5 dem4_alt5, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*TABLE A9: Alternative measures of institutional quality
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xtreg d_fh pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_fh pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_civ_lib pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_civ_lib pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_pol_right pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_pol_right pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_fh_ipolity2 pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_fh_ipolity2 pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_pts pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_pts pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)

xtreg d_physint pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_physint pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


log close

