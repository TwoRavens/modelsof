*variables 
gen se2 = $SE2
egen sumse2 = sum(se2)
gen cons = 1

*matrixes  
mkmat $DV, matrix(y)
mkmat $GCOL, matrix(G)
mkmat $RHS cons, matrix(X)

*estimate sigma2
regress $DV $RHS, robust
predict e, resid
gen e2 = e*e
egen sume2 = sum(e2)
matrix t = J(rowsof(y),1,trace(invsym(X'*X)*X'*G*X))
svmat double t
rename t1 t
gen sigma2 = (sume2 - sumse2 + t)/(rowsof(y) - colsof(X))

*generate weighting matrix
mkmat sigma2
matrix S = diag(sigma2)
matrix O = S+G

*transform data
matrix Oinv = invsym(O)
matrix rtOinv = cholesky(Oinv)
matrix L = rtOinv'
*then L*O*L' = I
matrix y_ = L*y
matrix X_ = L*X
svmat double y_
svmat double X_

*generate FGLS estimates
reg y_1 X_*, noc level(90)

*check that correct
matrix b = invsym(X'*invsym(O)*X)*X'*invsym(O)*y
matrix list b
