** Load the data cd \Users\uli\Desktop\Data_construction_comp\_submission_restatuse samplefinal, clear** Options: Y, W, Z, set of covariates, transformation of the dependent variable, subsample selection ** This part may be modified 	** transfo=0: no transformation	** transfo=1: log(.+1)	** transfo=2: Phi^(-1)(percentiles)	** transfo=3: Box-Cox	** subsamp=0: full sample	** subsamp=1: only girls	** subsamp=2: only boys	** subsamp=3: high father's social class (I,II)	** subsamp=4: low father's social class (III,IV,V)	** subsamp=5: date the school became comprehensive <=1968	** subsamp=6: date the school became comprehensive >=1969** If needed, 1st principal component of test scores** To be used as an instrument Zpca read7 math7, factor(1)predict abi** Options local nout=noutif `nout'==1{local y="math11"}else if `nout'==2{local y="read11"}else if `nout'==3{local y="verbal11"}local w1="abi"local z1="FEDUC MEDUC"local option="one"scalar transfo=0scalar subsamp=0mata:// Nboot=nb of bootstrap iterations// Nquant=nb of percentilesNboot=100Nquant=99// ngrid is the number of nods to compute the characteristic function (and integrate it)// npoint is the number of values where the densities/cdfs are evaluatedngrid=201npoint=1001// S is the bandwidth for the deconvolution// May be modified, using as a guide the approach in Diggle and Hall (1993)// See program Diggle.do// Here are reported the values for math16 as the dependent variabletransfo=st_numscalar("transfo")// Note: for the Box-Cox transformation, this unusual expression fits somehow the bandwidth choice // proposed by Diggle and Hall, for values of lambda comprised between 0 and 2S=(transfo==0)*.42+(transfo==1)*5.5+(transfo==2)*3.5end** Keep children with non-missing parental education when the Z's used are (FEDUC,MEDUC)local FEDUClist="FEDUC MEDUC"local a : list FEDUClist==z1if `a'==1 {keep if FEDUCmiss==0 & MEDUCmiss==0local zerolist=""}else {local zerolist="FEDUC MEDUC FEDUCmiss MEDUCmiss"}** Covariates: three possible choiceslocal onelist "`zerolist' cmsex sc580-sc584 sc58miss sc69* sc1965* sc65miss oldersib oldersibmiss mwork65 mwork65miss MINC1-MINC2 FINC1-FINC4" local twolist "`onelist' stay65 stay65miss nchildc65 nchildc65miss noschool noschoolmiss ptr69 ptr69miss junior69 buildage69 buildage69miss nostream69"/*!RESTRICTED LOCAL CONTROLS REMOVED FROM list three*/local threelist "`twolist' RE161-RE169"** Transforming the datagen init`y'=`y'** Rule of thumb's bandwidth for smoothing cdf's and pdf's** Used for estimates on the raw data onlyqui _pctile `y', p(25 75)scalar bw=(r(r2)-r(r1))/1.34qui su `y'scalar bw=.9*min(r(sd),bw)*_N^(-1/5)mata:bw=st_numscalar("bw")end** The program allows for several W's or Z'slocal b: list sizeof w1scalar B=`b'** Keep observations with non-missing dependent/independent variables keep ``option'list' `y' `w1' `z1' C GRAM SECMOD init`y' read7 math7qui reg `y' ``option'list'  `w1' `z1' Ckeep if e(sample)** Save the initial samplesave init, replace** Start mata routinemata: // Matrices of bootstrapped estimates: ratio of beta's, mean, variance, quantilesRT=J(Nboot,3,.)MT=J(Nboot,4,.)VT=J(Nboot,3,.)MT2=J(Nboot,1,.)VT2=J(Nboot,1,.)QT=J(Nboot,Nquant,.)MGS=J(Nboot,2,.)b=st_numscalar("B")// Bootstrap iterations// The iteration (Nboot+1) is the estimate on the original samplefor (j=1;j<=Nboot+1;j++){stata("use init, clear")// Bootstrap, clustered at the LEA (and individual) levelif (j<=Nboot){stata("bsample")}// 2SLS regression, to estimate the ratio of beta's// C=1 denotes comprehensiveif (j<=Nboot){stata("qui ivreg2 `y' (`w1'=`z1') ``option'list' if C==1")}if (j==Nboot+1){stata("ivreg2 `y' (`w1'=`z1') ``option'list' if C==1")}stata("matrix eb=e(b)")if (b==1){	stata("scalar Ratio1=eb[1,1]")	stata("scalar Ratio2=.")	stata("qui gen w=Ratio1*`w1'")	if (j<=Nboot){	RT[j,1]=st_numscalar("Ratio1")	}}else if (b==2){stata("scalar Ratio1=eb[1,1]")stata("scalar Ratio2=eb[1,2]")// Note: this line needs to be modified when there are 2 W's, different from (math11,read11)stata("qui gen w=Ratio1*math11+Ratio2*read11")if (j<=Nboot){	RT[j,1]=st_numscalar("Ratio1")	RT[j,2]=st_numscalar("Ratio2")	}}else if (b==3){stata("scalar Ratio1=eb[1,1]")stata("scalar Ratio2=eb[1,2]")stata("scalar Ratio3=eb[1,3]")// Note: this line needs to be modified when there are 3 W's, different from (math11,read11,verbal11)stata("qui gen w=Ratio1*math11+Ratio2*read11+Ratio3*verbal11")if (j<=Nboot){	RT[j,1]=st_numscalar("Ratio1")	RT[j,2]=st_numscalar("Ratio2")	RT[j,3]=st_numscalar("Ratio3")	}}// Compute regression residualsstata("qui reg `y' ``option'list' if C==1")stata("qui predict resy1, resid")stata("qui reg `y' ``option'list' if C==0")stata("qui predict resy0, resid")stata("qui reg w ``option'list' if C==1")stata("qui predict resw1, resid")stata("qui reg w ``option'list' if C==0")stata("qui predict resw0, resid")stata("qui reg `z1' ``option'list' if C==1")stata("qui predict resz11, resid")stata("qui reg `z1' ``option'list' if C==0")stata("qui predict resz10, resid")// Propensity score(X) stata("qui xi: logit C ``option'list' if C==0|C==1")stata("qui predict piX")if (j==Nboot+1){stata("su piX")}// Propensity score(X,Y1) stata("qui xi: logit C read7 math7 ``option'list' if C==0|C==1")stata("qui predict piX2")stata("qui su C if C==0|C==1")stata("scalar piC=r(mean)")// Mean effect, rawstata("qui su `y' if C==0")stata("scalar mean0=r(mean)")stata("qui su `y' if C==1")stata("scalar mean1=r(mean)")mean0=st_numscalar("mean0")mean1=st_numscalar("mean1")// Mean effect, matching on observables (X)stata("qui gen effectm=C/(1-piC)*(`y')*(1-piX)/piX if piX>=0.05 & piX<=0.95")stata("qui su effectm if C==0|C==1")stata("scalar meanm1=r(mean)")// Mean effect, matching on observables (X,Y1)stata("qui gen effectm2=C/(1-piC)*(`y')*(1-piX2)/piX2 if piX2>=0.05 & piX2<=0.95")stata("qui su effectm2 if C==0|C==1")stata("scalar meanm12=r(mean)")// Mean effect, matching on observables and unobservablesstata("qui su w if C==0")stata("qui gen effect=C/(1-piC)*(`y'-w)*(1-piX)/piX+r(mean) if piX>=0.05 & piX<=0.95")stata("qui su effect if C==0|C==1")stata("scalar meanc1=r(mean)")stata("scalar dmean=mean0-mean1")stata("scalar dmeanc=mean0-meanc1")stata("scalar dmeanm=mean0-meanm1")stata("scalar dmeanm2=mean0-meanm12")meanc1=st_numscalar("meanc1")meanm1=st_numscalar("meanm1")if (j<=Nboot){MT[j,1]=st_numscalar("dmean")MT[j,2]=st_numscalar("dmeanc")MT[j,3]=st_numscalar("dmeanm")MT[j,4]=st_numscalar("dmeanm2")}}// END OF BOOTSTRAPendmata:st_matrix("eb1",sqrt(variance(MT[,2])))st_matrix("eb2",sqrt(variance(MT[,3])))st_matrix("eb3",sqrt(variance(MT[,4])))enduse table7, clearreplace cov`nout'=dmeanc if _n==1replace cov`nout'std=eb1[1,1] if _n==1replace cov`nout'=dmeanm if _n==2replace cov`nout'std=eb2[1,1] if _n==2replace cov`nout'=dmeanm2 if _n==3replace cov`nout'std=eb3[1,1] if _n==3save table7, replace