use Cost_and_Dem_Matrices_with_TcredUSA.dta
*Note: This program also produces the credit chain measures based on Net Payables Turnover or on Payables to material costs
*For this simply replace the Payturn measure for the corresponding one signaled below
mata
/*Reading the data from the dataset*/

//Cost and dem
st_view(C=.,.,(2..29))
st_view(D=.,.,(30..57))

/*Stupid step: transforming views into matrices*/
C = C
D = D

*st_view(p=.,.,("NetPayturn")) /*Activate this one and comment "Payturn" line to use net payables turnover*/
*st_view(p=.,.,("Paymatc")) /*Activate this one and comment "Payturn" line to use payables to material cost*/

/*Variables in the output dataset have to be renamed when using alternative measures of Payables financing, like the ones described above*/

st_view(p=.,.,("Payturn"))
st_view(r=.,.,("Recturn"))
st_view(s=.,.,("Stdbtpay"))

/*This is the part where I take the inverse ratios*/
p = 1:/p
r = 1:/r
*s = 1:/s

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

matrix colnames CostPayCC = CostPayCC_inv311  CostPayCC_inv313  CostPayCC_inv314  CostPayCC_inv321  CostPayCC_inv322  CostPayCC_inv323  CostPayCC_inv324  CostPayCC_inv331  CostPayCC_inv332  CostPayCC_inv341  CostPayCC_inv342  CostPayCC_inv351  CostPayCC_inv352  CostPayCC_inv353  CostPayCC_inv354  CostPayCC_inv355  CostPayCC_inv356  CostPayCC_inv361  CostPayCC_inv362  CostPayCC_inv369  CostPayCC_inv371  CostPayCC_inv372  CostPayCC_inv381  CostPayCC_inv382  CostPayCC_inv383  CostPayCC_inv384  CostPayCC_inv385  CostPayCC_inv390
matrix colnames CostRecCC = CostReCC_invC311  CostReCC_invC313  CostReCC_invC314  CostReCC_invC321  CostReCC_invC322  CostReCC_invC323  CostReCC_invC324  CostReCC_invC331  CostReCC_invC332  CostReCC_invC341  CostReCC_invC342  CostReCC_invC351  CostReCC_invC352  CostReCC_invC353  CostReCC_invC354  CostReCC_invC355  CostReCC_invC356  CostReCC_invC361  CostReCC_invC362  CostReCC_invC369  CostReCC_invC371  CostReCC_invC372  CostReCC_invC381  CostReCC_invC382  CostReCC_invC383  CostReCC_invC384  CostReCC_invC385  CostReCC_invC390
matrix colnames CostStdpayCC = CostStdpayCC311  CostStdpayCC313  CostStdpayCC314  CostStdpayCC321  CostStdpayCC322  CostStdpayCC323  CostStdpayCC324  CostStdpayCC331  CostStdpayCC332  CostStdpayCC341  CostStdpayCC342  CostStdpayCC351  CostStdpayCC352  CostStdpayCC353  CostStdpayCC354  CostStdpayCC355  CostStdpayCC356  CostStdpayCC361  CostStdpayCC362  CostStdpayCC369  CostStdpayCC371  CostStdpayCC372  CostStdpayCC381  CostStdpayCC382  CostStdpayCC383  CostStdpayCC384  CostStdpayCC385  CostStdpayCC390

matrix colnames DemPayCC = DemPayCC_inv311  DemPayCC_inv313  DemPayCC_inv314  DemPayCC_inv321  DemPayCC_inv322  DemPayCC_inv323  DemPayCC_inv324  DemPayCC_inv331  DemPayCC_inv332  DemPayCC_inv341  DemPayCC_inv342  DemPayCC_inv351  DemPayCC_inv352  DemPayCC_inv353  DemPayCC_inv354  DemPayCC_inv355  DemPayCC_inv356  DemPayCC_inv361  DemPayCC_inv362  DemPayCC_inv369  DemPayCC_inv371  DemPayCC_inv372  DemPayCC_inv381  DemPayCC_inv382  DemPayCC_inv383  DemPayCC_inv384  DemPayCC_inv385  DemPayCC_inv390
matrix colnames DemRecCC = DemReCC_invC311  DemReCC_invC313  DemReCC_invC314  DemReCC_invC321  DemReCC_invC322  DemReCC_invC323  DemReCC_invC324  DemReCC_invC331  DemReCC_invC332  DemReCC_invC341  DemReCC_invC342  DemReCC_invC351  DemReCC_invC352  DemReCC_invC353  DemReCC_invC354  DemReCC_invC355  DemReCC_invC356  DemReCC_invC361  DemReCC_invC362  DemReCC_invC369  DemReCC_invC371  DemReCC_invC372  DemReCC_invC381  DemReCC_invC382  DemReCC_invC383  DemReCC_invC384  DemReCC_invC385  DemReCC_invC390
matrix colnames DemStdpayCC = DemStdpayCC311  DemStdpayCC313  DemStdpayCC314  DemStdpayCC321  DemStdpayCC322  DemStdpayCC323  DemStdpayCC324  DemStdpayCC331  DemStdpayCC332  DemStdpayCC341  DemStdpayCC342  DemStdpayCC351  DemStdpayCC352  DemStdpayCC353  DemStdpayCC354  DemStdpayCC355  DemStdpayCC356  DemStdpayCC361  DemStdpayCC362  DemStdpayCC369  DemStdpayCC371  DemStdpayCC372  DemStdpayCC381  DemStdpayCC382  DemStdpayCC383  DemStdpayCC384  DemStdpayCC385  DemStdpayCC390

svmat  CostPayCC, names(col)
svmat  CostRecCC, names(col)
svmat  CostStdpayCC, names(col)

svmat  DemPayCC, names(col)
svmat  DemRecCC, names(col)
svmat  DemStdpayCC, names(col)


save Cost_and_Dem_Model_matrices_CC_inv, replace
