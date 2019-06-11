/*--------------------------------------------------------------

Master do-file for Stata calculations, Rate of Return on Everything.
This file constructs the dataset, and makes the charts and tables
	in the main paper and online appendix.
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

global main_dir "~/Dropbox/rore/RORE_QJE_replication"
*global main_dir "D:\Dropbox\rore\RORE_QJE_replication"

cd "${main_dir}"

include paths

*================== Set parameters ========================================

* Net to gross rental ratio
global netgross = 0.67


* R-P plausibility graphs
local rp_plaus = 1

*======================= Run commands =============================================

* 1. Dataset construction xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
do "${rore}/src/do_files/data/construct_core_dataset.do"

* 2. Data overview xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* 2-1/ Data overview table
do "${rore}/src/do_files/analysis/data_overview/data_overview.do"

* 3. Wealth shares xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
do "${rore}/src/do_files/analysis/world/wealth_shares.do"

* 4. Analysis: world summaries xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* 4-1/ Returns summary bar chart + scatterpolot: 
*	i). Returns bar charts for aggregate trends
*	ii). Scatter plot risk vs return: both standalone, and combined with bar chart
do "${rore}/src/do_files/analysis/world/world_returns_bar_charts.do"
do "${rore}/src/do_files/analysis/world/risk_and_return.do"

* 4-2/ Returns table
* For paper: real + nominal returns
do "${rore}/src/do_files/analysis/world/world_returns_table_paper.do"

* 4-4/ r-g; risky vs safe rate: calculate world averages and plot the decadal MA graphs
do "${rore}/src/do_files/analysis/world/r_global_risky_safe.do"

* 4-5/ Monetary regimes
do "${rore}/src/do_files/analysis/world/monetary_regimes.do"

* 5. Analysis: by country xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* 5-1/ By-country r vs g, risky vs safe, equity vs housing tables
do "${rore}/src/do_files/analysis/bycountry/bycountry_r_minus_g.do"

* 6. Accuracy xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* Housing ----------------------------------------------------------------
* 6-1-1/ REITs
do "${rore}/src/do_files/analysis/accuracy/all_REITs.do"
* 6-1-2/ Maintenance costs
do "${rore}/src/do_files/analysis/accuracy/maintenance_costs.do"
* 6-1-3/ Balance sheet approach comparison
do "${rore}/src/do_files/analysis/accuracy/bs_approach_comparison.do"
* 6-1-4/ Alternative benchmarks table
do "${rore}/src/do_files/analysis/accuracy/benchmark_comparison.do"
* 6-1-5/ Location sensitivity
do "${rore}/src/do_files/analysis/accuracy/location_sensitivity.do"

* 6-1-6 Housing by-country plausibility
local plaus_cs AUS BEL CHE DEU DNK ESP FIN FRA GBR ITA JPN NLD NOR PRT SWE USA
local rp_plaus = 1
if `rp_plaus' == 1	{
	foreach c of local plaus_cs	{
		do "${rore}/src/do_files/analysis/accuracy/rp_plaus/rp_plaus_`c'.do"
	}
}

* 6-1-7/ Comparison of rents to London indices
do "${rore}/src/do_files/analysis/accuracy/uk_vs_london_early_comparison.do"

* 6-1-8/ Comparison to Shiller
do "${rore}/src/do_files/analysis/accuracy/shiller_hp_comparison.do"


* Equity ----------------------------------------------------------------

* 6-2-4/ Corporate taxes
do "${rore}/src/do_files/analysis/accuracy/corp_tax_impact.do"

* Further checks/comparability  -----------------------------------------
* 6-3-1/ Household balance sheets
do "${rore}/src/do_files/analysis/accuracy/hh_balance_sheets.do"
* 6-3-2/ PSZ comparison
do "${rore}/src/do_files/analysis/accuracy/psz_returns_comparison.do"
* 6-3-3/ Hyperinflations
do "${rore}/src/do_files/analysis/accuracy/hyperinflations.do"
* 6-3-4/ Returns without interpolation
do "${rore}/src/do_files/analysis/accuracy/returns_without_interpolation.do"
* 6-3-5/ Rolling window return averages (smoothed equity vs smoothed housing)
do "${rore}/src/do_files/analysis/accuracy/nonoverlapping_window_averages.do"
* 6-3-6/ Foreign assets
do "${rore}/src/do_files/analysis/accuracy/fgn_assets.do"
* 6-3-7/ Disaster returns
do "${rore}/src/do_files/analysis/accuracy/disaster_returns.do"
* Zillow returns
do "${rore}/src/do_files/analysis/accuracy/zillow.do"
* 7. Divs vs prices xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
do "${rore}/src/do_files/analysis/world/divs_vs_capgain.do"

* 8. Correlations xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* 8-1/ Calculate correlations
do "${rore}/src/do_files/analysis/world/return_correlations.do"

do "${rore}/src/do_files/analysis/world/correlations_crosscountry.do"

* 8-2/ Draw correlation graphs
do "${rore}/src/do_files/analysis/world/correlation_graphs_world_combined.do"
