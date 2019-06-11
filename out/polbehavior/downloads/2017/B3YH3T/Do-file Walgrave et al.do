
************************************************************************************************
***What draws politicians' attention. An experimental study of issue framing effects on individual political elites***

*Stefaan Walgrave, Julie Sevenans, Kirsten Van Camp and Peter Loewen
*DO-file 
*Accepted for publication in Political Behavior

************************************************************************************************

*Note that the data published online do not allow to reproduce the balance tests (Online Material).
*In our project (which follows the ethical rules of the European Research Council), we were obliged to make sure that 
*the data were totally anonymous. That is, we need to make sure that an individual politician cannot be identified based 
*on our data. This poses a problem for the variables used in the experimental balance tests (age, political experience, 
*function,...) which, in many instances, allow to identify the politician.


use "Data-file Walgrave et al.dta"


*Reshape 

reshape long source1_ source2_ source3_ conflict1_ conflict2_ conflict3_ political1_ political2_ political3_ resp1_ resp2_ resp3_ opinion1_ opinion2_ opinion3_, i(infopolcode) j(condition)

rename source1_ source1
rename opinion1_ opinion1
rename resp1_ resp1
rename conflict1_ conflict1
rename political1_ political1
rename resp2_ resp2
rename opinion2_ opinion2
rename political2_ political2
rename source2_ source2
rename conflict2_ conflict2
rename resp3_ resp3
rename political3_ political3
rename source3_ source3
rename conflict3_ conflict3
rename opinion3_ opinion3

reshape long source conflict political resp opinion, i(infopolcode condition) j(issue)


*Analyses

encode country, gen(countrynum)
drop country
rename countrynum country


xtreg conflict 	condition gov i.issue i.country, i(infopolcode)			//Table A1, Model 1
xtreg conflict 	i.condition##i.gov i.issue i.country, i(infopolcode)	//Table A1, Model 2
margins, at (condition=(1 2)) over(gov) atmeans							//Figure 2
xtreg conflict 	i.condition##i.issue gov i.country, i(infopolcode)		//Table A1, Model 3
xtreg conflict 	i.condition##i.country gov i.issue, i(infopolcode)		//Table A1, Model 4
margins, at (condition=(1 2)) over(country) atmeans						//Figure 1


xtreg political 	condition gov i.issue i.country, i(infopolcode)			//Table A2, Model 1
xtreg political 	i.condition##i.gov i.issue i.country, i(infopolcode)	//Table A2, Model 2
margins, at (condition=(1 2)) over(gov) atmeans								//Figure 4                             
xtreg political 	i.condition##i.issue gov i.country, i(infopolcode)      //Table A2, Model 3
xtreg political 	i.condition##i.country gov i.issue, i(infopolcode)      //Table A2, Model 4
margins, at (condition=(1 2)) over(country) atmeans							//Figure 3


xtreg resp 	condition gov i.issue i.country, i(infopolcode)         //Table A3, Model 1
xtreg resp 	i.condition##i.gov i.issue i.country, i(infopolcode)    //Table A3, Model 2
margins, at (condition=(1 2)) over(gov) atmeans 					//Figure 6                    
xtreg resp 	i.condition##i.issue gov i.country, i(infopolcode)      //Table A3, Model 3
xtreg resp 	i.condition##i.country gov i.issue, i(infopolcode)      //Table A3, Model 4
margins, at (condition=(1 2)) over(country) atmeans					//Figure 5
