*********************************************************************
*	STATA CODE
*	"Robust inequality of opportunity comparisons
*	Theory and application to early-childhood policy evaluation" 
*
*	The Review of Economics and Statistics
*
*	Francesco Andreoli (LISER)
*	Tarjei Havnes (University of Oslo) 
*	Arnaud Lefranc (University of Cergy-Pontoise)
*
*	March 2018
**********************************************************************

/*	TO BE RUN WITH REGISTRY DATA (UNAVAILABLE IN THIS FOLDER, SEE DATA ACCESS)
*	ESTIMATES
*	a) Estiate policy effects of teform

do ezopboot.do
*/

*	INFERENCE
*	a.2) Arrange baseline data and produce Figure 3

do settings.do

*	a.3) Produce estimates of p-values for joint tests and produces Figure 2

do graphs_joint_test.do

*	a.4) Produce estimates of gap curves and p-values for joint tests in Figure 1

do table_graph_3groups.do

*	a.5) Produce estimates of the Gini Opportunity indext (overall and for selected groups)

do gini_opp.do
