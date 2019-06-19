use Cost_and_Dem_Matrices_with_TcredUSA.dta
*This version assumes all relative ratios are equal
mata
/*Reading the data from the dataset*/

//Cost and dem
st_view(C=.,.,(2..29))
st_view(D=.,.,(30..57))

/*Stupid step: transforming views into matrices*/
C = C
D = D

st_view(p=.,.,("Payturn"))
st_view(r=.,.,("Recturn"))
st_view(s=.,.,("Stdbtpay"))

p = p
r = r
s = s

/*Creating the underlying direct linkages matrices*/

C_ = I(rows(C)) - invsym(C)
D_ = I(rows(D)) - invsym(D)

/*Creating the credit chain matrices*/

CCh_C_p = C*C_*C
CCh_C_r = C*C_*C
CCh_C_s = C*C_*C

CCh_D_p = D*D_*D
CCh_D_r = D*D_*D
CCh_D_s = D*D_*D

/*Creating the final matrices considering the credit chain*/

Rc = invsym(sqrt(diag(diagonal(C*C'))))
Rd = invsym(sqrt(diag(diagonal(D*D'))))

/*First terms*/

CostPay_    = Rc*(CCh_C_p*C'+C*CCh_C_p')*Rc
CostRec_    = Rc*(CCh_C_r*C'+C*CCh_C_r')*Rc
CostStdpay_ = Rc*(CCh_C_s*C'+C*CCh_C_s')*Rc

DemPay_    = Rd*(CCh_D_p*D'+D*CCh_D_p')*Rd
DemRec_    = Rd*(CCh_D_r*D'+D*CCh_D_r')*Rd
DemStdpay_ = Rd*(CCh_D_s*D'+D*CCh_D_s')*Rd

CostPayCC     = CostPay_ - 0.5*(diag(diagonal(CostPay_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostPay_)))
CostRecCC     = CostRec_ - 0.5*(diag(diagonal(CostRec_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostRec_)))
CostStdpayCC  = CostStdpay_ - 0.5*(diag(diagonal(CostStdpay_))*Rc*C*C'*Rc + Rc*C*C'*Rc*diag(diagonal(CostStdpay_)))
DemPayCC      = DemPay_ - 0.5*(diag(diagonal(DemPay_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemPay_)))
DemRecCC      = DemRec_ - 0.5*(diag(diagonal(DemRec_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemRec_)))
DemStdpayCC   = DemStdpay_ - 0.5*(diag(diagonal(DemStdpay_))*Rd*D*D'*Rd + Rd*D*D'*Rd*diag(diagonal(DemStdpay_)))

/*Copying them back to stata*/

st_matrix("CostPayCC",CostPayCC)
st_matrix("CostRecCC",CostRecCC)
st_matrix("CostStdpayCC",CostStdpayCC)

st_matrix("DemPayCC",DemPayCC)
st_matrix("DemRecCC",DemRecCC)
st_matrix("DemStdpayCC",DemStdpayCC)

/*End mata*/

end

keep isic

*Now I relabel the columns of the matrices

matrix colnames CostPayCC = CostPayCC_test311  CostPayCC_test313  CostPayCC_test314  CostPayCC_test321  CostPayCC_test322  CostPayCC_test323  CostPayCC_test324  CostPayCC_test331  CostPayCC_test332  CostPayCC_test341  CostPayCC_test342  CostPayCC_test351  CostPayCC_test352  CostPayCC_test353  CostPayCC_test354  CostPayCC_test355  CostPayCC_test356  CostPayCC_test361  CostPayCC_test362  CostPayCC_test369  CostPayCC_test371  CostPayCC_test372  CostPayCC_test381  CostPayCC_test382  CostPayCC_test383  CostPayCC_test384  CostPayCC_test385  CostPayCC_test390
matrix colnames CostRecCC = CostRecCC_test311  CostRecCC_test313  CostRecCC_test314  CostRecCC_test321  CostRecCC_test322  CostRecCC_test323  CostRecCC_test324  CostRecCC_test331  CostRecCC_test332  CostRecCC_test341  CostRecCC_test342  CostRecCC_test351  CostRecCC_test352  CostRecCC_test353  CostRecCC_test354  CostRecCC_test355  CostRecCC_test356  CostRecCC_test361  CostRecCC_test362  CostRecCC_test369  CostRecCC_test371  CostRecCC_test372  CostRecCC_test381  CostRecCC_test382  CostRecCC_test383  CostRecCC_test384  CostRecCC_test385  CostRecCC_test390
matrix colnames CostStdpayCC = CostStdpayCC_test311  CostStdpayCC_test313  CostStdpayCC_test314  CostStdpayCC_test321  CostStdpayCC_test322  CostStdpayCC_test323  CostStdpayCC_test324  CostStdpayCC_test331  CostStdpayCC_test332  CostStdpayCC_test341  CostStdpayCC_test342  CostStdpayCC_test351  CostStdpayCC_test352  CostStdpayCC_test353  CostStdpayCC_test354  CostStdpayCC_test355  CostStdpayCC_test356  CostStdpayCC_test361  CostStdpayCC_test362  CostStdpayCC_test369  CostStdpayCC_test371  CostStdpayCC_test372  CostStdpayCC_test381  CostStdpayCC_test382  CostStdpayCC_test383  CostStdpayCC_test384  CostStdpayCC_test385  CostStdpayCC_test390

matrix colnames DemPayCC = DemPayCC_test311  DemPayCC_test313  DemPayCC_test314  DemPayCC_test321  DemPayCC_test322  DemPayCC_test323  DemPayCC_test324  DemPayCC_test331  DemPayCC_test332  DemPayCC_test341  DemPayCC_test342  DemPayCC_test351  DemPayCC_test352  DemPayCC_test353  DemPayCC_test354  DemPayCC_test355  DemPayCC_test356  DemPayCC_test361  DemPayCC_test362  DemPayCC_test369  DemPayCC_test371  DemPayCC_test372  DemPayCC_test381  DemPayCC_test382  DemPayCC_test383  DemPayCC_test384  DemPayCC_test385  DemPayCC_test390
matrix colnames DemRecCC = DemRecCC_test311  DemRecCC_test313  DemRecCC_test314  DemRecCC_test321  DemRecCC_test322  DemRecCC_test323  DemRecCC_test324  DemRecCC_test331  DemRecCC_test332  DemRecCC_test341  DemRecCC_test342  DemRecCC_test351  DemRecCC_test352  DemRecCC_test353  DemRecCC_test354  DemRecCC_test355  DemRecCC_test356  DemRecCC_test361  DemRecCC_test362  DemRecCC_test369  DemRecCC_test371  DemRecCC_test372  DemRecCC_test381  DemRecCC_test382  DemRecCC_test383  DemRecCC_test384  DemRecCC_test385  DemRecCC_test390
matrix colnames DemStdpayCC = DemStdpayCC_test311  DemStdpayCC_test313  DemStdpayCC_test314  DemStdpayCC_test321  DemStdpayCC_test322  DemStdpayCC_test323  DemStdpayCC_test324  DemStdpayCC_test331  DemStdpayCC_test332  DemStdpayCC_test341  DemStdpayCC_test342  DemStdpayCC_test351  DemStdpayCC_test352  DemStdpayCC_test353  DemStdpayCC_test354  DemStdpayCC_test355  DemStdpayCC_test356  DemStdpayCC_test361  DemStdpayCC_test362  DemStdpayCC_test369  DemStdpayCC_test371  DemStdpayCC_test372  DemStdpayCC_test381  DemStdpayCC_test382  DemStdpayCC_test383  DemStdpayCC_test384  DemStdpayCC_test385  DemStdpayCC_test390

svmat  CostPayCC, names(col)
svmat  CostRecCC, names(col)
svmat  CostStdpayCC, names(col)

svmat  DemPayCC, names(col)
svmat  DemRecCC, names(col)
svmat  DemStdpayCC, names(col)

save Cost_and_Dem_Model_matrices_CC_T, replace
