


 **********************************************************************************************************************************************************************************************************************************************************************************************

 **********************************************************************************************************************************************************************************************************************************************************************************************

*** REPLICATION FILE FOR "DEMOCRACY UNDER HIGH INEQUALITY" (Journal of Politics): FRANCESC AMAT (IPERG-UNIVERSITY OF BARCELONA) AND PABLO BERAMENDI (DUKE UNIVERSITY)

*** Do-File version: 01/02/2019

 **********************************************************************************************************************************************************************************************************************************************************************************************

 **********************************************************************************************************************************************************************************************************************************************************************************************

 
 
 **********************************************************************************************************************************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************************************************************************************************************************

 * TABLES AND FIGURES IN THE MAIN TEXT:
 
 **********************************************************************************************************************************************************************************************************************************************************************************************
 **********************************************************************************************************************************************************************************************************************************************************************************************


** Table 7

sort code_municipality_TSE NUMERO_ZONA NUMERO_SECAO year

tset  munXzonaXsecao  idsecao_year

areg changelogturnout  c.logsharelow##c.pmism##i.exposed##c.gini  changelogaptos if first==1  , abs(code_municipality_TSE ) robust

areg changelogturnout  c.logsharelow##c.pmism##i.exposed##c.gini relmunlogsharelow changelogaptos if first==1  , abs(code_municipality_TSE ) robust

xtmixed changelogturnout  c.logsharelow##c.pmism##i.exposed##c.gini  changelogaptos     lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04  ratioaptos    if first==1 || ufd: ||  code_municipality_TSE:  ,  mle 

xtmixed changelogturnout  c.logsharelow##c.pmism##i.exposed##c.gini relmunlogsharelow changelogaptos     lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04  ratioaptos    if first==1 || ufd: ||  code_municipality_TSE:  ,  mle 


 
 
 ** Figure 8: 
 
sort code_municipality_TSE NUMERO_ZONA NUMERO_SECAO year

tset  munXzonaXsecao  idsecao_year
 
xtmixed changelogturnout  c.logsharelow##c.pmism##i.exposed##c.gini relmunlogsharelow changelogaptos     lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04  ratioaptos i.ufd   if first==1  ||  code_municipality_TSE:  ,  mle cluster(code_municipality_TSE)

margins, dydx(pmism) at( logsharelow=(-2(0.1)7 )   exposed==0   gini=0.7 ) noestimcheck 

marginsplot,  level(90) yline(0) name(nonexp) addplot(hist logsharelow if exposed==0 & e(sample), yaxis(2) fcolor(none) dens lcolor(gs8))  scheme(s1mono)

set more off

xtmixed changelogturnout  c.logsharelow##c.pmism##i.exposed##c.gini relmunlogsharelow changelogaptos     lpib lpop purb  p_secundario   mun_novo  area   comarca vereador_eleit   lrec_trans lfunc_ativ    ENLP2000 winmargin sameparty  pref_masc pref_idade_tse   exp_prefeito  pref_escola p_cad_pref  vereador9600      op_01_04  ratioaptos  i.ufd  if first==1 ||  code_municipality_TSE:  ,  mle cluster(code_municipality_TSE)

margins, dydx(pmism) at( logsharelow=(-2(0.1)7 )   exposed==1  gini=0.7 ) noestimcheck 

marginsplot,  level(90) yline(0) name(exp) addplot(hist logsharelow  if exposed==1 & e(sample), yaxis(2) fcolor(none) dens lcolor(gs8))  scheme(s1mono)

graph combine nonexp exp, xcommon ycommon 


