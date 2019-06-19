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

     st_view(p=.,.,("Payturn_ic"),"sample")
     st_view(r=.,.,("Recturn_ic"),"sample")
     st_view(s=.,.,("Stdbtpay_ic"),"sample")

     p = 1:/p
     r = 1:/r
     s = 1:/s

    /*Creating the underlying direct linkages matrices*/

     C_ = I(rows(C)) - invsym(C)
     D_ = I(rows(D)) - invsym(D)

     /*Creating the credit chain matrices*/

     CCh_C_p = C*C_*diag(p)*C
     CCh_C_r = C*C_*diag(r)*C
     CCh_C_s = C*C_*diag(s)*C

     CCh_D_p = D*D_*diag(p)*D
     CCh_D_r = D*D_*diag(r)*D
     CCh_D_s = D*D_*diag(s)*D

     Rc = invsym(sqrt(diag(diagonal(C*C'))))
     Rd = invsym(sqrt(diag(diagonal(D*D'))))

     /*First terms*/

     CostPay_    = Rc*(CCh_C_p*C'+C*CCh_C_p')*Rc
     CostRec_    = Rc*(CCh_C_r*C'+C*CCh_C_r')*Rc
     CostStdpay_ = Rc*(CCh_C_s*C'+C*CCh_C_s')*Rc

     DemPay_    = Rd*(CCh_D_p*D'+D*CCh_D_p')*Rd
     DemRec_    = Rd*(CCh_D_r*D'+D*CCh_D_r')*Rd
     DemStdpay_ = Rd*(CCh_D_s*D'+D*CCh_D_s')*Rd

     CostPayCC_c     = CostPay_ - 0.5*(diag(diagonal(CostPay_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostPay_)))
     CostRecCC_c     = CostRec_ - 0.5*(diag(diagonal(CostRec_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostRec_)))
     CostStdpayCC_c  = CostStdpay_ - 0.5*(diag(diagonal(CostStdpay_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostStdpay_)))
     DemPayCC_c      = DemPay_ - 0.5*(diag(diagonal(DemPay_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemPay_)))
     DemRecCC_c      = DemRec_ - 0.5*(diag(diagonal(DemRec_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemRec_)))
     DemStdpayCC_c   = DemStdpay_ - 0.5*(diag(diagonal(DemStdpay_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemStdpay_)))


     //Accumulate them

     if (i==1) {
         CostPayCC   =CostPayCC_c
         CostRecCC   =CostRecCC_c
         CostStdpayCC=CostStdpayCC_c
         DemPayCC    =DemPayCC_c
         DemRecCC    =DemRecCC_c
         DemStdpayCC =DemStdpayCC_c
     }
     else {
         CostPayCC   =CostPayCC\CostPayCC_c
         CostRecCC   =CostRecCC\CostRecCC_c
         CostStdpayCC=CostStdpayCC\CostStdpayCC_c
         DemPayCC    =DemPayCC\DemPayCC_c
         DemRecCC    =DemRecCC\DemRecCC_c
         DemStdpayCC =DemStdpayCC\DemStdpayCC_c
     }

}

/*Copying them back to stata*/

st_matrix("CostPayCC",CostPayCC)
st_matrix("CostRecCC",CostRecCC)
st_matrix("CostStdpayCC",CostStdpayCC)

st_matrix("DemPayCC",DemPayCC)
st_matrix("DemRecCC",DemRecCC)
st_matrix("DemStdpayCC",DemStdpayCC)

/*End mata*/

end

keep wbcode isic cty

*Now I relabel the columns of the matrices

/*matrix colnames CostPayCC = CostPayCC311  CostPayCC313  CostPayCC314  CostPayCC321  CostPayCC322  CostPayCC323  CostPayCC324  CostPayCC331  CostPayCC332  CostPayCC341  CostPayCC342  CostPayCC351  CostPayCC352  CostPayCC353  CostPayCC354  CostPayCC355  CostPayCC356  CostPayCC361  CostPayCC362  CostPayCC369  CostPayCC371  CostPayCC372  CostPayCC381  CostPayCC382  CostPayCC383  CostPayCC384  CostPayCC385  CostPayCC390
matrix colnames CostRecCC = CostRecCC311  CostRecCC313  CostRecCC314  CostRecCC321  CostRecCC322  CostRecCC323  CostRecCC324  CostRecCC331  CostRecCC332  CostRecCC341  CostRecCC342  CostRecCC351  CostRecCC352  CostRecCC353  CostRecCC354  CostRecCC355  CostRecCC356  CostRecCC361  CostRecCC362  CostRecCC369  CostRecCC371  CostRecCC372  CostRecCC381  CostRecCC382  CostRecCC383  CostRecCC384  CostRecCC385  CostRecCC390
matrix colnames CostStdpayCC = CostStdpayCC311  CostStdpayCC313  CostStdpayCC314  CostStdpayCC321  CostStdpayCC322  CostStdpayCC323  CostStdpayCC324  CostStdpayCC331  CostStdpayCC332  CostStdpayCC341  CostStdpayCC342  CostStdpayCC351  CostStdpayCC352  CostStdpayCC353  CostStdpayCC354  CostStdpayCC355  CostStdpayCC356  CostStdpayCC361  CostStdpayCC362  CostStdpayCC369  CostStdpayCC371  CostStdpayCC372  CostStdpayCC381  CostStdpayCC382  CostStdpayCC383  CostStdpayCC384  CostStdpayCC385  CostStdpayCC390

matrix colnames DemPayCC = DemPayCC311  DemPayCC313  DemPayCC314  DemPayCC321  DemPayCC322  DemPayCC323  DemPayCC324  DemPayCC331  DemPayCC332  DemPayCC341  DemPayCC342  DemPayCC351  DemPayCC352  DemPayCC353  DemPayCC354  DemPayCC355  DemPayCC356  DemPayCC361  DemPayCC362  DemPayCC369  DemPayCC371  DemPayCC372  DemPayCC381  DemPayCC382  DemPayCC383  DemPayCC384  DemPayCC385  DemPayCC390
matrix colnames DemRecCC = DemRecCC311  DemRecCC313  DemRecCC314  DemRecCC321  DemRecCC322  DemRecCC323  DemRecCC324  DemRecCC331  DemRecCC332  DemRecCC341  DemRecCC342  DemRecCC351  DemRecCC352  DemRecCC353  DemRecCC354  DemRecCC355  DemRecCC356  DemRecCC361  DemRecCC362  DemRecCC369  DemRecCC371  DemRecCC372  DemRecCC381  DemRecCC382  DemRecCC383  DemRecCC384  DemRecCC385  DemRecCC390
matrix colnames DemStdpayCC = DemStdpayCC311  DemStdpayCC313  DemStdpayCC314  DemStdpayCC321  DemStdpayCC322  DemStdpayCC323  DemStdpayCC324  DemStdpayCC331  DemStdpayCC332  DemStdpayCC341  DemStdpayCC342  DemStdpayCC351  DemStdpayCC352  DemStdpayCC353  DemStdpayCC354  DemStdpayCC355  DemStdpayCC356  DemStdpayCC361  DemStdpayCC362  DemStdpayCC369  DemStdpayCC371  DemStdpayCC372  DemStdpayCC381  DemStdpayCC382  DemStdpayCC383  DemStdpayCC384  DemStdpayCC385  DemStdpayCC390
*/

matrix colnames CostPayCC = CostInvPayCC_05311  CostInvPayCC_05313  CostInvPayCC_05314  CostInvPayCC_05321  CostInvPayCC_05322  CostInvPayCC_05323  CostInvPayCC_05324  CostInvPayCC_05331  CostInvPayCC_05332  CostInvPayCC_05341  CostInvPayCC_05342  CostInvPayCC_05351  CostInvPayCC_05352  CostInvPayCC_05353  CostInvPayCC_05354  CostInvPayCC_05355  CostInvPayCC_05356  CostInvPayCC_05361  CostInvPayCC_05362  CostInvPayCC_05369  CostInvPayCC_05371  CostInvPayCC_05372  CostInvPayCC_05381  CostInvPayCC_05382  CostInvPayCC_05383  CostInvPayCC_05384  CostInvPayCC_05385  CostInvPayCC_05390
matrix colnames CostRecCC = CostInvRecC_05C311  CostInvRecC_05C313  CostInvRecC_05C314  CostInvRecC_05C321  CostInvRecC_05C322  CostInvRecC_05C323  CostInvRecC_05C324  CostInvRecC_05C331  CostInvRecC_05C332  CostInvRecC_05C341  CostInvRecC_05C342  CostInvRecC_05C351  CostInvRecC_05C352  CostInvRecC_05C353  CostInvRecC_05C354  CostInvRecC_05C355  CostInvRecC_05C356  CostInvRecC_05C361  CostInvRecC_05C362  CostInvRecC_05C369  CostInvRecC_05C371  CostInvRecC_05C372  CostInvRecC_05C381  CostInvRecC_05C382  CostInvRecC_05C383  CostInvRecC_05C384  CostInvRecC_05C385  CostInvRecC_05C390
matrix colnames CostStdpayCC = CostStdpayCC_05311  CostStdpayCC_05313  CostStdpayCC_05314  CostStdpayCC_05321  CostStdpayCC_05322  CostStdpayCC_05323  CostStdpayCC_05324  CostStdpayCC_05331  CostStdpayCC_05332  CostStdpayCC_05341  CostStdpayCC_05342  CostStdpayCC_05351  CostStdpayCC_05352  CostStdpayCC_05353  CostStdpayCC_05354  CostStdpayCC_05355  CostStdpayCC_05356  CostStdpayCC_05361  CostStdpayCC_05362  CostStdpayCC_05369  CostStdpayCC_05371  CostStdpayCC_05372  CostStdpayCC_05381  CostStdpayCC_05382  CostStdpayCC_05383  CostStdpayCC_05384  CostStdpayCC_05385  CostStdpayCC_05390

matrix colnames DemPayCC = DemInvPayCC_05311  DemInvPayCC_05313  DemInvPayCC_05314  DemInvPayCC_05321  DemInvPayCC_05322  DemInvPayCC_05323  DemInvPayCC_05324  DemInvPayCC_05331  DemInvPayCC_05332  DemInvPayCC_05341  DemInvPayCC_05342  DemInvPayCC_05351  DemInvPayCC_05352  DemInvPayCC_05353  DemInvPayCC_05354  DemInvPayCC_05355  DemInvPayCC_05356  DemInvPayCC_05361  DemInvPayCC_05362  DemInvPayCC_05369  DemInvPayCC_05371  DemInvPayCC_05372  DemInvPayCC_05381  DemInvPayCC_05382  DemInvPayCC_05383  DemInvPayCC_05384  DemInvPayCC_05385  DemInvPayCC_05390
matrix colnames DemRecCC = DemInvRecC_05C311  DemInvRecC_05C313  DemInvRecC_05C314  DemInvRecC_05C321  DemInvRecC_05C322  DemInvRecC_05C323  DemInvRecC_05C324  DemInvRecC_05C331  DemInvRecC_05C332  DemInvRecC_05C341  DemInvRecC_05C342  DemInvRecC_05C351  DemInvRecC_05C352  DemInvRecC_05C353  DemInvRecC_05C354  DemInvRecC_05C355  DemInvRecC_05C356  DemInvRecC_05C361  DemInvRecC_05C362  DemInvRecC_05C369  DemInvRecC_05C371  DemInvRecC_05C372  DemInvRecC_05C381  DemInvRecC_05C382  DemInvRecC_05C383  DemInvRecC_05C384  DemInvRecC_05C385  DemInvRecC_05C390
matrix colnames DemStdpayCC = DemStdpayCC_05311  DemStdpayCC_05313  DemStdpayCC_05314  DemStdpayCC_05321  DemStdpayCC_05322  DemStdpayCC_05323  DemStdpayCC_05324  DemStdpayCC_05331  DemStdpayCC_05332  DemStdpayCC_05341  DemStdpayCC_05342  DemStdpayCC_05351  DemStdpayCC_05352  DemStdpayCC_05353  DemStdpayCC_05354  DemStdpayCC_05355  DemStdpayCC_05356  DemStdpayCC_05361  DemStdpayCC_05362  DemStdpayCC_05369  DemStdpayCC_05371  DemStdpayCC_05372  DemStdpayCC_05381  DemStdpayCC_05382  DemStdpayCC_05383  DemStdpayCC_05384  DemStdpayCC_05385  DemStdpayCC_05390

svmat  CostPayCC, names(col)
svmat  CostRecCC, names(col)
svmat  CostStdpayCC, names(col)

svmat  DemPayCC, names(col)
svmat  DemRecCC, names(col)
svmat  DemStdpayCC, names(col)

save Cost_and_Dem_Model_matrices_bycty_`minobs'plus_CC_inv, replace
