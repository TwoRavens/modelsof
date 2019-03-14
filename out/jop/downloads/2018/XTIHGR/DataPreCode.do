* "The Gendered Effects of Violence on Political Engagement"

* This file contains the necessary code and instructions to create Engagement_scale (the primary dependent variable)

clear

* Set the appropriate directory
* cd ... 

set more off

* Use Data_Pre.dta. This dataset does not contain Engagement_scale. 
use "Data_Pre.dta"

* Create Engagement_scale
factor Voting Interest, pcf
predict Engagement_scale

* Save the new dataset (containing Engagement_scale) as Data_Post.dta
* Make sure Data_Post.dta is saved in Stata 12 format (or earlier)
* All subsequent analyses will use Data_Post.dta
