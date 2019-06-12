
******** 
* PART 1 


* MODEL 1
xtpcse fdi unrest lnpc aid_gdp democracy ka_fill growth tr_gdp fdi_l1 multiple, p

margins, at(unrest = 0)
margins, at(unrest = 1)



* MODEL 2
xtpcse fdi violent_mov nonviol_mov lnpc aid_gdp democracy ka_fill growth tr_gdp fdi_l1 multiple, p

margins, at(violent_mov = 0 nonviol_mov = 0)
margins, at(violent_mov = 1 nonviol_mov = 0)
margins, at(violent_mov = 0 nonviol_mov = 1)


* Robustness
* Model 3  
  xtpcse fdi violent_mov nonviol_mov lnpc aid_gdp democracy ka_fill growth tr_gdp multiple, p c(ar1)
* Model 4  
  xtpcse fdi violent_mov nonviol_mov lnpc aid_gdp democracy ka_fill growth tr_gdp fdi_l1 multiple wbgi_rle, p
* xtgls  fdi violent_mov nonviol_mov lnpc aid_gdp democracy ka_fill growth tr_gdp fdi_l1 multiple , c(ar1) force



* MODEL 5
xtpcse fdi violent_mov nonviol_mov secession fself regch lnpc aid_gdp democracy ka_fill growth tr_gdp fdi_l1 multiple, p

margins, at(violent_mov = 0 nonviol_mov = 0)
margins, at(violent_mov = 1 nonviol_mov = 0)
margins, at(violent_mov = 0 nonviol_mov = 1)
*** Highlight coefficient on regime change 



* MODEL 6
probit unrest fdi_l1 L.lnpc L.democracy L.al_ethnic infantmr counter, robust



* MODEL 7
heckman fdi violent_mov lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple, robust select(unrest = fdi_l1 L.lnpc L.democracy L.al_ethnic infantmr counter)

margins, at(violent_mov = 0)
margins, at(violent_mov = 1)




********
* PART 2


* MODEL 8
heckman fdi violent_mov_2 lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple, robust select(unrest_4 = fdi_l1 L.lnpc L.democracy L.al_ethnic infantmr counter)



* MODEL 9
heckman fdi success_post  lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple, robust select(unrest_4 = fdi_l1 L.lnpc L.dem L.al_ethnic infantmr counter)

margins, at(success_post = 0)
margins, at(success_post = 1)


*adjust success_post = 0, xb ci eq(fdi)
*adjust success_post = 1, xb ci eq(fdi)


* Robustness
  heckman fdi success_post  lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple wbgi_rle, robust select(unrest_4 = fdi_l1 L.lnpc L.democracy L.al_ethnic infantmr counter)
  heckman fdi success_post  lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple, robust select(unrest_4 = fdi_l1 fh_pr L.lnpc L.democracy L.al_ethnic infantmr counter)
  heckman fdi success_post  lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple, robust select(unrest_4 = fdi_l1 ciri_physint L.lnpc L.democracy L.al_ethnic infantmr counter)
  
  
  
* MODEL 10
heckman fdi success_post  lnpc aid_gdp democracy fdi_l1 ka_fill growth tr_gdp multiple, robust select(violent_mov_4 = fdi_l1 L.lnpc L.democracy L.al_ethnic infantmr counter)

margins, at(success_post = 0)
margins, at(success_post = 1)
