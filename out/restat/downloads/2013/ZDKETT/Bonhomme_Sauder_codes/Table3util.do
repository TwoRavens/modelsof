** Load the data use samplefinal, clearlocal y="math16"local w1="math11"local ncov=ncovlocal ninst=ninstif `ncov'==1{local option="one"}else if `ncov'==2{local option="two"}else if `ncov'==3{local option="three"}else if `ncov'==4{local option="five"}else if `ncov'==5{local option="six"}if `ninst'==1{local z1="math7 read7"}else if `ninst'==2{local z1="draw copy"}else if `ninst'==3{local z1="FEDUC MEDUC"}** Nboot=nb of bootstrap iterationsmata Nboot=100** Keep children with non-missing parental education when the Z's used are (FEDUC,MEDUC)local FEDUClist="FEDUC MEDUC"local aa : list FEDUClist==z1if `aa'==1 {keep if FEDUCmiss==0 & MEDUCmiss==0local zerolist=""}else {local zerolist="FEDUC MEDUC FEDUCmiss MEDUCmiss"}** Covariates: seven possible choiceslocal onelist "`zerolist' cmsex sc580-sc584 sc58miss sc69* sc1965* sc65miss oldersib oldersibmiss mwork65 mwork65miss MINC1-MINC2 FINC1-FINC4" local twolist "`onelist' stay65 stay65miss nchildc65 nchildc65miss noschool noschoolmiss ptr69 ptr69miss junior69 buildage69 buildage69miss nostream69"local threelist "`twolist' RE161-RE169"*!RESTRICTED: only available with special license*local fourlist "`threelist' lab_cont pop_size pop_dens indus"local fivelist "`threelist'"** Sixlist is a list of interacted covariateslocal a: list sixlist==`option'listif `a'==1{if `aa'==0{local sixlist "cmsex FEDUC sc580-sc584 nchildc65 junior69 buildage69 nostream69 RE161-RE169"foreach vv of varlist `sixlist'{foreach ww of varlist `sixlist'{gen `vv'`ww'=`vv'*`ww'}}local sixlist "cmsex* FEDUC* sc58* nchildc65* junior69* buildage69* nostream69* RE161*"#delimit ;local sixlist "`sixlist' sc69* sc58miss sc1965* sc65miss oldersib oldersibmiss mwork65 mwork65miss MINC1-MINC2 FINC1-FINC4 stay65 stay65miss nchildc65miss noschool noschoolmiss ptr69 ptr69miss  buildage69miss";#delimit crqui drop cmsexcmsex cmsexFEDUC cmsexnchildc65 FEDUCsc581 FEDUCsc582 FEDUCbuildage69 FEDUCnostream69 FEDUCRE161 qui drop sc580cmsex sc580FEDUC sc580sc580 sc580sc581 sc580sc582 sc580sc583 sc580sc584 qui drop sc580nchildc65 sc580nostream69 sc581cmsex sc581sc580 sc581sc581 sc581sc582 qui drop sc581sc583 sc581sc584 sc582cmsex sc582sc580 sc582sc581 sc582sc582 qui drop sc582sc583 sc582sc584 sc582nostream69 sc583cmsex sc583FEDUC sc583sc580 sc583sc581 qui drop sc583sc582 sc583sc583 sc583sc584 sc584cmsex sc584FEDUC sc584sc580 qui drop sc584sc581 sc584sc582 sc584sc583 sc584sc584 sc584RE161 nchildc65FEDUC qui drop nchildc65sc581 nchildc65sc582 nchildc65sc583 nchildc65sc584 qui drop nchildc65junior69 junior69cmsex junior69FEDUC junior69sc580 junior69sc581 qui drop junior69sc582 junior69sc583 junior69sc584 junior69junior69 buildage69cmsex qui drop buildage69sc580 buildage69sc581 buildage69sc582 buildage69sc583 buildage69sc584 qui drop buildage69nchildc65 buildage69junior69 nostream69cmsex nostream69sc581 nostream69sc583 nostream69sc584 nostream69nchildc65 qui drop nostream69junior69 nostream69buildage69 nostream69nostream69qui drop RE161 RE161cmsex RE161sc58* RE161nchildc65 RE161junior69 RE161buildage69 RE161nostream69 RE161RE* }else if `aa'==1{local sixlist "cmsex sc580-sc584 nchildc65 junior69 buildage69 nostream69 RE161-RE169"foreach vv of varlist `sixlist'{foreach ww of varlist `sixlist'{gen `vv'`ww'=`vv'*`ww'}}local sixlist "cmsex* sc58* nchildc65* junior69* buildage69* nostream69* RE161*"#delimit ;local sixlist "`sixlist' sc69* sc58miss sc1965* sc65miss oldersib oldersibmiss mwork65 mwork65miss MINC1-MINC2 FINC1-FINC4 stay65 stay65miss nchildc65miss noschool noschoolmiss ptr69 ptr69miss  buildage69miss";#delimit crqui drop cmsexcmsex cmsexnchildc65  qui drop sc580cmsex  sc580sc580 sc580sc581 sc580sc582 sc580sc583 sc580sc584 drop sc580nchildc65 sc580nostream69 sc581cmsex sc581sc580 sc581sc581 sc581sc582 qui drop sc581sc583 sc581sc584 sc582cmsex sc582sc580 sc582sc581 sc582sc582 qui drop sc582sc583 sc582sc584 sc582nostream69 sc583cmsex  sc583sc580 sc583sc581 qui drop sc583sc582 sc583sc583 sc583sc584 sc584cmsex  sc584sc580 qui drop sc584sc581 sc584sc582 sc584sc583 sc584sc584 sc584RE161  qui drop nchildc65sc581 nchildc65sc582 nchildc65sc583 nchildc65sc584 qui drop nchildc65junior69 junior69cmsex  junior69sc580 junior69sc581 qui drop junior69sc582 junior69sc583 junior69sc584 junior69junior69 buildage69cmsex qui drop buildage69sc580 buildage69sc581 buildage69sc582 buildage69sc583 buildage69sc584 qui drop buildage69nchildc65 buildage69junior69 nostream69cmsex nostream69sc581 nostream69sc583 nostream69sc584 nostream69nchildc65 qui drop nostream69junior69 nostream69buildage69 nostream69nostream69qui drop RE161 RE161cmsex RE161sc58* RE161nchildc65 RE161junior69 RE161buildage69 RE161nostream69 RE162RE* }}** Keep observations with non-missing dependent/independent variables keep ``option'list' `y' `w1' `z1' C GRAM SECMODqui reg `y' ``option'list'  `w1' `z1' Ckeep if e(sample)** Save the initial samplesave init, replace** Start mata routinemata: // Matrices of bootstrapped estimates: raw, ATT(X, endowment), ATT-matching(X), ATT-matching(X,Y1)MT=J(Nboot,5,.)// Bootstrap iterations// The iteration (Nboot+1) is the estimate on the original samplefor (j=1;j<=Nboot+1;j++){stata("use init, clear")// RESTRICTED: Needed to remove clustering at la level// Bootstrap, clustered at the LEA (and individual) levelif (j<=Nboot){stata("bsample")}// 2SLS regression, to estimate the ratio of beta's// C=1 denotes comprehensiveif (j<=Nboot){stata("qui ivreg2 `y' (`w1'=`z1') ``option'list' if C==1")}if (j==Nboot+1){stata("qui ivreg2 `y' (`w1'=`z1') ``option'list' if C==1, first")}stata("matrix eb=e(b)")	stata("scalar Ratio1=eb[1,1]")	stata("scalar Ratio2=.")	stata("qui gen w=Ratio1*`w1'")// Compute regression residualsstata("qui reg `y' ``option'list' if C==1")stata("qui predict resy1, resid")stata("qui reg `y' ``option'list' if C==0")stata("qui predict resy0, resid")stata("qui reg w ``option'list' if C==1")stata("qui predict resw1, resid")stata("qui reg w ``option'list' if C==0")stata("qui predict resw0, resid")stata("qui reg `z1' ``option'list' if C==1")stata("qui predict resz11, resid")stata("qui reg `z1' ``option'list' if C==0")stata("qui predict resz10, resid")// Propensity score(X) stata("qui xi: logit C ``option'list' if C==0|C==1")stata("qui predict piX")if (j==Nboot+1){stata("su piX")}// Propensity score(X,Y1) stata("qui xi: logit C `w1' ``option'list' if C==0|C==1")stata("qui predict piX2")stata("qui su C if C==0|C==1")stata("scalar piC=r(mean)")// Mean effect, rawstata("qui su `y' if C==0")stata("scalar mean0=r(mean)")stata("qui su `y' if C==1")stata("scalar mean1=r(mean)")mean0=st_numscalar("mean0")mean1=st_numscalar("mean1")// Mean effect, matching on observables (X)stata("qui gen effectm=C/(1-piC)*(`y')*(1-piX)/piX if piX>=0.05 & piX<=0.95")stata("qui su effectm if C==0|C==1")stata("scalar meanm1=r(mean)")// Mean effect, matching on observables (X,Y1)stata("qui gen effectm2=C/(1-piC)*(`y')*(1-piX2)/piX2 if piX2>=0.05 & piX2<=0.95")stata("qui su effectm2 if C==0|C==1")stata("scalar meanm12=r(mean)")// Mean effect, matching on observables and unobservablesstata("qui su w if C==0")stata("qui gen effect=C/(1-piC)*(`y'-w)*(1-piX)/piX+r(mean) if piX>=0.05 & piX<=0.95")stata("qui su effect if C==0|C==1")stata("scalar meanc1=r(mean)")stata("scalar dmean=mean0-mean1")stata("scalar dmeanc=mean0-meanc1")stata("scalar dmeanm=mean0-meanm1")stata("scalar dmeanm2=mean0-meanm12")meanc1=st_numscalar("meanc1")meanm1=st_numscalar("meanm1")meanm12=st_numscalar("meanm12")// Mean effect, regression on observables and unobservablesstata("qui gen inter=`y'-resy1 if C==0")stata("qui su inter if C==0")stata("scalar mean1reg=r(mean)")stata("qui replace inter=w-resw0 if C==0")stata("qui su inter if C==0")stata("scalar mean1reg=mean1reg+r(mean)")stata("qui replace inter=w-resw1 if C==0")stata("qui su inter if C==0")stata("scalar mean1reg=mean1reg-r(mean)")stata("scalar dmeanreg=mean0-mean1reg")if (j<=Nboot){MT[j,1]=st_numscalar("dmean")MT[j,2]=st_numscalar("dmeanc")MT[j,3]=st_numscalar("dmeanm")MT[j,4]=st_numscalar("dmeanm2")MT[j,5]=st_numscalar("dmeanreg")}}// END OF BOOTSTRAPend// Mean effect, regression on observables (X)qui reg `y' C ``option'list'matrix ebreg=-e(b)matrix eVreg=e(V)// Mean effect, regression on observables (X,Y1)qui reg `y' C `w1' ``option'list'matrix ebreg2=-e(b)matrix eVreg2=e(V)mata:st_matrix("eb1",sqrt(variance(MT[,2])))st_matrix("eb2",sqrt(variance(MT[,3])))st_matrix("eb3",sqrt(variance(MT[,4])))st_matrix("eb4",sqrt(variance(MT[,5])))enduse table3, clearreplace cov`ncov'=dmeanreg if _n==`ninst'replace cov`ncov'std=eb4[1,1] if _n==`ninst'replace cov`ncov'=dmeanc if _n==5+`ninst'replace cov`ncov'std=eb1[1,1] if _n==5+`ninst'if `ninst'==2{replace cov`ncov'=ebreg[1,1] if _n==4replace cov`ncov'std=sqrt(eVreg[1,1]) if _n==4replace cov`ncov'=ebreg2[1,1] if _n==5replace cov`ncov'std=sqrt(eVreg2[1,1]) if _n==5replace cov`ncov'=dmeanm if _n==9replace cov`ncov'std=eb2[1,1] if _n==9replace cov`ncov'=dmeanm2 if _n==10replace cov`ncov'std=eb3[1,1] if _n==10}save table3, replace*** NOTE on Table 3:* The estimates are arrangned in rows (different estimators) and columns (set of covariates used) in the table* Row 1-3 corresponds to ATT on observables and unobservables using the three different set of instruments* Row 4-5 correspond to ATT using IPW (Hirano), where row 5 also includes age 11 test scores -> Y1 in the current code* Rows 6-10 correspond to the matching effects (not reported)* Note that significance levels are slightly different from the paper - this is due to the non-availability of local area controls* in the re-deposited NCDS sample.