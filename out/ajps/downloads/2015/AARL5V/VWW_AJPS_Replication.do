
*For Table 1
*all congresses, overall and then by minority and majority
*Model 1
reg les female leslag seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
*Model 2
reg les majwomen minwomen leslag seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)

*now for 1970s and 1980s
*Model 3
reg les majwomen minwomen leslag seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress<102, cluster( icpsr)

*and for 1990s and 2000s
*Model 4
reg les majwomen minwomen leslag seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress>101, cluster( icpsr)

*by congress (thus no lag), by party effect
*For Figure 1
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==93, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==94, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==95, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==96, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==97, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==98, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==99, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==100, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==101, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==102, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==103, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==104, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==105, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==106, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==107, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==108, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==109, cluster( icpsr)
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress==110, cluster( icpsr)


*Examining results by stages, for Table 2 and Figure 2

*Here are stages with overall women results, along with interpretations for the figure
reg all_bills female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_bills if female==0
	*Thus, controlling for all else, women introduce 11.4% more bills than men (100*1.994/17.448)
reg all_aic female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_aic if female==0
	*Thus, controlling for all else, women have 1.5% more action in committee than men
reg all_abc female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_abc if female==0
	*Thus, controlling for all else, women have 9.2% more action beyond committee than men
reg all_pass female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_pass if female==0
	*Thus, controlling for all else, women have 8.0% more House passages than men
reg all_law female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_law if female==0
	*Thus, controlling for all else, women have 6.1% more laws than men

*Here with minority and majority women
*Model 5
reg all_bills majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_bills if female==0 & majority==1
	* Thus, controlling for all else, majority party women introduce 16.9% more bills than majority party men (100*3.249/19.207)
sum all_bills if female==0 & majority==0
	* Thus, controlling for all else, minority party women introduce 5.0% more bills than minority party men (100*0.7515/15.036)
*Model 6
reg all_aic majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_aic if female==0 & majority==1
	* Thus, controlling for all else, majority party women receive 1.6% LESS action in committee than majority party men
sum all_aic if female==0 & majority==0
	* Thus, controlling for all else, minority party women receive 11.7% more action in committee than minority party men
*Model 7
reg all_abc majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_abc if female==0 & majority==1
	* Thus, controlling for all else, majority party women receive 7.8% more action beyond committee than majority party men
sum all_abc if female==0 & majority==0
	* Thus, controlling for all else, minority party women receive 30.9% more action beyond committee than minority party men
*Model 8
reg all_pass majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_pass if female==0 & majority==1
	* Thus, controlling for all else, majority party women have 3.5% more House passages than majority party men
sum all_pass if female==0 & majority==0
	* Thus, controlling for all else, minority party women have 28.3% more House passages than minority party men
*Model 9
reg all_law majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
sum all_law if female==0 & majority==1
	* Thus, controlling for all else, majority party women have 1.6% FEWER laws than majority party men
sum all_law if female==0 & majority==0
	* Thus, controlling for all else, minority party women have 33.3% more laws than minority party men

*For Supplemental Appendices

*For Table S1
*Democrats and Republicans
*Model S1, using all congresses, broken down by Democratic and Republican women
reg les demwomen repwomen leslag seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
*Model S3, now for 1990s and 2000s (Model S2 results for 1970s and 1980s mimic those for majority and minority, from Model 3)
reg les demwomen repwomen leslag seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress>101, cluster( icpsr)
*shows little difference between Democratic and Republican women, even in the era where the main effect is based on minority party women.

*For Table S2
*Excluding lagged LES, but using all congresses, overall and then by minority and majority
*Model S4
reg les female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
*Model S5
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)

*now for 1970s and 1980s
*Model S6
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress<102, cluster( icpsr)

*and for 1990s and 2000s
*Model S7
reg les majwomen minwomen seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq if congress>101, cluster( icpsr)

*For Table S3, using data that incorporates amendments, scores based on half of all credit given to amenders and half given to sponsor
*gen les_am_half = (les+les_am)/2
*gen leslag_am_half = les_am_half[_n-1]
*replace leslag_am_half = . if  icpsr~=icpsr[_n-1] | congress~=1+congress[_n-1]

*Notice that we lose 93-97th Congresses and 100th for this analysis

*Model S8
reg les_am_half female leslag_am_half seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)

*Model S9
reg les_am_half majwomen minwomen leslag_am_half seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair power meddist afam latino deleg_size votepct votepct_sq, cluster( icpsr)
