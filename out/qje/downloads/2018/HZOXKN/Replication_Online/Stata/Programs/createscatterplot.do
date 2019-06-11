// Note: Install the binscatter command using
//       ssc install binscatter
	clear
	clear mata
	set memory 700m
	set more off, perm

	local dirworking  "../IntermediateFiles/"
	local diroutput   "../Output/"


use `dirworking'master_path, clear

local whereIstarted `c(pwd)'
cd "`diroutput'"
*DRY2 DRY3 DRY5 DRY10 Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 
reg DRY5 path_intra_wide if FOMCused==1, r
scatter DRY5 path_intra_wide if FOMCused==1
outsheet DRY5 path_intra_wide if FOMCused==1 using scatter_DRY5, replace

binscatter  DRY5 path_intra_wide if FOMCused==1, nquantiles(50) savedata(binscatter50_DRY5) replace reportreg
binscatter  DRY5 path_intra_wide if FOMCused==1, nquantiles(20) savedata(binscatter20_DRY5) replace
cd "`whereIstarted'"
