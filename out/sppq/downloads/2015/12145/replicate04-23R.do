**************************************************************************
**************************************************************************
**Running this *.do file will replicate results from Palazzolo &        **
**Moscardelli, "Policy Crisis and Political Leadership:  Election Law   **
**Reform in the States after the 2000 Presidential Election."           **
**                                                                      **
**The model in the paper was estimated using STATA 9.                   **
**                                                                      **
**************************************************************************
**************************************************************************

* use "E:\SPPQ\Replication_Data_04-23R.dta"

*The model includes an interaction term which multiplies the winning 
*presidential candidate's margin of victory in a state and its residual vote 
*rate.  To compute this variable, we first recoded margin of victory so that
*closer races would be associated with higher values.

sum ffactor
gen ffrecode=43.451-ffactor
label var ffrecode "recoded margin of victory"

*Generate interaction used in model
*This variable already appears in the dataset
*Running this syntax without first deleting the existing variable 
*will produce an error message.

* gen ffrxrv = ffrecode * residvot
* label var ffrxrv "interaction of residvot and ffactor"

*Save the altered dataset

save "E:\SPPQ\Replication_Data_04-23R.dta", replace


* Estimate model with Florida (state=9) excluded

regress depvar leadindx ranney simple compound termrank culture ideology fiscalin lwv_act ffactor residvot ffrxrv commrec if state~=9



