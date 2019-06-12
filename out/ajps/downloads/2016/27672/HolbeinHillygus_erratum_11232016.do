
******** Code for erratum for Holbein, John B. and D. Sunshine Hillygus. “Making Young Voters: The Impact of Preregistration on Youth Turnout.” American Journal of Political Science. 60(2): 364-382. 
******** Erratum available on AJPS website

*cd // insert directory here

use "CPS data 2.5.14.dta", clear

******** Table 2: Incorrect Diff in Diff	
xi: reg voted pre_reg_state i.state*i.year age  married female f_income college_degree metropolitan white time_at_address registered biz_farm_employ interview_in_person dmv_register hispanic_encode if age<23	 
	   
******** Table E1: Corrected Diff in diff	
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address registered biz_farm_employ interview_in_person dmv_register hispanic_encode if age<23	, cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address registered biz_farm_employ interview_in_person dmv_register hispanic_encode if age<23	

********Diff Diff Model Variations--slightly wider age window (more precise)	
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address registered biz_farm_employ interview_in_person dmv_register hispanic_encode if age<24	, cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address registered biz_farm_employ interview_in_person dmv_register hispanic_encode if age<25	, cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address registered biz_farm_employ interview_in_person dmv_register hispanic_encode if age<26	, cluster(state_year)
		
********Diff Diff Model Variations--no registration status (perhaps overcontrolling)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person dmv_register hispanic_encode if age<23	 , cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person dmv_register hispanic_encode if age<24	 , cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person dmv_register hispanic_encode if age<25	 , cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person dmv_register hispanic_encode if age<26	 , cluster(state_year)

*And, no DMV
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person hispanic_encode if age<23	 , cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person hispanic_encode if age<24	 , cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person hispanic_encode if age<25	 , cluster(state_year)
xi: reg voted pre_reg_state i.state i.year age  married female f_income college_degree metropolitan white time_at_address  biz_farm_employ interview_in_person hispanic_encode if age<26	 , cluster(state_year)
