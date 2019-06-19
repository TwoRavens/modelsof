use Backward_and_Forward_Matrices_with_TcredUSA.dta

mata
/*Reading the data from the dataset*/

//Cost and dem
st_view(C=.,.,(2..29))
st_view(D=.,.,(30..57))

/*C is backward, D is forward*/
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

matrix colnames CostPayCC = CostPayCC311  CostPayCC313  CostPayCC314  CostPayCC321  CostPayCC322  CostPayCC323  CostPayCC324  CostPayCC331  CostPayCC332  CostPayCC341  CostPayCC342  CostPayCC351  CostPayCC352  CostPayCC353  CostPayCC354  CostPayCC355  CostPayCC356  CostPayCC361  CostPayCC362  CostPayCC369  CostPayCC371  CostPayCC372  CostPayCC381  CostPayCC382  CostPayCC383  CostPayCC384  CostPayCC385  CostPayCC390
matrix colnames CostRecCC = CostRecCC311  CostRecCC313  CostRecCC314  CostRecCC321  CostRecCC322  CostRecCC323  CostRecCC324  CostRecCC331  CostRecCC332  CostRecCC341  CostRecCC342  CostRecCC351  CostRecCC352  CostRecCC353  CostRecCC354  CostRecCC355  CostRecCC356  CostRecCC361  CostRecCC362  CostRecCC369  CostRecCC371  CostRecCC372  CostRecCC381  CostRecCC382  CostRecCC383  CostRecCC384  CostRecCC385  CostRecCC390
matrix colnames CostStdpayCC = CostStdpayCC311  CostStdpayCC313  CostStdpayCC314  CostStdpayCC321  CostStdpayCC322  CostStdpayCC323  CostStdpayCC324  CostStdpayCC331  CostStdpayCC332  CostStdpayCC341  CostStdpayCC342  CostStdpayCC351  CostStdpayCC352  CostStdpayCC353  CostStdpayCC354  CostStdpayCC355  CostStdpayCC356  CostStdpayCC361  CostStdpayCC362  CostStdpayCC369  CostStdpayCC371  CostStdpayCC372  CostStdpayCC381  CostStdpayCC382  CostStdpayCC383  CostStdpayCC384  CostStdpayCC385  CostStdpayCC390

matrix colnames DemPayCC = DemPayCC311  DemPayCC313  DemPayCC314  DemPayCC321  DemPayCC322  DemPayCC323  DemPayCC324  DemPayCC331  DemPayCC332  DemPayCC341  DemPayCC342  DemPayCC351  DemPayCC352  DemPayCC353  DemPayCC354  DemPayCC355  DemPayCC356  DemPayCC361  DemPayCC362  DemPayCC369  DemPayCC371  DemPayCC372  DemPayCC381  DemPayCC382  DemPayCC383  DemPayCC384  DemPayCC385  DemPayCC390
matrix colnames DemRecCC = DemRecCC311  DemRecCC313  DemRecCC314  DemRecCC321  DemRecCC322  DemRecCC323  DemRecCC324  DemRecCC331  DemRecCC332  DemRecCC341  DemRecCC342  DemRecCC351  DemRecCC352  DemRecCC353  DemRecCC354  DemRecCC355  DemRecCC356  DemRecCC361  DemRecCC362  DemRecCC369  DemRecCC371  DemRecCC372  DemRecCC381  DemRecCC382  DemRecCC383  DemRecCC384  DemRecCC385  DemRecCC390
matrix colnames DemStdpayCC = DemStdpayCC311  DemStdpayCC313  DemStdpayCC314  DemStdpayCC321  DemStdpayCC322  DemStdpayCC323  DemStdpayCC324  DemStdpayCC331  DemStdpayCC332  DemStdpayCC341  DemStdpayCC342  DemStdpayCC351  DemStdpayCC352  DemStdpayCC353  DemStdpayCC354  DemStdpayCC355  DemStdpayCC356  DemStdpayCC361  DemStdpayCC362  DemStdpayCC369  DemStdpayCC371  DemStdpayCC372  DemStdpayCC381  DemStdpayCC382  DemStdpayCC383  DemStdpayCC384  DemStdpayCC385  DemStdpayCC390

svmat  CostPayCC, names(col)
svmat  CostRecCC, names(col)
svmat  CostStdpayCC, names(col)

svmat  DemPayCC, names(col)
svmat  DemRecCC, names(col)
svmat  DemStdpayCC, names(col)

renpfix Cost Backwd
renpfix Dem  Fwd

save Backward_and_Forward_Model_matrices_CC_inv_net, replace
