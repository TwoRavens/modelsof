
capture mata: mata drop ezOP_alpha() ezOP_beta() ezop() test() test_eq() pvalue() eval() kp() 
mata: 
mata clear
mata set matastrict on
void ezOP_alpha(real matrix QF, real matrix QG, real matrix SF, real matrix SG, real scalar nF, real scalar nG, real scalar q, string scalar TstatAlpha, string scalar PvalueAlpha)
	{
	real matrix R, RG, D21, D0, O2, O0, T1, T2, pvalue, D1, O1, S0, S1, DFG1, DFG0, Gap, O01, Tstat, Pvalue, T11, T10, T20, T21, AlfaBeta
	real scalar nFG0, nFG1, nFG
	Tstat = J(1,3,.)
	Pvalue = J(1,3,.)
	R = (I(q), -I(q))
	RG = (R, -R)
	nFG = nF + nG
	test_eq(QF, QG, SF, SG, nF, nG, nFG, q, R, "D0", "O0", "T10")
	Tstat[1,1] = st_matrix("T10")
	Pvalue[1,1] = 1- chi2(q,Tstat[1,1])

	test(st_matrix("O0"), st_matrix("D0"), nFG, "T20")
	Tstat[1,2] = st_matrix("T20")
	pvalue(st_matrix("O0"),Tstat[1,2])
	Pvalue[1,2] = st_matrix("pvalue")

	test_eq(QG, QF, SG, SF, nG, nF, nFG, q, R, "D1", "O1", "T11")
	test(st_matrix("O1"), st_matrix("D1"), nFG, "T21")
	Tstat[1,3] = st_matrix("T21")
	pvalue(st_matrix("O1"),Tstat[1,3])
	Pvalue[1,3] = st_matrix("pvalue")
	st_matrix(TstatAlpha, Tstat)
	st_matrix(PvalueAlpha, Pvalue)
}
void ezOP_beta(real matrix QF, real matrix QG, real matrix SF, real matrix SG, real scalar nF, real scalar nG, real scalar q, string scalar TstatBeta, string scalar PvalueBeta)
	{
	real matrix R, RG, D21, D0, O2, O0, T1, T2, pvalue, D1, O1, S0, S1, DFG1, DFG0, Gap, O01, Tstat, Pvalue, T11, T10, T20, T21, AlfaBeta
	real scalar nFG0, nFG1, nFG
	Tstat = J(1,3,.)
	Pvalue = J(1,3,.)
	R = (I(q), -I(q))
	RG = (R, -R)
	nFG = nF + nG
	test_eq(QF, QG, SF, SG, nF, nG, nFG, q, R, "D0", "O0", "T10")
	Tstat[1,1] = st_matrix("T10")
	Pvalue[1,1] = 1- chi2(q,Tstat[1,1])

	test(st_matrix("O0"), st_matrix("D0"), nFG, "T20")
	Tstat[1,2] = st_matrix("T20")
	pvalue(st_matrix("O0"),Tstat[1,2])
	Pvalue[1,2] = st_matrix("pvalue")

	test_eq(QG, QF, SG, SF, nG, nF, nFG, q, R, "D1", "O1", "T11")
	test(st_matrix("O1"), st_matrix("D1"), nFG, "T21")
	Tstat[1,3] = st_matrix("T21")
	pvalue(st_matrix("O1"),Tstat[1,3])
	Pvalue[1,3] = st_matrix("pvalue")
	st_matrix(TstatBeta, Tstat)
	st_matrix(PvalueBeta, Pvalue)
}

void ezop(real matrix QF0, real matrix QG0, real matrix QF1, real matrix QG1, real matrix SF0, real matrix SG0, real matrix SF1, real matrix SG1, real scalar alpha, real scalar beta, real scalar nF, real scalar nG, real scalar q, string scalar TstatEZOP, string scalar PvalueEZOP)
	{
	real matrix R, RG, Tstat, Pvalue, DQTEa, OQTEa, T1QTEa, T2QTEa, pvalue
	real scalar nFG, n
	string scalar fail
	Tstat = J(1,3,.)
	Pvalue = J(1,3,.)
	R = (I(q), -I(q))
	RG = (R, -R)
	nFG = nF + nG
	fail = "The dominance condition cannot be meaningfully tested"
	if (alpha == 0 | beta == 0) {
		fail
	}
	else {
		if (alpha==1 & beta==1) {
			test_eqDD(QF0, QG0, SF0, SG0, QF1, QG1, SF1, SG1, nG, nF, nFG, q, RG, "DQTEa", "OQTEa", "T1QTEa")
			}
		else if (alpha==1 & beta==-1) {
			test_eqDD(QF0, QG0, SF0, SG0, QG1, QF1, SG1, SF1, nG, nF, nFG, q, RG, "DQTEa", "OQTEa", "T1QTEa")
			}
		else if (alpha==-1 & beta==1) {
			test_eqDD(QG0, QF0, SG0, SF0, QF1, QG1, SF1, SG1, nG, nF, nFG, q, RG, "DQTEa", "OQTEa", "T1QTEa")
			}
		else {
			test_eqDD(QG0, QF0, SG0, SF0, QG1, QF1, SG1, SF1, nG, nF, nFG, q, RG, "DQTEa", "OQTEa", "T1QTEa")
			}
		n = 2*nFG
		Tstat[1,1] = st_matrix("T1QTEa")
		Pvalue[1,1] = 1- chi2(q,Tstat[1,1])

		test(st_matrix("OQTEa"), st_matrix("DQTEa"), n, "T2QTEa")
		Tstat[1,2] = st_matrix("T2QTEa")
		pvalue(st_matrix("OQTEa"),Tstat[1,2])
		Pvalue[1,2] = st_matrix("pvalue")

		Tstat[1,3] = .
		Pvalue[1,3] = .
		}
	st_matrix(TstatEZOP, Tstat)
	st_matrix(PvalueEZOP, Pvalue)
	}
void ezOP2(real matrix QF, real matrix QG, real matrix SF, real matrix SG, real scalar nF, real scalar nG, real scalar nFG, real scalar q, string scalar TstatAlpha, string scalar PvalueAlpha)
	{
	real matrix R, RG, D21, D0, O2, O0, T1, T2, pvalue, D1, O1, S0, S1, DFG1, DFG0, Gap, O01, Tstat, Pvalue, T11, T10, T20, T21, AlfaBeta
	real scalar nFG0, nFG1
	Tstat = J(1,3,.)
	Pvalue = J(1,3,.)
	R = (I(q), -I(q))
	RG = (R, -R)
	test_eq(QF, QG, SF, SG, nF, nG, nFG, q, R, "D0", "O0", "T10")
	Tstat[1,1] = st_matrix("T10")
	Pvalue[1,1] = 1- chi2(q,Tstat[1,1])

	test(st_matrix("O0"), st_matrix("D0"), nFG, "T20")
	Tstat[1,2] = st_matrix("T20")
	pvalue(st_matrix("O0"),Tstat[1,2])
	Pvalue[1,2] = st_matrix("pvalue")

	test_eq(QG, QF, SG, SF, nG, nF, nFG, q, R, "D1", "O1", "T11")
	test(st_matrix("O1"), st_matrix("D1"), nFG, "T21")
	Tstat[1,3] = st_matrix("T21")
	pvalue(st_matrix("O1"),Tstat[1,3])
	Pvalue[1,3] = st_matrix("pvalue")
	st_matrix(TstatAlpha, Tstat)
	st_matrix(PvalueAlpha, Pvalue)
}

void test_eq(real matrix mQv2, real matrix mQv1, real matrix Ov2, real matrix Ov1, real scalar ra, real scalar rb, real scalar rt, real scalar a, real matrix R, string scalar D21s, string scalar  Os, string scalar T1s)
	{
	real matrix  O1, O2, T1, O1v2, O1v1, Ov2r, Ov1r, T1v2, T1v1, O
	real vector D21
	D21 = mQv2 - mQv1
	O1 = ( (rt/ra*Ov2), J(a,a,0) \ J(a,a,0) , (rt/rb*Ov1) )
	O = R*(O1)*(R')
	T1 = rt*(D21')*invsym(O)*D21
	if (T1[1,1]<0) 
		{
		O1v2 = ( (rt/ra*Ov2), J(a,a,0) \ J(a,a,0) , (rt/ra*Ov2) )
		O1v1 = ( (rt/rb*Ov1), J(a,a,0) \ J(a,a,0) , (rt/rb*Ov1) )
		Ov2r = R*(O1v2)*(R')
		Ov1r = R*(O1v1)*(R')
		T1v2 = rt*(D21')*invsym(Ov2r)*D21
		T1v1 = rt*(D21')*invsym(Ov1r)*D21
		if (T1v2[1,1]>=T1v1[1,1]) 
			{
			T1[1,1]=T1v2[1,1]
			O2 = Ov2r
			}
		else 
			{
			T1[1,1]=T1v1[1,1]
			O2 = Ov1r
			}
		}
	else 
		{
		T1[1,1]=T1[1,1]
		O2 = O
		}
	st_matrix(T1s, T1)
	st_matrix(D21s, D21)
	st_matrix(Os, O2)
	}
void test_eqDD(real matrix Qa, real matrix Qb, real matrix Sa, real matrix Sb, real matrix Qc, real matrix Qd, real matrix Sc, real matrix Sd, real scalar nF, real scalar nG, real scalar nFG, real scalar q, real matrix R, string scalar DD, string scalar  ODD, string scalar T1DD)
	{
	real matrix  O1, O2, O3, O, T1
	real vector Lambda, Gamma
	Lambda = Qa \ Qb \ Qc \ Qd
	Gamma = R*Lambda
	O1 = ( ((2*nFG/nF)*Sa), J(q,q,0) \ J(q,q,0) , ((2*nFG/nG)*Sb) )
	O2 = ( ((2*nFG/nF)*Sc), J(q,q,0) \ J(q,q,0) , ((2*nFG/nG)*Sd) )
	O3 = ( O1, J(2*q,2*q,0) \ J(2*q,2*q,0) , O2 )
	O = R*(O3)*(R')
	T1 = 2*nFG*(Gamma')*invsym(O)*Gamma
	st_matrix(T1DD, T1)
	st_matrix(DD, Gamma)
	st_matrix(ODD, O)
	}
void eval(todo, real vector p, d, V, v, g , H)
	{
	real rowvector q
	q = exp(log(p))
	transmorphic S
	v = ((d - q')')*(invsym(V))*(d - q')
	}
void test(real matrix V, real vector d, real scalar n, string scalar T2s)
	{
	real vector sm
	real vector ev
	transmorphic S
	real scalar i, opt
	real vector p
	real matrix T2
	ev = J(1,rows(d),.)
	for (i=1; i<=rows(d); i++)
		{
		if (d[i]>=0) ev[i]=d[i]+.1
		else ev[i]=.1
		}
	S = optimize_init()
	optimize_init_which(S, "min")
	optimize_init_evaluator(S, &eval())
	optimize_init_params(S, ev)
	optimize_init_argument(S, 1, d)
	optimize_init_argument(S, 2, V)
	optimize_evaluate(S)
	opt = _optimize(S)
	opt
	if (opt==0) {
		p = optimize_result_params(S)
		p = p'
	}
	else {
	p = J(rows(d),1,.)
	for (i=1; i<=rows(d); i++)
		{
		if (d[i]>=0) p[i]=d[i]
		else p[i]=0
		}
	}
	T2 = n*((d - p)')*(invsym(V))*(d - p)
	st_matrix(T2s, T2)
	}
void pvalue(real matrix O, real matrix T2)
	{
	real matrix  s, w, p, pvalue, W 
	real scalar i, j, h, n
	n = 10000
	W = invnormal(uniform(n,cols(O)))*cholesky(O)
	for (i=1; i<=n; i++)
		{
		for (j=1; j<=cols(O); j++)
			{
			if (W[i,j]<=0) W[i,j]=0
			else W[i,j]=1
			}
		 }
	s = rowsum(W)
	w = J(rows(s),cols(O)+1,.)
	for (h = 0;h<=cols(O);h++)
		{
		for (i=1; i<=n; i++)
			{
			if (s[i,1]==h) w[i,cols(O)+1-h] = 1
			else w[i,cols(O)+1-h] = 0
			}
		}
	w = colsum(w)/n
	p = J(cols(O)+1,1,.)
	p[1,1] = 0
	for (h = 1;h<=cols(O);h++)
		{
		p[h+1,1] = 1 - chi2(h, T2)
		}
	pvalue = w*p
	st_matrix("pvalue", pvalue)
	}
Kobbe1 = (	.455,1.642,2.706,3.841,5.412,6.635,9.5\
			2.09,3.808,5.138,6.483,8.273,9.634,12.81\
			3.475,5.528,7.045,8.542,10.501,11.971,15.357\
			4.776,7.094,8.761,10.384,12.483,14.045,17.612\
			6.031,8.574,10.371,12.103,14.325,15.968,19.696\
			7.257,9.998,11.911,13.742,16.074,17.791,21.666\
			8.461,11.383,13.401,15.321,17.755,19.54,23.551\
			9.648,12.737,14.853,16.856,19.384,21.232,25.37\
			10.823,14.067,16.274,18.354,20.972,22.879,27.133\
			11.987,15.377,17.67,19.824,22.525,24.488,28.856)
Kobbe2 = (	13.142,16.67,19.045,21.268,24.049,26.065,30.542\
			14.289,17.949,20.41,22.691,25.549,27.616,32.196\
			15.43,19.216,21.742,24.096,27.026,29.143,33.823\
			16.566,20.472,23.069,25.484,28.485,30.649,35.425\
			17.696,21.718,24.384,26.856,29.927,32.136,37.005\
			18.824,22.956,25.689,28.219,31.353,33.607,38.566\
			19.943,24.186,26.983,29.569,32.766,35.063,40.109\
			21.06,25.409,28.268,30.908,34.167,36.505,41.636\
			22.174,26.625,29.545,32.237,35.556,37.935,43.148\
			23.285,27.835,30.814,33.557,36.935,39.353,44.646)
Kobbe3 = (	24.394,29.04,32.077,34.869,38.304,40.761,46.133\
			25.499,30.24,33.333,36.173,39.664,42.158,47.607\
			26.602,31.436,34.583,37.47,41.016,43.547,49.071\
			27.703,32.627,35.827,38.761,42.36,44.927,50.524\
			28.801,33.813,37.066,40.045,43.696,46.299,51.986\
			29.898,34.996,38.301,41.324,45.026,47.663,53.403\
			30.992,36.176,39.531,42.597,46.349,49.02,54.83\
			32.085,37.352,40.756,43.865,47.667,50.371,56.248\
			33.176,38.524,41.977,45.128,48.978,51.715,57.66\
			34.266,39.694,43.194,46.387,50.284,53.054,59.064)
Kobbe4 = (  35.354,40.861,44.408,47.641,51.585,54.386,60.461\
			36.44,42.025,45.618,48.891,52.881,55.713,61.852\
			37.525,43.186,46.825,50.137,54.172,57.035,63.237\
			38.609,44.345,48.029,51.379,55.459,58.352,64.616\
			39.691,45.501,49.229,52.618,56.742,59.665,65.989\
			40.773,46.655,50.427,53.853,58.02,60.973,67.357\
			41.853,47.808,51.622,55.085,59.295,62.276,68.72\
			42.932,48.957,52.814,56.313,60.566,63.576,70.078\
			44.01,50.105,54.003,57.539,61.833,64.871,71.432\
			45.087,51.251,55.19,58.762,63.097,66.163,72.78)
Kobbe = (Kobbe1\Kobbe2\Kobbe3\Kobbe4)
void kp(real scalar df, real matrix Kobbe)
	{
	if (df<=40) st_matrix("UB", Kobbe[df,.])
	else st_matrix("UB", Kobbe[40,.])
	}
end
