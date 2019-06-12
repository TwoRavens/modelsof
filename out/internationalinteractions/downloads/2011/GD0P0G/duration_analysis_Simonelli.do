version 11.0
#delimit ;
set more off ;

cd "F:\Duration_Paper\";

log using negduration_replication.log, replace;


* ******************************************************************	*;
*	File-Name: 	duration_replication_Simonelli.do					 *;
*	Date:		June 15, 2010							             *;
*	Author:  	NS									                 *;
*	Purpose: 	replication						                     *;
*	Data Used: 	Multilateral_agreements_simonelli.dta	*;
*	Data Output: 	negduration_replication.log					*;
*	Status:		works											*;
* ******************************************************************	*;

use Multilateral_agreements_simonelli.dta; 

********************************************************************	*;

* run descriptive stats for length of negotiations and first proposal maker  *;

summarize Length_neg;

summarize Length_neg if Arms_limit==1;

summarize Length_neg if Rules_war==1;

summarize Length_neg if Terrorism==1;

summarize Length_neg if Commodity==1;

summarize Length_neg if Environmental==1;


summarize State_proposer IGO_proposer NGO_proposer Majorpower_prop Multiple_first_proposals;

summarize State_proposer IGO_proposer NGO_proposer Majorpower_prop Multiple_first_proposals if Arms_limit==1;

summarize State_proposer IGO_proposer NGO_proposer Majorpower_prop Multiple_first_proposals if Rules_war==1;

summarize State_proposer IGO_proposer NGO_proposer Majorpower_prop Multiple_first_proposals if Terrorism==1;

summarize State_proposer IGO_proposer NGO_proposer Majorpower_prop Multiple_first_proposals if Commodity==1;

summarize State_proposer IGO_proposer NGO_proposer Majorpower_prop Multiple_first_proposals if Environmental==1;


* run weibull regression model to check for duration depenedence	*;

stset Length_neg;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Majorpower_prop Cold_war, nohr dist(weib);

* run exponential regression model 									*;
* run exponential model with nonsecurity and interactive vars		*;
* note that environmental dropped due to of collinearity			*;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Majorpower_prop Cold_war, nohr dist(exp);

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Cold_war Non_security IGO_nonsecurity NGO_nonsecurity, nohr dist(exp);

* run exponential model with IGO and NGO interactive variables		*;
* note that NGO_terr dropped due to collinearity					*;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Cold_war IGO_arms IGO_comm IGO_terr IGO_environ, nohr dist(exp);

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Cold_war IGO_arms IGO_comm IGO_terr IGO_environ NGO_arms NGO_comm NGO_environ, nohr dist(exp);


* robustness check- drop agreements that never entered into force	*;

preserve;
drop if Entry_date==.;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Majorpower_prop Cold_war, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Cold_war Non_security IGO_nonsecurity NGO_nonsecurity, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Cold_war IGO_arms IGO_comm IGO_terr IGO_environ NGO_arms NGO_comm NGO_environ, nohr dist(exp);

restore;

* robustness check- drop Depth variable								*;

stset Length_neg;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Arms_limit Terrorism Commodity Environmental Majorpower_prop Cold_war, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Arms_limit Terrorism Commodity Cold_war Non_security IGO_nonsecurity NGO_nonsecurity, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Arms_limit Terrorism Commodity Environmental Cold_war IGO_arms IGO_comm IGO_terr IGO_environ NGO_arms NGO_comm NGO_environ, nohr dist(exp);

* robustness check- drop Cold war variable							*;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Majorpower_prop, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Non_security IGO_nonsecurity NGO_nonsecurity, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental IGO_arms IGO_comm IGO_terr IGO_environ NGO_arms NGO_comm NGO_environ, nohr dist(exp);

* robustness check- include Major power proposer variable in models	*;
* previously excluded from											*;
* note that this changes reference category							*;

streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Majorpower_prop Cold_war Non_security IGO_nonsecurity NGO_nonsecurity, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Majorpower_prop Cold_war IGO_arms IGO_comm IGO_terr IGO_environ, nohr dist(exp);
streg IGO_proposer NGO_proposer Negotiating_states Duration_limit Depth Arms_limit Terrorism Commodity Environmental Majorpower_prop Cold_war IGO_arms IGO_comm IGO_terr IGO_environ NGO_arms NGO_comm NGO_environ, nohr dist(exp);

exit;
