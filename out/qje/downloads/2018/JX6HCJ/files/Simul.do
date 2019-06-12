capture mkdir simul
capture cd simul

global iter = 10000
global reps = 1000

foreach dir in chi2 normal fixed achi2 anormal afixed ichi2 inormal ifixed ilev ip {
	capture mkdir `dir'
	}


****************************************
****************************************

*Balanced

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		quietly generate double y = (invnormal(uniform())^2-1)*x + invnormal(uniform())
		mata {
			R = J($reps,5,.); BR = J($reps,2,.)
			y = st_data(.,"y"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = (sigma'*sigma)*$N/($N-2); B = b, sqrt(sigma)
			JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2)
				a1 = colsum(tt:*x) ; a2 = ($N/($N-2))*2*colsum((tt:^2):*((x-a1*t):*e)); a3 = ($N/($N-2))*colsum((tt:^2):*((x-a1*t):^2))
				R[i,1..5] = b, sqrt(sigma), a1, a2, a3
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2]; yy = yy[1...,1]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..2] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		quietly replace B1 = B1[_n-1] if _n > 1
		quietly replace B2 = B2[_n-1] if _n > 1
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save chi2\i`p'n$N, replace
		}
	}
	

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		quietly generate double y = invnormal(uniform())*x + invnormal(uniform())
		mata {
			R = J($reps,5,.); BR = J($reps,2,.)
			y = st_data(.,"y"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = (sigma'*sigma)*$N/($N-2); B = b, sqrt(sigma)
			JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2)
				a1 = colsum(tt:*x) ; a2 = ($N/($N-2))*2*colsum((tt:^2):*((x-a1*t):*e)); a3 = ($N/($N-2))*colsum((tt:^2):*((x-a1*t):^2))
				R[i,1..5] = b, sqrt(sigma), a1, a2, a3
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2]; yy = yy[1...,1]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..2] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		quietly replace B1 = B1[_n-1] if _n > 1
		quietly replace B2 = B2[_n-1] if _n > 1
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save normal\i`p'n$N, replace
		}
	}
	

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		quietly generate double y = invnormal(uniform())
		mata {
			R = J($reps,5,.); BR = J($reps,2,.)
			y = st_data(.,"y"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = (sigma'*sigma)*$N/($N-2); B = b, sqrt(sigma)
			JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2)
				a1 = colsum(tt:*x) ; a2 = ($N/($N-2))*2*colsum((tt:^2):*((x-a1*t):*e)); a3 = ($N/($N-2))*colsum((tt:^2):*((x-a1*t):^2))
				R[i,1..5] = b, sqrt(sigma), a1, a2, a3
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2]; yy = yy[1...,1]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..2] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		quietly replace B1 = B1[_n-1] if _n > 1
		quietly replace B2 = B2[_n-1] if _n > 1
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save fixed\i`p'n$N, replace
		}
	}


****************************************
****************************************

*Unbalanced - a

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		quietly generate double y = (invnormal(uniform())^2-1)*x + invnormal(uniform())
		mata {
			R = J($reps,5,.); BR = J($reps,2,.)
			y = st_data(.,"y"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = (sigma'*sigma)*$N/($N-2); B = b, sqrt(sigma)
			JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2)
				a1 = colsum(tt:*x) ; a2 = ($N/($N-2))*2*colsum((tt:^2):*((x-a1*t):*e)); a3 = ($N/($N-2))*colsum((tt:^2):*((x-a1*t):^2))
				R[i,1..5] = b, sqrt(sigma), a1, a2, a3
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2]; yy = yy[1...,1]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..2] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		quietly replace B1 = B1[_n-1] if _n > 1
		quietly replace B2 = B2[_n-1] if _n > 1
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save achi2\i`p'n$N, replace
		}
	}
	

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		quietly generate double y = invnormal(uniform())*x + invnormal(uniform())
		mata {
			R = J($reps,5,.); BR = J($reps,2,.)
			y = st_data(.,"y"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = (sigma'*sigma)*$N/($N-2); B = b, sqrt(sigma)
			JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2)
				a1 = colsum(tt:*x) ; a2 = ($N/($N-2))*2*colsum((tt:^2):*((x-a1*t):*e)); a3 = ($N/($N-2))*colsum((tt:^2):*((x-a1*t):^2))
				R[i,1..5] = b, sqrt(sigma), a1, a2, a3
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2]; yy = yy[1...,1]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..2] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		quietly replace B1 = B1[_n-1] if _n > 1
		quietly replace B2 = B2[_n-1] if _n > 1
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save anormal\i`p'n$N, replace
		}
	}
	

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		quietly generate double y = invnormal(uniform())
		mata {
			R = J($reps,5,.); BR = J($reps,2,.)
			y = st_data(.,"y"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = (sigma'*sigma)*$N/($N-2); B = b, sqrt(sigma)
			JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2)
				a1 = colsum(tt:*x) ; a2 = ($N/($N-2))*2*colsum((tt:^2):*((x-a1*t):*e)); a3 = ($N/($N-2))*colsum((tt:^2):*((x-a1*t):^2))
				R[i,1..5] = b, sqrt(sigma), a1, a2, a3
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2]; yy = yy[1...,1]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..2] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		quietly replace B1 = B1[_n-1] if _n > 1
		quietly replace B2 = B2[_n-1] if _n > 1
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save afixed\i`p'n$N, replace
		}
	}


****************************************
****************************************

*Interactions

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly generate double y = (invnormal(uniform())^2-1)*x1 + (invnormal(uniform())^2-1)*x2 + u + invnormal(uniform())

		mata {
			R = J($reps,4,.); BR = J($reps,4,.)
			y = st_data(.,"y"); x = st_data(.,"x1 x2"); c = st_data(.,"u"); c = c, J($N,1,1); m = x, c; m = rowsum(m*invsym(m'*m):*m); m = 1:-m; ccc = invsym(c'*c)*c'
			y = y - c*(ccc*y); xx = x - c*(ccc*x); v = invsym(xx'*xx); xxx = xx*v; b = colsum(xxx:*y)
			e = y-xx*b'; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-4); B = b, sqrt(sigma)
			JK = b:-(xx:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x[1...,1]); t = t, t:*c[1...,1]; t = t - c*(ccc*t); v = invsym(t'*t)
				tt = t*v; b = colsum(tt:*y); e = y-t*b'; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-4)
				R[i,1..4] = b, sqrt(sigma)
				}
			y = st_data(.,"y x1 x2 u")
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2..3]; c = yy[1...,4], J($N,1,1); yy = yy[1...,1]
				ccc = invsym(c'*c)*c'; yy = yy - c*(ccc*yy); xx = xx - c*(ccc*xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-4)); BR[i,1..4] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		foreach var in B1 B2 B3 B4 {
			quietly replace `var' = `var'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save ichi2\i`p'n$N, replace
		}
	}


foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly generate double y = invnormal(uniform())*x1 + invnormal(uniform())*x2 + u + invnormal(uniform())

		mata {
			R = J($reps,4,.); BR = J($reps,4,.)
			y = st_data(.,"y"); x = st_data(.,"x1 x2"); c = st_data(.,"u"); c = c, J($N,1,1); m = x, c; m = rowsum(m*invsym(m'*m):*m); m = 1:-m; ccc = invsym(c'*c)*c'
			y = y - c*(ccc*y); xx = x - c*(ccc*x); v = invsym(xx'*xx); xxx = xx*v; b = colsum(xxx:*y)
			e = y-xx*b'; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-4); B = b, sqrt(sigma)
			JK = b:-(xx:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x[1...,1]); t = t, t:*c[1...,1]; t = t - c*(ccc*t); v = invsym(t'*t)
				tt = t*v; b = colsum(tt:*y); e = y-t*b'; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-4)
				R[i,1..4] = b, sqrt(sigma)
				}
			y = st_data(.,"y x1 x2 u")
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2..3]; c = yy[1...,4], J($N,1,1); yy = yy[1...,1]
				ccc = invsym(c'*c)*c'; yy = yy - c*(ccc*yy); xx = xx - c*(ccc*xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-4)); BR[i,1..4] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		foreach var in B1 B2 B3 B4 {
			quietly replace `var' = `var'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save inormal\i`p'n$N, replace
		}
	}


foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly generate double y = u + invnormal(uniform())

		mata {
			R = J($reps,4,.); BR = J($reps,4,.)
			y = st_data(.,"y"); x = st_data(.,"x1 x2"); c = st_data(.,"u"); c = c, J($N,1,1); m = x, c; m = rowsum(m*invsym(m'*m):*m); m = 1:-m; ccc = invsym(c'*c)*c'
			y = y - c*(ccc*y); xx = x - c*(ccc*x); v = invsym(xx'*xx); xxx = xx*v; b = colsum(xxx:*y)
			e = y-xx*b'; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-4); B = b, sqrt(sigma)
			JK = b:-(xx:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x[1...,1]); t = t, t:*c[1...,1]; t = t - c*(ccc*t); v = invsym(t'*t)
				tt = t*v; b = colsum(tt:*y); e = y-t*b'; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-4)
				R[i,1..4] = b, sqrt(sigma)
				}
			y = st_data(.,"y x1 x2 u")
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,2..3]; c = yy[1...,4], J($N,1,1); yy = yy[1...,1]
				ccc = invsym(c'*c)*c'; yy = yy - c*(ccc*yy); xx = xx - c*(ccc*xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b'; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-4)); BR[i,1..4] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("JK",JK); st_matrix("B",B)
		foreach matrix in R BR JK B {
			quietly svmat double `matrix'
			} 
		foreach var in B1 B2 B3 B4 {
			quietly replace `var' = `var'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save ifixed\i`p'n$N, replace
		}
	}


*****************************************

*Calculating leverage distribution for interactions

foreach j in 20 200 2000 {
	global N = `j'
	matrix R = J(10000,8,.)
	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"
		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly reg x1 x2 u
		quietly predict double e, resid
		quietly replace e = e^2
		quietly sum e
		quietly replace e = e/r(sum)
		gsort -e
		quietly replace e = e + e[_n-1] if _n > 1
		quietly sum e, detail
		matrix R[`p',1] = r(min), r(p1), r(p5), r(p10)
		drop e
		quietly reg x2 x1 u
		quietly predict double e, resid
		quietly replace e = e^2
		quietly sum e
		quietly replace e = e/r(sum)
		gsort -e
		quietly replace e = e + e[_n-1] if _n > 1
		quietly sum e, detail
		matrix R[`p',5] = r(min), r(p1), r(p5), r(p10)
		}
	drop _all
	svmat double R
	generate N = $N
	generate iteration = _n
	save ilev\ilev$N, replace
	}


****************************************

*Combining files

foreach j in 20 200 2000 {
	foreach method in chi2 normal fixed achi2 anormal afixed ichi2 inormal ifixed {
		drop _all
		forvalues p = 1/$iter {
			local file = "`method'" + "\i" + "`p'" + "n" + "`j'"
			append using `file'
			}
		local file = "`method'" + "\" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

****************************************

*Calculating p-values

foreach j in 20 200 2000 {
	foreach method in fixed normal chi2 afixed anormal achi2 {
		local file = "`method'" + "\" + "`method'" + "n" + "`j'"
		display "`file'"
		use `file', clear
		quietly gen byte Rcu = abs(R1) > abs(B1) - 1e-08 if R1 ~= .
		quietly gen byte Rcl = abs(R1) > abs(B1) + 1e-08 if R1 ~= . 
		quietly gen byte Rtu = abs(R1/R2) > abs(B1/B2) - 1e-08 if R1 ~= . 
		quietly gen byte Rtl = abs(R1/R2) > abs(B1/B2) + 1e-08 if R1 ~= . 
		quietly gen byte Bcu = abs(BR1-B1) > abs(B1) - 1e-08 if BR1 ~= . 
		quietly gen byte Bcl = abs(BR1-B1) > abs(B1) + 1e-08 if BR1 ~= .  
		quietly gen byte Btu = abs((BR1-B1)/BR2) > abs(B1/B2) - 1e-08 if BR1 ~= .  
		quietly gen byte Btl = abs((BR1-B1)/BR2) > abs(B1/B2) + 1e-08 if BR1 ~= .  
		quietly replace JK1 = (JK1-B1)^2
		collapse (mean) B1 B2 JK1 (sum) Rc* Rt* Bc* Bt*, by(iteration) fast
		quietly replace JK1 = sqrt((`j'-1)*JK1)
		generate N = `j'
		generate file = "`method'"
		local file = "ip\" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

foreach j in 20 200 2000 {
	foreach method in ifixed inormal ichi2 {
		local file = "`method'" + "\" + "`method'" + "n" + "`j'"
		display "`file'"
		use `file', clear
		forvalues k = 1/2 {
			local m = `k' + 2
			quietly gen byte Rcu`k' = abs(R`k') > abs(B`k') - 1e-08 if R`k' ~= . 
			quietly gen byte Rcl`k' = abs(R`k') > abs(B`k') + 1e-08 if R`k' ~= .  
			quietly gen byte Rtu`k' = abs(R`k'/R`m') > abs(B`k'/B`m') - 1e-08 if R`k' ~= .  
			quietly gen byte Rtl`k' = abs(R`k'/R`m') > abs(B`k'/B`m') + 1e-08 if R`k' ~= .  
			quietly gen byte Bcu`k' = abs(BR`k'-B`k') > abs(B`k') - 1e-08 if BR`k' ~= .  
			quietly gen byte Bcl`k' = abs(BR`k'-B`k') > abs(B`k') + 1e-08 if BR`k' ~= .   
			quietly gen byte Btu`k' = abs((BR`k'-B`k')/BR`m') > abs(B`k'/B`m') - 1e-08 if BR`k' ~= .   
			quietly gen byte Btl`k' = abs((BR`k'-B`k')/BR`m') > abs(B`k'/B`m') + 1e-08 if BR`k' ~= .   
			quietly replace JK`k' = (JK`k'-B`k')^2
			}
		collapse (mean) B1 B2 B3 B4 JK* (sum) Rc* Rt* Bc* Bt*, by(iteration) fast
		quietly replace JK1 = sqrt((`j'-1)*JK1)
		quietly replace JK2 = sqrt((`j'-1)*JK2)
		generate N = `j'
		generate file = "`method'"
		local file = "ip\" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

drop _all
foreach j in 20 200 2000 {
	foreach method in fixed normal chi2 afixed anormal achi2 {
		local file = "ip\" + "`method'" + "n" + "`j'"
		append using `file'
		}
	}
gen double p = Ftail(1,N-2,(B1/B2)^2)
gen double pjk = Ftail(1,N-1,(B1/JK1)^2)
set seed 1
gen double u = uniform()
gen double prc = (Rcl + u*(Rcu-Rcl+1))/(1001)
gen double prt = (Rtl + u*(Rtu-Rtl+1))/(1001)
gen double pbc = (Bcl + u*(Bcu-Bcl+1))/(1001)
gen double pbt = (Btl + u*(Btu-Btl+1))/(1001)
keep p* file N iteration
compress
save pvalues, replace

drop _all
foreach j in 20 200 2000 {
	foreach method in ifixed inormal ichi2 {
		local file = "ip\" + "`method'" + "n" + "`j'"
		append using `file'
		}
	}
gen double p1 = Ftail(1,N-4,(B1/B3)^2)
gen double p2 = Ftail(1,N-4,(B2/B4)^2)
gen double pjk1 = Ftail(1,N-1,(B1/JK1)^2)
gen double pjk2 = Ftail(1,N-1,(B2/JK2)^2)
set seed 1
gen double u = uniform()
forvalues i = 1/2 {
	gen double prc`i' = (Rcl`i' + u*(Rcu`i'-Rcl`i'+1))/(1001)
	gen double prt`i' = (Rtl`i' + u*(Rtu`i'-Rtl`i'+1))/(1001)
	gen double pbc`i' = (Bcl`i' + u*(Bcu`i'-Bcl`i'+1))/(1001)
	gen double pbt`i' = (Btl`i' + u*(Btu`i'-Btl`i'+1))/(1001)
	}
keep p* file N iteration
compress
save ipvalues, replace

**********************************************
**********************************************

*Suest - 10 equations

*Balanced

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		forvalues i = 1/10 {
			quietly generate double y`i' = (invnormal(uniform())^2-1)*x + invnormal(uniform())
			}
		mata {
			R = J($reps,20,.); BR = J($reps,20,.)
			y = st_data(.,"y*"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); B = b, sqrt(sigma); JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); R[i,1..20] = b, sqrt(sigma)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..20] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("B",B); st_matrix("JK",JK)
		foreach matrix in R BR B JK {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/20 {
			quietly replace B`i' = B`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save chi2\s`p'n$N, replace
		}
	}
	

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())*x + invnormal(uniform())
			}
		mata {
			R = J($reps,20,.); BR = J($reps,20,.)
			y = st_data(.,"y*"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); B = b, sqrt(sigma); JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); R[i,1..20] = b, sqrt(sigma)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..20] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("B",B); st_matrix("JK",JK)
		foreach matrix in R BR B JK {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/20 {
			quietly replace B`i' = B`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save normal\s`p'n$N, replace
		}
	}


foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())
			}
		mata {
			R = J($reps,20,.); BR = J($reps,20,.)
			y = st_data(.,"y*"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); B = b, sqrt(sigma); JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); R[i,1..20] = b, sqrt(sigma)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..20] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("B",B); st_matrix("JK",JK)
		foreach matrix in R BR B JK {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/20 {
			quietly replace B`i' = B`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save fixed\s`p'n$N, replace
		}
	}



****************************************
****************************************

*Unbalanced - a

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		forvalues i = 1/10 {
			quietly generate double y`i' = (invnormal(uniform())^2-1)*x + invnormal(uniform())
			}
		mata {
			R = J($reps,20,.); BR = J($reps,20,.)
			y = st_data(.,"y*"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); B = b, sqrt(sigma); JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); R[i,1..20] = b, sqrt(sigma)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..20] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("B",B); st_matrix("JK",JK)
		foreach matrix in R BR B JK {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/20 {
			quietly replace B`i' = B`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save achi2\s`p'n$N, replace
		}
	}
	

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())*x + invnormal(uniform())
			}
		mata {
			R = J($reps,20,.); BR = J($reps,20,.)
			y = st_data(.,"y*"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); B = b, sqrt(sigma); JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); R[i,1..20] = b, sqrt(sigma)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..20] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("B",B); st_matrix("JK",JK)
		foreach matrix in R BR B JK {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/20 {
			quietly replace B`i' = B`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save anormal\s`p'n$N, replace
		}
	}


foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())
			}
		mata {
			R = J($reps,20,.); BR = J($reps,20,.)
			y = st_data(.,"y*"); x = st_data(.,"x"); m = x, J($N,1,1); m = rowsum(m*invsym(m'*m):*m); m = 1:-m
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; b = colsum(xxx:*y)
			e = y-x*b; sigma = xxx:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); B = b, sqrt(sigma); JK = b:-(x:*(e:/m))*v
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = colsum(sigma:*sigma)*$N/($N-2); R[i,1..20] = b, sqrt(sigma)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = colsum(sigma:*sigma)*($N/($N-2)); BR[i,1..20] = b, sqrt(sigma)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("B",B); st_matrix("JK",JK)
		foreach matrix in R BR B JK {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/20 {
			quietly replace B`i' = B`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save afixed\s`p'n$N, replace
		}
	}


****************************************
****************************************

*p-values

foreach j in 20 200 2000 {
	foreach method in fixed normal chi2 afixed anormal achi2 {
		display "`method'"
 		forvalues p = 1/$iter {
			local file = "`method'" + "\s" + "`p'" + "n" + "`j'"
			use `file', clear
			forvalues i = 1/10 {
				quietly replace JK`i' = JK`i' - B`i'
				quietly replace BR`i' = BR`i' - B`i'
				local k = `i' + 10
				quietly gen byte Rcu`i' = abs(R`i') > abs(B`i') - 1e-08 if R`i' ~= .
				quietly gen byte Rcl`i' = abs(R`i') > abs(B`i') + 1e-08 if R`i' ~= . 
				quietly gen byte Rtu`i' = abs(R`i'/R`k') > abs(B`i'/B`k') - 1e-08 if R`i' ~= . 
				quietly gen byte Rtl`i' = abs(R`i'/R`k') > abs(B`i'/B`k') + 1e-08 if R`i' ~= . 
				quietly gen byte Bcu`i' = abs(BR`i') > abs(B`i') - 1e-08 if BR`i' ~= . 
				quietly gen byte Bcl`i' = abs(BR`i') > abs(B`i') + 1e-08 if BR`i' ~= .  
				quietly gen byte Btu`i' = abs(BR`i'/BR`k') > abs(B`i'/B`k') - 1e-08 if BR`i' ~= .  
				quietly gen byte Btl`i' = abs(BR`i'/BR`k') > abs(B`i'/B`k') + 1e-08 if BR`i' ~= .  
				}
			quietly matrix accum JK = JK1-JK10 in 1/`j', noconstant
			mkmat B1-B10 in 1/1, matrix(B)
			matrix JK = JK*(`j'-1)/`j'
			matrix JK = B*invsym(JK)*B'
			mata R = st_data((1,$reps),("R1","R2","R3","R4","R5","R6","R7","R8","R9","R10")); BR = st_data((1,$reps),("BR1","BR2","BR3","BR4","BR5","BR6","BR7","BR8","BR9","BR10")); B = st_matrix("B")
			mata VR = invsym(R'*R); VBR = invsym(BR'*BR); BVR = B*VR*B'; BVBR = B*VBR*B'; VR = rowsum(R*VR:*R); VBR = rowsum(BR*VBR:*BR) 
			mata VR = (VR:>BVR*.999999,VR:>BVR*1.000001); VBR = (VBR:>BVBR*.999999,VBR:>BVBR*1.000001)
			mata st_matrix("VR",VR); st_matrix("VBR",VBR)
			quietly svmat VR
			quietly svmat VBR
			forvalues i = 1/10 {
				quietly replace JK`i'= ((`j'-1)/`j')*JK`i'^2
				}
			collapse (mean) B1-B20 iteration (sum) JK* VR* VBR* Rc* Rt* Bc* Bt*, fast
			quietly generate pjk = Ftail(10,`j'-1,JK[1,1]/10)
			quietly generate N = `j'
			quietly generate file = "`method'"
			local file = "`method'" + "\spv" + "`p'" + "n" + "`j'"
			quietly save `file', replace
			}
		}
	}

drop _all
foreach j in 20 200 2000 {
	foreach method in fixed normal chi2 afixed anormal achi2 {
		display "`method'"
		forvalues p = 1/$iter {
			local file = "`method'" + "\spv" + "`p'" + "n" + "`j'"
			append using `file'
			}
		}
	}
forvalues i = 1/10 {
	local k = `i' + 10
	gen double p`i' = Ftail(1,N-2,(B`i'/B`k')^2)
	gen double pjk`i' = Ftail(1,N-1,(B`i'^2)/JK`i')
	}
set seed 1
gen double u = uniform()
quietly generate double prc = (VR2 + u*(1+VR1-VR2))/1001
quietly generate double pbc = (VBR2 + u*(1+VBR1-VBR2))/1001
forvalues i = 1/10 {
	gen double u`i' = uniform()
	gen double prc`i' = (Rcl`i' + u`i'*(1 + Rcu`i'-Rcl`i'))/1001
	gen double prt`i' = (Rtl`i' + u`i'*(1 + Rtu`i'-Rtl`i'))/1001
	gen double pbc`i' = (Bcl`i' + u`i'*(1 + Bcu`i'-Bcl`i'))/1001
	gen double pbt`i' = (Btl`i' + u`i'*(1 + Btu`i'-Btl`i'))/1001
	}
keep p* file N iteration
compress
save spvalues, replace

*********************************************
*********************************************

*Full Suest

*Balanced

foreach j in 20 200 2000  {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		forvalues i = 1/10 {
			quietly generate double y`i' = (invnormal(uniform())^2-1)*x + invnormal(uniform())
			}
		mata {
			R = J($reps,2,.); BR = J($reps,2,.)
			y = st_data(.,"y*"); x = st_data(.,"x")
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; bb = colsum(xxx:*y)
			e = y-x*bb; sigma = xxx:*e; sigma = sigma'*sigma*$N/($N-1); sigma = invsym(sigma); S = bb*sigma*bb', colsum(rowsum(abs(sigma)):>0)
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = sigma'*sigma*$N/($N-1); 
				sigma = invsym(sigma); R[i,1..2] = b*sigma*b', colsum(rowsum(abs(sigma)):>0)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = sigma'*sigma*$N/($N-1) 
				sigma = invsym(sigma); BR[i,1..2] = (b-bb)*sigma*(b-bb)', colsum(rowsum(abs(sigma)):>0)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("S",S)
		foreach matrix in R BR S {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/2 {
			quietly replace S`i' = S`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save chi2\fs`p'n$N, replace
		}
	}
	
foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())*x + invnormal(uniform())
			}
		mata {
			R = J($reps,2,.); BR = J($reps,2,.)
			y = st_data(.,"y*"); x = st_data(.,"x")
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; bb = colsum(xxx:*y)
			e = y-x*bb; sigma = xxx:*e; sigma = sigma'*sigma*$N/($N-1); sigma = invsym(sigma); S = bb*sigma*bb', colsum(rowsum(abs(sigma)):>0)
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = sigma'*sigma*$N/($N-1); 
				sigma = invsym(sigma); R[i,1..2] = b*sigma*b', colsum(rowsum(abs(sigma)):>0)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = sigma'*sigma*$N/($N-1) 
				sigma = invsym(sigma); BR[i,1..2] = (b-bb)*sigma*(b-bb)', colsum(rowsum(abs(sigma)):>0)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("S",S)
		foreach matrix in R BR S {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/2 {
			quietly replace S`i' = S`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save normal\fs`p'n$N, replace
		}
	}

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/2)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())
			}
		mata {
			R = J($reps,2,.); BR = J($reps,2,.)
			y = st_data(.,"y*"); x = st_data(.,"x")
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; bb = colsum(xxx:*y)
			e = y-x*bb; sigma = xxx:*e; sigma = sigma'*sigma*$N/($N-1); sigma = invsym(sigma); S = bb*sigma*bb', colsum(rowsum(abs(sigma)):>0)
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = sigma'*sigma*$N/($N-1); 
				sigma = invsym(sigma); R[i,1..2] = b*sigma*b', colsum(rowsum(abs(sigma)):>0)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = sigma'*sigma*$N/($N-1) 
				sigma = invsym(sigma); BR[i,1..2] = (b-bb)*sigma*(b-bb)', colsum(rowsum(abs(sigma)):>0)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("S",S)
		foreach matrix in R BR S {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/2 {
			quietly replace S`i' = S`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save fixed\fs`p'n$N, replace
		}
	}

****************************************
****************************************

*Unbalanced - a

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		forvalues i = 1/10 {
			quietly generate double y`i' = (invnormal(uniform())^2-1)*x + invnormal(uniform())
			}
		mata {
			R = J($reps,2,.); BR = J($reps,2,.)
			y = st_data(.,"y*"); x = st_data(.,"x")
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; bb = colsum(xxx:*y)
			e = y-x*bb; sigma = xxx:*e; sigma = sigma'*sigma*$N/($N-1); sigma = invsym(sigma); S = bb*sigma*bb', colsum(rowsum(abs(sigma)):>0)
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = sigma'*sigma*$N/($N-1); 
				sigma = invsym(sigma); R[i,1..2] = b*sigma*b', colsum(rowsum(abs(sigma)):>0)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = sigma'*sigma*$N/($N-1) 
				sigma = invsym(sigma); BR[i,1..2] = (b-bb)*sigma*(b-bb)', colsum(rowsum(abs(sigma)):>0)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("S",S)
		foreach matrix in R BR S {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/2 {
			quietly replace S`i' = S`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save achi2\fs`p'n$N, replace
		}
	}
	
foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())*x + invnormal(uniform())
			}
		mata {
			R = J($reps,2,.); BR = J($reps,2,.)
			y = st_data(.,"y*"); x = st_data(.,"x")
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; bb = colsum(xxx:*y)
			e = y-x*bb; sigma = xxx:*e; sigma = sigma'*sigma*$N/($N-1); sigma = invsym(sigma); S = bb*sigma*bb', colsum(rowsum(abs(sigma)):>0)
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = sigma'*sigma*$N/($N-1); 
				sigma = invsym(sigma); R[i,1..2] = b*sigma*b', colsum(rowsum(abs(sigma)):>0)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = sigma'*sigma*$N/($N-1) 
				sigma = invsym(sigma); BR[i,1..2] = (b-bb)*sigma*(b-bb)', colsum(rowsum(abs(sigma)):>0)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("S",S)
		foreach matrix in R BR S {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/2 {
			quietly replace S`i' = S`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save anormal\fs`p'n$N, replace
		}
	}

foreach j in 20 200 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x = (_n <= $N/10)
		forvalues i = 1/10 {
			quietly generate double y`i' = invnormal(uniform())
			}
		mata {
			R = J($reps,2,.); BR = J($reps,2,.)
			y = st_data(.,"y*"); x = st_data(.,"x")
			y = y:-mean(y); x = x:-mean(x); v = invsym(x'*x); xxx = x*v; bb = colsum(xxx:*y)
			e = y-x*bb; sigma = xxx:*e; sigma = sigma'*sigma*$N/($N-1); sigma = invsym(sigma); S = bb*sigma*bb', colsum(rowsum(abs(sigma)):>0)
			for (i=1;i<=$reps;i++) {
				t = jumble(x); tt = v*t; b = colsum(tt:*y); e = y-t*b; sigma = tt:*e; sigma = sigma'*sigma*$N/($N-1); 
				sigma = invsym(sigma); R[i,1..2] = b*sigma*b', colsum(rowsum(abs(sigma)):>0)
				}
			y = y, x
			for (i=1;i<=$reps;i++) {
				u = ceil(uniform($N,1)*$N); if (colmin(u) < 1) u = rowmax((u,J($N,1,1))) 
				yy = y[u[1,1],1...]; for (j=2;j<=$N;j++) yy = yy \ y[u[j,1],1...]
				xx = yy[1...,11]; yy = yy[1...,1..10]; yy = yy:-mean(yy); xx = xx:-mean(xx); xxx = xx*invsym(xx'*xx)
				b = colsum(xxx:*yy); e = yy-xx*b; sigma = (xxx:*e); sigma = sigma'*sigma*$N/($N-1) 
				sigma = invsym(sigma); BR[i,1..2] = (b-bb)*sigma*(b-bb)', colsum(rowsum(abs(sigma)):>0)
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("BR",BR); st_matrix("S",S)
		foreach matrix in R BR S {
			quietly svmat double `matrix'
			} 
		forvalues i = 1/2 {
			quietly replace S`i' = S`i'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save afixed\fs`p'n$N, replace
		}
	}

*****************************************************
*****************************************************

*Combining files

foreach j in 20 200 2000 {
	foreach method in chi2 normal fixed achi2 anormal afixed  {
		drop _all
		forvalues p = 1/$iter {
			local file = "`method'" + "\fs" + "`p'" + "n" + "`j'"
			append using `file'
			}
		local file = "`method'" + "\fs" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

*****************************************

foreach j in 20 200 2000 {
	foreach method in fixed normal chi2 afixed anormal achi2 {
		local file = "`method'" + "\fs" + "`method'" + "n" + "`j'"
		display "`file'"
		use `file', clear
		quietly gen double p = chi2tail(S2,S1) if S2 == 10
		quietly gen IRu = R1 > S1 - 1e-08 if R2 == 10
		quietly gen IRl = R1 > S1 + 1e-08 if R2 == 10
		quietly gen IR = (R2 == 10)
		quietly gen IBu = BR1 > S1 - 1e-08 if BR2 == 10
		quietly gen IBl = BR1 > S1 + 1e-08 if BR2 == 10
		quietly gen IB = (BR2 == 10)
		collapse (sum) I* (mean) p, by(iteration) fast
		generate N = `j'
		generate file = "`method'"
		local file = "ip\fs" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

drop _all
foreach j in 20 200 2000 {
	foreach file in chi2 normal fixed achi2 anormal afixed {
		append using ip\fs`file'n`j'
		}
	}
set seed 1
gen double u = uniform()
gen double pr = (IRl + u*(IRu-IRl+1))/(IR + 1)
gen double pb = (IBl + u*(IBu-IBl+1))/(IB + 1)
merge 1:1 file N iteration using spvalues, keepusing(pjk prc pbc)
keep pr pb pjk prc pbc p N file iteration
sort file N iteration
save fsuestpvalues, replace

*****************************
****************************

*Homoskedastic variance estimate (for Figure III)

*Interactions

foreach j in 20 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly generate double y = (invnormal(uniform())^2-1)*x1 + (invnormal(uniform())^2-1)*x2 + u + invnormal(uniform())

		mata {
			R = J($reps,4,.)
			y = st_data(.,"y"); x = st_data(.,"x1 x2"); c = st_data(.,"u"); c = c, J($N,1,1); ccc = invsym(c'*c)*c'
			y = y - c*(ccc*y); xx = x - c*(ccc*x); v = invsym(xx'*xx); xxx = xx*v; b = colsum(xxx:*y)
			e = y-xx*b'; sigma = v*(e'*e)/($N-4); B = b, sqrt(diagonal(sigma))'
			for (i=1;i<=$reps;i++) {
				t = jumble(x[1...,1]); t = t, t:*c[1...,1]; t = t - c*(ccc*t); v = invsym(t'*t)
				tt = t*v; b = colsum(tt:*y); e = y-t*b'; sigma = v*(e'*e)/($N-4)
				R[i,1..4] = B = b, sqrt(diagonal(sigma))'
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("B",B)
		quietly svmat double R
		quietly svmat double B
		foreach var in B1 B2 B3 B4 {
			quietly replace `var' = `var'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save ichi2\hi`p'n$N, replace
		}
	}


foreach j in 20 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly generate double y = invnormal(uniform())*x1 + invnormal(uniform())*x2 + u + invnormal(uniform())

		mata {
			R = J($reps,4,.)
			y = st_data(.,"y"); x = st_data(.,"x1 x2"); c = st_data(.,"u"); c = c, J($N,1,1); ccc = invsym(c'*c)*c'
			y = y - c*(ccc*y); xx = x - c*(ccc*x); v = invsym(xx'*xx); xxx = xx*v; b = colsum(xxx:*y)
			e = y-xx*b'; sigma = v*(e'*e)/($N-4); B = b, sqrt(diagonal(sigma))'
			for (i=1;i<=$reps;i++) {
				t = jumble(x[1...,1]); t = t, t:*c[1...,1]; t = t - c*(ccc*t); v = invsym(t'*t)
				tt = t*v; b = colsum(tt:*y); e = y-t*b'; sigma = v*(e'*e)/($N-4)
				R[i,1..4] = B = b, sqrt(diagonal(sigma))'
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("B",B)
		quietly svmat double R
		quietly svmat double B
		foreach var in B1 B2 B3 B4 {
			quietly replace `var' = `var'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save inormal\hi`p'n$N, replace
		}
	}


foreach j in 20 2000 {

	global N = `j'

	forvalues p = 1/$iter {
		set seed `p'
		if (ceil(`p'/50)*50 == `p') display "`p'"

		drop _all
		quietly set obs $N
		quietly generate byte x1 = (_n <= $N/2)
		quietly generate u = -ln(1-uniform())
		quietly generate x2 = x1*u
		quietly generate double y = u + invnormal(uniform())

		mata {
			R = J($reps,4,.)
			y = st_data(.,"y"); x = st_data(.,"x1 x2"); c = st_data(.,"u"); c = c, J($N,1,1); ccc = invsym(c'*c)*c'
			y = y - c*(ccc*y); xx = x - c*(ccc*x); v = invsym(xx'*xx); xxx = xx*v; b = colsum(xxx:*y)
			e = y-xx*b'; sigma = v*(e'*e)/($N-4); B = b, sqrt(diagonal(sigma))'
			for (i=1;i<=$reps;i++) {
				t = jumble(x[1...,1]); t = t, t:*c[1...,1]; t = t - c*(ccc*t); v = invsym(t'*t)
				tt = t*v; b = colsum(tt:*y); e = y-t*b'; sigma = v*(e'*e)/($N-4)
				R[i,1..4] = B = b, sqrt(diagonal(sigma))'
				}
			}
		drop _all
		mata st_matrix("R",R); st_matrix("B",B)
		quietly svmat double R
		quietly svmat double B
		foreach var in B1 B2 B3 B4 {
			quietly replace `var' = `var'[_n-1] if _n > 1
			}
		quietly generate int iteration = `p'
		quietly generate int rep = _n
		quietly save ifixed\hi`p'n$N, replace
		}
	}


****************************************

*Combining files

foreach j in 20 2000 {
	foreach method in ichi2 inormal ifixed {
		drop _all
		forvalues p = 1/$iter {
			local file = "`method'" + "\hi" + "`p'" + "n" + "`j'"
			append using `file'
			}
		local file = "`method'" + "\h" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

****************************************

*Calculating p-values

foreach j in 20 2000 {
	foreach method in ifixed inormal ichi2 {
		local file = "`method'" + "\h" + "`method'" + "n" + "`j'"
		display "`file'"
		use `file', clear
		forvalues k = 1/2 {
			local m = `k' + 2
			quietly gen byte Rcu`k' = abs(R`k') > abs(B`k') - 1e-08 if R`k' ~= . 
			quietly gen byte Rcl`k' = abs(R`k') > abs(B`k') + 1e-08 if R`k' ~= .  
			quietly gen byte Rtu`k' = abs(R`k'/R`m') > abs(B`k'/B`m') - 1e-08 if R`k' ~= .  
			quietly gen byte Rtl`k' = abs(R`k'/R`m') > abs(B`k'/B`m') + 1e-08 if R`k' ~= .  
			}
		collapse (mean) B1 B2 B3 B4 (sum) Rc* Rt*, by(iteration) fast
		generate N = `j'
		generate file = "`method'"
		local file = "ip\h" + "`method'" + "n" + "`j'"
		save `file', replace
		}
	}

drop _all
foreach j in 20 2000 {
	foreach method in ifixed inormal ichi2 {
		local file = "ip\h" + "`method'" + "n" + "`j'"
		append using `file'
		}
	}
gen double p1 = Ftail(1,N-4,(B1/B3)^2)
gen double p2 = Ftail(1,N-4,(B2/B4)^2)
set seed 1
gen double u = uniform()
forvalues i = 1/2 {
	gen double prc`i' = (Rcl`i' + u*(Rcu`i'-Rcl`i'+1))/(1001)
	gen double prt`i' = (Rtl`i' + u*(Rtu`i'-Rtl`i'+1))/(1001)
	}
keep p* file N iteration
compress
save hipvalues, replace

