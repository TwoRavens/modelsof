xtset

xtreg dcount llnfiftykm llnelswhere lnmogviowfp ldcount count1 std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, fe robust 
outreg using "F:\results\count", 3aster bdec(3) coefastr addstat(R-sq overall,e(r2_o), R-sq within,e(r2_w), R-sq between,e(r2_b)) se replace

xtreg dcount llnfiftykm llnelswhere lnmogviowfp wfp ldcount count1 std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, re robust 
outreg using "F:\results\count", 3aster bdec(3) coefastr addstat(R-sq overall,e(r2_o), R-sq within,e(r2_w), R-sq between,e(r2_b)) se append

xtreg dcount  llnfiftykm llnelswhere lnmogviowfp ldcountcal std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, fe robust 
outreg using "F:\results\count", 3aster bdec(3) coefastr addstat(R-sq overall,e(r2_o), R-sq within,e(r2_w), R-sq between,e(r2_b)) se append

xtabond dcount llnfiftykm llnelswhere lnmogviowfp count1 std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, vce(robust) 
outreg using "F:\results\count", 3aster bdec(3) coefastr addstat(number of observations,e(N), model chi-squared statistic,  e(chi2), sum of squared differenced residuals, e(rss)) se append

xtabond dcount llnfiftykm llnelswhere lnmogviowfp std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, vce(robust) 
outreg using "F:\results\count", 3aster bdec(3) coefastr addstat(number of observations,e(N), model chi-squared statistic,  e(chi2), sum of squared differenced residuals, e(rss)) se append

