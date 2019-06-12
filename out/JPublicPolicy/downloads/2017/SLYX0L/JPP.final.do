/****************************************************
Data Replication File
"Agency Rulemaking in a Separation of Powers System"
Journal of Public Policy
Rachel Augustine Potter, University of Virginia (rapotter@virginia.edu)
Charles R. Shipan, University of Michigan (cshipan@umich.edu) 


September 2017; Created using Stata 14.0
****************************************************/

/*VARIABLE NAMES & DESCRIPTIONS
agency					Agency id number
agencyname 				Agency name
year 					Year
quarter 				Quarter
tq 						Time (quarter)
tq2 					Time squared (quarter)
ty						Time (year)
ty2						Time squared (year)
timequarterid 			Quarter id counter
ndsignif_nprm_count 	Count of significant proposed rules (excluding deadline rules)
ndinsignifnprm 			Count of insignificant proposed rules (excluding deadline rules)
signif_nprm_count 		Count of significant proposed rules 
ndsignif_final_count 	Count of significant final rules (excluding deadline rules)
ndinsigniffinal 		Count of insignificant final rules (excluding deadline rules)
signif_final_count 		Count of significant final rules 
priority 				Indicator for whether the agency is a presidential priority
alignedpresident  		Indicator for whether the agency and the president are ideologically aligned
transition  			Indicator for whether the quarter is a transition quarter
midnight 				Indicator for whether the quarter is a midnight quarter
oppsizeunity 			Opposition Size Unity measure
cong_agencydisagree 	Indicator for whether Congress and the agency disagree ideologically
hearings_sentiment 		Sentiment of agency oversight hearings (see Marvel and McGrath 2016)
oversight_hearings		Count of oversight hearings for the agency (see Marvel and McGrath 2016)
lncases 				Logged number of appellate court cases involving the agency
lnsize  				Logged number of employees in the agency
cl_ideology 			Clinton and Lewis ideology score for agency
cl_moderate 			Indicator for whether Clinton and Lewis credibility interval overlaps with zero
independent 			Indicator for independent agency
divided  				Indicator for divided government
g1-g45 					Agency fixed effects
y1-y13 					Year fixed effects
*/

****CODE TO REPLICATE MODELS IN THE PAPER
import delimited "Potter.Shipan.JPP.final.csv", encoding(ISO-8859-1)
xtset agency timequarterid

*Table 1. Counts of Proposed Rules and Final Rules by Quarter
xtnbreg ndsignif_nprm_count  priority alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re
xtnbreg ndsignif_final_count  priority alignedpresident transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re

*Table 3. Proposed Rules and Final Rules for Priority and Non-Priority Agencies by Quarter
xtnbreg ndsignif_nprm_count alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 if  priority == 0, re
xtnbreg ndsignif_nprm_count alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 if  priority == 1, re
xtnbreg ndsignif_final_count alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 if  priority == 0, re
xtnbreg ndsignif_final_count alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 if  priority == 1, re


****CODE TO REPLICATE MODELS IN THE ONLINE APPENDIX

*Table A4. Counts of Proposed Rules and Final Rules (Including Rules with a Deadline) by Quarter
xtnbreg signif_nprm_count  priority alignedpresident transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re
xtnbreg signif_final_count  priority alignedpresident transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re

*Table A6. Counts of Proposed and Final Rules by Quarter Using a PPML Approach
ppml ndsignif_nprm_count  priority alignedpresident  transition  midnight oppsizeunity g1-g45 y1-y13 if  g24!=1, cluster(agency) noconstant
ppml ndsignif_final_count  priority alignedpresident transition  midnight oppsizeunity  g1-g45 y1-y13 if  g24!=1, cluster(agency) noconstant

*Table A7. Counts of Proposed and Final Rules with an Alternate Congress Measure
xtnbreg ndsignif_nprm_count  priority alignedpresident  transition  midnight  cong_agencydisagree lnsize  cl_ideology  independent divided tq tq2 , re
xtnbreg ndsignif_final_count  priority alignedpresident transition  midnight cong_agencydisagree lnsize  cl_ideology  independent divided tq tq2 , re

*Table A8. Counts of Proposed and Final Rules Incorporating Congressional Oversight Committees
xtnbreg ndsignif_nprm_count c.hearings_sentiment##c.oversight_hearings priority alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re 
xtnbreg ndsignif_final_count c.hearings_sentiment##c.oversight_hearings priority alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re 

*Table A9. Counts of Proposed and Final Rules Excluding Moderate Agencies
xtnbreg ndsignif_nprm_count  priority alignedpresident transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 if  cl_moderate !=1, re
xtnbreg ndsignif_final_count  priority alignedpresident transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 if  cl_moderate !=1, re

*Table A10. Counts of Insignificant Proposed Rules and Insignificant Final Rules by Quarter
xtnbreg ndinsignifnprm  priority alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re
xtnbreg ndinsigniffinal  priority alignedpresident transition  midnight oppsizeunity lnsize  cl_ideology  independent divided tq tq2 , re

*Table A11. Counts of Proposed Rules and Final Rules (Including the Courts) by Quarter
xtnbreg ndsignif_nprm_count  priority alignedpresident  transition  midnight oppsizeunity lncases lnsize  cl_ideology  independent divided tq tq2 , re
xtnbreg ndsignif_final_count  priority alignedpresident  transition  midnight oppsizeunity lncases lnsize  cl_ideology  independent divided tq tq2 , re

*Table A12. Interactive Model of Proposed Rules and Final Rules for Priority and Non-Priority Agencies by Quarter
xtnbreg ndsignif_nprm_count  i.priority##c.alignedpresident i.priority##c.transition  i.priority##c.midnight i.priority##c.oppsizeunity  lnsize  cl_ideology  independent divided tq tq2 , re
xtnbreg ndsignif_final_count  i.priority##c.alignedpresident i.priority##c.transition  i.priority##c.midnight i.priority##c.oppsizeunity  lnsize  cl_ideology  independent divided tq tq2 , re

clear

************************
*Table A5. Counts of Proposed Rules and Final Rules by Year
import delimited "Potter.Shipan.JPP.final.csv", encoding(ISO-8859-1)

collapse (sum) ndsignif_nprm_count ndsignif_final_count (first) agencyname priority alignedpresident oppsizeunity lnsize  cl_ideology  independent divided ty ty2 (mean) transition  midnight ,by(agency year) 
xtset agency year

xtnbreg ndsignif_nprm_count  priority alignedpresident  transition  midnight oppsizeunity lnsize  cl_ideology  independent divided ty ty2 , re
xtnbreg ndsignif_final_count  priority alignedpresident transition oppsizeunity  midnight lnsize  cl_ideology  independent divided ty ty2 , re

clear
