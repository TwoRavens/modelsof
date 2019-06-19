****** DO FILE for running all tables *******

set more off

*** PLEASE SET PATH ***
*local folderpathPaper /Users/username/Desktop/ReplicationFiles/Codes/Paper/Tables
*local folderpathOA /Users/username/Desktop/ReplicationFiles/Codes/OA/Tables
*local folderpathData /Users/username/Desktop/ReplicationFiles/Data/Main

* quietly run the Data Generating Files
run "`folderpathData'/PrepData.do"

cd "`folderpathOA'"
* quietly run
run "`folderpathPaper'/Table2.do"

cd `folderpathOA'
* quietly run OA Tables
run "`folderpathOA'/OA_Tab2.do"
run "`folderpathOA'/OA_Tab3.do"
run "`folderpathOA'/OA_Tab4.do"
run "`folderpathOA'/OA_Tab5.do"
run "`folderpathOA'/OA_Tab5_fig.do"
run "`folderpathOA'/OA_Tab8.do"
* run "`folderpathOA'/OA_Tab9.do"
* not reproducible due to data confidentiality
run "`folderpathOA'/OA_Tab10.do"
run "`folderpathOA'/OA_Tab12.do"
run "`folderpathOA'/OA_Tab12_fig.do"
run "`folderpathOA'/OA_Tab13.do"

run "`folderpathPaper'/Table1.do"

** longer runtime
run "`folderpathOA'/OA_Tab11.do"

** very long run time (approx 3-4 hours)
run "`folderpathOA'/OA_Tab_6_Tab7_NLLS_call.do"
* table 3 needs output from OA_Tab6_Tab7
run "`folderpathPaper'/Table3.do"
