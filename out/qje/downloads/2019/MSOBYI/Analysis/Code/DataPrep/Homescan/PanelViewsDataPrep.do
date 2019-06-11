/* PanelViewsDataPrep.do */


/* Prep the 2017 Allcott, Lockwood, and Taubinsky PanelViews survey */
* Consider this as outside data, and put in the data folder
use C:/Users/Hunt/Dropbox/OptimalSodaTax/Externals/Intermediate/Homescan/PanelViews_by_Household.dta, replace
keep household_code Knowledge_Av health_importance_Av BMI_Av Diabetic_Av
rename Knowledge_Av svy_health_knowledge
rename health_importance_Av svy_health_importance
rename BMI_Av BMI
rename Diabetic_Av Diabetic

label var svy_health_knowledge "Nutrition knowledge"
label var svy_health_importance "Health importance"

saveold $Externals/Data/Nielsen/Homescan/PanelViews.dta, replace
