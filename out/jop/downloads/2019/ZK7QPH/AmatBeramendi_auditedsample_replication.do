




 **********************************************************************************************************************************************************************************************************************************************************************************************

 **********************************************************************************************************************************************************************************************************************************************************************************************

*** REPLICATION FILE FOR "DEMOCRACY UNDER HIGH INEQUALITY" (Journal of Politics): FRANCESC AMAT (IPERG-UNIVERSITY OF BARCELONA) AND PABLO BERAMENDI (DUKE UNIVERSITY)

*** Do-File version: 30/01/2019

 **********************************************************************************************************************************************************************************************************************************************************************************************

 **********************************************************************************************************************************************************************************************************************************************************************************************

 
 
 
 **********************************************************************************************************************************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************************************************************************************************************************

 * TABLES AND FIGURES IN THE MAIN TEXT:
 
 **********************************************************************************************************************************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************************************************************************************************************************

 
 

 ** Table 1: 
 
set more off

reg  logpublicempl2004   c.gini##c.pmism  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref   uf_d*    , robust cluster(ufd)

reg  logpublicempl2004   c.gini##c.pmism  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref   uf_d*      i.party_* , robust cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd   , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd i.party_*    , r cluster(ufd)


 ** Figure 1:
 
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd   , r cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism")    addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(sq2g)
  
reg  logpublicempl2004   c.gini##c.pmism  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref   uf_d*    , robust cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism")    addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(sq3g)
  
graph combine  sq2g sq3g, scheme(s1mono) xcommon 



 ** Table 2:
  
set more off

reg  logpublicempl2004   lfunc_ativ c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca   vereador_pc transfers_pc  lrec_trans  age2004 agesq2004  married2004 instruction2004  male2004      uf_d*   i.party_*    if first==1  , cluster(ufd)

reg  logpublicempl2004   lfunc_ativ c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca   vereador_pc transfers_pc  lrec_trans   age2004 agesq2004  married2004 instruction2004  male2004 ENLP2000  sameparty     uf_d*   i. party_* if first==1  , cluster(ufd)

reg logmeaneduc2004     lfunc_ativ  c.gini##c.pmism##c.winmargin  lpop logmeanbudget2004  medianincome20002004     vereador_pc transfers_pc  lrec_trans  age2004 agesq2004  married2004 instruction2004  male2004    uf_d*   i.party_*    if first==1   , r cluster(ufd)

reg logmeaneduc2004     lfunc_ativ  c.gini##c.pmism##c.winmargin  lpop logmeanbudget2004  medianincome20002004     vereador_pc transfers_pc  lrec_trans  age2004 agesq2004  married2004 instruction2004  male2004 ENLP2000  sameparty    uf_d*    i. party_*  if first==1   , r cluster(ufd)


 
 
 ** Table 3:
 set more off

reg turnoutrate04ver c.gini##c.pmism  lpib             			   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit                              uf_d*   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty         uf_d*   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans lfunc_ativ              uf_d*    , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans lfunc_ativ              uf_d*    i.party_*, robust cluster(ufd)

 
 
** Figure 2: 

set more off 

reg turnoutrate04ver c.gini##c.pmism  lpib  lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit    first  ENLP2000 winmargin sameparty lrec_trans lfunc_ativ    uf_d*    , robust cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck  

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism")   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(sq1g) 
  
  
  
** Table 4:   
 
set more off
fvset base 8 instruction2008
fvset base 7 party2008d
fvset base 5 nsorteio
fvset base 10 ufd

reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004  if first==1  , r cluster(ufd)

reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004  i.ufd  if first==1, r cluster(ufd)

reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004 previousreelec2008  i.ufd if first==1 , r cluster(ufd)

reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004 previousreelec2008  male2008 age2008  agesq2008  married2008  i.instruction2008  i.ufd if first==1, r cluster(ufd)

reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004 previousreelec2008  male2008 age2008  agesq2008  married2008  i.instruction2008 i.party2008d  i.ufd if first==1, r cluster(ufd)

reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004 previousreelec2008  male2008 age2008  agesq2008  married2008  i.instruction2008 i.party2008d  i.ufd i.nsorteio if first==1, r cluster(ufd)



** Figure 3: 
 
set more off
 
reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004 previousreelec2008  male2008 age2008  agesq2008  married2008  i.instruction2008  i.ufd if first==1 , r cluster(ufd)

margins ,  dydx(pmism) at(gini_ipea=(0.4(0.01).75) exposed==0) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(pgchange1) title("Non-Exposed Municipalities")
 
set more off
 
reg  changepubliceducdiff    c.gini##c.pmism##i.exposed   changebudget  medianincome20002004 previousreelec2008  male2008 age2008  agesq2008  married2008  i.instruction2008  i.ufd if first==1, r cluster(ufd)

margins ,  dydx(pmism) at(gini_ipea=(0.4(0.01).75) exposed==1) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(pgchange2) title("Exposed Municipalities")

graph combine pgchange1 pgchange2, scheme(s1mono) xcommon ycommon 



** Table 5:

set more off
reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  if first==1  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio   if first==1  , cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1   ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & party_d4==0   , cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & party_d4==0  , cluster(ufd)



  
 ** Figure 4:
  
set more off
 
reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & party_d4==0  , cluster(ufd)

margins ,  dydx(pmism) at(gini_ipea=(0.4(0.01).75) exposed==0) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Non-Exposed Municipalities") name(chturnout1)

set more off
 
reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & party_d4==0  , cluster(ufd)

margins ,  dydx(pmism) at(gini_ipea=(0.4(0.01).75) exposed==1) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8))  title("Exposed Municipalities")  name(chturnout2)

graph combine chturnout1 chturnout2, scheme(s1mono) xcommon ycommon 
 
 
 
** Table 6:
 
set more off

logit  reeleito_2004   i.exposed##c.pmism        lpib lpop purb  p_secundario   mun_novo  area   comarca           i.nsorteio  uf_d*    if first==1 , cluster(ufd)

logit  reeleito_2004   i.exposed##c.pmism        lpib lpop purb  p_secundario   mun_novo  area   comarca    ENLP2000 winmargin sameparty lrec_trans lfunc_ativ    i.nsorteio  uf_d* if first==1 , cluster(ufd)

logit  reeleito_2004   i.exposed##c.pmism        lpib lpop purb  p_secundario   mun_novo  area   comarca    ENLP2000 winmargin sameparty lrec_trans lfunc_ativ    pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600     i.nsorteio  uf_d* if first==1 , cluster(ufd)

logit  reeleito_2004   i.exposed##c.pmism        lpib lpop purb  p_secundario   mun_novo  area   comarca    ENLP2000 winmargin sameparty lrec_trans lfunc_ativ    pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600     i.party_*   i.nsorteio  uf_d* if first==1 , cluster(ufd)


 
 
** Figure 5: 
 
set more off

logit  reeleito_2004   i.exposed##c.pmism        lpib lpop purb  p_secundario   mun_novo  area   comarca    lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty         i.nsorteio  uf_d*    if first==1 , cluster(ufd)

margins exposed, at(pmism = (0(0.1)5.5)) atmeans level(90) noestimcheck 

marginsplot, scheme(s1mono) title("Predicted Re-Election Probability by Exposure") xlabel(0 1 2 3 4 5) ylabel(0 0.2 0.4 0.6 0.8 1)  level(90) addplot(hist pmism if pmism<6 & e(sample), yaxis(2) fcolor(none) dens  lcolor(gs8)) 




** Figure 6:
 
reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & purb<0.6, cluster(ufd)
 
margins ,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==0) atmeans  noestimcheck

marginsplot ,   scheme(s1mono) level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Non-Exposed Municipalities") name(m1az2)


reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & purb<0.6, cluster(ufd)

margins, dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==1) atmeans noestimcheck

marginsplot , scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Exposed Municipalities") name(m2az2)
 
 
reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & purb>0.6, cluster(ufd)
 
margins,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==0) atmeans  noestimcheck

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Non-Exposed Municipalities") name(m3az2)


reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & purb>0.6, cluster(ufd)

margins,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==1) atmeans noestimcheck

marginsplot , scheme(s1mono)   level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Exposed Municipalities") name(m4az2)


graph combine m1az2 m2az2 m3az2 m4az2, ycommon xcommon  col(2) row(2)  scheme(s1mono)	



** FIgure 7:


reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & p_secund<.230587 , cluster(ufd)

margins ,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==0) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Non-Exposed Municipalities") name(ms1)


reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & p_secund<.230587 , cluster(ufd)

margins,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==1) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Exposed Municipalities") name(ms2)

 
reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & p_secund>.230587 , cluster(ufd)

margins ,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==0) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Non-Exposed Municipalities") name(ms3)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & p_secund>.230587 , cluster(ufd)

margins,  dydx(pmism) at(gini_ipea=(0.45(0.01).75) exposed==1) atmeans noestimcheck 

marginsplot ,  scheme(s1mono)  level(90) yline(0 , noextend) addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) title("Exposed Municipalities") name(ms4)

graph combine ms1 ms2 ms3 ms4, ycommon xcommon scheme(s1mono) col(2) row(2)






 **********************************************************************************************************************************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************************************************************************************************************************

 * TABLES AND FIGURES IN THE SUPPLEMENTARY APPENDIX:
 
 **********************************************************************************************************************************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************************************************************************************************************************

 
 
 ** APPENDIX B:

 
 ** Descriptive statistics

set more off
estpost summarize turnoutrate04ver lfunc_ativ logpublicempl2004  logmeaneduc2004 changelogturnoutver  changepubliceducdiff  reeleito_2004   gini poverty pmism   lpib   lpop purb  p_secundario   mun_novo  area  comarca vereador_eleit vereador_pc transfers_pc  lrec_trans   first ENLP2000 winmargin sameparty  op_01_04   ratioapto  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004



** Balance table:
 
set more off
estpost ttest turnoutrate04ver lfunc_ativ logpublicempl2004  logmeaneduc2004 changelogturnoutver  changepubliceducdiff  reeleito_2004   gini poverty pmism   lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit vereador_pc transfers_pc  lrec_trans   first ENLP2000 winmargin sameparty  op_01_04   ratioapto  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   , by(exposed)  


 
** APPENDIX C: Histograms:


histogram turnoutrate00ver , scheme(s1mono) title("Turnout 2000") name(t2000)

histogram turnoutrate04ver , scheme(s1mono) title("Turnout 2004") name(t2004)

graph combine t2000 t2004, xcommon ycommon scheme(s1mono)


histogram logmeaneduc2004 , scheme(s1mono) title("Primary Education Spending 2004") name(s2004b)

histogram logmeaneduc2008 , scheme(s1mono) title("Primary Education Spending 2008") name(s2008b)

graph combine s2004b s2008b, xcommon ycommon scheme(s1mono)


histogram lfunc_ativ, scheme(s1mono) title("Log Public Employees 2002") name(public1)

histogram logpublicempl2004, scheme(s1mono) title("Log Public Employees 2004") name(public2) 

graph combine public1 public2, xcommon ycommon scheme(s1mono)


histogram gini_ipea , scheme(s1mono) title("Gini Measure across Municipalities")

histogram pmism     , scheme(s1mono) title("Audited Mismanagement across Municipalities") 



** APPENDIX D: Robustness Checks for Linear Interactions: 

** Turnout
 
* Bin

interflex   turnoutrate04ver pmism gini  lpib  lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans lfunc_ativ    ,    ylab(Turnout) dlab(Audited Mismanagement) xlab(Inequality) vce(robust) xd(histogram) n(3) cl(ufd)
 
*Kernel 

interflex   turnoutrate04ver pmism gini  lpib  lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans lfunc_ativ    ,    ylab(Turnout) dlab(Audited Mismanagement) xlab(Inequality) vce(robust) xd(histogram)  cl(ufd) type(kernel) 


** Primary eduaction spending 

* Bin

interflex  logmeaneduc2004 pmism gini   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   ,    ylab(Log Primary Educ Spend) dlab(Audited Mismanagement) xlab(Inequality) vce(robust) xd(histogram) n(3) cl(ufd)

* Kernel

interflex  logmeaneduc2004 pmism gini   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   ,    ylab(Log Primary Educ Spend) dlab(Audited Mismanagement) xlab(Inequality) vce(robust) xd(histogram)  cl(ufd)  type(kernel)

** Log public employees 

* Bin
interflex    logpublicempl2004   pmism gini  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref    , ylab(Log Public Employees) dlab(Audited Mismanagement) xlab(Inequality) vce(robust) xd(histogram) n(3) cl(ufd)

* Kernel
interflex    logpublicempl2004  pmism gini  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref     , ylab(Log Public Employees) dlab(Audited Mismanagement) xlab(Inequality) vce(robust) xd(histogram)  cl(ufd)  type(kernel)




** APPENDIX E: Heterogeneous effects under the status quo:


** Table E.1:

set more off
   
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004      i.ufd  if purb<0.57  , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004    i.ufd  if purb<0.57  , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd  if purb<0.57  , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004     i.ufd  if purb>0.57 , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004    i.ufd  if purb>0.57 , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd  if purb>0.57 , r cluster(ufd)


** Figure 12:

set more off
 
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd  if purb<0.57  , r cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(educ1)
  
set more off
  
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd  if purb>0.57 , r cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(educ2)

graph combine educ1 educ2, scheme(s1mono) xcommon ycommon 



** Table E.2

set more off 
 
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004      i.ufd  if winmargin<0.1235395   , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004    i.ufd  if winmargin<0.1235395   , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd  if winmargin<0.1235395   , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004     i.ufd  if winmargin>0.1235395  , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004    i.ufd  if winmargin>0.1235395 , r cluster(ufd)

reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd  if winmargin>0.1235395  , r cluster(ufd)

 
 
** Figure 13:
 
set more off
 
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004    i.ufd  if winmargin<0.1235395   , r cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(educwinmargin1)
  
set more off
  
reg logmeaneduc2004 c.gini##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004    i.ufd  if winmargin>0.1235395   , r cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(educwinmargin2)

graph combine educwinmargin1 educwinmargin2, scheme(s1mono) xcommon ycommon 
 
 
 ** Table E.3
 
set more off

reg   logpublicempl2004   lfunc_ativ c.gini##c.pmism lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans i.nsorteio if winmargin<.12  , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ c.gini##c.pmism lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans i.nsorteio uf_d*    if winmargin<.12 , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ c.gini##c.pmism lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans  i.nsorteio if winmargin>.12   , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ c.gini##c.pmism lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans   i.nsorteio uf_d*  if winmargin>.12    , cluster(ufd)



** Figure 14


set more off
 
reg   logpublicempl2004   lfunc_ativ c.gini##c.pmism lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans i.nsorteio uf_d*    if winmargin<.12 , cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(perlowwin)

set more off

reg   logpublicempl2004   lfunc_ativ c.gini##c.pmism lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans   i.nsorteio uf_d*  if winmargin>.12    , cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans noestimcheck 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(perhighwin)

graph combine perlowwin perhighwin, scheme(s1mono) xcommon ycommon 
  
  
 
** Table E.4

 
 set more off
 
reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit           uf_d* if purb<0.57   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit    first ENLP2000 winmargin sameparty         uf_d* if purb<0.57   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ      first ENLP2000 winmargin sameparty         uf_d* if purb<0.57   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit          uf_d* if purb>0.57   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit    first ENLP2000 winmargin sameparty         uf_d* if purb>0.57   , robust cluster(ufd)

reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ      first ENLP2000 winmargin sameparty         uf_d* if purb>0.57   , robust cluster(ufd)

 
** Figure 15


set more off
 
reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ      first ENLP2000 winmargin sameparty         uf_d* if purb<0.57  , robust cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8))  name(tunoutsqrural)
  
set more off  
  
reg turnoutrate04ver c.gini##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ      first ENLP2000 winmargin sameparty         uf_d*  if purb>0.57  , robust cluster(ufd)

margins ,  dydx(pmism) at(gini=(0.4(0.01).75)) atmeans 

marginsplot,   scheme(s1mono) level(90) yline(0) title("Clientelism") recast(line)   addplot(hist gini if e(sample), yaxis(2) fcolor(none) dens lcolor(gs8)) name(turnoutsqurban)

graph combine tunoutsqrural turnoutsqurban, scheme(s1mono) xcommon ycommon 

  
 
** Table E.5

set more off

reg   logpublicempl2004   lfunc_ativ  c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans  , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ  c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans   uf_d*   , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ  c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans   uf_d*   i. party_*   , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ  c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   ENLP2000 winmargin sameparty lrec_trans  if first==1  , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ  c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   ENLP2000 winmargin sameparty lrec_trans  uf_d*    if first==1  , cluster(ufd)

reg   logpublicempl2004   lfunc_ativ  c.gini##c.pmism##c.winmargin lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   ENLP2000 winmargin sameparty lrec_trans  uf_d*   i. party_* if first==1  , cluster(ufd)



** APPENDIX F: Robustness tests for the capacity shock


** Table F.1


set more off

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1   ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & pmism<5.5  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & pmism< 2.3125    ,cluster(ufd)


** Table F.2


set more off

reg  changelogturnoutver     c.gini##c.lfunc_ativ##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  if first==1  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.lfunc_ativ##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio   if first==1  , cluster(ufd)

reg  changelogturnoutver     c.gini##c.lfunc_ativ##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.lfunc_ativ##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1   ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.lfunc_ativ##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & party_d4==0   , cluster(ufd)

reg  changelogturnoutver     c.gini##c.lfunc_ativ##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans  ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & party_d4==0  , cluster(ufd)



** Table F.3

set more off

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1   ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & reeleito_2004==1 ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & reeleito_2004==1  ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & reeleito_2004==0 ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04   ratioaptos	i.nsorteio  uf_d*  if first==1 & reeleito_2004==0  ,cluster(ufd)


** Table F.4

set more off

reg  changelogturnoutver     c.gini##c.pmism##i.alt_exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.alt_exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref                    op_01_04   ratioaptos	i.nsorteio    , cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.alt_exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*   ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.alt_exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref                    op_01_04   ratioaptos	i.nsorteio  uf_d*    ,cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.alt_exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio  uf_d*  if party_d4==0   , cluster(ufd)

reg  changelogturnoutver     c.gini##c.pmism##i.alt_exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref                    op_01_04   ratioaptos	i.nsorteio  uf_d*  if party_d4==0  , cluster(ufd)



** APPENDIX G: Heterogeneous effects for the capacity shock


** Table G.1

set more off
 
reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   				     op_01_04   ratioaptos	i.nsorteio   if first==1 & purb>0.6, cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   if first==1 & purb>0.6 ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & purb>0.6 ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   				     op_01_04   ratioaptos	i.nsorteio   if first==1 & purb<0.6  ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   if first==1 & purb<0.6 ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & purb<0.6, cluster(ufd)


** Table G.2

  
set more off
 
reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   				     op_01_04   ratioaptos	i.nsorteio   if first==1   & p_secund>.230587, cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   if first==1  & p_secund>.230587 ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1  & p_secund>.230587,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   				     op_01_04   ratioaptos	i.nsorteio   if first==1  & p_secund<.230587  ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   if first==1 & p_secund<.230587  ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & p_secund<.230587 , cluster(ufd)


** Table G.3

set more off
 
reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   				     op_01_04   ratioaptos	i.nsorteio   if first==1   &  AMstation==0, cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   if first==1  & AMstation==0,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1  & AMstation==0,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   				     op_01_04   ratioaptos	i.nsorteio   if first==1  & AMstation==1  ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty     															   					 op_01_04   ratioaptos	i.nsorteio   if first==1 &  AMstation==1   ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop  purb p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 &  AMstation==1  , cluster(ufd)


** Table G.4

set more off

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   	                  op_01_04   ratioaptos	 i.nsorteio   if first==1 & winmargin<.1235     ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000  sameparty  winmargin   															   					  op_01_04   ratioaptos	i.nsorteio   if first==1 & winmargin<.1235     ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000  sameparty  winmargin pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600    op_01_04   ratioaptos	i.nsorteio    if first==1 & winmargin<.1235     ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ       																						   		              op_01_04   ratioaptos	i.nsorteio   if first==1 & winmargin>.1235      , cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000  sameparty  winmargin   															   					  op_01_04   ratioaptos	i.nsorteio   if first==1 & winmargin>.1235     ,cluster(ufd)

reg  changelogturnoutver    c.gini##c.pmism##i.exposed  lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000  sameparty  winmargin  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600   op_01_04   ratioaptos	i.nsorteio   if first==1 & winmargin>.1235     ,cluster(ufd)



** APPENDIX H: Further Checks. Exclusion of Second Term and Re-Electin Models


** Table H.1 


set more off

reg pmism   c.gini_ipea##i.first   lpib lpop purb  p_secundario   area  comarca vereador_eleit mun_novo lrec_trans lfunc_ativ 																											i.nsorteio  uf_d*  ,robust cluster(ufd)

reg pmism   c.gini_ipea##i.first   lpib lpop purb  p_secundario   area  comarca vereador_eleit mun_novo lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty 																			i.nsorteio  uf_d* ,robust cluster(ufd)

reg pmism   c.gini_ipea##i.first   lpib lpop purb  p_secundario   area  comarca vereador_eleit mun_novo lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref    		i.nsorteio  uf_d* ,robust cluster(ufd)

reg pmism   c.gini_ipea##i.first   lpib lpop purb  p_secundario   area  comarca vereador_eleit mun_novo lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  party_d*  i.nsorteio  uf_d* ,robust cluster(ufd)


** Table H.2. 


 set more off
 
reg  reeleito_2004   c.gini##c.pmism##i.exposed   lpib lpop purb  p_secundario   mun_novo  area   comarca    lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600     i.party2004d  if first==1, cluster(ufd)

reg  reeleito_2004   c.gini##c.pmism##i.exposed   lpib lpop purb  p_secundario   mun_novo  area   comarca    lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600     i.party2004d i.nsorteio  if first==1, cluster(ufd)

reg  reeleito_2004   c.gini##c.pmism##i.exposed   lpib lpop purb  p_secundario   mun_novo  area   comarca    lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600     i.party2004d i.nsorteio  uf_d* if first==1, cluster(ufd)


** Figure 16


set more off

reg reeleito_2004   c.pmism##c.gini##i.exposed   lpib lpop purb  p_secundario   mun_novo  area   comarca    lrec_trans lfunc_ativ   ENLP2000 winmargin sameparty   pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600     i.party2004d i.nsorteio  uf_d* if first==1, cluster(ufd)

margins exposed, at(pmism = (0(0.1)5.5)  gini=0.65) atmeans level(90) noestimcheck 

marginsplot, scheme(s1mono) title("Predicted Re-Election Probability by Exposure Under High Inequality") by(exposed)  xlabel(0 1 2 3 4 5) ylabel(0 0.2 0.4 0.6 0.8 1)  level(90) 




** APPENDIX I: Models employing poverty measure

** Table I.1

set more off

reg turnoutrate04ver c.poverty##c.pmism  lpib             			  lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit                              uf_d*   , robust cluster(ufd)

reg turnoutrate04ver c.poverty##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty         uf_d*   , robust cluster(ufd)

reg turnoutrate04ver c.poverty##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans lfunc_ativ              uf_d*    , robust cluster(ufd)

reg turnoutrate04ver c.poverty##c.pmism  lpib                         lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty lrec_trans lfunc_ativ              uf_d*    i.party_*, robust cluster(ufd)



** Table I.2

set more off

reg  logpublicempl2004   c.poverty##c.pmism  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref   uf_d*    , robust cluster(ufd)

reg   logpublicempl2004   c.poverty##c.pmism  lpib   lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   first ENLP2000 winmargin sameparty pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref   uf_d*    i.party2004d, robust cluster(ufd)

reg logmeaneduc2004 c.poverty##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd   , r cluster(ufd)

reg logmeaneduc2004 c.poverty##c.pmism   logmeanbudget2004  medianincome20002004 previousreelec2004  age2004 agesq2004  married2004 instruction2004  male2004   i.ufd i.party2004d   , r cluster(ufd)




