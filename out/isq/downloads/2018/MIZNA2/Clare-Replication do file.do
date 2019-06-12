
***************************************************************************************
*** THE FOLLOWING COMMANDS REPLICATE THE RESULTS IN TABLE 1 (MODELS 1-4) IN THE	***
*** ARTICLE "THE DETERRENT VALUE OF DEMOCRATIC ALLIES".					***
***************************************************************************************


*** MODEL 1 ***
probit cwinit max_defense dmax_defense parity parity_initally jdem jdem_targallies offense s_un_reg cwpceyrs cwpceyrs2 cwpceyrs3, robust

*** MODEL 2 ***
probit cwinit max_defense dmax_defense max_contig dmax_contig parity parity_initally jdem jdem_targallies offense s_un_reg cwpceyrs cwpceyrs2 cwpceyrs3, robust

*** MODEL 3 ***
probit cwinit max_defense dmax_defense mean_ally_prop_world dmean_ally_prop_world parity parity_initally jdem jdem_targallies offense s_un_reg cwpceyrs cwpceyrs2 cwpceyrs3, robust 

*** MODEL 4 ***
probit cwinit max_defense dmax_defense mean_trade_prop_world dmean_trade_prop_world parity parity_initally jdem jdem_targallies offense s_un_reg cwpceyrs cwpceyrs2 cwpceyrs3, robust


