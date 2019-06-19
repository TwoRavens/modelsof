****version for trainingstock

capture program drop acf_trainingbootstrap
program define acf_trainingbootstrap, rclass
	syntax , exog(varlist)
	
	************************Ackerberg - Caves - Frazier************

	
	tempvar av_hat phi_hat phihat_lag tag sample
	quietly: xi: reg av $polynomial ydum* ndum* 
	predict `av_hat' , xb

	***********making data for second step

	gen `phi_hat' = `av_hat'  
	sort idnumber year
	bysort idnumber: gen `phihat_lag' = `phi_hat'[_n-1] if year == year[_n-1] +1

	gen `tag'  = missing(`phihat_lag', k , k_lag, l, av, m, stockl25pimshare , stockl25pimshare_lag) 
	


	****GMM

	gen `sample' = missing(`phi_hat', `phihat_lag', k, l, av, l_lag, k_lag, stockl25pimshare , stockl25pimshare_lag )
	replace `sample' = 1 - `sample'
	quietly: reg av l k stockl25pimshare ydum* ndum* if `sample' , cluster(mark)
	esttab , keep(l k stockl25pimshare) r2 se
	return scalar bk_olsm = _b[k]
	return scalar bl_olsm = _b[l]
	return scalar btrainl_olsm = _b[stockl25pimshare]
	return scalar obsOLS = e(N)
	return scalar clustOLS = e(N_clust)
	scalar initl = _b[l]			//storing parameters for later use as initial values
	scalar initk = _b[k]
	scalar inittrainl = _b[stockl25pimshare]

	mata: acftrain1(("`exog'"), "`phi_hat'" , "`phihat_lag'", "k_lag" , "l_lag", "stockl25pimshare_lag", "`sample'")
	return scalar bl_acfGMMfix = paramfix[1,1]
	return scalar bk_acfGMMfix = paramfix[1,2]
	return scalar btrain_acfGMMfix = paramfix[1,3]
	return scalar obsGMM = scalar(obsGMM)
	return scalar converged = scalar(converge)
	return scalar iter = scalar(iterations)
	scalar bl_acfGMMfix = paramfix[1,1]
	scalar bk_acfGMMfix = paramfix[1,2]
	scalar btrain_acfGMMfix = paramfix[1,3]
	
	****wage regression*******

	tempvar cl w tfp
	gen `tfp' = av - bl_acfGMMfix*l - bk_acfGMMfix*k - btrain_acfGMMfix*stockl25pimshare
	gen `w' = ln(wage)
	gen `cl' = ln((tangibleassetstheur/capitaldefl)/avemplfte)
	label var `cl' "caplab"
	label var `w' "wage"
	label var `tfp' "tfp"
	quietly reg `w' stockl25pimshare ydum* ndum* if `sample', cluster(mark)
	esttab  , drop(ndum* ydum*) se r2 scalars(N_clust) label
	return scalar btr_wagebase = _b[stockl25pimshare]
	quietly: reg `w' stockl25pimshare `cl' `tfp' ydum* ndum* if `sample', cluster(mark)
	esttab  , drop(ndum* ydum*) se r2 scalars(N_clust) label
	return scalar btr_wageaug = _b[stockl25pimshare]
	return scalar bcl_wageaug = _b[`cl']
	return scalar btfp_wageaug = _b[`tfp']
end

mata
mata clear
	void acftrain1(string vector exog, string scalar phi_hat, string scalar phihat_lag, string scalar k_lag, string scalar l_lag, string scalar stockl25pimshare_lag, string scalar sample)
		{
		external m_phihat, m_phihatlag, m_k, m_l, m_klag, m_llag, cons, m_stockl25pimshare, m_stockl25pimsharelag, instr, min
		m_phihat = st_data(.,phi_hat,sample)			//copying data from stata in mata
		m_phihatlag = st_data(.,phihat_lag,sample)
		m_k = st_data(.,("k"),sample)
		m_l = st_data(.,("l"),sample)
		m_stockl25pimshare = st_data(., ("stockl25pimshare"),sample)
		m_klag = st_data(.,k_lag,sample)
		m_llag = st_data(.,l_lag,sample)
		m_stockl25pimsharelag = st_data(., stockl25pimshare_lag,sample)
		st_numscalar("obsGMM", rows(m_llag))
		cons = J(rows(m_phihat),1,1)
		instr = st_data(.,tokens(exog), sample)

		init=(st_numscalar("initl"), st_numscalar("initk"), st_numscalar("inittrainl"))	
									//initial values for b_l and b_k and b_stockl25pimshare
		S=optimize_init()					//creates name for optimization problem
		optimize_init_evaluator(S, &acf_gmmtrain1())	//names the function to optimize
		optimize_init_tracelevel(S, "none")
		optimize_init_which(S,"min")		//minimize, not maximize
		optimize_init_evaluatortype(S,"v0")	//we don't calculate Hessian or gradient
		optimize_init_params(S,init)		//fills in initial values
		optimize_init_conv_maxiter(S,500)		//maximum 500 iterations
		p=optimize(S)					//optimization and puts results in vector p
	
		
		"LABOR FIXED INPUT ACF GMM"
		"NACE `i'"
		"Coefficients"
		p
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
		external m_phihat, m_phihatlag, m_k, m_l, m_klag, m_llag, m_stockl25pimshare, m_stockl25pimsharelag, cons , instr, min
		inputs = (m_l,m_k, m_stockl25pimshare)
		inputslag = (m_llag, m_klag, m_stockl25pimsharelag)

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
		

