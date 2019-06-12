
*Model 1, Table 2:

probit election unemp_6 cpi_6 unemp_3 cpi_3 if fixed==0

*Model 2, Table 2:

probit election unemp_6 cpi_6 unemp_3 cpi_3 months_since winter_summer if fixed==0

*Model 3, Table 2:

probit election unemp_6 cpi_6 unemp_3 cpi_3 if fixed==1

*Model 4, Table 2:

probit election unemp_6 cpi_6 unemp_3 cpi_3 months_since winter_summer if fixed==1



*Figure 1 (Predicted Probabilities):

qui probit election unemp_6 cpi_6 unemp_3 cpi_3 months_since winter_summer if fixed==0


qui prvalue, x(unemp_6=	-0.20	months_since= 39 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 39 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 40 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 40 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 41 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 41 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 42 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 42 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 43 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 43 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since=44 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 44 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 45 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 45 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 46 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 46 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 47 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 47 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 48 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 48 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 49 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 49 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 50 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 50 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 51 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 51 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 52 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 52 winter_summer=0) diff
qui prvalue, x(unemp_6=	-0.20	months_since= 53 winter_summer=0) save
prvalue, x(unemp_6=	0.19 months_since= 53 winter_summer=0) diff


qui prvalue, x(unemp_3=	-0.36	months_since= 39 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 39 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 40 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 40 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 41 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 41 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 42 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 42 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 43 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 43 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since=44 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 44 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 45 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 45 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 46 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 46 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 47 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 47 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 48 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 48 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 49 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 49 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 50 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 50 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 51 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 51 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 52 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 52 winter_summer=0) diff
qui prvalue, x(unemp_3=	-0.36	months_since= 53 winter_summer=0) save
prvalue, x(unemp_3=	0.35 months_since= 53 winter_summer=0) diff



qui prvalue, x(cpi_3=	-0.08	months_since= 39 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 39 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 40 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 40 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 41 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 41 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 42 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 42 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 43 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 43 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since=44 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 44 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 45 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 45 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 46 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 46 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 47 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 47 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 48 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 48 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 49 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 49 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 50 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 50 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 51 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 51 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 52 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 52 winter_summer=0) diff
qui prvalue, x(cpi_3=	-0.08	months_since= 53 winter_summer=0) save
prvalue, x(cpi_3=	0.50 months_since= 53 winter_summer=0) diff


qui prvalue, x(cpi_6=	0.02	months_since= 39 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 39 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 40 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 40 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 41 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 41 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 42 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 42 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 43 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 43 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since=44 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 44 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 45 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 45 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 46 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 46 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 47 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 47 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 48 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 48 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 49 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 49 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 50 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 50 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 51 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 51 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 52 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 52 winter_summer=0) diff
qui prvalue, x(cpi_6=	0.02	months_since= 53 winter_summer=0) save
prvalue, x(cpi_6=	0.41 months_since= 53 winter_summer=0) diff


qui prvalue, x(months_since=46) save
prvalue, x(months_since= 52) diff
qui prvalue, x(months_since=49 winter_summer=0) save
prvalue, x(months_since=49 winter_summer=1) diff

