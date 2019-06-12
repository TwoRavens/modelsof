//SPPQ Executable file of commands for paper title "Stakeholder Participation and Strategy in Rulemaking: A
//Comparative Analysis"

//data to use
use Public_Comment_Data.dta

//Metadata

//case = case name
//state = state name

//comments_pub = total number of comments from individuals
//comments_reg = total number of comments from regulated industry
//comments_adv = total number of comments from advocacy organizations

//tech_pub_count = total number of public comments that were coded 1 for technical information
//tech_pub_perc = percent of comments from public that were coded 1 for technical information

//tech_reg_count = total number of comments from regulated community that were coded 1 for technical information
//tech_reg_perc = percent of comments from regulated community that were coded 1 for technical information

//tech_adv_count = percent of comments from advocacy organizations that were coded 1 for technical information
//tech_adv_perc = percent of comments from advocacy organization that were coded 1 for technical information

//tech_tot_count=total number of comments that were coded 1 for technical information
//tech_tot_perc = percent of comments that were coded 1 for technical information

//value_pub_count = total number of public comments that were coded 1 for broad political/value statement
//value_pub_perc = percent of public comments that broad political/value statement

//value_reg_count = total number of regulated community comments that were coded 1 for broad political/value statement
//value_reg_perc = percent of regulated community comments that were coded 1 for broad political/value statement

//value_adv_count = total number of advocacy organization comments that were coded 1 for broad political/value statement
//value_adv_perc = percent of advocacy organization comments that were coded 1 for broad political/value statement

//value_tot_count = total number of comments with broad political/value statements
//value_tot_perc = percent of comments with broad political/value statements

//form_reg = number of form letters motivated by regulated community
//form_adv = number of form letters motivated by advocacy organizations



//page 22, comparison of industry and advococay percentages of technical information
//paired signed Wilcoxon

signrank tech_reg_perc=tech_adv_perc

//results, z=-0.454; p=0.65


//page 22, advocacy organizations’ use of technical arguments, as a percentage of total comments, did
//significantly vary across regulatory issues

 kwallis tech_adv_perc, by(case)
 
 //chi-squared with ties, 9.448, df=2, p=0.0089

 //page 23, The percentages of non-technical comments did not significantly vary between industry and advocacy groups (Wilcoxon signed pair test
 
 signrank value_reg_perc=value_adv_perc
 
 //results, z=0.651, p=0.51
 
 //page 23, form letters. statistically significant difference between the frequency
//of form letters that were mobilized by industry and advocacy organizations across the eight
//cases.

tabi 14 10\17 227\0 114\714 120597\0 12\6 377\0 1853, chi2

//results, chi2(7) = 1.5 e3; p=<0.001
