**Probit model robustness checks**
**without interactions**
probit   civilwar  recession wardefeat deathinoffice coldwar_new popln ethpol gdpln  peaceyrs  peaceyrs_sq peaceyrs_cb , robust
probit   civilwar  newshock1 popln ethpol gdpln  peaceyrs  peaceyrs_sq peaceyrs_cb , robust
**With interactions**
probit   civilwar newshock1  newshock1_w opposition w popln ethpol gdpln  peaceyrs  peaceyrs_sq peaceyrs_cb , robust
probit   civilwar newshock1  newshock1_opp opposition w popln ethpol gdpln  peaceyrs  peaceyrs_sq peaceyrs_cb , robust
