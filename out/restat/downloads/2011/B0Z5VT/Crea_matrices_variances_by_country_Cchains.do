local minobs 05
use Cost_and_Dem_Matrices_with_Tcred_bycty_`minobs'plus.dta

*Create the matrix that has the same structure as the one before but repeated by country
*First I need to load the data and make a loop over the countries
sort wbcode isic
egen cty = group(wbcode)
sort cty isic
sum cty
local ncount = r(max)
gen sample=0
mata

//read number of countries

N = st_numscalar("r(max)")

/*Reading the data from the dataset*/

//Looping

for (i=1; i<=N; i++) {
     i
     //Cost and dem

     //Mark sample

     st_numscalar("ss", i)

     stata("replace sample = cty==ss")

     st_view(C=.,.,(3..30),"sample")
     st_view(D=.,.,(31..58),"sample")

     /*Stupid step: transforming views into matrices*/

     C = C
     D = D

     st_view(s=.,.,("relvar"),"sample")

     /*Creating the variances matrices*/

     S = diag(s:^2)

    
     Rc = invsym(sqrt(diag(diagonal(C*C'))))
     Rd = invsym(sqrt(diag(diagonal(D*D'))))

     /*First terms*/

     CostVar_ = Rc*(D*S*D')*Rc

     DemVar_ = Rd*(D*S*D')*Rd

     CostVar_c  = CostVar_ - 0.5*(diag(diagonal(CostVar_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostVar_)))
     DemVar_c      = DemVar_ - 0.5*(diag(diagonal(DemVar_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemVar_)))
 
     //Accumulate them

     if (i==1) {
         CostVar=CostVar_c
         DemVar    =DemVar_c
         }
     else {
         CostVar   =CostVar\CostVar_c
         DemVar    =DemVar\DemVar_c
         }

}

/*Copying them back to stata*/

st_matrix("CostVar",CostVar)

st_matrix("DemVar",DemVar)

/*End mata*/

end

keep wbcode isic cty

*Now I relabel the columns of the matrices

matrix colnames CostVar = CostVar311  CostVar313  CostVar314  CostVar321  CostVar322  CostVar323  CostVar324  CostVar331  CostVar332  CostVar341  CostVar342  CostVar351  CostVar352  CostVar353  CostVar354  CostVar355  CostVar356  CostVar361  CostVar362  CostVar369  CostVar371  CostVar372  CostVar381  CostVar382  CostVar383  CostVar384  CostVar385  CostVar390

matrix colnames DemVar = DemVar311  DemVar313  DemVar314  DemVar321  DemVar322  DemVar323  DemVar324  DemVar331  DemVar332  DemVar341  DemVar342  DemVar351  DemVar352  DemVar353  DemVar354  DemVar355  DemVar356  DemVar361  DemVar362  DemVar369  DemVar371  DemVar372  DemVar381  DemVar382  DemVar383  DemVar384  DemVar385  DemVar390

svmat  CostVar, names(col)

svmat  DemVar, names(col)

save Cost_and_Dem_Variance_matrices_bycty, replace
