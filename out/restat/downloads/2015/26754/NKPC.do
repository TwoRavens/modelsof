//creates results in the log files: variables, NKPC_gmm, NKPC_gmm_robustness
clear all
use "\\isad.isadroot.ex.ac.uk\uoe\user\Submitted New Keynesian Model with Overtime Labor\Referee reports RESTAT\reports 2nd round\Files for RESTAT\Data.dta"

log using variables,replace

tsset date, quarterly

generate time_squared= time*time

generate real_GDP_percapita= real_GDP/pop_SA

generate N1_percapita_SA= N1_SA/ pop_SA

generate N2_percapita_SA= N2_SA/ pop_SA

drop real_GDP_percapita

generate real_GDP_percapita= (real_GDP/pop_SA)*(100/0.0559584)

generate logy= log(real_GDP_percapita)

hprescott  logy, stub(HP)

rename HP_logy_1 y

rename  HP_logy_sm_1 y_sm

regress logy time time_squared

generate logy_detrended= logy-.0031521*time-4.44e-06*time_squared-3.632234

generate p=log(GDP_deflator)

generate p_c=log(CPI_c)

generate w=log(comprnfb)

generate pi=(p- L.p)*4

generate pi_pc= (p_c-L.p_c)*4

generate longshort_spread= GS10-GS1

generate pi_w=(w-L.w)*4

generate log_labor_share=log(labor_share)

generate A= (real_GDP_percapita)/( (516*((N1_percapita_SA)^(1-0.33)) )+(overtimehours*((N2_percapita_SA)^(1-0.33)) ) )

generate  overtime_share= (comprnfb)/ (A*((N2_percapita_SA)^(-0.33))  )

drop overtime_share

generate  overtime_share= (comprnfb)/ (A*((N2_percapita_SA)^(-0.33))  )* (100/199.94846)

summarize real_GDP_percapita labor_share overtime_share in 123/238

generate log_overtime_share=log(overtime_share)

summarize log_overtime_share log_labor_share

generate ROLC= log_overtime_share-4.64084

generate  ROLC_1= L.ROLC

generate  ROLC_2= L.ROLC_1

generate  ROLC_3= L.ROLC_2

generate  ROLC_4= L.ROLC_3

generate RULC= log_labor_share-4.65282

generate  RULC_1= L.RULC

generate  RULC_2= L.RULC_1

generate  RULC_3= L.RULC_2

generate  RULC_4= L.RULC_3

summarize pi pi_pc longshort_spread pi_w

generate pi_hat= pi-.0331613

drop pi_pc pi_w longshort_spread

generate longshort_spread= (GS10-GS1)-.9090638

generate  pi_pc=  ((p_c-L.p_c)*4)-.0322211

generate  pi_w=  ((w-L.w)*4)-.0160929

generate     longshort_spread_1= L.longshort_spread

generate     longshort_spread_2= L.longshort_spread_1

generate     longshort_spread_3= L.longshort_spread_2

generate     longshort_spread_4= L.longshort_spread_3

generate   pi_w_1= L.pi_w

generate   pi_w_2= L.pi_w_1

generate   pi_w_3= L.pi_w_2

generate   pi_w_4= L.pi_w_3

generate   pi_pc_1= L.pi_pc

generate   pi_pc_2= L.pi_pc_1

generate   pi_pc_3= L.pi_pc_2

generate   pi_pc_4= L.pi_pc_3

generate    pi_hat_1= L.pi_hat

generate    pi_hat_2= L.pi_hat_1

generate    pi_hat_3= L.pi_hat_2

generate    pi_hat_4= L.pi_hat_3

generate    pi_hat_F1= F.pi_hat

generate   logy_detrended_1= L.logy_detrended

generate   logy_detrended_2= L.logy_detrended_1

generate   logy_detrended_3= L.logy_detrended_2

generate   logy_detrended_4= L.logy_detrended_3

generate inflation_growth= pi_hat- pi_hat_1

summarize y logy_detrended RULC ROLC N1_percapita_SA N2_percapita_SA overtimehours in 123/238

correlate ROLC  ROLC_1 pi_hat pi_hat_1 pi_hat_F1 y logy_detrended in 123/238

correlate RULC  RULC_1 pi_hat pi_hat_1 pi_hat_F1 y logy_detrended in 123/238

correlate  y L.y pi_hat pi_hat_1 pi_hat_F1 logy_detrended in 123/238

correlate   logy_detrended logy_detrended_1 pi_hat pi_hat_1 pi_hat_F1 y in 123/238

correlate ROLC RULC y logy_detrended inflation_growth F.inflation_growth in 123/238

twoway (line ROLC date, lpattern(dash)) (line RULC date, lpattern(dot)) (line y date) in 123/238

log close

log using NKPC_gmm,replace

ivregress gmm  pi_hat ( RULC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 RULC_3 RULC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

//notice that the bandwidth of Newey-West's kernel is equal to the number of lags+1

ivreg2  pi_hat ( RULC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 RULC_3 RULC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant robust gmm2s nofooter bw(8) first ffirst

ivregress gmm  pi_hat ( RULC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( RULC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(9) first ffirst

ivregress gmm  pi_hat ( ROLC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant robust gmm2s nofooter bw(10) first ffirst

ivregress gmm  pi_hat ( ROLC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(6) first ffirst

ivregress gmm  pi_hat ( RULC pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 RULC_3 RULC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( RULC pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 RULC_3 RULC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant robust gmm2s nofooter bw(21) first ffirst

ivregress gmm  pi_hat ( RULC pi_hat_1 pi_hat_F1 = pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( RULC pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(21) first ffirst

ivregress gmm  pi_hat ( ROLC pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC pi_hat_1  pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant robust gmm2s nofooter bw(21) first ffirst

ivregress gmm  pi_hat ( ROLC pi_hat_1 pi_hat_F1= pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(21) first ffirst

log close

log using NKPC_gmm_robustness,replace

summarize overtimehours

generate A_h2fix= (real_GDP_percapita)/( (516*((N1_percapita_SA)^(1-0.33)) )+(155.187*((N2_percapita_SA)^(1-0.33)) ) )

generate  overtime_share_h2fix= (comprnfb)/ (A_h2fix*((N2_percapita_SA)^(-0.33))  )

drop overtime_share_h2fix

generate  overtime_share_h2fix= (comprnfb)/ (A_h2fix*((N2_percapita_SA)^(-0.33))  )* (100/200.8336)

generate log_overtime_share_h2fix=log(overtime_share_h2fix)

summarize log_overtime_share_h2fix

generate ROLC_h2fix= log_overtime_share_h2fix-4.636248

generate  ROLC_h2fix_1= L.ROLC_h2fix

generate  ROLC_h2fix_2= L.ROLC_h2fix_1

generate  ROLC_h2fix_3= L.ROLC_h2fix_2

generate  ROLC_h2fix_4= L.ROLC_h2fix_3

ivregress gmm  pi_hat ( ROLC_h2fix pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 ROLC_h2fix_3 ROLC_h2fix_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC_h2fix pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 ROLC_h2fix_3 ROLC_h2fix_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant robust gmm2s nofooter bw(8) first ffirst

ivregress gmm  pi_hat ( ROLC_h2fix pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC_h2fix pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 pi_w_1 pi_w_2  pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(3) first ffirst

ivregress gmm  pi_hat ( ROLC_h2fix pi_hat_1  pi_hat_F1= pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 ROLC_h2fix_3 ROLC_h2fix_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC_h2fix pi_hat_1  pi_hat_F1= pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 ROLC_h2fix_3 ROLC_h2fix_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant robust gmm2s nofooter bw(14) first ffirst

ivregress gmm  pi_hat ( ROLC_h2fix pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC_h2fix pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_h2fix_1 ROLC_h2fix_2 pi_w_1 pi_w_2  pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(10) first ffirst

generate  delta_pi_hat_F1=pi_hat-pi_hat_F1

generate  delta_pi_hat_1=pi_hat_1-pi_hat_F1

ivregress gmm   delta_pi_hat_F1 ( RULC = pi_hat_1 pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 RULC_3 RULC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( ROLC = pi_hat_1 pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( RULC = pi_hat_1 pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( ROLC  = pi_hat_1 pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( RULC  delta_pi_hat_1=  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 RULC_3 RULC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( ROLC  delta_pi_hat_1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( RULC  delta_pi_hat_1=  pi_hat_2 pi_hat_3 pi_hat_4 RULC_1 RULC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivregress gmm   delta_pi_hat_F1 ( ROLC  delta_pi_hat_1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

sum ROLC, d

g ROLC_out= ROLC if ROLC>=r(p5) & ROLC<=r(p95)

ivregress gmm   pi_hat ( ROLC_out  pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2 pi_hat ( ROLC_out  pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238,  noconstant robust gmm2s nofooter bw(15) first ffirst

ivregress gmm   pi_hat ( ROLC_out  pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC_out  pi_hat_F1= pi_hat_1  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(14) first ffirst

ivregress gmm   pi_hat ( ROLC_out pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2 pi_hat ( ROLC_out pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 ROLC_3 ROLC_4 pi_w_1 pi_w_2 pi_w_3 pi_w_4 pi_pc_1 pi_pc_2  pi_pc_3 pi_pc_4 longshort_spread_1 longshort_spread_2 longshort_spread_3 longshort_spread_4 logy_detrended_1 logy_detrended_2 logy_detrended_3 logy_detrended_4) in 123/238,  noconstant robust gmm2s nofooter bw(20) first ffirst

ivregress gmm   pi_hat ( ROLC_out pi_hat_1 pi_hat_F1=  pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant wmatrix(hac nwest optimal)

estat overid

matrix list e(V)

ivreg2  pi_hat ( ROLC_out pi_hat_1 pi_hat_F1= pi_hat_2 pi_hat_3 pi_hat_4 ROLC_1 ROLC_2 pi_w_1 pi_w_2 pi_pc_1 pi_pc_2 longshort_spread_1 longshort_spread_2 logy_detrended_1 logy_detrended_2) in 123/238, noconstant robust gmm2s nofooter bw(15) first ffirst

twoway (line ROLC date, lpattern(dash)) (line ROLC_out date, cmissing(n)) in 123/238

sum ROLC_out in 123/238

regress delta_pi_hat_F1 RULC in 123/238, noconstant

regress delta_pi_hat_F1 ROLC in 123/238, noconstant

log close

