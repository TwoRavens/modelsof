log using "C:\Documents and Settings\tir\My Documents\River Treaty Effectiveness\Climate&InstReplication1.log"

// Do file for Tir & Stinnett's "Weathering Climate Change: Can Institutions Mitigate International Water Conflict?" Forthcoming in the Journal of Peace Research, 2012

// June 7, 2011

version 11

set more off

// VARIABLES
//  Please see the manuscript for the operational definition of each variable and data source.

// cwmid = militarized interstate dispute
// lnwaterpcmin = log of water per capita amount available in the water poorer country
// instcoop = level of river treaty institutionalization
// instXwater = interaction between water availability and institutionalization level
// numbtreaties = number of treaties signed between the countries
// anyupdown = upstream/downstream relationship for contiguous countries
// updown* = upstream/downstream relationship for all countries 
// power1 = relative power
// alliance = dyad members are allies
// gdpmax = level of economic development for the richer state
// interdep = economic interdependence
// dyaddem = dyadic democracy
// contig = coniguity scale (distance)
// contiguity = dichotomous contiguity indicator
// LnDistance = log of distance between dyad membersDyadSize = log dyadic population size
// LnDyadDevelop = log of the dyad's economic size
// peaceyrs1; _spline* = technical variables related to the btscs correction

use "C:\Documents and Settings\tir\My Documents\River Treaty Effectiveness\EffectDyadYr3.dta", clear

// Model 1: Base Model
logit cwmid power1 alliance gdpmax interdep dyaddem contig peaceyrs1 _spline*, nolog

// Model 2: River and Water variables
logit cwmid lnwaterpcmin instcoop numbtreaties anyupdown power1 alliance gdpmax interdep dyaddem contig peaceyrs1 _spline*, nolog

// Model 3: Interaction
logit cwmid lnwaterpcmin instcoop instXwater numbtreaties anyupdown power1 alliance gdpmax interdep dyaddem contig peaceyrs1 _spline*, nolog

// Robusteness checks

// (1) Gravity variables added: dyad size and econ size (ln of combined dyadic figures, from Gleditsch et al. 2006)
logit cwmid lnwaterpcmin instcoop numbtreaties anyupdown power1 alliance gdpmax interdep dyaddem contig DyadSize LnDyadDevelop peaceyrs1 _spline*, nolog

// (2) Replacing the contiguity scale with dichotomous contiguity + ln distance (both from Gleditsch et al. 2006)
logit cwmid lnwaterpcmin instcoop numbtreaties anyupdown power1 alliance gdpmax interdep dyaddem LnDistance contiguity peaceyrs1 _spline*, nolog

// (3) Including both gravity/size AND coniguity (both dichotomously and as ordinal scale to capture distance)
logit cwmid lnwaterpcmin instcoop numbtreaties anyupdown power1 alliance gdpmax interdep dyaddem contig contiguity DyadSize LnDyadDevelop peaceyrs1 _spline*, nolog

// (4) Replacing the original up/downstream variable (which was for contiguous countries only) with the variable for all countries (defined as up/downstream when at least 33% of the basin is upstream, from Gleditsch et al. 2006).  Similar results obtain when the definition is changed to at least 5%, 10%, 25%, or 50% of the basin being upstream.
logit cwmid lnwaterpcmin instcoop numbtreaties updown33 power1 alliance gdpmax interdep dyaddem contig peaceyrs1 _spline*, nolog

// (5) Including all robusteness variables (gravity/size, contiguity + distance, revised up/downstream)
logit cwmid lnwaterpcmin instcoop numbtreaties updown25 power1 alliance gdpmax interdep dyaddem contig contiguity DyadSize LnDyadDevelop peaceyrs1 _spline*, nolog

log off
log close
