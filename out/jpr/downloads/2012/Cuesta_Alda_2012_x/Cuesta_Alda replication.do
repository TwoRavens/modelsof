*OLS(1)
xi: regress VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn TRUST [pw=FACTEXP] , cluster(BARRIOn)

est store OLS
xi: regress VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn TRUST, cluster(BARRIOn)
ivhettest 

*GMM(3)

xi: ivregress gmm VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO CALENO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

estat firststage
estat overid, forceweights
hausman OLS ., force 

*2SLS(2)
xi: ivregress gmm VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO CALENO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

est store GMM

xi: ivregress 2sls VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO CALENO), first 

est store DOS

estat firststage
estat overid

hausman  DOS GMM, force


*GMM (4)
xi: regress VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn TRUST [pw=FACTEXP] , cluster(BARRIOn)
est store OLS
xi: ivregress gmm VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)
estat firststage
estat endog, forceweights
hausman OLS ., force 


*OTHER MODELS (not presented in article)

*Number of victimization cases, VICTIM
xi: ivregress gmm VICTIM ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO CALENO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

*Poisson Model
xi: poisson VICTIM ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn TRUST [pw=FACTEXP] , cluster(BARRIOn)




* Models by Victimization Category

xi: ivregress gmm ASESINATO ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm PROPERTYOFFENCE ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm HURTO ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm BEATING ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm SEXOFFENCE ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm SECUESTRO ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm AMENAZAS ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm VIF ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)

xi: ivregress gmm INJURIES ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn (TRUST=TRUST_BARRIO) [pw=FACTEXP] , cluster(BARRIOn) first wmatrix(cluster BARRIOn)
 

*Simultaneous model
xi:  reg3 (VICTIM_01 ESTRATO MUJER D10  EDAD EDADSQ i.COMUNAn TRUST)  (TRUST VICTIM_01_BARRIO CALENO ESTRATO MUJER D10 EDAD EDADSQ I.COMUNAn)
  


