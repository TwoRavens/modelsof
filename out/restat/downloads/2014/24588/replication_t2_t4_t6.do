#delimit ;
clear all;
set mem 100m;
set more off;
capture log close;
log using replication.log, replace;

use replicationdata_t4-t6.dta, clear;


*********************************************;
****           TABLE 2                ******;
*********************************************;
global prefchar3 "cd_age pref_pri pref_high pref_college cd_sexo2000 pref_experience";
global munichar3 "dong sh_pubsector djornal dradio SedeComarca shquota cad_treino_me be_conselho";

local varlist "$munichar $prefchar3 $munichar3 pref_esposa_politico sh_nepot_prefeitura_i1 sh_secpol  nfuncionarios totsec cad_pub_communidades cad_pub_escolas ncond_visita  cad_verify pdelib2  desistiu1999 propbe1999";
gen first = 1 if reeleito ==0;
replace first = 0 if reeleito==1;

foreach x of local varlist {;
  reg `x' first reeleito [pw=nstrata], noc; 
  areg `x' reeleito [pw=nstrata], robust abs(uf); 
};



*********************************************;
****           TABLE 4                 ******;
*********************************************;

reg impact3 reeleito [pw=nstrata] , robust;
areg impact3 reeleito $munichar $prefchar2 [pw=nstrata] , robust abs(uf);
areg impact3 reeleito $munichar $prefchar2 $munichar2 [pw=nstrata] , robust abs(uf);
areg impact3 reeleito_exp  $munichar $prefchar2 [pw=nstrata ]  , robust abs(uf);
areg impact3 reeleito_first $munichar cd_age cd_educ2000 cd_sexo2000 pref_experience party_d1 party_d2 party_d3 party_d5 party_d6 party_d7 party_d8 party_d12 $munichar2 [pw=nstrata] , robust abs(uf);
areg impact3 reeleito pref_esposa_politico sh_nepot_prefeitura_i1 sh_secpol  nfuncionarios totsec  $munichar $prefchar2 $munichar2 [pw=nstrata] , robust abs(uf);

*********************************************;
****           TABLE 5                 ******;
*********************************************;

reg reeleito00_04 impact3  [pw=nstrata], robust;
  sum reeleito00_04 if e(sample)==1;
areg reeleito00_04 impact3  $munichar $prefchar2 [pw=nstrata], robust abs(uf);

reg reeleito00_04 dimpact_25   [pw=nstrata] , robust;
areg reeleito00_04 dimpact_25   $munichar $prefchar2 [pw=nstrata], robust abs(uf);

reg reeleito00_04 denuncia_renda  [pw=nstrata], robust;
areg reeleito00_04 denuncia_renda  $munichar $prefchar2 [pw=nstrata], robust abs(uf);

reg reeleito00_04 denuncia_renda dimpact_25 [pw=nstrata], robust;
areg reeleito00_04 denuncia_renda  dimpact_25 $munichar $prefchar2 [pw=nstrata], robust abs(uf);

*********************************************;
****           TABLE 6                 ******;
*********************************************;

areg  impact3 cad_pub_escolas  $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
  sum impact3 if e(sample)==1;

areg  impact3 cad_verify  $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
  sum impact3 if e(sample)==1;

areg  impact3 pdelib2     $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
  sum impact3 if e(sample)==1;

areg  impact3 ncond_visita  $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
  sum impact3 if e(sample)==1;

areg  cad_pub_escolas  reeleito   $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
 sum cad_pub_escolas if e(sample)==1;

areg  cad_verify reeleito    $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
 sum cad_verify if e(sample)==1;

areg  pdelib2  reeleito   $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
 sum pdelib2 if e(sample)==1;

areg  ncond_visita reeleito    $munichar $prefchar2 $munichar2  [pw=nstrata] , robust abs(uf);
 sum ncond_visita if e(sample)==1;


*********************************************;
****            FIGURE                 ******;
*********************************************;

**Figure 1**;
twoway (kdensity impact3) (scatter tstat3 impact3, msymbol(circle_hollow)), legend(order(1 "Impacts" 2 "t-statistic")) saving(kden_plot1, replace) yline(1.96); 

**Figure 2**;
lowess reeleito00_04 impact3 if impact3<.1&impact3>-.25, gen(Ereel) nograph;

gen impactbins =.;
gen lb =.;
gen ub=.;
quietly forvalues i = 0(1)100 {;
   replace lb =-.25+ 0.01*`i';
   replace ub =-.25+ 0.01*(`i'+1);
   replace impactbins = `i' if lb<=impact3&impact3<=ub;
};

egen mreel= mean(reeleito00_04),by(impactbins );
egen bintag = tag(impactbins );
two (scatter mreel impact3 if bintag ==1&impact3<.1)(line Ereel impact3, sort), xline(-.09) ytitle("Reelection rates") xtitle("Program Impacts") legend(off) xlab(-.25(.05).08) graphregion(color(white));




log close;
exit;

