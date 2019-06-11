## Aleman and Kim 2015

## Model 1

xtabond2 depvar c.depvarlag c.educationlag c.lngdpc  i.yeardv, gmm (c.depvarlag, l(1 8) collapse ) iv(c.educationlag c.lngdpc i.yeardv) twostep robust

## Model 2

xtabond2 depvar c.depvarlag c.educationlag c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.depvarlag, l(1 8) collapse ) iv(c.educationlag c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 3

xtabond2 fhb c.fhblag c.educationlag c.lngdpc  i.yeardv, gmm (c.fhblag, l(1 8) collapse ) iv(c.educationlag c.lngdpc i.yeardv) twostep robust

## Model 4

xtabond2 fhb c.fhblag c.educationlag c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.fhblag, l(1 8) collapse ) iv(c.educationlag c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 5

xtabond2 udsmean c.udsmeanlag c.educationlag c.lngdpc  i.yeardv, gmm (c.udsmeanlag, l(1 7) collapse ) iv(c.educationlag c.lngdpc i.yeardv) twostep robust

## Model 6

xtabond2 udsmean c.udsmeanlag c.educationlag c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.udsmeanlag, l(1 7) collapse ) iv(c.educationlag c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 7

xtabond2 depvar c.depvarlag c.educationlag##c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.depvarlag, l(1 8) collapse ) iv(c.educationlag##c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust
margins, dydx(educationlag) at( lngdpc=(3.5 (.25) 12)) level(90)
marginsplot


## Model 8

xtabond2 depvar c.depvarlag c.educationlag##i.oecd c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.depvarlag, l(1 8) collapse ) iv(c.educationlag##i.oecd c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 9

xtabond2 depvar c.depvarlag c.educationlag##i.rich50s60sq75 c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.depvarlag, l(1 8) collapse ) iv(c.educationlag##i.rich50s60sq7 c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 10

xtabond2 fhb c.fhblag c.educationlag##c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.fhblag, l(1 8) collapse ) iv(c.educationlag##c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 11

xtabond2 fhb c.fhblag c.educationlag##i.oecd c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.fhblag, l(1 8) collapse ) iv(c.educationlag##i.oecd c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 12

xtabond2 fhb c.fhblag c.educationlag##i.rich50s60sq75 c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.fhblag, l(1 8) collapse ) iv(c.educationlag##i.rich50s60sq75 c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 13

xtabond2 udsmean c.udsmeanlag c.educationlag##c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.udsmeanlag, l(1 7) collapse ) iv(c.educationlag##c.lngdpc c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 14

xtabond2 udsmean c.udsmeanlag c.educationlag##i.oecd c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.udsmeanlag, l(1 7) collapse ) iv(c.educationlag##i.oecd c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust

## Model 15

xtabond2 udsmean c.udsmeanlag c.educationlag##i.rich50s60sq75 c.lnoilgaspop2000 c.lnpopi i.yeardv, gmm (c.udsmeanlag, l(1 7) collapse ) iv(c.educationlag##i.rich50s60sq75 c.lnoilgaspop2000 c.lnpopi i.yeardv) twostep robust


