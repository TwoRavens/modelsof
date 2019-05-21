*Table 1 Main article

#delimit;
reg D.schooling  noncitvotsh if term==2, robust;
#delimit;
xi: reg D.schooling  noncitvotsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust;
#delimit;
xi: reg D.socialvard  noncitvotsh if term==2, robust;
#delimit;
xi: reg D.socialvard  noncitvotsh  Taxbase2 L.Taxbase2  pop L.pop manu L.manu if term==2, robust;

*Table 2 and Figure 2 Main Article

#delimit;
gen where = -20;
gen pipe = "|";
#delimit;
gen inter15=noncit15*noncitvotsh;
#delimit;
xi: reg D.schooling noncit15 L.noncit15 noncitvotsh inter15  if term==2 , robust;
outreg2 using size.tex, replace;
#delimit;
xi: reg D.schooling noncitvotsh noncit15 inter15   Taxbase2 L.Taxbase2  pop L.pop   manu L.manu if term==2, robust;
outreg2 using sizeint.tex, replace;
#delimit;
lincom _b[noncitvotsh]+_b[inter15]*.08;
lincom _b[noncitvotsh]+_b[inter15]*.21;
lincom _b[noncitvotsh]+_b[inter15]*0.37;
matrix b=e(b);matrix V=e(V);scalar b1=b[1,1];scalar b2=b[1,2];scalar b3=b[1,3];scalar varb1=V[1,1];scalar varb2=V[2,2];scalar varb3=V[3,3];scalar covb1b3=V[1,3];scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=(b1+b3*MV);
gen conse=sqrt(varb1+varb3*(MV*MV)+2*covb1b3*MV);
gen a=1.96*conse;gen upper=conb+a;gen lower=conb-a;


#delimit;
twoway (line conb MV if MV>=.118 & MV<=.3749, lcolor(black)) 
(line lower MV if MV>=.118 & MV<=.3749, clpattern(dash) clwidth(thin) lcolor(black) )
(line upper MV if MV>=.118 & MV<=.3749, clpattern(dash) clwidth(thin) lcolor(black))
(scatter where noncit15 if term==2, ms(none) mlabel(pipe) mlabcolor(black) mlabpos(0)), 
saving(totaleducult, replace)
title(Education Services, size(4))
xtitle("Proportion School-Aged Noncitizens") ytitle("") 
xlabel(.10(0.05).40)
xsca(range(.10 .40) titlegap(2))
             ysca(titlegap(2)) 
             legend(col(1) order(1 2) label(1 Marginal Effect) label(2 95% Confidence Interval)label(3 Ò Ó))
graphregion(fcolor(white))  plotregion(style(none))
 graphregion(color(white)) graphregion(margin(zero))
plotregion(lcolor(black) lwidth(thin))
;
#delimit;
gen where2 = -5;
drop conb- lower;
#delimit;
gen inter5=noncit5*noncitvotsh;
#delimit;
xi: reg D.socialvard  noncit15 noncitvotsh inter5   if term==2 , robust;
outreg2 using size.tex, append;
#delimit;
xi: reg D.socialvard  noncitvotsh noncit5  inter5  Taxbase2 L.Taxbase2  pop L.pop  manu L.manu  if term==2, robust ;
outreg2 using sizeint.tex, append;
lincom _b[noncitvotsh]+_b[inter5]*.04;
lincom _b[noncitvotsh]+_b[inter5]*.12;
lincom _b[noncitvotsh]+_b[inter5]*.19;
matrix b=e(b);matrix V=e(V);scalar b1=b[1,1];scalar b2=b[1,2];scalar b3=b[1,3];scalar varb1=V[1,1];scalar varb2=V[2,2];scalar varb3=V[3,3];scalar covb1b3=V[1,3];scalar covb2b3=V[2,3];
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3;
gen conb=b1+b3*MV;
gen conse=sqrt(varb1+varb3*(MV*MV)+2*covb1b3*MV);
gen a=1.96*conse;gen upper=conb+a;gen lower=conb-a;

#delimit;
twoway (line conb MV if MV>=.04 & MV<=.20, lcolor(black)) 
(line lower MV if MV>=.04 & MV<=.20, clpattern(dash) clwidth(thin) lcolor(black))
(line upper MV if MV>=.04 & MV<=.20, clpattern(dash) clwidth(thin) lcolor(black))
(scatter where2 noncit5 if term==2, ms(none) mlabel(pipe) mlabcolor(black) mlabpos(0)), 
saving(socialvard, replace)
title(Social and Family Services, size(4))
xtitle("Proportion Preschool-Aged Noncitizens") ytitle("") 
xlabel(.04(.02).20)
xsca(range(.04 .20) titlegap(2))
             ysca(titlegap(2)) 
             legend(col(1) order(1 2) label(1 Marginal Effect) label(2 95% Confidence Interval)label(3 Ò Ó))
graphregion(fcolor(white))  plotregion(style(none))
 graphregion(color(white)) graphregion(margin(zero))
plotregion(lcolor(black) lwidth(thin))
;
#delimit;
grc1leg  totaleducult.gph socialvard.gph, graphregion(fcolor(white))  plotregion(style(none))
 graphregion(color(white)) 
plotregion(lcolor(white)) rows(1) span;

*Table 3 Main article

#delimit;
xi: ivreg2 D.schooling  (noncitvotsh=inv1950 inv1967)    if term==2, first robust cluster(lan);
#delimit;
xi: ivreg2 D.schooling  (noncitvotsh=inv1950 inv1967)  Taxbase2 L.Taxbase2  manu L.manu pop L.pop  if term==2, first robust cluster(lan);
#delimit;
xi: ivreg2 D.socialvard  (noncitvotsh=inv1950 inv1967)    if term==2, first robust cluster(lan);
#delimit;
xi: ivreg2 D.socialvard  (noncitvotsh=inv1950 inv1967)  Taxbase2 L.Taxbase2  manu L.manu pop L.pop  if term==2, first robust cluster(lan);
#delimit;
reg D.schooling  L.estnoncitvotsh if term==2, robust;
#delimit;
xi: reg D.schooling  L.estnoncitvotsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust;
#delimit;
reg D.socialvard  L.estnoncitvotsh if term==2, robust;
#delimit;
xi: reg D.socialvard  L.estnoncitvotsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust;

*Table 1 Supporting Information
#delimit;
sum schooling L.schooling D.schooling socialvard L.socialvard D.socialvard noncitvotsh Taxbase2 L.Taxbase2 
pop L.pop manu L.manu noncit15 noncit5 inv1950 inv1967 L.estnoncitvotsh noncitturnsh Wasteinvest L.Wasteinvest
 D.Wasteinvest leftmaj L.leftmaj schoolinggrant L.schoolinggrant Socialvardgrant L.Socialvardgrant if term==2;

*Table 2 Supporting Information

pwcorr D.schooling D.socialvard noncitvotsh Taxbase2 L.Taxbase2 pop L.pop manu L.manu if term==2, star(10);

*Table 3 Supporting Information

#delimit;
xi: reg noncitvotsh inv1950 inv1967    if term==2, robust cluster(lan);
test inv1950 inv1967;
xi: reg noncitvotsh inv1950 inv1967   Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust cluster(lan);
test inv1950 inv1967;
*Table 4 Supporting Information

#delimit;
xi: reg noncitvotsh inv1950 Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2 , robust cluster(lan);
test inv1950;
#delimit;
xi: ivreg2 D.schooling  (noncitvotsh=inv1950)  Taxbase2 L.Taxbase2  manu L.manu pop L.pop  if term==2,  robust cluster(lan);
#delimit;
xi: ivreg2 D.socialvard  (noncitvotsh=inv1950)  Taxbase2 L.Taxbase2  manu L.manu pop L.pop  if term==2,  robust cluster(lan);
#delimit;
xi: reg noncitvotsh inv1967 Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2  , robust cluster(lan);
test inv1967;
#delimit;
xi: ivreg2 D.schooling  (noncitvotsh=inv1967)  Taxbase2 L.Taxbase2  manu L.manu pop L.pop  if term==2,  robust cluster(lan) first;
#delimit;
xi: ivreg2 D.socialvard  (noncitvotsh=inv1967)  Taxbase2 L.Taxbase2  manu L.manu pop L.pop  if term==2, robust cluster(lan);


*Table 5 Supporting Information
#delimit;
reg D.schooling  noncitturnsh if term==2, robust;
#delimit;
xi: reg D.schooling  noncitturnsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust;
#delimit;
reg D.socialvard  noncitturnsh if term==2, robust;
#delimit;
xi: reg D.socialvard  noncitturnsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust;

*Table 6 Supporting Information

#delimit;
xi: reg D.Wasteinvest noncitvotsh  if term==2, robust ;
xi: reg D.Wasteinvest noncitvotsh    Taxbase2 L.Taxbase2  pop L.pop manu L.manu  if term==2, robust ;

*Table 7 Supporting Information

#delimit;
xi: reg D.schooling  noncitvotsh  Taxbase2 L.Taxbase2  pop L.pop manu L.manu schoolinggrant L.schoolinggrant leftmaj L.leftmaj, robust;
#delimit;
xi: reg D.socialvard noncitvotsh   Taxbase2 L.Taxbase2  pop L.pop manu L.manu  Socialvardgrant L.Socialvardgrant leftmaj L.leftmaj if term==2, robust;

*Table 8 Supporting Information

#delimit;
gen varmdo=1 if kommun=="VŠrmdš";
recode varmdo .=0;
gen mellerud=1 if kommun=="Mellerud";
recode mellerud .=0;
#delimit;
gen stenungsund=1 if kommun=="Stenungsund";
recode stenungsund .=0;
#delimit;
#delimit;
xi: reg D.schooling noncitvotsh varmdo if term==2, robust ;
#delimit;
xi: reg D.schooling noncitvotsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu varmdo mellerud stenungsund if term==2, robust;
#delimit;
xi: reg D.socialvard noncitvotsh varmdo if term==2, robust ;
#delimit;
xi: reg D.socialvard noncitvotsh Taxbase2 L.Taxbase2  pop L.pop manu L.manu varmdo mellerud if term==2, robust;
