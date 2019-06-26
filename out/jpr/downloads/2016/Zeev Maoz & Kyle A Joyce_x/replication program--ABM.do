* ABM-Nodal Analyses
* Change directory name in accordance with your file locations
use "D:\data\UCINET\shocks\homophily shocks\Replication Files\comenmynodal3.dta", clear
* 1. Degree Centrality
* Negative Shocks
reg T6degcent N6degcent T6Uij  T6Uji  N0tiecaprow N0seqrow N0shockaccrate  negshocksize negshockspread neighnegshock if shocktype==-1, robust
* Note, marginal plots are produced for each variable separately, but they are aggregated in the manuscript to save space
margins, at(negshocksize=(0(.1)1))
margins, at(negshockspread=(0(.1)1))
margins, at(neighnegshock=(0(10)100))
* Positive Shocks
reg T6degcent N6degcent T6Uij  T6Uji  N0tiecaprow N0seqrow N0shockaccrate  poshocksize poshockspread neighposhock if shocktype==1, robust
margins, at(poshocksize=(0(.1)1))
margins, at(poshockspread=(0(.1)1))
margins, at(neighposhock=(0(10)100))
* 2. Local Transitivity
* Negative Shocks
reg T6loctrans N6loctrans T6Uij  T6Uji  N0tiecaprow N0seqrow N0shockaccrate  negshocksize negshockspread neighnegshock if shocktype==-1, robust
margins, at(negshocksize=(0(.1)1))
margins, at(negshockspread=(0(.1)1))
margins, at(neighnegshock=(0(10)100))
* Positive Shocks
reg T6loctrans N6loctrans T6Uij  T6Uji  N0tiecaprow N0seqrow N0shockaccrate  poshocksize poshockspread neighposhock if shocktype==1, robust
margins, at(poshocksize=(0(.1)1))
margins, at(poshockspread=(0(.1)1))
margins, at(neighposhock=(0(10)100))

* ABM Dyadic Analyses
use "D:\data\UCINET\shocks\homophily shocks\Replication Files\comenmy3dyad.dta", clear
* 1. Edge Probability
* Negative Shocks
logit T6edge N6edge   T6Uij T6Uji  minpretiecap maxseq negshock negshockspread maxneighneg T5threestar T5ev if  row<col & shocktype==-1,  robust 
margins, at(negshock=(0(.1)1))
margins, at(negshockspread=(0(.02).2))
margins, at(maxneighneg=(0(4)40))
* Positive Shocks
logit T6edge N6edge   T6Uij T6Uji  minpretiecap maxseq poshock poshockspread maxneighpos T5threestar T5ev if  row<col & shocktype==1,  robust
margins, at(poshock=(0(.1)1))
margins, at(poshockspread=(0(.1)1))
margins, at(maxneighpos=(0(4)40))

* 2. Structural Equivalence
* Negative Shocks
reg T6struceq N6struceq   T6Uij T6Uji  minpretiecap maxseq negshock negshockspread maxneighneg T5threestar T6seqev if  row<col & shocktype==-1,  robust
margins, at(negshock=(0(.1)1))
margins, at(negshockspread=(0(.1)1))
* Positive Shocks
reg T6struceq N6struceq   T6Uij T6Uji  minpretiecap maxseq poshock poshockspread maxneighpos T5threestar T6seqev if  row<col & shocktype==1,  robust
margins, at(poshock=(0(.1)1))
margins, at(poshockspread=(0(.1)1))
margins, at(maxneighpos=(0(4)40))

* ABM Group-Level Analyses
* Bote: For group-level and network-level analyses we use the same file
use "D:\data\UCINET\shocks\homophily shocks\Replication Files\comenmy3netchar.dta", clear
* Nodularity
reg T6modul N6modul pretiecaprow T6Uij preaccptrate negshockmag if shocktype==-1, robust
margins, at(negshockmag=(0(2)20))
reg T6modul N6modul pretiecaprow T6Uij preaccptrate poshockmag if shocktype==1, robust
margins, at(poshockmag=(0(5)50))
* Separation Coefficient
reg T6sepcoef N6sepcoef pretiecaprow T6Uij preaccptrate negshockmag if shocktype==-1, robust
margins, at(negshockmag=(0(2)20))
reg T6sepcoef N6sepcoef pretiecaprow T6Uij preaccptrate poshockmag if shocktype==1, robust
margins, at(poshockmag=(0(5)50))

* Network Characteristics
* Negative Shocks
* Density
reg T6dens N6dens pretiecaprow T6Uij preaccptrate negshockmag if shocktype==-1, robust
margins, at(negshockmag=(0(2)20))
* Transitivity
reg T6trans N6trans pretiecaprow T6Uij preaccptrate negshockmag if shocktype==-1, robust
margins, at(negshockmag=(0(2)20))
* Positive Shocks
* Density
reg T6dens N6dens pretiecaprow T6Uij preaccptrate poshockmag if shocktype==1, robust
margins, at(poshockmag=(0(5)50))
* Transitivity
reg T6trans N6trans pretiecaprow T6Uij preaccptrate poshockmag if shocktype==1, robust
margins, at(poshockmag=(0(5)50))


* Real World Analyses
* Nodal Characteristics
use "D:\data\UCINET\shocks\homophily shocks\Replication Files\realworldshocknat.dta", clear
tsset state year
* Degree Centrality
*Baseline Models
xtreg atopdegcent  i.democ   L.joindem  L.nocommonenmies   L.cultsim L.newsrg  L.cinc L.status avgtarg L.neigh3star  L.neightriang , fe
xtreg atopdegcent  i.democ   L.atopUij   L.newsrg  L.cinc L.status avgtarg L.neigh3star  L.neightriang , fe
* Shock Model
xtreg atopdegcent  mvavdeg  i.democ  L.atopUij  L.newsrg  L.cinc L.status avgtarg mvavposhock mvavnegshock mvavpospread mvavnegspread mvavneigh*, fe
margins, at(mvavposhock=(0(.1)1))
margins, at(mvavnegshock=(0(.1)1))
margins , at(mvavpospread=(0(2)20))
margins , at(mvavnegspread=(0(2)20))
margins, at(mvavneighpos=(0(2)20))
margins, at(mvavneighneg=(0(2)20))
* Local Transitivity
* Baseline Models
xtreg atoploctrans  i.democ   L.joindem  L. nocommonenmies  L.cultsim L.newsrg  L.cinc L.status avgtarg L.neigh3star  L.neightriang , fe
xtreg atoploctrans  i.democ   L.atopUij    L.newsrg  L.cinc L.status avgtarg L.neigh3star  L.neightriang , fe
* Shock Model
xtreg atoploctrans mvavtrans  i.democ   L.atopUij    L.newsrg  L.cinc L.status avgtarg mvavposhock mvavnegshock mvavpospread mvavnegspread mvavneighpos mvavneighneg L.neigh3star  L.neightriang , fe
margins, at(mvavposhock=(0(.1)1))
margins, at(mvavnegshock=(0(.1)1))
margins , at(mvavpospread=(0(2)20))
margins , at(mvavnegspread=(0(2)20))
margins, at(mvavneighpos=(0(2)20))
margins, at(mvavneighneg=(0(2)20))

* Dyadic Analyses
use "D:\data\UCINET\shocks\homophily shocks\Replication Files\realworldydshock.dta", clear
tsset dyad year
* Edge Probability
* Baseline Models
logit atopally i.joindem L. dichenmyenmy L.cultsimlev L.relcap logdist newsrg  revstatus L.ally_k3star L.ally_triangle if statea<stateb, robust iter(12)
logit atopally i.joindem L.atopUij L.atopUji L.relcap logdist newsrg  revstatus L.ally_k3star L.ally_triangle if statea<stateb, robust iter(12)
* Shock Model
logit atopally mvavally i.joindem L.atopU* L.relcap logdist newsrg  revstatus mvavposhock mvavnegshock  mvavpospread mvavnegspread  mvavneighpos mvavneighneg L.ally_k3star  L.ally_triangle noallyrs atopspl* if statea<stateb, robust iter(12)
margins, at(mvavposhock=(0(.1)1))
margins, at(mvavnegshock=(0(.1)1))
margins, at(mvavpospread=(0(.06).6))
margins, at(mvavnegspread=(0(.06).6))
margins, at(mvavneighpos=(0(2)20))
margins, at(mvavneighneg=(0(2)20))
*Structural Equivalence
* Baseline Models
xtreg atopstruceq i.joindem L. dichenmyenmy L.cultsimlev L.caprat logdist newsrg  revstatus L.ally_k3star L.struceqev if statea<stateb, re
 xtreg atopstruceq i.joindem L.atopUij L.atopUji  L.caprat logdist newsrg  revstatus L.ally_k3star L.struceqev if statea<stateb, re
* Shcok Model
xtreg atopstruceq mvavstruceq i.joindem L.atopU* L.relcap logdist newsrg  revstatus mvavposhock mvavnegshock mvavpospread mvavnegspread mvavneighpos mvavneighneg L.ally_k3star  L.struceqev if statea<stateb, re
margins, at(mvavposhock=(0(.1)1))
margins, at(mvavnegshock=(0(.1)1))
margins, at(mvavpospread=(0(.06).6))
margins, at(mvavnegspread=(0(.06).6))
margins, at(mvavneighpos=(0(2)20))
margins, at(mvavneighneg=(0(2)20))
* Network Characteristics
use "D:\data\UCINET\shocks\homophily shocks\Replication Files\realworldnetchar.dta", clear
* 1. Density
* Baseline Models
prais atopdens   L.democ L.dichenmy L.cultsim  L.capcon avgmids L.prmaj  nostates, corc
prais atopdens   L.democ L.meanUij  L.capcon avgmids L.prmaj  nostates, corc
* Shock Model
prais atopdens mvavdens  L.meanU  L.capcon L.prmaj    mvavposhockmag mvavnegshockmag,  corc rho(tsc) twostep
margins, at(mvavposhockmag=(0(.5)5))
margins, at(mvavnegshockmag=(0(.5)5))
* 2. Transitivity (Clustering Coefficient)
* Baseline Models
prais atoptrans   L.democ L.dichenmy L.cultsim  L.capcon avgmids L.prmaj  nostates, corc
prais atoptrans   L.democ L.meanUij   L.capcon avgmids L.prmaj  nostates, corc
* Shock Model
prais atoptrans mvavtrans L.meanU  L.capcon L.prmaj    mvavposhockmag mvavnegshockmag,  corc rho(tsc) twostep
margins, at(mvavposhockmag=(0(.5)5))
margins, at(mvavnegshockmag=(0(.5)5))
