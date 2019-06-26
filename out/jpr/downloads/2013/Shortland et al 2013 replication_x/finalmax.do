xtset

xtreg dmax llnfiftykm llnelswhere lnmogviowfp ldmax count1 std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, fe robust 
outreg using "F:\results\max", 3aster bdec(3) coefastr addstat(R-sq overall,e(r2_o), R-sq within,e(r2_w), R-sq between,e(r2_b)) se replace

xtreg dmax  llnfiftykm llnelswhere lnmogviowfp wfp ldmax count1 std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, re robust 
outreg using "F:\results\max", 3aster bdec(3) coefastr addstat(R-sq overall,e(r2_o), R-sq within,e(r2_w), R-sq between,e(r2_b)) se append

xtabond dmax  llnfiftykm llnelswhere lnmogviowfp count1 std faofo posdev negdev highrain df12f14 df14f15 df15f16 if  mogadishu<1, vce(robust) 
estat sargan
outreg using "F:\results\max", 3aster bdec(3) coefastr addstat(number of observations,e(N), model chi-squared statistic,  e(chi2), sum of squared differenced residuals, e(rss)) se append

xtreg dmaxcal   llnfiftykm llnelswhere lnmogviowfp ldmaxcal countcal stdcal faofo posdev negdev highrain if  mogadishu<1, fe robust 
outreg using "F:\results\max", 3aster bdec(3) coefastr addstat(R-sq overall,e(r2_o), R-sq within,e(r2_w), R-sq between,e(r2_b)) se append

xtabond dmaxcal llnfiftykm llnelswhere lnmogviowfp countcal stdcal faofo posdev negdev highrain if  mogadishu<1, vce(robust) 
outreg using "F:\results\max", 3aster bdec(3) coefastr addstat(number of observations,e(N), model chi-squared statistic,  e(chi2), sum of squared differenced residuals, e(rss)) se append

