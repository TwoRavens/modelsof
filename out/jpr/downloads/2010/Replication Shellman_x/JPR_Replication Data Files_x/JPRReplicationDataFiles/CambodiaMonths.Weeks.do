*JPR Replication Models
*Shellman, Hatfield, and Mills
*Case: Cambodia 
*Data Files: Run on both the months and weeks data files to produce all output reported in the Appendix
******************************************************************************************************************************************

*Descriptives
sum gmv89alldissoc  alldissocgmv89 gmv89tdk  tdkgmv89 gmv89sikfunc sikfuncgmv89 gmv89kplnf  kplnfgmv89 gmv89rescg rescggmv89 hosscalegmv89alldissoc hosscalealldissocgmv89  coopscalegmv89alldissoc    coopscalealldissocgmv89 hosscalegmv89tdk  hosscaletdkgmv89 coopscalegmv89tdk     coopscaletdkgmv89 hosscalegmv89sikfunc hosscalesikfuncgmv89 coopscalegmv89sikfunc    coopscalesikfuncgmv89 hosscalegmv89kplnf  hosscalekplnfgmv89  coopscalegmv89kplnf   coopscalekplnfgmv89 hosscalegmv89rescg hosscalerescggmv89  coopscalegmv89rescg  coopscalerescggmv89  hosgmv89alldissoc hosalldissocgmv89  coopgmv89alldissoc    coopalldissocgmv89 hosgmv89tdk  hostdkgmv89 coopgmv89tdk     cooptdkgmv89 hosgmv89sikfunc hossikfuncgmv89 coopgmv89sikfunc    coopsikfuncgmv89 hosgmv89kplnf  hoskplnfgmv89  coopgmv89kplnf   coopkplnfgmv89 hosgmv89rescg hosrescggmv89  coopgmv89rescg  cooprescggmv89 cpp1 funcinpec cpp2

********VAR MODELS****************** 

*Note how we display the results in the paper and appendix. We do not display results with both the government and dissident equations in the SAME table. 
*For comparison purposes, the results for both VAR equations are displayed in separate tables. 
                             
*Run on both weekly and monthly datasets
*Two v. MultiActor Models UNIDIMENSIONALSCALE
set more off
var gmv89alldissoc  alldissocgmv89  ,  lags(1) exog(cpp1 funcinpec cpp2) 
var gmv89tdk  tdkgmv89,  lags(1) exog(cpp1 funcinpec cpp2)            
var gmv89sikfunc sikfuncgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var gmv89kplnf  kplnfgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var gmv89rescg rescggmv89,  lags(1) exog(cpp1 funcinpec cpp2)


*MultiActor Coop & Hos Scales Broken up
set more off
var hosscalegmv89alldissoc hosscalealldissocgmv89  coopscalegmv89alldissoc    coopscalealldissocgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var hosscalegmv89tdk  hosscaletdkgmv89 coopscalegmv89tdk     coopscaletdkgmv89,  lags(1) exog(cpp1 funcinpec cpp2)            
var hosscalegmv89sikfunc hosscalesikfuncgmv89 coopscalegmv89sikfunc    coopscalesikfuncgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var hosscalegmv89kplnf  hosscalekplnfgmv89  coopscalegmv89kplnf   coopscalekplnfgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var hosscalegmv89rescg hosscalerescggmv89  coopscalegmv89rescg  coopscalerescggmv89,  lags(1) exog(cpp1 funcinpec cpp2)


*MultiActor Coop & Hos FREQUENCIES Broken up
var hosgmv89alldissoc hosalldissocgmv89  coopgmv89alldissoc    coopalldissocgmv89,  lags(1)  exog(cpp1 funcinpec cpp2)
var hosgmv89tdk  hostdkgmv89 coopgmv89tdk     cooptdkgmv89,  lags(1)  exog(cpp1 funcinpec cpp2)           
var hosgmv89sikfunc hossikfuncgmv89 coopgmv89sikfunc    coopsikfuncgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var hosgmv89kplnf  hoskplnfgmv89  coopgmv89kplnf   coopkplnfgmv89,  lags(1) exog(cpp1 funcinpec cpp2)
var hosgmv89rescg hosrescggmv89  coopgmv89rescg  cooprescggmv89,  lags(1) exog(cpp1 funcinpec cpp2)

*End .do file
***********************************
*NOTE: If first run on Cambodia Weeks data, repeat on Cambodia Months data or vice versa.

