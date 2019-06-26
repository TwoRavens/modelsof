* Labels of Nodal ABM File
use "D:\data\UCINET\shocks\homophily shocks\comenemynodal3.dta", clear
label variable N0tiecaprow "Network Formation (N0) Tie Capacity"
label variable N0seqrow "Sequenc of Entry"
label variable N0demrow "Democracy"
label variable N0joindem "Pct. joint democracies"
label variable N0cultsim "Pct. common enemies"
label variable N0Uij "Sum Utilities of node i for other nodes"
label variable N0Uji "Sum utilities of other nodes to focal node"
label variable N0comenmy "Pct. nodes with shared enemies"
label variable N0edge "Sum of edges network formatio (N0)"
label variable N0offerow "No. offers made by focal nodes in formation stage"
label variable N0offercol "No of offers reveived by focal node at N0"
label variable N0accptrow "No. of offers focal node accepted at N0"
label variable N0droppedrow "No of focal node's offers accepted by other nodes at N0"
label variable N0tiecapdif "Difference between tie-capacity and degree"
label variable N0degcent "Degree Centrality at N0"
label variable N0accptrate "Acceptance Rate at N0"
label variable N1Uij "Focal Node's total Utility at N1"
label variable N1Uji "The total utility assigned by other nodes to Focal Node at N1"
label variable N6loctrans "Local Transitivity at N6"
label variable T6loctrans "Local Transitivity at T6"
label variable CT1diff "Difference of edges between Cotrol and Treatment at first post-shock iteration"
label variable poshockspread "Positive Shock Spread"
label variable negshockspread "Negative Shock Spread"
label variable netsize "Network Size"
label variable initialrow "Was node present at first random network formation stage?"
label define initialrow 0 "Joined later" 1 "Present in random stage"
label values initialrow initialrow
label define shocktype -1 "Negative" 0 "None" 1 "Positive"
label values shocktype shocktype
save "D:\data\UCINET\shocks\homophily shocks\comenemynodal3.dta", replace
* Labels of Dyadic ABM File
use "D:\data\UCINET\shocks\homophily shocks\comenemy3.dta", clear
ren pre* N0*
ren n1* N1*
ren n2* N2*
ren n3* N3*
ren n4* N4*
ren n5* N5*
ren n6* N6*
order runno row col netsize N* C* T*
label variable runno "network id"
label variable netsize "Network Size"
label variable N0iter "Network formation iteration (N0)"
label variable N0edge "Network Formation (N0) edge"
label variable N0tiecaprow "Row Tie Capacity"
label variable N0tiecapcol "Column Tie Capacity"
label variable N0demrow "Row Democracy Score"
label variable N0enenrow "Row Enemy of Enemy Score"
label variable N0cultsimrow "Cultural Similarity Score Row"
label variable N0demcol "Column Democracy Score"
label variable N0enencol "Column Enemy of Enemy Score"
label variable N0cultsimcol "Column cultural Similarity Score"
label variable N0seqrow "Row Sequence of Entry at N0"
label variable N0seqcol "Column Sequence of Entry at N0"
label variable N0offerow "Row offered an edge to Column"
label variable N0offercol "Column offered an Edge to Row"
label variable N0accptrow "Row Accepts Column's Offer"
label define offers 0 "No" 1 "Yes"
label values N0offerow offers
label values N0offercol offers
label values N0accptrow offers
label variable N0accptcol "Column accepts Row's offer"
label variable N0joindem "Joint Democracy N0"
label variable N0comenmy "Common Enemy N0"
label variable N0cultsim "Cultural Similarity N0"
label variable N0uij "uij N0"
label variable N0uij "First-order utility of row for column N0"
label variable N0uji "First order utility of column for row"
label variable N0ujk "Second-order utility of row for column's neighbors"
label variable N0costij "Cost of edge for row"
label variable N0Uij "Second-order utility of Column for Row's neighbors"
label variable N0Uij "Total Utility of Row for Column"
label variable N0uik "Second-order utility of column for row's neighbors"
label variable N0costji "Column's cost for edge with row"
label variable N0Uji "Total Column's utility for edge with row"
label variable poshock "Positive Shock"
label variable negshock "Negative Shock"
label variable minpretiecap "Min. tie capacity row-column"
label variable sumposhock "Sequence of last (row-column) to enter network"
label variable sumnegshock "No. nodes experiencing negative shocks"
label variable sumposhock "Sum of dyads experiencing positive shocks"
label variable maxseq "Sequence of last (row-column) to enter network"
label variable sumnegshock "No. dyadsexperiencing negative shocks"
label variable sumposhock "No. dyads experiencing positive shocks"
label variable shocktype "Shock Type"
label variable maxposhock "Dyad Maximum positive shock"
label variable maxnegshock "Dyad Maximum negative shock"
label variable poshockspread "Positive Shock Spread"
label variable poshockspread "Pct. Dyads Experiencing Positive Shocks"
label variable negshockspread "Pct. Dyads Experiencing Negative Shocks"
label variable neighposrow "Positive Shocks of Row's Neighbors"
label variable neighnegsrow "Negative Shocks of Row's Neighbors"
label variable neighposcol "Positive Shocks of Column's neigghbors"
label variable neighnegscol "Negative Shocks of Column's Neighbors"
label variable maxneighpos "Dyad Max. Positive Neighborhood Shocks"
label variable maxneighneg "Dyad Max. Negative Neighborhood Shocks"
label variable threestar "Three Stars"
ren threestar T5threestar
label var T5twostar "Two Stars"
label var T5ev "T5 Expected Value"
label var T6seqev "T6structural equivalence EV"
label var N6struceq "N6 Structural Equivalence"
label var T6struceq "T6 Structural Equivalence"
drop N1tiecap* N2tiecap* N3tiecap* N4tiecap* N5tiecap* N6tiecap* C*tiecap* T*tiecap*
drop N1dem* N2dem* N3dem* N4dem* N5dem* N6dem* C*dem* T*dem*
drop N1enen* N2enen* N3enen* N4enen* N5enen* N6enen* C*enen* T*enen*
drop N1cultsim* N2cultsim* N3cultsim* N4cultsim* N5cultsim* N6cultsim* C*cultsim* T*cultsim*
drop N1initial N2initial N3initial N4initial N5initial N6initial C*initial T*initial
drop N1joindem N2joindem N3joindem N4joindem N5joindem N6joindem C*joindem T*joindem
drop N1comenmy N2comenmy N3comenmy N4comenmy N5comenmy N6comenmy C*comenmy 
drop T2comenmy T3comenmy T4comenmy T5comenmy T6comenmy 
