* This program reproduces tables and figures from the paper 
* The Impacts of Neighborhoods on Intergenerational Mobility II: County-Level Estimates 
* Raj Chetty and Nathaniel Hendren 

* The code is organized in 4 parts.
* The first part of the code renames variables
* The Second part of the code produces preferred estimates of causal effects (Online Tables 1 and 2) from the paper.
* The Third part of the code produces Figures from the paper.
* The Fourth part of the code produces Tables from the paper.

set more off

* Install (update) maptile 
* For more informations on maptile, visit https://michaelstepner.com/maptile/
capture ssc install spmap
capture ssc install maptile
capture maptile_install using "http://files.michaelstepner.com/geo_county1990.zip"
capture maptile_install using "http://files.michaelstepner.com/geo_cz.zip"

* Install (update) binscatter
* For more information on binscatter, visit https://michaelstepner.com/binscatter/
capture ssc install binscatter

* Install (update) dm79 which includes svmat2
capture net install dm79, from(http://www.stata.com/stb/stb56)

* Please change the directory to location of the appropriate files
*global dir ../replicate
global dir "${dropbox}/movers/final_web_files/replicate_qje_submission"
cd ${dir}
global data "${dir}/data"
global figures "${dir}/figures"
global tables "${dir}/tables"
global logs "${dir}/logs"
global code "${dir}/code"

do "${code}/rename_variables"

do "${code}/preferred_estimates"

do "${code}/paper2_figures"

do "${code}/paper2_tables"
