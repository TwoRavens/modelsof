// THIS FILE IS FOR USE WITH THE STATA FILE "Data_HKSReplication_80-2000Sample.dta"

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

***************************************************************
***************************************************************
// MODELS 7-9 IN TABLE 3
***************************************************************
***************************************************************
regress dmea_re meastart_re infl_low ix_meainfl log_durablestart polity2 enp_gov  log_cgdp 
estimates store mea_lowfull
regress dmea_re meastart_re infl_low ix_meainfl log_durablestart polity2 enp_gov  log_cgdp if country!="Thailand"
estimates store mea_lowfull_thailand
regress ddpt_re dptstart_re infl_low ix_dptinfl log_durablestart polity2 enp_gov log_cgdp 
estimates store dpt_lowfull

***************************************************************
***************************************************************
// CODES FOR THE 3 OF THE 4 GRAPHS IN FIGURE 3
***************************************************************
***************************************************************

estimates restore mea_lowfull
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
gen a=2.009*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV  if MV<0.75 , clwidth(medium) clcolor(black)  
    || line upper  MV  if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV  if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(Model 7)
   xlabel()
  legend(off)
  note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

estimates restore mea_lowfull_thailand
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
gen a=2.009*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV  if MV<0.75 , clwidth(medium) clcolor(black)  
    || line upper  MV  if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV  if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(Model 8)
   xlabel()
  legend(off)
 note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr

estimates restore dpt_lowfull
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
gen a=2.009*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV  if MV<0.75 , clwidth(medium) clcolor(black)  
    || line upper  MV  if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV  if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Marginal Effect of Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(Model 9)
   xlabel()
  legend(off)
 note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr


***********************END FILE *****************