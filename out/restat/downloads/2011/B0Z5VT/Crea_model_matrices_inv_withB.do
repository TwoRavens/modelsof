use Cost_and_Dem_Matrices_with_TcredUSA.dta

mata
/*Reading the data from the dataset*/

//Cost and dem
st_view(C=.,.,(2..29))
st_view(D=.,.,(30..57))

st_view(p=.,.,("Payturn"))
st_view(r=.,.,("Recturn"))
st_view(s=.,.,("Stdbtpay"))

p = 1:/p
r = 1:/r

s1 = rows(D)
s2 = cols(D)

/*Computing the matrix B*/

B = I(s1) - pinv(D)

Rd = invsym(sqrt(diag(diagonal(B*B'))))

BPay_    = Rd*B*diag(p)*B'*Rd
BStdpay_ = Rd*B*diag(s)*B'*Rd

BPay      = BPay_ - 0.5*(diag(diagonal(BPay_))*Rd*B*B'*Rd + Rd*B*B'*Rd*diag(diagonal(BPay_)))
BStdpay   = BStdpay_ - 0.5*(diag(diagonal(BStdpay_))*Rd*B*B'*Rd + Rd*B*B'*Rd*diag(diagonal(BStdpay_)))


/*Copying them back to stata*/

st_matrix("BPay",BPay)
st_matrix("BStdpay",BStdpay)

/*End mata*/

end

keep isic

*Now I relabel the columns of the matrices

matrix colnames BPay = BPay_inv311  BPay_inv313  BPay_inv314  BPay_inv321  BPay_inv322  BPay_inv323  BPay_inv324  BPay_inv331  BPay_inv332  BPay_inv341  BPay_inv342  BPay_inv351  BPay_inv352  BPay_inv353  BPay_inv354  BPay_inv355  BPay_inv356  BPay_inv361  BPay_inv362  BPay_inv369  BPay_inv371  BPay_inv372  BPay_inv381  BPay_inv382  BPay_inv383  BPay_inv384  BPay_inv385  BPay_inv390
matrix colnames BStdpay = BStdpay311  BStdpay313  BStdpay314  BStdpay321  BStdpay322  BStdpay323  BStdpay324  BStdpay331  BStdpay332  BStdpay341  BStdpay342  BStdpay351  BStdpay352  BStdpay353  BStdpay354  BStdpay355  BStdpay356  BStdpay361  BStdpay362  BStdpay369  BStdpay371  BStdpay372  BStdpay381  BStdpay382  BStdpay383  BStdpay384  BStdpay385  BStdpay390

svmat  BPay, names(col)
svmat  BStdpay, names(col)

save B_Model_matrices_inv, replace
