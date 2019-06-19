
#delimit;
global clrLags "4";

* Model 1: n=0, OLS, lagged consumption only;
reg dcnsm L.dcnsm if tin($startReg,$endReg);	* OLS;
scalar m1r2 = e(r2_a);
newey  dcnsm L.dcnsm if tin($startReg,$endReg), lag($nwLags);	* HAC errors;
scalar m1a1 = _b[L.dcnsm];
scalar m1se1 = _se[L.dcnsm];
scalar m1t1 = m1a1/m1se1;
scalar m1n = e(N);

* Model 2: n=1, predicted (instrumented) consumption only;
reg dcnsm $ivset1all if tin($startReg,$endReg);
scalar m2r1 = e(r2_a);
predict dconsHatm2;
reg dcnsm L.dconsHatm2 if tin($startReg,$endReg);
scalar m2r2 = e(r2_a);

ivreg2 dcnsm (L.dcnsm = $ivset2all) if tin($startReg,$endReg), robust bw($nwLags) ffirst;	* IV (kitchen sink);
scalar m2a1= _b[L.dcnsm];
scalar m2se1=_se[L.dcnsm];
scalar m2t1 = m2a1/m2se1;
matrix efirst = e(first);
scalar m2p1 = efirst[6,1];
scalar m2f1 = efirst[3,1];
scalar m2p2 = e(jp);
scalar m2n = e(N);

* CLR tests;
*************************************;
condivreg_hac_cleanV02 dcnsm (L.dcnsm = $ivset2all) if tin($startReg,$endReg), lag($clrLags);	* get the weak-robust CIs;

sca m2rhoCIlow = e(LR_x1);
sca m2rhoCIhi = e(LR_x2);
sca m2rho = _b[L.dcnsm];
sca m2rhoSe = _se[L.dcnsm];
sca m2rBarC = .;
sca m2rhoPval = abs(e(LR_p));
sca m2fFirst = e(F_first);


* For "true" consumption do OLS;
************************************************************************************************;
if $cStarIndex==1 {;

	* Model 2: n=1, OLS consumption only;
	scalar m2r1 = .;
	reg dcnsm L.dcnsm if tin($startReg,$endReg);
	scalar m2r2 = e(r2_a);
	scalar m2a1 = _b[L.dcnsm];
	scalar m2se1 = _se[L.dcnsm];
	scalar m2t1 = m2a1/m2se1;
	scalar m2p1 = .;
	scalar m2f1 = .;
	scalar m2p2 = .;
	scalar m2n = e(N);

};

* Model 3: n=1, predicted (instrumented) income only [a la Campbell&Mankiw];
*************************************;
reg dinc $ivset2all if tin($startReg,$endReg);
scalar m3r1 = e(r2_a);
predict dincHatm3;
reg dcnsm dincHatm3 if tin($startReg,$endReg);
scalar m3r2 = e(r2_a);

ivreg2 dcnsm (dinc = $ivset2all) if tin($startReg,$endReg), robust bw($nwLags) ffirst;	* IV (kitchen sink);
scalar m3a2= _b[dinc];
scalar m3se2=_se[dinc];
scalar m3t2= m3a2/m3se2;
matrix efirst = e(first);
scalar m3p1 = efirst[6,1];
scalar m3f1 = efirst[3,1];
scalar m3p2 = e(jp);
scalar m3n = e(N);

* CLR tests;
condivreg_hac_cleanV02 dcnsm (dinc = $ivset2all) if tin($startReg,$endReg), lag($clrLags);	* get the weak-robust CIs;

sca m3rhoCIlow = e(LR_x1);
sca m3rhoCIhi = e(LR_x2);
sca m3rho = _b[dinc]; 
sca m3rhoSe = _se[dinc];
sca m3rBarC = .;
sca m3rhoPval = abs(e(LR_p));
sca m3fFirst = e(F_first);

* Model 4: n=1, predicted (instrumented) wealth only;
reg wyRatio $ivset1all if tin($startReg,$endReg);
scalar m4r1 = e(r2_a);
predict wyRatioHatm4;
reg dcnsm L.wyRatioHatm4 if tin($startReg,$endReg);
scalar m4r2 = e(r2_a);

ivreg2 dcnsm (wyRatio = $ivset2all) if tin($startReg,$endReg), robust bw($nwLags) ffirst;	* IV (kitchen sink);
scalar m4a3= _b[wyRatio];
scalar m4se3=_se[wyRatio];
scalar m4t3=m4a3/m4se3;
matrix efirst = e(first);
scalar m4p1 = efirst[6,1];
scalar m4f1 = efirst[3,1];
scalar m4p2 = e(jp);
scalar m4n = e(N);

* CLR tests;
condivreg_hac_cleanV02 dcnsm (L.wyRatio = $ivset2all) if tin($startReg,$endReg), lag($clrLags);	* get the weak-robust CIs;

sca m4rhoCIlow = e(LR_x1);
sca m4rhoCIhi = e(LR_x2);
sca m4rho = _b[L.wyRatio]; 
sca m4rhoSe = _se[L.wyRatio];
sca m4rBarC = .;
sca m4rhoPval = abs(e(LR_p));
sca m4fFirst = e(F_first);

* Model 5: n=1, predicted (instrumented) consumption, íncome and wealth [Horse race];
reg dcnsm $ivset1all if tin($startReg,$endReg);
predict dcnsmHatm5;
reg dinc $ivset2all if tin($startReg,$endReg);
predict dincHatm5;
scalar m5r1inc = e(r2_a);
matrix efirst = e(first);
scalar m5f1inc = efirst[3,1];
reg wyRatio $ivset1all if tin($startReg,$endReg);
predict wyRatioHatm5;
scalar m5r1wea = e(r2_a);
reg dcnsm L.dcnsmHatm5 dincHatm5 L.wyRatioHatm5 if tin($startReg,$endReg);;
scalar m5r2 = e(r2_a);
scalar m5rC1=e(r2_a);

* do an arbitrary regression of everything just to find out for what sample the data are available;
reg dcnsm dinc wyRatio $ivset1all if tin($startReg,$endReg);
predict dcnsmFit if tin($startReg,$endReg); 

ivreg2 dcnsm (L.dcnsm dinc L.wyRatio = $ivset2all) if tin($startReg,$endReg), robust bw($nwLags) ffirst;	* IV (kitchen sink);
scalar m5a1= _b[L.dcnsm];
scalar m5se1=_se[L.dcnsm];
scalar m5t1=m5a1/m5se1;
scalar m5a2= _b[dinc];
scalar m5se2=_se[dinc];
scalar m5t2=m5a2/m5se2;
scalar m5a3= _b[L.wyRatio];
scalar m5se3=_se[L.wyRatio];
scalar m5t3=m5a3/m5se3;
scalar m5p2 = e(jp);
scalar m5n = e(N);
mat mFirst=e(first);
scalar m5a1fStat=mFirst[3,1];

* For "true" consumption instument income and wealth ONLY;
************************************************************************************************;
if $cStarIndex==1 {;

	ivreg2 dcnsm L.dcnsm (dinc L.wyRatio = $ivset2all) if tin($startReg,$endReg), robust bw($nwLags) ffirst;	* IV (kitchen sink);
	scalar m5a1= _b[L.dcnsm];
	scalar m5se1=_se[L.dcnsm];
	scalar m5t1=m5a1/m5se1;
	scalar m5a2= _b[dinc];
	scalar m5se2=_se[dinc];
	scalar m5t2=m5a2/m5se2;
	scalar m5a3= _b[L.wyRatio];
	scalar m5se3=_se[L.wyRatio];
	scalar m5t3=m5a3/m5se3;
	scalar m5p2 = e(jp);
	scalar m5n = e(N);
	scalar m5a1fStat=.;

};


**********************************************************************************;
qui summ dcnsm if tin($startReg,$endReg);
scalar varC = r(sd);
scalar bBase = m2a1; *m5a1/m2a1;
qui summ dinc if tin($startReg,$endReg);
scalar varY = r(sd);

* put it all together;
**********************************************************************************;
*m1a1,m2a1,m3a2,m4a3,m5a1,m5a2,m5a3,m5p2,m2r1,m2f1; *with consumption Rbar;
*m1a1,m2a1,m3a2,m4a3,m5a1,m5a2,m5a3,m5p2,m5r1inc,m5f1inc; *with income Rbar;
mat t1point=(
m1a1,m2a1,m3a2,m4a3,m5a1,m5a2,m5a3,m5p2,m2r1,m2f1
);

mat t1se=(
m1se1,m2se1,m3se2,m4se3,m5se1,m5se2,m5se3
);

mat t1pval=(
m2rhoPval,m3rhoPval,m4rhoPval
);

drop dconsHatm2 dincHatm3 wyRatioHatm4 dcnsmHatm5 dincHatm5 wyRatioHatm5;

