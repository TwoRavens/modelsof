use $root\files\results\basecoef, clear
keep if paper == "BM"
sort CoefNum
mata select = st_data(.,"select")
sum select
global N = r(sum)

use results\JackknifeBM, clear
keep ResB*
global NN = _N
mata ResB = st_data(.,"ResB*"); ResB = select(ResB,select')
keep ResB1-ResB$N
mata st_store(.,.,ResB)	
save results\JackkniferedBM, replace
