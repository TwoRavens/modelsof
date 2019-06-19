#delimit ;

/* this is an amended version of the file provided by Cameron Gelbach and Miller (CR23_IK_CSS.do)
the file has been adapted in the following ways: 
1) include a command in the syntax indicating the cluster variable
2) modifying the "noconstant" option to be just the string "noconstant"
3) including an option "bound" which caluclates the effective number of clusters setting the residuals to 1 (the lower bound)
4) sampling only 100000 observations in large data sets (program freezes computer if data is too large)
*/

/* this file implements the Carter-Schnepel-Steigerwald calculations.
 it is implemented as program, which needs to be loaded by running the .do file */

cap prog drop effclusters_CSS ;
prog def effclusters_CSS , rclass ;
syntax, key_rhs(varlist) CLustvar(varlist) [noconstant]  ;

preserve ;
qui keep if e(sample)==1 ;
if _N>100000{ ;
display "Note: calculation based on a random sample of 100,000 obs (same proportion of obs in each group)" ;
local prop  = 100000/_N  ;
qui sample `prop', by(`clustvar') ;
} ;

cap drop resid ;
predict resid, resid ;
/*
if "`bound'"!="" { ;
replace resid=1 ;
} ;

if "`simulation'"!="" { ;
replace resid=e ;
} ;
*/

tempname betavec V noomit ;
matrix `betavec' = e(b) ;
local lhs=e(depvar) ;



foreach r in  effclusters_CSS effclusters_CSS_BOUND { ;
	local `r' = . ; 
} ;

local nc=0 ;
if "`constant'"!="" {;
local nc=1;
};



mata: cr2cr3("`betavec'","`clustvar'","resid","`key_rhs'",`nc') ;

qui sum `clustvar';
return scalar G=r(max) ;


foreach r in  effclusters_CSS effclusters_CSS_BOUND { ;
	return scalar `r' = `r' ;
} ;


display "Cluster variable: `clustvar'" ;
display "Total number of `clustvar' clusters, G="%4.0f numclusters ;
display "Effective number of `clustvar' clusters (residual based) for `key_rhs'=" effclusters_CSS ;
display "Effective number of `clustvar' clusters (lower bound) for `key_rhs'=" effclusters_CSS_BOUND ;


restore ;


end ;


mata ;

mata drop cr2cr3()

void cr2cr3(betapointer,clusterid,residuals,key_rhs,noconstant) {

RHSvarnames = (st_matrixcolstripe(betapointer)[.,2])'

st_view(cluid=., .,tokens(clusterid)) 
st_view(resid=., .,tokens(residuals)) 


if (noconstant ~= 1) { 
st_view(X=., .,RHSvarnames[1,1..cols(RHSvarnames)-1]) 
X = (X,J(rows(X),1,1))				// add a constant
} 

if (noconstant == 1) { 
st_view(X=., .,RHSvarnames[1,1..cols(RHSvarnames)]) 
} 


// create a cluster-list, and determine the number of clusters 
clusteridlist = uniqrows(cluid)
numclusters = rows(clusteridlist)
cluster_index = J(rows(clusteridlist),2,0)
numobs = rows(X) 
ones = J(numobs,1,1)

obsid = runningsum(J(numobs,1,1))		// internal id for each dyadic observation

// take the X matrix, sort by cluster id.  Keep the original obsid, for sorting back later if needed
sorted = sort((obsid,cluid,resid,X),2)

newX = sorted[|1,4 \ .,.|]
newresid = sorted[|1,3 \ .,3|]

XpX = newX' * newX 
XpXinv = invsym(XpX) 

k = rows(XpX) 

// identify which column of the X matrix contains the key RHS variable
findKeyrhs = RHSvarnames :== key_rhs
keyRHScol = select(1::k,findKeyrhs')


 

i_g = 1 
while(i_g<=numclusters) { 
	vec_this_cluid = ones*clusteridlist[i_g]  // clusteridlist[i] gives the cluster id we are considering.
	
	// build an index for each cluster, where does it start and where does it end,
	// 		in terms of the obsid in newX (which is sorted on cluid).  save this next to clusteridlist
	match_id =  (sorted[.,2] :== vec_this_cluid)
	obsrange = select(obsid,match_id) 
	min_g = min(obsrange)
	max_g = max(obsrange)
	cluster_index[i_g,.] = (min_g,max_g)
	

	i_g++ 
} 



/* Compute the random effects parameters for within-group and individual error covariances */
running_sum = 0 
num_elements = 0 

i_g = 1 
while(i_g<=numclusters) { 
	
	min_g = cluster_index[i_g,1]
	max_g = cluster_index[i_g,2]
	resid_g = newresid[min_g..max_g,.]
	n_g = max_g - min_g + 1
	
	addon_sum = sum(resid_g * resid_g') - resid_g' * resid_g
	addon_elements = n_g * (n_g - 1)
	running_sum = running_sum + addon_sum
	num_elements = num_elements + addon_elements
		
i_g++ 
} 

group_covar = running_sum / num_elements 

s2 = newresid' * newresid / (numobs-1)
indiv_var = s2 - group_covar

// CSS step 1 - create a set of gamma_g's.  Here we set up the vector to store them in.
gammas_collection = J(numclusters,1,0)
gammas_collectionB = J(numclusters,1,0)

i_g = 1 
while(i_g<=numclusters) { 

	min_g = cluster_index[i_g,1]
	max_g = cluster_index[i_g,2]
	n_g = max_g - min_g + 1
	
	OM_hat = J(n_g,n_g,group_covar) + ( I(n_g) * indiv_var)


	// CSS step 1
	X_g = newX[min_g..max_g,.] // takes newX, extracts match_id rows
	gamma_g_mat = XpXinv * X_g' * OM_hat * X_g * XpXinv 
	gamma_g = gamma_g_mat[keyRHScol,keyRHScol]
	gammas_collection[i_g,1] = gamma_g
	
i_g++ 
}


i_g = 1 
while(i_g<=numclusters) { 

	min_g = cluster_index[i_g,1]
	max_g = cluster_index[i_g,2]
	n_g = max_g - min_g + 1
	
	OM_hatB = J(n_g,n_g,1)


	// CSS step 1
	X_g = newX[min_g..max_g,.] // takes newX, extracts match_id rows
	gamma_g_matB = XpXinv * X_g' * OM_hatB * X_g * XpXinv 
	gamma_gB = gamma_g_matB[keyRHScol,keyRHScol]
	gammas_collectionB[i_g,1] = gamma_gB
	
i_g++ 
}



/* Carter, Schnepel, and Steigerwald (2103) Effective number of clusters */
/*
CSS Step 1: create a set of gamma-g's.  These come from:

gamma_g = the kxk element of:  xpx_inv * X_g' * OM_g * X_g * xpx_inv

CSS Step 2:  make gamma-bar as average of gamma_g's.

CSS Step 3:  GAMMA = (1/G) sum((gamma_g - gamma-bar)^2) / (gamma-bar)^2
CSS Step 4:  Effective # clusters = G / (1+GAMMA)
*/

// CSS step 1 done above, stored in gammas_collection
// here are steps 2-4
gamma_bar = mean(gammas_collection)
gamma_dev_sq = (gammas_collection - J(numclusters,1,gamma_bar)) :* (gammas_collection - J(numclusters,1,gamma_bar))
avg_gam_dev_sq = mean(gamma_dev_sq)
GAMMA = avg_gam_dev_sq / ((gamma_bar)^2)
effclusters_CSS = numclusters / (1+GAMMA)

gamma_barB = mean(gammas_collectionB)
gamma_dev_sqB = (gammas_collectionB - J(numclusters,1,gamma_barB)) :* (gammas_collectionB - J(numclusters,1,gamma_barB))
avg_gam_dev_sqB = mean(gamma_dev_sqB)
GAMMAB = avg_gam_dev_sqB / ((gamma_barB)^2)
effclusters_CSS_BOUND = numclusters / (1+GAMMAB)

st_numscalar("effclusters_CSS",effclusters_CSS)
st_numscalar("effclusters_CSS_BOUND",effclusters_CSS_BOUND)
st_numscalar("numclusters",numclusters)

} 
end







