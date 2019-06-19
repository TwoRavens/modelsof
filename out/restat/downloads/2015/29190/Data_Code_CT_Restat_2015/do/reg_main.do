
clear all
use $Output_final/main_ct
qui tab country, gen(iccode)
qui tab year,gen(time)
tsset ccode year


cd $log
log using reg_main.log, replace


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 2 Summary statistics
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

summ d_pol2_rob pr polity2 polity2_1962 polity2_2009 share avshare countshare


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 3 Baseline
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg d_pol2_rob pr time*, fe cluster(ccode)

xtreg d_pol2_rob pra prd dem4 time*, fe cluster(ccode)

xtreg d_pol2_rob pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(dem4 pra prd pl4a1pr pl4d1pr pl4a1 pl4d1, collapse) small iv(iccode* time*) cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 4: Polity2 components
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg d_exconst pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_exconst pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_exrec pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4  time*, fe cluster(ccode)

xtabond2 d_exrec pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_polcomp pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4  time*, fe cluster(ccode)

xtabond2 d_polcomp pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 5 Export shares
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg d_pol2_rob pra prd pl4a2pr pl4d2pr pl4a2 pl4d2 dem4 time* if dec_avshare>1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a2pr pl4d2pr pl4a2 pl4d2 dem4 iccode* time* if dec_avshare>1, gmm(dem4 pl4a2 pl4d2 pra prd pl4a2pr pl4d2pr, collapse) iv(iccode* time*) small robust cluster(ccode) 


xtreg d_pol2_rob pra prd pl4a3pr pl4d3pr pl4a3 pl4d3 dem4  time* if quart_avshare>1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a3pr pl4d3pr pl4a3 pl4d3 dem4 iccode* time* if quart_avshare>1, gmm(dem4 pl4a3 pl4d3 pra prd pl4a3pr pl4d3pr, collapse) iv(iccode* time*) small robust cluster(ccode) 


xtreg d_pol2_rob pra prd pl4a4pr pl4d4pr pl4a4 pl4d4 dem4  time* if median_avshare>1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a4pr pl4d4pr pl4a4 pl4d4 dem4 iccode* time* if median_avshare>1, gmm(dem4 pl4a4 pl4d4 pra prd pl4a4pr pl4d4pr, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 share dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 share dem4 iccode* time*, gmm(dem4 pl4a1 pl4d1 pra prd pl4a1pr pl4d1pr share, collapse) iv(iccode* time*) cluster(ccode) 


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 6: Boundary observations
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg dpol2p pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4  time*, fe cluster(ccode)

xtabond2 dpol2p pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(dem4 pl4a1 pl4d1 pra prd pl4a1pr pl4d1pr, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg dum_d_pol2_rob pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4  time*, fe cluster(ccode)

xtabond2 dum_d_pol2_rob pra prd pl4a1pr pl4d1pr pl4a1 pl4d1 dem4 iccode* time*, gmm(dem4 pl4a1 pl4d1 pra prd pl4a1pr pl4d1pr, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a5pr pl4d5pr pl4a5 pl4d5 dem4  time* if mmin>-10 & max<10, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a5pr pl4d5pr pl4a5 pl4d5 dem4 iccode* time* if mmin>-10 & max<10, gmm(pra prd pl4a5pr pl4d5pr pl4a5 pl4d5 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a6pr pl4d6pr pl4a6 pl4d6 dem4  time* if pl4>-10 & pl4<10, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a6pr pl4d6pr pl4a6 pl4d6 dem4 iccode* time* if pl4>-10 & pl4<10, gmm(pra prd pl4a6pr pl4d6pr pl4a6 pl4d6 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 7: Big producers
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg d_pol2_rob pra prd pl4a7pr pl4d7pr pl4a7 pl4d7 dem4 time* if opec!=1 , fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a7pr pl4d7pr pl4a7 pl4d7 dem4 iccode* time* if opec!=1 , gmm(pra prd pl4a7pr pl4d7pr pl4a7 pl4d7 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a8pr pl4d8pr pl4a8 pl4d8 dem4  time* if prod!=1 , fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a8pr pl4d8pr pl4a8 pl4d8 dem4 iccode* time* if prod!=1 , gmm(pra prd pl4a8pr pl4d8pr pl4a8 pl4d8 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 8: General price index
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg d_pol2_rob gpi_pra gpi_prd pl4a1gpipr pl4d1gpipr pl4a1 pl4d1 dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob gpi_pra gpi_prd pl4a1gpipr pl4d1gpipr pl4a1 pl4d1 dem4 iccode* time*, gmm(gpi_pra gpi_prd pl4a1gpipr pl4d1gpipr pl4a1 pl4d1 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob gpi_75_pra gpi_75_prd pl4a1975gpi75pr pl4d1975gpi75pr pl4a1975 pl4d1975 dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob gpi_75_pra gpi_75_prd pl4a1975gpi75pr pl4d1975gpi75pr pl4a1975 pl4d1975 dem4 iccode* time*, gmm(gpi_75_pra gpi_75_prd pl4a1975gpi75pr pl4d1975gpi75pr pl4a1975 pl4d1975 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob gpi_80_pra gpi_80_prd pl4a1980gpi80pr pl4d1980gpi80pr pl4a1980 pl4d1980 dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob gpi_80_pra gpi_80_prd pl4a1980gpi80pr pl4d1980gpi80pr pl4a1980 pl4d1980 dem4 iccode* time*, gmm(gpi_80_pra gpi_80_prd pl4a1980gpi80pr pl4d1980gpi80pr pl4a1980 pl4d1980 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob gpi_90_pra gpi_90_prd pl4a1990gpi90pr pl4d1990gpi90pr pl4a1990 pl4d1990 dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob gpi_90_pra gpi_90_prd pl4a1990gpi90pr pl4d1990gpi90pr pl4a1990 pl4d1990 dem4 iccode* time*, gmm(gpi_90_pra gpi_90_prd pl4a1990gpi90pr pl4d1990gpi90pr pl4a1990 pl4d1990 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob gpi_01_pra gpi_01_prd pl4a2001gpi01pr pl4d2001gpi01pr pl4a2001 pl4d2001 dem4 time*, fe cluster(ccode)

xtabond2 d_pol2_rob gpi_01_pra gpi_01_prd pl4a2001gpi01pr pl4d2001gpi01pr pl4a2001 pl4d2001 dem4 iccode* time*, gmm(gpi_01_pra gpi_01_prd pl4a2001gpi01pr pl4d2001gpi01pr pl4a2001 pl4d2001 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*TABLE 9: Typologies of commodity
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*

xtreg d_pol2_rob pra prd pl4a9pr pl4d9pr pl4a9 pl4d9 dem4  time* if ps==1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a9pr pl4d9pr pl4a9 pl4d9 dem4 iccode* time* if ps==1, gmm(pra prd pl4a9pr pl4d9pr pl4a9 pl4d9 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a10pr pl4d10pr pl4a10 pl4d10 dem4  time* if nps==1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a10pr pl4d10pr pl4a10 pl4d10 dem4 iccode* time* if nps==1, gmm(pra prd pl4a10pr pl4d10pr pl4a10 pl4d10 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a11pr pl4d11pr pl4a11 pl4d11 dem4  time* if min==1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a11pr pl4d11pr pl4a11 pl4d11 dem4 iccode* time* if min==1, gmm(pra prd pl4a11pr pl4d11pr pl4a11 pl4d11 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a12pr pl4d12pr pl4a12 pl4d12 dem4  time* if nmin==1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a12pr pl4d12pr pl4a12 pl4d12 dem4 iccode* time* if nmin==1, gmm(pra prd pl4a12pr pl4d12pr pl4a12 pl4d12 dem4, collapse) iv(iccode* time*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a13pr pl4d13pr pl4a13 pl4d13 dem4 year if oil==1, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a13pr pl4d13pr pl4a13 pl4d13 dem4 iccode* year if oil==1, gmm(pra prd pl4a13pr pl4d13pr pl4a13 pl4d13 dem4, collapse) iv(iccode*) small robust cluster(ccode)


xtreg d_pol2_rob pra prd pl4a14pr pl4d14pr pl4a14 pl4d14 dem4 year if oil==0, fe cluster(ccode)

xtabond2 d_pol2_rob pra prd pl4a14pr pl4d14pr pl4a14 pl4d14 dem4 iccode* year if oil==0, gmm(pra prd pl4a14pr pl4d14pr pl4a14 pl4d14 dem4, collapse) iv(iccode* year) small robust cluster(ccode)



log close
