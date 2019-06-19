* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

loc nrep = 50
eststo clear
foreach rc in 0 1 2 {
loc compliancelist "0 1"
if `rc'==2 loc compliancelist "1"
foreach compliance in `compliancelist' {
foreach subsidy in 5   {
loc estfile "result_mixlogit_rc`rc'_nrep`nrep'_compliance`compliance'"
est use TableText/`estfile'
esttab 
eststo
}
}
}
esttab,eqlabels(none)
loc filename "$path/Paper/tables/mixlogit"
loc labellist " choice "" d_weight_min_2 "$\alpha: (\Delta \text{Weight})^2$" d_liter_km_2 "$\beta: (\Delta \text{Fuel consumption})^2$" d_liter_km_weight_min "$\gamma: \Delta \text{Weight} \times \Delta \text{Fuel consumption}$" subsidy "$\tau$: 1\{Subsidy\}"  comp_at_old "$\dot{\lambda}$: Shadow price of old fuel-econ. standard" compliance "$\lambda$: Shadow pirce of new fuel-econ. standard""
esttab using `filename'_nostar.tex,eqlabels(none) nostar nomtitles  ///
sfmt(%5.3g) se(%4.2f) b(%4.2f) nodepvars  noobs booktabs replace compress label nonotes fragment coeflabels(`labellist')  ///
order(d_weight_min_2 d_liter_km_2 d_liter_km_weight_min subsidy compliance comp_at_old )

*********************
*** Final minor edit in latex 
*********************
* A few minor edits have to be done in latex: 1) standard deviations has to be converted to absolute values, 
* and the text line of "Stadard deviation of random-coefficient" has to be inserted. 
