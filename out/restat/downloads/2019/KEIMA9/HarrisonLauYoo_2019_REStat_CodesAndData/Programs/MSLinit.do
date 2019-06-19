// MPMSL_init is a program to initialize estimation settings for MPMSL codes
//
// Required options
// 	id(.):   name of subject ID variable
//	nrep(.): number of Halton draws to make per subject
//	burn(.): number of initial Halton draws to burn per subject 
//	neq(.):  number of random parameters in the model 
//
// Generates the following Mata objects to be used by an MSL estimation code later (N = total number of observations in the data file, N_panel = total number of subjects)
//	id:     [N x 1]       vector of subject id variable 
//  nrep:   [1 x 1]       scalar measuring the number of Halton draws 
//  ERR`k': [N x nrep]    matrix of N(0,1) draws from a Halton sequence. ERR1, ERR2, ..., ERR`neq' i.e. one matrix per each random parameter.
//  idDV:   [N x N_panel] matrix of subject dummies

program define MSLinit, rclass
	syntax, id(varname) nrep(integer) burn(integer) neq(integer)    
	
	quietly {
		// make sure that the data set is sorted by subjects
		sort `id', stable

		//-----------------------------------------------------------------
		// BLOCK 1: All operations are carried out in the Mata environment.
		//-----------------------------------------------------------------
		// To carry out a big block of Mata operations within a Stata program, we must write that block out as a Mata function.
		// The reason is because both Stata program and Mata block require -end- command to close. 
		// If the Mata block were inserted here directly, Stata would mistake Mata's -end- for the program's own -end-.
		
		// id: [N x 1] vector of subject id variable. N is the total number of observations in the current data set.
		mata: st_view(id=.,.,st_local("id"))		
	
		// nrep, burn, and neq are [1 x 1] scalars
		mata: nrep = strtoreal(st_local("nrep"))	// number of Halton draws to make
		mata: burn = strtoreal(st_local("burn"))	// number of initial Halton draws to burn
		mata: neq  = strtoreal(st_local("neq"))	// number of random parameters in the model
		
		// generate [N x N_panel] matrix of subject dummies using "id" as input
		mata: idDV = idDV_generator(id)
		
		// generate [N x (neq*nrep)] matrix of N(0,1) using "id", "nrep", "burn" and "neq" as inputs
		mata: ERR = ERR_generator(id, nrep, burn, neq)
		
		//--------------------------------------------------------------------------------------
		// BLOCK 2: Operations are carried out in a combination of Stata and Mata environments.
		//--------------------------------------------------------------------------------------
		
		// Split out each successive set of nrep columns in [N x (neq*nrep)] matrix "ERR" into an [N x nrep] matrix: call them ERR1, ERR2, and so on.
		// We use the Stata enviroment's -forvalues- command to loop over matrix names; the Mata enviroment's -for- command does not allow us to loop over matrix names.  
		forvalues k = 1/`neq' {
			mata: ERR`k' = ERR[., ((`k'-1)*nrep + 1)..`k'*nrep]
			if (`k' <  `neq') local _matrices `_matrices' ERR`k', 
			if (`k' == `neq') local _matrices `_matrices' ERR`k'
		}
		
		// Delete Mata matrix ERR which is no longer needed 
		mata: mata drop ERR
		
		// Inform subjects of what MPMSL has done 
		noisily display as text "Sorted data by `id', using -sort `id', stable-"
		noisily display as text "Generated Mata scalar inputs for MSL: nrep = `nrep', burn = `burn'"
		noisily display as text "Generated Mata matrix inputs for MSL: id, idDV, `_matrices'"  
	}
end

// Mata functions to be called by MPMSL_init
mata:
function idDV_generator(transmorphic colvector id)
{  
	// panel:   [N_panel x 2] matrix. 
	// N_panel: [1 x 1] scalar that measures the number of subjects identifed by column vector "id". 
	//		column 1 of matrix "panel" reports the data row for the first observation on each subject. 
	//		column 2 of matrix "panel" reports the data row for the last observation on each subject.
	panel   = panelsetup(id,1)
	N_panel = panelstats(panel)[1]
	
	// initialise a [N x N_panel] matrix of 0s. we will replace column c with 1s in data rows corresponding to subject c. 
	// in the end, this matrix will look like a data set of subject dummies that equal 1 for particular subjects
	idDV = J(rows(id), N_panel, 0)
	
	// loop over subjects update matrix "ERR" and matrix "idDV"  
	for(n=1; n<=N_panel; n++) {	
		
		// N_n: [1 x 1] scalar that measures the number of observations on subject n
		N_n = 1 + (panel[n, 2] - panel[n, 1])
		
		// In matrix "idDV", replace column n with 1 in N_n rows corresponding to subject n: 
		//	resulting column n looks like a Stata dummy variable that equals 1 for observations on subject n and 0 otherwise
		idDV[panel[n,1]..panel[n,2], n] = J(N_n, 1, 1)
	}
	
	// output of this function is a [N x N_panel] matrix of subject dummies, idDV.
	return(idDV)
}
end

mata:
function ERR_generator(transmorphic colvector id, real scalar nrep, real scalar burn, real scalar neq)
{  
	// panel:   [N_panel x 2] matrix. 
	// N_panel: [1 x 1] scalar that measures the number of subjects identifed by column vector "id". 
	//		column 1 of matrix "panel" reports the data row for the first observation on each subject. 
	//		column 2 of matrix "panel" reports the data row for the last observation on each subject.
	panel   = panelsetup(id,1)
	N_panel = panelstats(panel)[1]
	
	// initialise a [N x (neq*nrep)] matrix of 0s. we will replace these 0s with N(0,1) draws based on Halton sequences.
	// the number of columns equals (neq*nrep) since when the model has "neq" random parameters, we make "nrep" draws of each random parameter.  
	ERR	= J(rows(id), (neq*nrep), 0)
	
	// loop over subjects update matrix "ERR" and matrix "idDV"  
	for(n=1; n<=N_panel; n++) {	
		
		// N_n: [1 x 1] scalar that measures the number of observations on subject n
		N_n = 1 + (panel[n, 2] - panel[n, 1])
		
		// ERR_n: [nrep x neq] matrix of N(0,1) draws from Halton sequences for subject n
		ERR_n = invnormal(halton(nrep,neq,(1+burn+nrep*(n-1))))
		
		// Vectorize ERR_n into a [1 x (neq*nrep)] row vector where the first set of nrep draws are for the first random coef, 
		// the second set of nrep draws are for the second random coef, and so on.
		ERR_n = vec(ERR_n)'
		
		// Expand ERR_n into a [N_n x (neq*nrep)] matrix by duplicating existing N(0,1) draws
		ERR_n = J(N_n, (neq*nrep), 1) :* ERR_n
		
		// In matrix "ERR", replace entire N_n rows corresponding to subject n with "ERR_n"
		ERR[panel[n,1]..panel[n,2], 1..(neq*nrep)] = ERR_n
	}
	
	// output of this function is a [N x (neq*nrep)] matrix of N(0,1) draws ERR
	return(ERR)
}
end

exit
