
*****$$$$$$$µµµµµµµ******** Estimation of Remittances in Normal Situation******$$$$$$$£££££££££££££µµµµµµµµµµµµµ
eststo: xi:regress lmttrans agerep nbtrf i.prectr i.emploi3 i.sexrep i.sexpf objtrans2_code2 nbhorsp if nomiss==1, vce(robust)
estat ic

*****$$$$$$uuuuuu********Estimation of Remittances in Conflict times*********$$$$$$$$$$$$$
eststo: xi:oglm mtant agerep nbtrf i.prectr i.emploi3 i.sexrep i.sexpf desttr2_code2 i.sejour_new if nomiss==1, link(probit)
estat ic

************* Editing of outputs (OLS and Ordinal Generalized Linear Model (OGLM))
esttab est1 est2, depvar r2 ar2 aic bic


************* Editing of outputs of Marginal Effects for Ordinal Generalized Linear Model
eststo clear
eststo: xi:oglm mtant agerep nbtrf i.prectr i.emploi3 i.sexrep i.sexpf desttr2_code2 i.sejour_new if nomiss==1, link(probit)
eststo: mfx, predict (outcome(1))
eststo: mfx, predict (outcome(2))
eststo: mfx, predict (outcome(3))
eststo: mfx, predict (outcome(4))
eststo: mfx, predict (outcome(5))
esttab est2 est3 est4 est5 est6, margin star(† 0.10 * 0.05 ** 0.01 *** 0.001) pr2 aic bic label

