

  
*************************************
**For table 1* (time horizon to cim)*
*************************************
*model 1*
reg  d.cim l.cim d.timh   d.gdp d.lnpop d.natural d.interest d.govcons d.conflict l.timh l.gdp  l.lnpop l.natural l.interest l.govcons l.conflict if democracy==0, cluster(cow)

	**LRM 1**
	reg  d.cim l.cim d.timh   d.gdp d.lnpop d.natural d.interest d.govcons d.conflict timh gdp  lnpop natural interest govcons conflict if democracy==0, cluster(cow)
	predict yhat1
	reg  cim yhat1  d.timh   d.gdp d.lnpop d.natural d.interest d.govcons d.conflict timh gdp  lnpop natural interest govcons conflict if democracy==0, cluster(cow)
	drop yhat1  


*model 2*
reg  d.icrg l.icrg d.timh   d.gdp d.lnpop d.natural d.interest d.govcons d.conflict l.timh l.gdp  l.lnpop l.natural l.interest l.govcons l.conflict if democracy==0, cluster(cow)
 
  
****************************
*for table 2* (cim to fdi)**
****************************
*model 3*
reg  d.lnfdi  l.lnfdi   d.cim d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict l.cim l.gdp l.lnpop  l.gdpgrowth l.govcons   l.natural  l.conflict  if democracy==0 , cluster(cow)

	**LRM 3**
	reg  d.lnfdi  l.lnfdi   d.cim d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict cim gdp lnpop  gdpgrowth govcons   natural  conflict  if democracy==0 , cluster(cow)
	predict yhat2
	reg  lnfdi yhat2 d.cim d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict cim gdp lnpop  gdpgrowth govcons   natural  conflict  if democracy==0 , cluster(cow)
	drop yhat2
 
*model 4*
reg  d.lnfdi  l.lnfdi   d.icrg   d.gdp d.lnpop  d.gdpgrowth d.govcons  d.natural  d.conflict l.icrg   l.gdp  l.lnpop l.gdpgrowth  l.govcons   l.natural   l.conflict  if democracy==0 , cluster(cow)
 
 
 
 
 
********************************
*for  table 3* (timh-cim-fdi)**
********************************

**first, making samples consistent**
reg  d.cim l.cim d.timh   d.gdp d.lnpop d.natural d.interest d.govcons d.conflict l.timh l.gdp  l.lnpop l.natural l.interest l.govcons l.conflict if democracy==0, cluster(cow)
gen newsample=1 if e(sample)==1

reg cim l.timh if newsample==1,cluster(cow)
predict cim_timh_new if  newsample==1
 
reg  cim l.gdp l.lnpop l.natural l.interest l.govcons l.conflict  if  newsample==1, cluster(cow)
predict cim_notimh_new if  newsample==1

 

*model 5*
reg  d.lnfdi  l.lnfdi  d.cim_timh_new d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict l.cim_timh_new l.gdp l.lnpop  l.gdpgrowth l.govcons   l.natural  l.conflict  if democracy==0 , cluster(cow)
gen overlap_sample=0
replace overlap_sample=1  if e(sample)

	*******
	*LRM 5*
	*******
	reg  d.lnfdi  l.lnfdi   d.cim_timh_new    d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict cim_timh_new   gdp lnpop  gdpgrowth govcons   natural  conflict  if newsample==1 , cluster(cow)
	predict yhat2 if newsample==1
	reg  lnfdi yhat2 d.cim_timh_new    d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict cim_timh_new   gdp lnpop  gdpgrowth govcons   natural  conflict  if newsample==1 , cluster(cow)
	drop yhat2
 

*model 6*
reg  d.lnfdi  l.lnfdi   d.cim_notimh_new d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict l.cim_notimh_new l.gdp l.lnpop  l.gdpgrowth l.govcons   l.natural  l.conflict  if democracy==0 , cluster(cow)
 
*model 7*
reg  d.lnfdi  l.lnfdi   d.cim_timh_new  d.cim_notimh_new d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural d.conflict l.cim_timh_new l.cim_notimh_new l.gdp l.lnpop  l.gdpgrowth l.govcons   l.natural  l.conflict  if democracy==0 , cluster(cow)
 
	*******
	*LRM 7*
	*******
	reg  d.lnfdi  l.lnfdi   d.cim_timh_new  d.cim_notimh_new d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict cim_timh_new  cim_notimh_new gdp lnpop  gdpgrowth govcons   natural  conflict  if newsample==1 , cluster(cow)
	predict yhat2 if newsample==1
	reg  lnfdi yhat2 d.cim_timh_new  d.cim_notimh_new d.gdp d.lnpop d.gdpgrowth d.govcons  d.natural  d.conflict cim_timh_new  cim_notimh_new gdp lnpop  gdpgrowth govcons   natural  conflict  if newsample==1 , cluster(cow)
	drop yhat2
	 
 
 
