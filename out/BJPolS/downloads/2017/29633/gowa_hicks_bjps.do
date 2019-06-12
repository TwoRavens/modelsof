use bjps/gh_bjps.dta , clear

*** DYADIC FE
preserve
gen othoth = WWIotherB*WWIotherA
gen neuneu = WWIneub*WWIneua
gen entneu = (WWIententea==1 & WWIneub==1) | (WWIententeb==1 & WWIneua==1)
gen Entout = ( WWIententea==1 | WWIententeb==1) & WWIentpair==0 & WWIallyaxis==0
gen Axisout = (WWIaxisa==1  | WWIaxisb==1) & WWIaxispair==0  &  neuaxisIB==0 & WWIallyaxis==0 
areg logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB Entout Axisout atopally lgdp i.year if year < 1930, abs(directed_dyadid)  cluster(directed_dyadid)
est store mod1d_1
log using "bjps\test_dfe.log" , replace
test WWIentpair = Entout
*test entneu=neuaxisI
log close
gen neuaxisIB14 = neuaxisIB==1 & year>=1914 & year<=1916
gen neuaxisIB18 = neuaxisIB==1 & year>=1917 & year<=1918

areg logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB14 neuaxisIB18 Entout Axisout atopally lgdp i.year if year < 1930, abs(directed_dyadid)  cluster(directed_dyadid)
est store mod1d_2
log using "bjps\test_dfe.log" , append
test neuaxisIB14 = neuaxisIB18
test WWIentpair = Entout

log close

** scandanavian neutrals

log using "bjps\test_dfe.log" , append

areg logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisI Entout Axisout  alliance defense lgdp i.year  if year < 1930, abs(directed_dyadid)  cluster(directed_dyadid)
est store mod1d_3
test alliance = defense
test WWIentpair = Entout
log close

** dyad checks

gen nogdp = lgdp==.
gen lgdp2 = cond(lgdp==.,0,lgdp)
gen nogdpwwi = wwi==1 & nogdp==1
gen nogdp2 = cond(nogdp==1 & wwi==0,1,0)
gen wwi_2 = cond(wwi==1 & nogdp==0,wwi,0)
areg logm_r lgdp2  i.nogdp#i.(WWIentpair) WWIaxispair WWIallyaxis  neuaxisIB Entout Axisout i.year if year < 1930, abs(directed_dyadid)  cluster(directed_dyadid)
est store mod1d_5

#delim ;
estout mod1d_1 mod1d_2  mod1d_5 using "bjps\table2_v3" , starlevels(* .1 ** .05 *** .01) cells(b(star fmt(%9.2f)) se(par fmt(%9.2f)))
  stats(N ll , fmt( %9.0f %9.2f) labels(N Log-likelihood ))  replace drop(*year*)  
  order(  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB neuaxisIB14 neuaxisIB18 Entout Axisout   atopally alliance defense lgdp ) ;
#delim cr

restore


*** TABLE 1

reg3hdfe logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB atopally  if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)
est store mod1_1

gen neuaxisIB14 = neuaxisIB==1 & year>=1914 & year<=1916
gen neuaxisIB18 = neuaxisIB==1 & year>=1917 & year<=1918

reg3hdfe logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB14 neuaxisIB18 atopally if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)
est store mod1_1a
log using "bjps\test.log" , replace
test neuaxisIB14 = neuaxisIB18
log close

** scandanavian neutrals
reg3hdfe logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB alliance defense  if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)
est store mod1_2
log using "bjps\test.log" , append
test alliance = defense
log close

#delim ;
estout mod1_1 mod1_1a mod1_2  using "bjps\table1_v3" , starlevels(* .1 ** .05 *** .01) cells(b(star fmt(%9.2f)) se(par fmt(%9.2f)))
  stats(N ll , fmt( %9.0f %9.2f) labels(N Log-likelihood ))  replace /*drop(_I* *_I*)  */
  order(  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB neuaxisIC  atopally alliance defense ) ;
#delim cr

gen WWIallies = (WWIentpair==1 | WWIaxispair==1) 
 reg3hdfe logm_r  WWIallies WWIallyaxis  neuaxisIB atopally  if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)


reg3hdfe logm_r  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB alliance defense dem6  if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)
est store mod3_1

gen neuaxisIC = neuaxisI==1 & neuaxisIB==0
reg3hdfe logm_r WWIentpair WWIaxispair WWIallyaxis neuaxisIB neuaxisIC alliance defense  if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)
est store mod3_2

reg3hdfe logm_r  WWIentpair2 WWIaxispair2 WWIallyaxis2  neuaxisI2B alliance defense  if year < 1930, id1(directed_dyadid) id2(impyr) id3(expyr) cluster(directed_dyadid)
est store mod3_3
#delim ;
estout mod3_1 mod3_2 mod3_3  using "bjps\table3_v3" , starlevels(* .1 ** .05 *** .01) 
  cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(N ll , fmt( %9.0f %9.2f) labels(N Log-likelihood ))  replace /*drop(_I* *_I*)  */
  order(  WWIentpair WWIaxispair WWIallyaxis  neuaxisIB  neuaxisI2B  alliance defense dem6 neuaxisIC) ;
#delim cr

