* Regime Age and Terrorism Do File
* James A. Piazza
* Dept. of Political Science, Penn State University
* jap45@psu.edu
* "Regime Age and Terrorism: Are Democracies More Prone to Terrorism: A Research Note"
* International Interactions


sort COW Year
tsset

* Table 1.  Summary Statistics
summarize GTD GTDDomestic ITERATE DemocracyPolity NonDemocracyPolity Durable DemAge5 DemAge6to10 DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus DictAge5 DictAge6to10 DictAge11to20 DictAge21to30 DictAge31to50 DictAge51Plus logpop logarea logGNI  AggSF GINI 

* Table 2.  Democracy Age and Terrorism

nbreg GTD logpop logarea logGNI  AggSF GINI  Durable  DemocracyPolity, nolog robust cluster(COW)
nbreg GTDDomestic logpop logarea logGNI  AggSF GINI  Durable  DemocracyPolity, nolog robust cluster(COW)
nbreg ITERATEloc logpop logarea logGNI  AggSF GINI  Durable  DemocracyPolity, nolog robust cluster(COW)
nbreg GTD logpop logarea logGNI  AggSF GINI DemAge5 DemAge6to10 DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus, nolog robust cluster(COW)
nbreg GTDDomestic logpop logarea logGNI  AggSF GINI DemAge5 DemAge6to10 DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus, nolog robust cluster(COW)
nbreg ITERATEloc logpop logarea logGNI  AggSF GINI DemAge5 DemAge6to10 DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus, nolog robust cluster(COW)

* Table 3.  Dictatorship Age and Terrorism

nbreg GTD logpop logarea logGNI  AggSF GINI  Durable  NonDemocracyPolity, nolog robust cluster(COW)
nbreg GTDDomestic logpop logarea logGNI  AggSF GINI  Durable  NonDemocracyPolity, nolog robust cluster(COW)
nbreg ITERATEloc logpop logarea logGNI  AggSF GINI  Durable  NonDemocracyPolity, nolog robust cluster(COW)
nbreg GTD logpop logarea logGNI  AggSF GINI DictAge5 DictAge6to10 DictAge11to20 DictAge21to30 DictAge31to50 DictAge51Plus, nolog robust cluster(COW)
nbreg GTDDomestic logpop logarea logGNI  AggSF GINI DictAge5 DictAge6to10 DictAge11to20 DictAge21to30 DictAge31to50 DictAge51Plus, nolog robust cluster(COW)
nbreg ITERATEloc logpop logarea logGNI  AggSF GINI DictAge5 DictAge6to10 DictAge11to20 DictAge21to30 DictAge31to50 DictAge51Plus, nolog robust cluster(COW)

* Table 4.  Mature Democracies and Terrorism

nbreg GTD logpop logarea logGNI  AggSF GINI NonDemocracy DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus, nolog robust cluster(COW)
nbreg GTDDomestic logpop logarea logGNI  AggSF GINI NonDemocracy DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus, nolog robust cluster(COW)
nbreg ITERATEloc logpop logarea logGNI  AggSF GINI NonDemocracy DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus, nolog robust cluster(COW)

* Figure 1.  Substantive Effects of Regime Type and Regime Age on Terrorism
* Note, because these are Monte Carlo simulations of first difference effects, mean effect of change in independent variable on dependent variable may slightly differ across simulation iterations.
 
estsimp nbreg GTD logpop logarea logGNI  AggSF GINI Dem5 Dem10 Dem15 Dem20 Dem25 Dem30 Dem35 Dem40 Dem45 Dem50 Dem55 Dem60, nolog
setx (logpop logarea logGNI GINI) mean (AggSF) median
simqi, fd(ev) changex(Dem5 0 1)
simqi, fd(ev) changex(Dem10 0 1)
simqi, fd(ev) changex(Dem15 0 1)
simqi, fd(ev) changex(Dem20 0 1)
simqi, fd(ev) changex(Dem25 0 1)
simqi, fd(ev) changex(Dem30 0 1)
simqi, fd(ev) changex(Dem35 0 1)
simqi, fd(ev) changex(Dem40 0 1)
simqi, fd(ev) changex(Dem45 0 1)
simqi, fd(ev) changex(Dem50 0 1)
simqi, fd(ev) changex(Dem55 0 1)
simqi, fd(ev) changex(Dem60 0 1)
drop b1-b19

estsimp nbreg GTD logpop logarea logGNI  AggSF GINI Dict5 Dict10 Dict15 Dict20 Dict25 Dict30 Dict35 Dict40 Dict45 Dict50 Dict55 Dict60, nolog
setx (logpop logarea logGNI GINI) mean (AggSF) median
simqi, fd(ev) changex(Dict5 0 1)
simqi, fd(ev) changex(Dict10 0 1)
simqi, fd(ev) changex(Dict15 0 1)
simqi, fd(ev) changex(Dict20 0 1)
simqi, fd(ev) changex(Dict25 0 1)
simqi, fd(ev) changex(Dict30 0 1)
simqi, fd(ev) changex(Dict35 0 1)
simqi, fd(ev) changex(Dict40 0 1)
simqi, fd(ev) changex(Dict45 0 1)
simqi, fd(ev) changex(Dict50 0 1)
simqi, fd(ev) changex(Dict55 0 1)
simqi, fd(ev) changex(Dict60 0 1)
drop b1-b19

* Table 5. Detail of Substantive Effects from Figure 1 above. 
* Note, because these are Monte Carlo simulations of first difference effects, mean effect of change in independent variable on dependent variable may slightly differ across simulation iterations.

estsimp nbreg GTD logpop logarea logGNI  AggSF GINI Dem5 Dem10 Dem15 Dem20 Dem25 Dem30 Dem35 Dem40 Dem45 Dem50 Dem55 Dem60, nolog
setx (logpop logarea logGNI GINI) mean (AggSF) median
simqi, fd(ev) changex(Dem5 0 1)
simqi, fd(ev) changex(Dem10 0 1)
simqi, fd(ev) changex(Dem15 0 1)
simqi, fd(ev) changex(Dem20 0 1)
simqi, fd(ev) changex(Dem25 0 1)
simqi, fd(ev) changex(Dem30 0 1)
simqi, fd(ev) changex(Dem35 0 1)
simqi, fd(ev) changex(Dem40 0 1)
simqi, fd(ev) changex(Dem45 0 1)
simqi, fd(ev) changex(Dem50 0 1)
simqi, fd(ev) changex(Dem55 0 1)
simqi, fd(ev) changex(Dem60 0 1)
drop b1-b19

estsimp nbreg GTD logpop logarea logGNI  AggSF GINI Dict5 Dict10 Dict15 Dict20 Dict25 Dict30 Dict35 Dict40 Dict45 Dict50 Dict55 Dict60, nolog
setx (logpop logarea logGNI GINI) mean (AggSF) median
simqi, fd(ev) changex(Dict5 0 1)
simqi, fd(ev) changex(Dict10 0 1)
simqi, fd(ev) changex(Dict15 0 1)
simqi, fd(ev) changex(Dict20 0 1)
simqi, fd(ev) changex(Dict25 0 1)
simqi, fd(ev) changex(Dict30 0 1)
simqi, fd(ev) changex(Dict35 0 1)
simqi, fd(ev) changex(Dict40 0 1)
simqi, fd(ev) changex(Dict45 0 1)
simqi, fd(ev) changex(Dict50 0 1)
simqi, fd(ev) changex(Dict55 0 1)
simqi, fd(ev) changex(Dict60 0 1)
drop b1-b19

* Table 6.  Comparison of Substantive Effects, Democratic Regime Age vs. Democratic Institutions
* Note, because these are Monte Carlo simulations of first difference effects, mean effect of change in independent variable on dependent variable may slightly differ across simulation iterations.

estsimp nbreg GTD logpop logarea logGNI  AggSF GINI DemAge5 DemAge6to10 DemAge11to20 DemAge21to30 DemAge31to50 DemAge51Plus Empower VanPart Executive, nolog
setx (logpop logarea logGNI GINI) mean (AggSF) median
simqi, fd(ev) changex(DemAge5 0 1)
simqi, fd(ev) changex(DemAge6to10 0 1)
simqi, fd(ev) changex(DemAge11to20 0 1)
simqi, fd(ev) changex(DemAge21to30 0 1)
simqi, fd(ev) changex(DemAge31to50 0 1)
simqi, fd(ev) changex(DemAge51Plus 0 1)
simqi, fd(ev) changex(Empower min max)
simqi, fd(ev) changex(VanPart min max)
simqi, fd(ev) changex(Executive min max)
drop b1-b16
