cd "C:\Users\md598\Dropbox\xun_dialysis\files to restat\replication"
clear all
use mainsample.dta

set more off

/*** repeat stage 1 and stage 2 using 300 bootstrap sample to construct standard error ***/
// poisson regression as stage 1
glm Cfmc lpop lpop2-lpop4 black* white* latino* asian* pop22to44* pop45to64* pop65andover* nephrologist* lbed* hosprn* pre_rate* conreg NE MW West fmcdist* davdist*, ro family(poisson) diff iter(30)
*matrix poly_fmc=e(b)'
predict tri_Cfmc_hat
glm Cdav lpop lpop2-lpop4 black* white* latino* asian* pop22to44* pop45to64* pop65andover* nephrologist* lbed* hosprn* pre_rate* conreg NE MW West fmcdist* davdist*, ro family(poisson) diff iter(30)
*matrix poly_dav=e(b)'
predict tri_Cdav_hat
glm Cother lpop lpop2-lpop4 black* white* latino* asian* pop22to44* pop45to64* pop65andover* nephrologist* lbed* hosprn* pre_rate* conreg NE MW West fmcdist* davdist*, ro family(poisson) diff iter(30)
*matrix poly_other=e(b)'
predict tri_Cother_hat

// tobit stage 2
tobit Cfmc tri_Cdav_hat tri_Cother_hat lpop black white latino asian pop22to44 pop45to64 pop65andover nephrologist_hsa lbed hosprn_hsa pre_rate conreg NE MW West fmcdist fmcdist2 davdist davdist2,ll
matrix est_fmc=e(b)'
tobit Cdav tri_Cfmc_hat tri_Cother_hat lpop black white latino asian pop22to44 pop45to64 pop65andover nephrologist_hsa lbed hosprn_hsa pre_rate conreg NE MW West fmcdist fmcdist2 davdist davdist2,ll
matrix est_dav=e(b)'
tobit Cother tri_Cfmc_hat tri_Cdav_hat lpop black white latino asian pop22to44 pop45to64 pop65andover nephrologist_hsa lbed hosprn_hsa pre_rate conreg NE MW West fmcdist fmcdist2 davdist davdist2,ll
matrix est_other=e(b)'
