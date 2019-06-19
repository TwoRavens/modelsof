****** DO FILE for running all tables *******

set more off

*** PLEASE SET PATH ***
*local folderpathPaper /Users/usename/Desktop/ReplicationFiles/Codes/Paper/Figures
*local folderpathOA /Users/username/Desktop/ReplicationFiles/Codes/OA/Figures


cd `folderpathPaper'
* quietly run Paper Figures
run "`folderpathPaper'/Fig3a_bw.do"
run "`folderpathPaper'/Fig3b_bw.do"
run "`folderpathPaper'/Fig5ab_bw.do"


cd `folderpathOA'
* quietly run OA Figures
run "`folderpathOA'/OA_Fig1b.do"
run "`folderpathOA'/OA_Fig5.do"
run "`folderpathOA'/OA_Fig7.do"
run "`folderpathOA'/OA_Fig8.do"
