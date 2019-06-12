// THIS FILE IS FOR USE WITH THE STATA FILE "Data_HKSReplication60-2000Sample.dta"

***************************************************************
***************************************************************
// CREATE THE NEEDED INTERACTION TERMS
***************************************************************
***************************************************************
gen ix_infinfl = infmortstart*infl_low
label var ix_infinfl  "Interaction term between Initial Infant Mortality Value & Party Nationalization"

***************************************************************
***************************************************************
// MODELS 10 IN TABLE 3
***************************************************************
***************************************************************
regress dinfmort infmortstart infl_low ix_infinfl log_cgdp log_durablestart polity2 enp_gov 

***************************************************************
***************************************************************
// CODE FOR THE BOTTOM RIGHT GRAPH IN FIGURE 3
***************************************************************
***************************************************************

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
gen a=2.086*conse;
gen upper=conb+a;
gen lower=conb-a;
graph twoway line conb   MV if MV<0.75 , clwidth(medium) clcolor(black)  
    || line upper  MV if MV<0.75 , clpattern(dash) clwidth(medium) clcolor(black)  
    || line lower  MV if MV<0.75, clpattern(dash) clwidth(medium) clcolor(black) 
    || hist infl_low if e(sample), yaxis(2) bin() bfcolor(none) blcolor(gs8) blwidth(thin) percent ytitle(Distribution of Modifying Variable (Percent), axis(2))
   ,ytitle(Effect of Lagged Level, size())  
   xtitle(Regional Fragmentation)  title(Model 10)
   xlabel()
  legend(off)
   yline(0, lcolor(black)) note() graphregion(color(white));
        drop MV conb conse a upper lower;
#delimit cr


***********************END FILE *****************