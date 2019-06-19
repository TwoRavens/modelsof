use adf.dta
tsset time1
dfuller sfastate, regress lags(1)
dfuller sfafor, regress lags(1)
dfuller sfapriv, regress lags(1)

tsset time2
dfuller deafor, regress lags(1) 
dfuller deapriv, regress lags(1)
dfuller deastate, regress lags(1)



