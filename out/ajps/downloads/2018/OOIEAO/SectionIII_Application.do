***Lost in Aggregation***
***Cook and Weidmann*****
***August 26, 2018*********
***Section III App*******

clear all 

**set working directory here**
*cd "C:\Users\..."

**import data for analysis**
import delimited report_data_stata.csv, delimiter(",")

**install package for weighted least squares (if not already installed)**
findit wls0

sort event_id id 

**different treatments of outcome variable** 
recode scope (99 = .)
gen log_participants = ln( avg_num_participants )
gen max_participants = log_participants
gen reports = 1 if  !missing(avg_num_participants) 
gen first_part = log_participants 

**source dummies**
gen source_id_num = 0 if source_id == "AP"
recode source_id_num . = 1 if source_id == "AFP"
recode source_id_num . = 2 if source_id == "BBC"

***Table 3***
mixed log_par i.scope ||cowcode: ||event_id:, difficult iterate(200) //Model 5
mixed log_par i.scope i.source_id_num ||cowcode: ||event_id:, difficult iterate(200) //Model 6

collapse (firstnm) first_part (mean) log_participants (max) max_participants scope (count) reports, by( event_id ) cw
rename scope max_scope 
tab max_scope, gen(d) //generates dummies for max_scope varaible to be used in wls0 (as factor variables are not allowed)

reg first_par i.max_scope //Model 1
reg max_par i.max_scope //Model 2
reg log_par i.max_scope //Model 3
wls0 log_par d2 d3, wvar(reports) type(e2) //Model 4 
