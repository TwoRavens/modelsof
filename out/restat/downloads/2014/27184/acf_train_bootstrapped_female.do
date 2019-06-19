*****program that will be bootstrapped for ACF method with split between male and female
***** workers


****after estimating productivity, the wage equation is estimated using as control variable tfp
****which was estimated in the value added function

capture program drop acf_trainingbootstrapfem
program define acf_trainingbootstrapfem, rclass
	syntax , exog(varlist)
	
	************************Ackerberg - Caves - Frazier************

	
	tempvar av_hat phi_hat phihat_lag tag sample
	quietly: xi: reg av $polynomial ydum* ndum* 
	predict `av_hat' , xb

	***********making data for second step

	gen `phi_hat' = `av_hat'  
	sort idnumber year
	bysort idnumber: gen `phihat_lag' = `phi_hat'[_n-1] if year == year[_n-1] +1



	****GMM

	gen `sample' = missing(`phi_hat', `phihat_lag', k, l, av, l_lag, k_lag, femsh, femsh_lag, trainlshare,trainlshare_lag )
	replace `sample' = 1 - `sample'
	quietly: reg av l k trainlshare femsh ydum* ndum* if `sample' , cluster(mark)
	esttab , drop(ndum* ydum*) r2 se
	return scalar bk_olsm = _b[k]
	return scalar bl_olsm = _b[l]
	return scalar bfem_olsm = _b[femsh]
	return scalar btr_olsm = _b[trainlshare]
	return scalar obsOLS = e(N)
	return scalar clustOLS = e(N_clust)
	scalar initl = _b[l]			//storing parameters for later use as initial values
	scalar initk = _b[k]
	scalar initfem = _b[femsh]
	scalar inittrainl = _b[trainlshare]

	mata: acftrain1(("`exog'"), "`phi_hat'" , "`phihat_lag'", "k_lag" , "l_lag", "trainlshare", "trainlshare_lag", "femsh", "femsh_lag", "`sample'")
	return scalar bl_acfGMMfix = paramfix[1,1]
	return scalar bk_acfGMMfix = paramfix[1,2]
	return scalar btr_acfGMMfix = paramfix[1,3]
	return scalar bfem_acfGMMfix = paramfix[1,4]
	return scalar obsGMM = scalar(obsGMM)
	return scalar converged = scalar(converge)
	return scalar iter = scalar(iterations)
	scalar bl_acfGMMfix = paramfix[1,1]
	scalar bk_acfGMMfix = paramfix[1,2]
	scalar btr_acfGMMfix = paramfix[1,3]
	scalar bfem_acfGMMfix = paramfix[1,4]	

	****wage regression*******

	tempvar cl w tfp
	gen `tfp' = av - bl_acfGMMfix*l - bk_acfGMMfix*k - btr_acfGMMfix*trainlshare - bfem_acfGMMfix*femsh 
	gen `w' = ln(wage)
	gen `cl' = ln((tangibleassetstheur/capitaldefl)/avemplfte)
	label var `cl' "caplab"
	label var `w' "wage"
	label var `tfp' "tfp"
	quietly reg `w' trainlshare femsh ydum* ndum* if `sample', cluster(mark)
	esttab  , drop(ndum* ydum*) se r2 scalars(N_clust) label
	return scalar btr_wagebase = _b[trainlshare]
	return scalar bfem_wagebase = _b[femsh]
	quietly: reg `w' trainlshare femsh `cl' `tfp' ydum* ndum* if `sample', cluster(mark)
	esttab  , drop(ndum* ydum*) se r2 scalars(N_clust) label
	return scalar btr_wageaug = _b[trainlshare]
	return scalar bfem_wageaug = _b[femsh]
	return scalar bcl_wageaug = _b[`cl']
	return scalar btfp_wageaug = _b[`tfp']
end

mata
mata clear
	void acftrain1(string vector exog, string scalar phi_hat, string scalar phihat_lag, string scalar k_lag, string scalar l_lag, string scalar trainlshare, string scalar trainlshare_lag, string scalar femsh, string scalar femsh_lag, string scalar sample)
		{
		external m_phihat, m_phihatlag, m_k, m_l, m_klag, m_llag, cons, m_trainlshare, m_trainlsharelag, m_femsh, m_femshlag, instr, min
		m_phihat = st_data(.,phi_hat,sample)			//copying data from stata in mata
		m_phihatlag = st_data(.,phihat_lag,sample)
		m_k = st_data(.,("k"),sample)
		m_l = st_data(.,("l"),sample)
		m_trainlshare = st_data(., trainlshare,sample)
		m_femsh = st_data(., femsh, sample)
		m_klag = st_data(.,k_lag,sample)
		m_llag = st_data(.,l_lag,sample)
		m_trainlsharelag = st_data(., trainlshare_lag,sample)
		m_femshlag = st_data(., femsh_lag, sample)
		st_numscalar("obsGMM", rows(m_llag))
		cons = J(rows(m_phihat),1,1)
		instr = st_data(.,tokens(exog), sample)

		init=(st_numscalar("initl"), st_numscalar("initk"), st_numscalar("inittrainl"), st_numscalar("initfem"))	
									//initial values for b_l and b_k, b_trainlshare, b_femsh
		S=optimize_init()					//creates name for optimization problem
		optimize_init_evaluator(S, &acf_gmmtrain1())	//names the function to optimize
		optimize_init_tracelevel(S, "none")
		optimize_init_which(S,"min")		//minimize, not maximize
		optimize_init_evaluatortype(S,"v0")	//we don't calculate Hessian or gradient
		optimize_init_params(S,init)		//fills in initial values
		optimize_init_conv_maxiter(S,500)		//maximum 500 iterations
		p=optimize(S)					//optimization and puts results in vector p
	
		
		"LABOR FIXED INPUT ACF GMM"		// here we print results on screen
		"NACE `i'"
		"Coefficients"
		names = ("l" , "k", "trainlshare", "femsh")
		coeff = strofreal(p, "%9.4g")
		names\coeff
		
		"Converged?"
		optimize_result_converged(S)
		st_numscalar("converge", optimize_result_converged(S))
		st_numscalar("iterations", optimize_result_iterations(S))
		"Iterations"
		optimize_result_iterations(S)
		"Last Iterations"
		optimize_result_iterationlog(S)
		st_matrix("paramfix", p)
		st_matrix("min", min)	
		}


	void acf_gmmtrain1(todo,beta,critxi,g,H) 
		{
		external m_phihat, m_phihatlag, m_k, m_l, m_klag, m_llag, cons, m_trainlshare, m_trainlsharelag, m_femsh, m_femshlag, instr, min
		inputs = (m_l,m_k, m_trainlshare, m_femsh)
		inputslag = (m_llag, m_klag, m_trainlsharelag, m_femshlag)

		m_omega = m_phihat - inputs*beta'				//computing estimates for productivity
		m_omegalag = m_phihatlag - inputslag*beta'
		m_omegalag2 = m_omegalag:*m_omegalag			//making polynomial
		m_omegalag3 = m_omegalag2:*m_omegalag
		m_omegalag4 = m_omegalag3:*m_omegalag

		X = (cons, m_omegalag , m_omegalag2, m_omegalag3, m_omegalag4)
		bpoly = (invsym(X'*X))*X'*m_omega
		xi = m_omega - X*bpoly
		W = invsym(instr'*instr)
		critxi=(instr'*xi)'*W*(instr'*xi)
		min = instr'*xi
		}


end
