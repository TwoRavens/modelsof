/*	Clinton, Lewis & Selin				              */
/*	CONDUCT ANALYSIS FOR SECTION 4 & Appendix		  */
/*	Replication for Agency Level Analysis 			  */

clear
use "AgencyLevelDataAll110Replication.dta", nolabel
destring, replace

/*	Table A1	*/
summ commi whcommdiff whdemdiff commi pacomm whdemdiff policyareas com1 cabinet clintonlewis fieldoffice appointee bushagenda rr	

/*	Differential Response Rate -- Appendix Table B3 	*/

gen lemploy = log(employment2007)
reg rr cabinet clintonlewis com1 potresp lemploy bureaus policyareas programs bushagenda

/* Drop "Other" and "Executive Office of the President" from Regressions */
/*drop if agcode4=="OTH" */  
/*drop if agcode4=="EOP" */


/*********************/
/*	Table 1	 in Text */
/*********************/

/*	All Executives */
reg whcommdiff commi policyareas bushagenda com1 cabinet clintonlewis fieldoffice appointee, robust 	/*	Model 1	*/
reg whdemdiff commi policyareas bushagenda com1 cabinet clintonlewis fieldoffice appointee, robust		/*	Model 3	*/

/*	Appendix Results: Table A6 -- Relationship with interest groups */
reg whintgrpdiff commi policyareas bushagenda com1 cabinet clintonlewis fieldoffice appointee, robust 	

/*	Appendix Results: Table A3 -- Using Policy Agendas to measure of the number of committees overseeing */
reg whcommdiff pacomm policyareas bushagenda com1 cabinet clintonlewis fieldoffice appointee, robust 	
reg whdemdiff pacomm policyareas bushagenda com1 cabinet clintonlewis fieldoffice appointee, robust		
reg whintgrpdiff pacomm policyareas bushagenda com1 cabinet clintonlewis fieldoffice appointee, robust 	


/******************************/
/*	Table 1	 in Text (cont'd) */
/******************************/

clear
use "AgencyLevelDataCareerists110Replication.dta"

/*	Just careerists	*/
reg whcommdiff commi policyareas bushagenda com1 cabinet clintonlewis fieldoffice, robust				/*	Model 2	*/
reg whdemdiff commi policyareas bushagenda com1 cabinet clintonlewis fieldoffice, robust				/*	Model 4	*/

/*	Appendix Results: Table A6 -- Relationship with interest groups using just careerists*/
reg whintgrpdiff commi policyareas bushagenda com1 cabinet clintonlewis fieldoffice, robust 	

/*	Appendix Results: Table A3 -- Using Policy Agendas to measure of the number of committees overseeing */
reg whcommdiff pacomm policyareas bushagenda com1 cabinet clintonlewis fieldoffice, robust 	
reg whdemdiff pacomm policyareas bushagenda com1 cabinet clintonlewis fieldoffice, robust		
