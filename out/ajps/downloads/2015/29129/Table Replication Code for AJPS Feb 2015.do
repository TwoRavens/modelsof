/* Farhang & Yaver AJPS Fragmentation Replication Code for Variables and Tables*/


/* Creating standardized measures of fragmentation indicators*/

egen z_actors=std(count_actors)
egen z_agencies=std(count_agencies)
egen z_overlap=std(count_overlap)


/* To generate the fragmentation index measure*/

alpha z_actors z_agencies z_overlap, c i 
gen frag_index=((z_actors +z_agencies +z_overlap)/3)
gen frag_index_pos = frag_index + 1.2961935


/* Alternative DV -- factor score using principle components analysis */

factor  z_actors z_agencies  z_overlap, pcf  
rotate
predict frag_factor
gen frag_factor_pos=frag_factor+1.4447265  

/* Creating restricted cubic spline */

rc_spline year, knots(1960 1985 1998)

/* Table 3 (sparse linear, full linear, full spline) */

eststo: reg frag_index_pos div_gov divisiveness marginofcontrol closeraces margin_elections_interact year, cluster(congress)
eststo: reg frag_index_pos div_gov divisiveness marginofcontrol closeraces margin_elections_interact year partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
eststo: reg frag_index_pos div_gov divisiveness marginofcontrol closeraces margin_elections_interact spline1 spline2 partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(r2 N)


/* Table 4, using seat share losses variable instead(sparse linear, full linear, full spline) */

eststo: reg frag_index_pos div_gov divisiveness marginofcontrol seatsharelosses margin_losses_interact year, cluster(congress)
eststo: reg frag_index_pos div_gov divisiveness marginofcontrol seatsharelosses margin_losses_interact year partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
eststo: reg frag_index_pos div_gov divisiveness marginofcontrol seatsharelosses margin_losses_interact spline1 spline2 partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(r2 N)

/* Table A1: using the factor score fragmentation dependent variable instead */

eststo: reg frag_factor_pos div_gov divisiveness marginofcontrol closeraces margin_elections_interact year, cluster(congress)
eststo: reg frag_factor_pos div_gov divisiveness marginofcontrol closeraces margin_elections_interact year partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
eststo: reg frag_factor_pos div_gov divisiveness marginofcontrol closeraces margin_elections_interact spline1 spline2 partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(r2 N)

/* Table A2: count models of individual forms of fragmentation */

eststo: poisson count_actors div_gov divisiveness marginofcontrol closeraces margin_elections_interact year partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
eststo: poisson count_agencies div_gov divisiveness marginofcontrol closeraces margin_elections_interact year partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
eststo: nbreg count_overlap div_gov divisiveness marginofcontrol closeraces margin_elections_interact year partymargin execbranchsize regulatorycommands pages rulemakingratio policy_consumer policy_civrights policy_environment policy_elections policy_energy policy_fooddrug policy_housing policy_labor policy_healthsafety policy_nationalsecurity policy_transportation policy_omnibus  policy_other, cluster(congress)
estout, style(tex) cells(b(star fmt(3)) se(par fmt(3))) stats(r2 N)


/* pctyeanay used in lieu of divisiveness in some robustness checks mentioned in paper * /
