** Figure 2 Relative distribution of attention to Labor and Employment category and Employee Benefits subtopic, per legislature (IX-XVI)

use "dataset_Figures2_3.dta"
label variable legislature `"Legislature"'
graph bar major_topic_labor minor_topic_labor, over(legislature) 


** Figure 3. Relative distribution of attention to Government Operations category and Government Employee Benefits subtopic, per legislature (IX XVI)

use "dataset_Figures2_3.dta"
label variable legislature `"Legislature"'
graph bar major_topic_gov minor_topic_gov, over(legislature) 

