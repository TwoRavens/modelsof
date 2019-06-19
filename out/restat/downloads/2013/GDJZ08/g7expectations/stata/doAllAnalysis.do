
local basePath "C:\Jirka\Research\g7expectations\g7expectations"
cd "`basePath'\Stata"

adopath + C:\ado\egenodd


capture log close

global disagrMeasBig "2"		
* Measure of disagreement: 2: st deviation, otherwise (eg, 1) IQR, default IQR;

*do dataStatistics

*do disagreementAnalysis_disaggregate

do disagreementAnalysis_aggregate
do disagreementAnalysis_aggregate_panel_rawMeans
do disagreementAnalysis_aggregate_panel

global disagrMeasBig "1"		
do disagreementAnalysis_aggregate
do disagreementAnalysis_aggregate_panel

global disagrMeasBig ""	
