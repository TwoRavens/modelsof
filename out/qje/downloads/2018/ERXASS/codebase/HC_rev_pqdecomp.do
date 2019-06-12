/* ----------------------------------------------------------------------HC_rev_pqdecomp.do
Main control file for price/quantity decomposition

Stuart Craig
Last updated 	20180816
*/

// Prepare the enrollment data and HCCI episode data
	do ${scHC}/HC_rev_pqdecomp_dataprep.do
	
// Implement the variance decomposition (Table II, Appendix Tables V and VI)
	do ${scHC}/HC_rev_pqdecomp_vardecomp.do

// Also implement the Oaxaca/Blinder style decomposition (Appendix Tables VII and VIII)
	do ${scHC}/HC_rev_pqdecomp_counterfactuals.do
	
exit
