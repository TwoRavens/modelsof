/******************************************************************************

Replication Materials for Tables and Figures in:

"Baker, Bus Driver, Babysitter, Candidate? Revealing the gendered development of political ambition among ordinary Americans"

By Melody Crowder-Meyer

Political Behavior 

Notes: 
I first present code needed to replicate the tables and figures in the paper. 
Then, I present code needed to replicate the tables in the Online Appendix.
Finally, I provide a codebook at end of this do file.


******************************************************************************/

* use "Ordinary Americans Replication Data 2014.dta"
svyset [pweight=weight]
set scheme lean2


// Table 1 

tab ismarried female, col
svy: tab ismarried female, col

tab havechild female, col
svy: tab havechild female, col

tab havechildunder6 female, col
svy: tab havechildunder6 female, col

tab income female, col
svy: tab income female, col

tab edu_range female, col
svy: tab edu_range female, col

tab whiteonly female, col
svy: tab whiteonly female, col

mean age if female==0
mean age if female==1
svy: mean age if female==0
svy: mean age if female==1



// Table 2

* Respondents with 4-year college degree or less
svy: logit thoughtabout_or_ran  female qualified_hold qualholdxfem encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if mastersandup==0

* Respondents with graduate degree
svy: logit thoughtabout_or_ran  female qualified_hold qualholdxfem encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if mastersandup==1



// Table 3

* Women
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0

* Men
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0



// Table 4

svy: tab edu_range female, col
svy: mean edu_range, over(female)
test [edu_range]0 = [edu_range]1

svy: tab partic_politics female, col
svy: mean partic_politics , over(female)
test [partic_politics]0 = [partic_politics]1

svy: tab ismarried female, col
svy: mean ismarried , over(female)
test [ismarried]0 = [ismarried]1

svy: tab encourage_personal_scale female, col
svy: mean encourage_personal_scale , over(female)
test [encourage_personal_scale]0 = [encourage_personal_scale]1

svy: tab encourage_political_scale female, col
svy: mean encourage_political_scale , over(female)
test [encourage_political_scale]0 = [encourage_political_scale]1

svy: tab qualified_hold female, col
svy: mean qualified_hold , over(female)
test [qualified_hold]0 = [qualified_hold]1

svy: tab qualified_run female, col
svy: mean qualified_run , over(female)
test [qualified_run]0 = [qualified_run]1

svy: tab qualified_run female, col
svy: mean qualified_run , over(female)
test [qualified_run]0 = [qualified_run]1

svy: tab thoughtabout_or_ran female, col
svy: mean thoughtabout_or_ran , over(female)
test [thoughtabout_or_ran]0 = [thoughtabout_or_ran]1




// Figure 1
* Qualified to hold office
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 qualified_hold=(1(1)4)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 qualified_hold=(1(1)4)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1).5)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1).5)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Self-Perceptions of Qualification to Hold Office") title("Political Ambition by Qualified to Hold Office", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))

* Qualified to run for office
svy: logit thoughtabout_or_ran  qualified_run encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 qualified_run=(1(1)4)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_run encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 qualified_run=(1(1)4)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1).5)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1).5)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Self-Perceptions of Qualification to Run for Office") title("Political Ambition by Qualified to Run for Office", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))


// Figure 2
* Education
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 edu_range=(0(1)5)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 edu_range=(0(1)5)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1).5)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1).5)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Education") title("Political Ambition by Education", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))

* Political Participation
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 partic_politics=(0(.25)1)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 partic_politics=(0(.25)1)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1).5)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1).5)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Political Participation") title("Political Ambition by Political Participation", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))


// Figure 3
* Political Source Recruitment
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 encourage_political_scale=(0(.33)1)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 encourage_political_scale=(0(.33)1)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1)1)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1)1)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Encouragement from Political Source") title("Political Ambition by Political Source Recruitment", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))

* Personal Source Recruitment
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 encourage_personal_scale=(0(.33)1)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(ismarried=0 blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 encourage_personal_scale=(0(.33)1)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1)1)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1)1)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Encouragement from Personal Source") title("Political Ambition by Personal Source Recruitment", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))


// Figure 4
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
	margins, atmeans at(blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 ismarried=(0 1)) level(90) saving(file1, replace)
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
	margins, atmeans at(blackonly==0 hispaniconly==0 asianPIonly==0 othermultiracial==0 havechild=1 Democrat=1 Republican=0 ismarried=(0 1)) level(90) saving(file2, replace)
combomarginsplot file1 file2, labels("Men" "Women") file1opts(msymbol(O) lpattern(dash) ylabel(0(.1).5)) file2opts(msymbol(S) lpattern(solid) ylabel(0(.1).5)) ytitle("Predicted Probability of Considering Seeking Office") xtitle("Unmarried or Married") title("Political Ambition by Marital Status", span) subtitle("For Men and Women", span)  yscale(titlegap(*7)) xscale(titlegap(*7))




/******************************************************************************
* Online Appendix Tables
******************************************************************************/

// Table A.3
svy: logit thoughtabout_or_ran  female qualified_run qualrunxfem encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if mastersandup==0
svy: logit thoughtabout_or_ran  female qualified_run qualrunxfem encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if mastersandup==1


// Table A.4
svy: logit thoughtabout_or_ran  qualified_run encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
svy: logit thoughtabout_or_ran  qualified_run encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0


// Table A.5
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 


// Table A.6
svy: logit thoughtabout_or_ran  i.female##c.qualified_hold i.female##c.REenc_political i.female##i.ismarried i.female##i.havechild i.female##c.REenc_personal i.female##c.REpartic_pol i.female##c.REpartic_com i.female##c.REknow_scale i.female##c.REeffic_scale i.female##c.age i.female##c.edu_range i.female##c.income i.female##ib1.racewmulti i.female##i.Democrat i.female##i.Republican  if mastersandup==0
svy: logit thoughtabout_or_ran  i.female##c.qualified_run i.female##c.REenc_political i.female##i.ismarried i.female##i.havechild i.female##c.REenc_personal i.female##c.REpartic_pol i.female##c.REpartic_com i.female##c.REknow_scale i.female##c.REeffic_scale i.female##c.age i.female##c.edu_range i.female##c.income i.female##ib1.racewmulti i.female##i.Democrat i.female##i.Republican  if mastersandup==0


// Table A.7 
relogit thoughtabout_or_ran  female qualified_hold qualholdxfem encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if mastersandup==0 [pweight=weight]
relogit thoughtabout_or_ran  female qualified_hold qualholdxfem encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if mastersandup==1 [pweight=weight]


// Table A.8
relogit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0 [pweight=weight]
relogit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechild encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0 [pweight=weight]


// Table A.9
svy: logit thoughtabout_or_ran qualified_hold REenc_political ismarried havechild REenc_personal worryaboutlosing partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
svy: logit thoughtabout_or_ran qualified_hold c.REenc_political##i.worryaboutlosing ismarried havechild c.REenc_personal##i.worryaboutlosing partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
svy: logit thoughtabout_or_ran qualified_hold REenc_political ismarried havechild REenc_personal worryaboutlosing partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
svy: logit thoughtabout_or_ran qualified_hold c.REenc_political##i.worryaboutlosing ismarried havechild c.REenc_personal##i.worryaboutlosing partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0


// Table A.10
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale i.ismarried##i.womentraditionalrole  havechild c.REenc_personal##i.womentraditionalrole partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried i.havechild##i.womentraditionalrole c.REenc_personal##i.womentraditionalrole partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale i.ismarried##i.womentraditionalrole havechild c.REenc_personal##i.womentraditionalrole partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried i.havechild##i.womentraditionalrole c.REenc_personal##i.womentraditionalrole partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0


// Table A.11
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechildunder6 encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==1 & mastersandup==0
svy: logit thoughtabout_or_ran  qualified_hold encourage_political_scale ismarried havechildunder6 encourage_personal_scale partic_politics partic_community knowledge_scale effic_scale age  edu_range income blackonly hispaniconly asianPIonly othermultiracial Democrat Republican if female==0 & mastersandup==0




/******************************************************************************

Codebook:

Please see the paper and Online Appendix for additional details about question wordings and variables

----------------------------------------------------------------------------------
female                                                           1= female, 0=male     
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
Democrat                                   1=Democrat, 0=Republican or Independent
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
Republican                                 1=Republican, 0=Democrat or Independent
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

            tabulation:  Freq.  Value
                           926  0
                           314  1

----------------------------------------------------------------------------------
Independent                                 1=Independent, 0=Republican or Democrat
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
income                              What is your combined yearly household income?
----------------------------------------------------------------------------------

                  type:  numeric (byte)
                 label:  incomelab

                 range:  [1,9]                        units:  1
         unique values:  9                        missing .:  2/1,240

            tabulation:  Freq.   Numeric  Label
                           313         1  Less than 30,000
                           147         2  30,000-39,999
                           147         3  40,000 - 49,999
                           150         4  50,000 - 59,999
                            82         5  60,000 - 69,999
                           113         6  70,000 - 79,999
                            55         7  80,000 - 89,999
                            56         8  90,000 - 99,999
                           175         9  100,000 or more


----------------------------------------------------------------------------------
age                                                              age in years
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [18,85]                      units:  1
         unique values:  68                       missing .:  0/1,240

----------------------------------------------------------------------------------
partic_politics     Proportion of political activities in which respondent participated
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  .01
         unique values:  5                        missing .:  0/1,240

----------------------------------------------------------------------------------
partic_community  Proportion of community activities in which respondent participated)
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  .1
         unique values:  3                        missing .:  0/1,240

----------------------------------------------------------------------------------
knowledge_scale              Proportion of political questions correctly answered
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  .1
         unique values:  6                        missing .:  0/1,240

----------------------------------------------------------------------------------
effic_scale    3 = high efficacy in all 4 statements, 1=low efficacy in all 4 statements
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,3]                        units:  .01
         unique values:  9                        missing .:  10/1,240


----------------------------------------------------------------------------------
havechild                                1= has at least one child, 0=does not
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  28/1,240

----------------------------------------------------------------------------------
ismarried                                     1= is married, 0= is not
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  24/1,240

----------------------------------------------------------------------------------
encourage_personal_scale    Proportion of personal sources encouraging respondent
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1.000e-08
         unique values:  4                        missing .:  0/1,240

----------------------------------------------------------------------------------
encourage_political_scale      Proportion of political sources encouraging respondent
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1.000e-08
         unique values:  4                        missing .:  0/1,240

----------------------------------------------------------------------------------
qualified_run       rates self 1=not at all to 4=very qualified to run for office
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,4]                        units:  1
         unique values:  4                        missing .:  6/1,240

----------------------------------------------------------------------------------
qualified_hold          rates self 1=not at all to 4=very qualified to hold office
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,4]                        units:  1
         unique values:  4                        missing .:  8/1,240

----------------------------------------------------------------------------------
havechildunder6                  1=has at least one child under age 6, 0= does not
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  29/1,240


----------------------------------------------------------------------------------
thoughtabout_or_ran       Ambition: 0=never thought about running, 1=sometimes 
                          thought about running through has held elected office
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  10/1,240


----------------------------------------------------------------------------------
qualholdxfem                              interaction of qualified_hold x female
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,4]                        units:  1
         unique values:  5                        missing .:  8/1,240

----------------------------------------------------------------------------------
qualrunxfem                               interaction of qualified_run x female
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,4]                        units:  1
         unique values:  5                        missing .:  6/1,240

----------------------------------------------------------------------------------
edu_range                                  1=less than HS to 6=post-college degree
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,6]                        units:  1
         unique values:  6                        missing .:  0/1,240

----------------------------------------------------------------------------------
mastersandup                1=post-college degree, 0=all other (lower)educ levels
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
womentraditionalrole             1=holds traditional gender role views, 0=does not
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  4/1,240


----------------------------------------------------------------------------------
worryaboutlosing                1=concerned about losing if ran, 0=not
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240


----------------------------------------------------------------------------------
whiteonly                         1=white, 0=all other race/ethnic identifications
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
blackonly                          1=Black, 0=all other race/ethnic identifications
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
hispaniconly                   1=Hispanic, 0=all other race/ethnic identifications
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240


----------------------------------------------------------------------------------
asianPIonly     1=Asian or Pacific Islander, 0=all other race/ethnic identifications
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240

----------------------------------------------------------------------------------
othermultiracial   1=Other race, More than 1 race checked, or Native American, 0=all else
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [0,1]                        units:  1
         unique values:  2                        missing .:  0/1,240


----------------------------------------------------------------------------------
racewmulti                          1=white,2=black,3=hisp,4=asianPI,5=other/multi
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,5]                        units:  1
         unique values:  5                        missing .:  0/1,240

						   
----------------------------------------------------------------------------------
REpartic_pol                   partic_politics recoded to integers
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,5]                        units:  1
         unique values:  5                        missing .:  0/1,240

----------------------------------------------------------------------------------
REpartic_com                   partic_community recoded to integers
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,3]                        units:  1
         unique values:  3                        missing .:  0/1,240

----------------------------------------------------------------------------------
REknow_scale                              knowledge_scale recoded to integers
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,6]                        units:  1
         unique values:  6                        missing .:  0/1,240

----------------------------------------------------------------------------------
REeffic_scale                             effic_scale recoded to integers
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,9]                        units:  1
         unique values:  9                        missing .:  10/1,240


----------------------------------------------------------------------------------
REenc_personal                        encourage_personal_scale recoded to integers
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,4]                        units:  1
         unique values:  4                        missing .:  0/1,240


----------------------------------------------------------------------------------
REenc_political                      encourage_political_scale recoded to integers
----------------------------------------------------------------------------------

                  type:  numeric (float)

                 range:  [1,4]                        units:  1
         unique values:  4                        missing .:  0/1,240

----------------------------------------------------------------------------------
weight                                                                      weight
----------------------------------------------------------------------------------

                  type:  numeric (double)

                 range:  [.01780023,4.8047432]        units:  1.000e-11
         unique values:  1,134                    missing .:  0/1,240



******************************************************************************/

