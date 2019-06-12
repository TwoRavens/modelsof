// THIS FILE IS FOR USE WITH THE STATA FILE "Data_HKSReplication_90-2000Sample.dta"

***************************************************************
***************************************************************
// CREATE THE NEEDED INTERACTION TERMS
***************************************************************
***************************************************************
gen ix_meainfl = meastart_re*infl_low
label var ix_meainfl  "Interaction term between Initial Measles Value & Party Nationalization"
gen ix_dptinfl = dptstart_re*infl_low
label var ix_dptinfl  "Interaction term between Initial DPT Value & Party Nationalization"
gen ix_infinfl = infmortstart*infl_low
label var ix_infinfl  "Interaction term between Initial Infant Mortality Value & Party Nationalization"

gen ix_meaB = meastart_re*PSNS_sw
label var ix_meaB  "Interaction term between Initial Measles Value & Boschler's Measure"
gen ix_dptB = dptstart_re*PSNS_sw
label var ix_dptB  "Interaction term between Initial DPT Value & Boschler's Measure"
gen ix_infB= infmortstart*PSNS_sw
label var ix_infB  "Interaction term between Initial Infant Mortality Value & Boschler's Measure"

***************************************************************
***************************************************************
// MAIN RESULTS (1990-2000)
// MODELS 1-3 IN TABLE 2
***************************************************************
***************************************************************
regress dmea_re meastart_re infl_low ix_meainfl log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa , robust
estimates store mea_lowfull2

regress ddpt_re dptstart_re infl_low ix_dptinfl  log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa , robust
estimates store dpt_lowfull2

regress dinfmort infmortstart infl_low ix_infinfl log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa , robust
estimates store inf_lowfull2

***Summary statistics for the above models
estimates restore mea_lowfull2
sum dmea_re ddpt_re dinfmort meastart_re dptstart_re infmortstart infl_low log_durablestart polity2 enp_gov log_cgdp if e(sample)

***************************************************************
***************************************************************
// ROBUSTNESS CHECKS (1990-2000)
// MODELS 4-6 IN TABLE 2
// THESE USE AN EXTENDED SET OF CONTROL VARIABLES
***************************************************************
***************************************************************
regress dmea_re meastart_re infl_low ix_meainfl log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa log_avemag system plurality poprural log_pop f , robust
estimates store mea_extended

regress ddpt_re dptstart_re infl_low ix_dptinfl log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa log_avemag system plurality poprural log_pop f , robust
estimates store dpt_extended

regress dinfmort infmortstart infl_low ix_infinfl log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa log_avemag system plurality poprural log_pop f, robust
estimates store inf_extended

***************************************************************
***************************************************************
// ROBUSTNESS CHECKS (1990-2000)
// MODELS 11-13 IN TABLE 4
// THESE USE BOSCHLER'S MEASURE OF PARTY SYSTEM NATIONALIZATION/REGIONALISM
***************************************************************
***************************************************************
regress dmea_re meastart_re PSNS_sw ix_meaB log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa , robust
estimates store psnssw_mea

regress ddpt_re dptstart_re PSNS_sw ix_dptB log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa , robust
estimates store psnssw_dpt

regress dinfmort infmortstart PSNS_sw ix_infB log_durablestart polity2 enp_gov log_cgdp easia sasia lamerica eeurope mideast africa  , robust
estimates store psnssw_inf

***************************************************************
***************************************************************
// CODES FOR THE 3 GRAPHS IN FIGURE 2
***************************************************************
***************************************************************
***Code for Top Left graph in Figure 2
estimates restore mea_lowfull2
#delimit ;
generate MV=((_n-1)/10);
replace  MV=. if _n>10;
matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];
scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV if _n<10;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<10; 
gen a=1.96*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV , clwidth(medium) clcolor(black)  
    || line upper  MV , clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV , clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of  Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(DV: Measles Immunization)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

***Code for Top Right graph in Figure 2
estimates restore dpt_lowfull2
#delimit ;
generate MV=((_n-1)/10);
replace  MV=. if _n>10;
matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];
scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV if _n<10;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<10; 
gen a=1.96*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV , clwidth(medium) clcolor(black)  
    || line upper  MV , clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV , clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of  Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(DV: DPT Immunization)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

***Code for Bottom Left graph in Figure 2
estimates restore inf_lowfull2
#delimit ;
generate MV=((_n-1)/10);
replace  MV=. if _n>10;
matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];
scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV if _n<10;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<10; 
gen a=1.96*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV , clwidth(medium) clcolor(black)  
    || line upper  MV , clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV , clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of  Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(DV: DPT Immunization)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

***************************************************************
***************************************************************
// ROBUSTNESS CHECKS (1990-2000)
// CODES FOR THE 3 GRAPHS IN FIGURE 4
***************************************************************
***************************************************************
***Code for Top Left graph in Figure 4
estimates restore psnssw_mea
#delimit ;
generate MV=((_n-1)/10);
replace  MV=. if _n>15;
matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];
scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV if _n<15;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<15; 
gen a=1.96*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV if MV<=1, clwidth(medium) clcolor(black)  
    || line upper  MV if MV<=1, clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV if MV<=1, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist PSNS_sw if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(DV: Measles Immunization)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

***Code for Top Right graph in Figure 2
estimates restore psnssw_dpt
#delimit ;
generate MV=((_n-1)/10);
replace  MV=. if _n>15;
matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];
scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV if _n<15;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<15; 
gen a=1.96*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV if MV<=1, clwidth(medium) clcolor(black)  
    || line upper  MV if MV<=1, clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV if MV<=1, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist PSNS_sw if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(DV: DPT Immunization)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

***Code for Bottom Left graph in Figure 2
estimates restore psnssw_inf
#delimit ;
generate MV=((_n-1)/10);
replace  MV=. if _n>15;
matrix b=e(b); 
matrix V=e(V);
scalar b1=b[1,1]; 
scalar b2=b[1,2];
scalar b3=b[1,3];
scalar varb1=V[1,1]; 
scalar varb2=V[2,2]; 
scalar varb3=V[3,3];
scalar covb1b3=V[1,3]; 
scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV if _n<15;
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<15; 
gen a=1.96*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV if MV<=1, clwidth(medium) clcolor(black)  
    || line upper  MV if MV<=1, clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV if MV<=1, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist PSNS_sw if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(DV: Infant Mortality)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr




***********************END FILE *****************