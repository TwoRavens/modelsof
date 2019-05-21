

#delimit;

reg racpolicy jimcrow13 disgust disgusjc13 angerjc13 anger fear fearjc13 ideology education income1 age south openissuejo1 if baddata2==0;

matrix b=e(b);

matrix V=e(V);

scalar b1=b[1,1];

scalar b2=b[1,2];

scalar b3=b[1,3];

scalar b4=b[1,4];

scalar b5=b[1,5];

scalar b6=b[1,6];

scalar b7=b[1,7];

scalar varb1=V[1,1];

scalar varb2=V[2,2];

scalar varb3=V[3,3];

scalar varb4=V[4,4];

scalar varb5=V[5,5];

scalar varb6=V[6,6];

scalar varb7=V[7,7];

scalar covb1b3=V[1,3];

scalar covb2b3=V[2,3];

scalar covb5b4=V[5,4];

scalar covb1b4=V[1,4];

scalar covb6b7=V[6,7];

scalar covb1b7=V[1,7];


scalar list b1 b2 b3 b4 b5 b6 b7 varb1 varb2 varb3 varb4 varb5 varb6 varb7 covb1b3 covb2b3 covb5b4 covb1b4 covb6b7 covb1b7 ;

gen conb_disgust=b1+b3*MV if _n<16;

gen conb_anger=b1+b4*MV if _n<16;

gen conb_fear=b1+b7*MV if _n<16;

gen conse_disgust=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<16;

gen conse_anger=sqrt(varb1+varb4*(MV^2)+2*covb1b4*MV) if _n<16;

gen conse_fear=sqrt(varb1+varb7*(MV^2)+2*covb1b7*MV) if _n<16;

gen a_disgust=1.96*conse_disgust;

gen upper_disgust=conb_disgust+a_disgust;

gen lower_disgust=conb_disgust-a_disgust;

gen a_anger=1.96*conse_anger;

gen upper_anger=conb_anger+a_anger;

gen lower_anger=conb_anger-a_anger;

gen a_fear=1.96*conse_fear;

gen upper_fear=conb_fear+a_fear;

gen lower_fear=conb_fear-a_fear;



twoway ///
(line conb_disgust MV, lcolor(black) lwidth(medium)lpattern(tight_dot)) ///
(line upper_disgust MV, lcolor(black) lwidth(thin) lpattern(dash)) ///
(line lower_disgust MV, lcolor(black) lwidth(thin) lpattern(dash)) ///
(line conb_anger MV, lcolor(black) lwidth(medium)) ///
(line conb_fear MV, lcolor(black) lwidth(medium)lpattern(longdash))  , ///
ytitle(Marginal Effect of Each Emotion on Policy Opinion) ytitle(, size(small)) ytitle(, margin(medium)) ///
xtitle(Old-fashioned Racism Scale) xtitle(, size(small)) xtitle(, margin(medium)) ///
title(Figure 2: Marginal Effect of Each Emotion on Policy Opinion as Old-fashioned Racism Changes) title(, size(small)) ///
legend(size(vsmall)) scheme(s1mono)
