use Cost_and_Dem_Matrices_with_TcredUK.dta

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

matrix colnames CostPayCC = CostPayCCUK_inv311  CostPayCCUK_inv313  CostPayCCUK_inv314  CostPayCCUK_inv321  CostPayCCUK_inv322  CostPayCCUK_inv323  CostPayCCUK_inv324  CostPayCCUK_inv331  CostPayCCUK_inv332  CostPayCCUK_inv341  CostPayCCUK_inv342  CostPayCCUK_inv351  CostPayCCUK_inv352  CostPayCCUK_inv353  CostPayCCUK_inv354  CostPayCCUK_inv355  CostPayCCUK_inv356  CostPayCCUK_inv361  CostPayCCUK_inv362  CostPayCCUK_inv369  CostPayCCUK_inv371  CostPayCCUK_inv372  CostPayCCUK_inv381  CostPayCCUK_inv382  CostPayCCUK_inv383  CostPayCCUK_inv384  CostPayCCUK_inv385  CostPayCCUK_inv390
matrix colnames CostRecCC = CostRecCCUK_inv311  CostRecCCUK_inv313  CostRecCCUK_inv314  CostRecCCUK_inv321  CostRecCCUK_inv322  CostRecCCUK_inv323  CostRecCCUK_inv324  CostRecCCUK_inv331  CostRecCCUK_inv332  CostRecCCUK_inv341  CostRecCCUK_inv342  CostRecCCUK_inv351  CostRecCCUK_inv352  CostRecCCUK_inv353  CostRecCCUK_inv354  CostRecCCUK_inv355  CostRecCCUK_inv356  CostRecCCUK_inv361  CostRecCCUK_inv362  CostRecCCUK_inv369  CostRecCCUK_inv371  CostRecCCUK_inv372  CostRecCCUK_inv381  CostRecCCUK_inv382  CostRecCCUK_inv383  CostRecCCUK_inv384  CostRecCCUK_inv385  CostRecCCUK_inv390
matrix colnames CostStdpayCC = CostStdpayCCUK311  CostStdpayCCUK313  CostStdpayCCUK314  CostStdpayCCUK321  CostStdpayCCUK322  CostStdpayCCUK323  CostStdpayCCUK324  CostStdpayCCUK331  CostStdpayCCUK332  CostStdpayCCUK341  CostStdpayCCUK342  CostStdpayCCUK351  CostStdpayCCUK352  CostStdpayCCUK353  CostStdpayCCUK354  CostStdpayCCUK355  CostStdpayCCUK356  CostStdpayCCUK361  CostStdpayCCUK362  CostStdpayCCUK369  CostStdpayCCUK371  CostStdpayCCUK372  CostStdpayCCUK381  CostStdpayCCUK382  CostStdpayCCUK383  CostStdpayCCUK384  CostStdpayCCUK385  CostStdpayCCUK390

matrix colnames DemPayCC = DemPayCCUK_inv311  DemPayCCUK_inv313  DemPayCCUK_inv314  DemPayCCUK_inv321  DemPayCCUK_inv322  DemPayCCUK_inv323  DemPayCCUK_inv324  DemPayCCUK_inv331  DemPayCCUK_inv332  DemPayCCUK_inv341  DemPayCCUK_inv342  DemPayCCUK_inv351  DemPayCCUK_inv352  DemPayCCUK_inv353  DemPayCCUK_inv354  DemPayCCUK_inv355  DemPayCCUK_inv356  DemPayCCUK_inv361  DemPayCCUK_inv362  DemPayCCUK_inv369  DemPayCCUK_inv371  DemPayCCUK_inv372  DemPayCCUK_inv381  DemPayCCUK_inv382  DemPayCCUK_inv383  DemPayCCUK_inv384  DemPayCCUK_inv385  DemPayCCUK_inv390
matrix colnames DemRecCC = DemRecCCUK_inv311  DemRecCCUK_inv313  DemRecCCUK_inv314  DemRecCCUK_inv321  DemRecCCUK_inv322  DemRecCCUK_inv323  DemRecCCUK_inv324  DemRecCCUK_inv331  DemRecCCUK_inv332  DemRecCCUK_inv341  DemRecCCUK_inv342  DemRecCCUK_inv351  DemRecCCUK_inv352  DemRecCCUK_inv353  DemRecCCUK_inv354  DemRecCCUK_inv355  DemRecCCUK_inv356  DemRecCCUK_inv361  DemRecCCUK_inv362  DemRecCCUK_inv369  DemRecCCUK_inv371  DemRecCCUK_inv372  DemRecCCUK_inv381  DemRecCCUK_inv382  DemRecCCUK_inv383  DemRecCCUK_inv384  DemRecCCUK_inv385  DemRecCCUK_inv390
matrix colnames DemStdpayCC = DemStdpayCCUK311  DemStdpayCCUK313  DemStdpayCCUK314  DemStdpayCCUK321  DemStdpayCCUK322  DemStdpayCCUK323  DemStdpayCCUK324  DemStdpayCCUK331  DemStdpayCCUK332  DemStdpayCCUK341  DemStdpayCCUK342  DemStdpayCCUK351  DemStdpayCCUK352  DemStdpayCCUK353  DemStdpayCCUK354  DemStdpayCCUK355  DemStdpayCCUK356  DemStdpayCCUK361  DemStdpayCCUK362  DemStdpayCCUK369  DemStdpayCCUK371  DemStdpayCCUK372  DemStdpayCCUK381  DemStdpayCCUK382  DemStdpayCCUK383  DemStdpayCCUK384  DemStdpayCCUK385  DemStdpayCCUK390

svmat  CostPayCC, names(col)
svmat  CostRecCC, names(col)
svmat  CostStdpayCC, names(col)

svmat  DemPayCC, names(col)
svmat  DemRecCC, names(col)
svmat  DemStdpayCC, names(col)

save Cost_and_Dem_Model_matrices_CC_UK_inv, replace
