pause on

do nasm_setup
foreach s in light WB surveys {
qui reg lrgdpch`s' if base_sample==1
predict rlrgdpch`s' if base_sample==1, resid
qui su rlrgdpch`s' if base_sample==1
*replace rlrgdpch`s'=(rlrgdpch`s'-r(mean))/r(sd) if base_sample==1
}

reg rlrgdpchlight rlrgdpchWB rlrgdpchsurveys if base_sample==1

reg rlrgdpchlight rlrgdpchsurveys   if base_sample==1
predict rrlrgdpchlight, resid
reg rlrgdpchWB rlrgdpchsurveys   if base_sample==1
predict rrlrgdpchWB, resid

reg rlrgdpchlight rlrgdpchWB  if base_sample==1
predict rrrlrgdpchlight, resid
reg rlrgdpchsurveys rlrgdpchWB    if base_sample==1
predict rrlrgdpchsurveys, resid

reg rrlrgdpchlight  rrlrgdpchWB if base_sample==1
global b1=_b[rrlrgdpchWB]
reg rrrlrgdpchlight  rrlrgdpchsurveys if base_sample==1
global b2=_b[rrlrgdpchsurveys]

scatter rrlrgdpchlight  rrlrgdpchWB if base_sample==1 & rrlrgdpchlight<=2, msiz(small) || function y=${b1}*x, range(rrlrgdpchWB ) ///
    legend(off) title("Scatter of Lights per Capita on GDP per Capita, Partial Relation", siz(4)) xtitle("Log GDP per Capita, Residuals") ///
	ytitle("Log Lights per Capita, Residuals") ylabel(,angle(horiz))
pause

scatter rrrlrgdpchlight  rrlrgdpchsurveys if base_sample==1, msiz(small) || function y=${b2}*x, range(rrlrgdpchsurveys ) ///
     legend(off) title("Scatter of Lights per Capita on Survey Means, Partial Relation", siz(4)) ///
	 xtitle("Log Survey Means, Residuals") ytitle("Log Lights per Capita, Residuals") ylabel(,angle(horiz))
pause

reg lrgdpchlight lrgdpchWB if base_sample==1
global a1=_b[_cons]
global b1=_b[lrgdpchWB]
scatter lrgdpchlight lrgdpchWB if base_sample==1, msiz(small) || function y=${a1}+${b1}*x, range(lrgdpchWB) ///
     legend(off) title("Scatter of Lights per Capita on GDP per Capita", siz(4)) ///
	 xtitle("Log GDP per Capita") ytitle("Log Lights per Capita") ylabel(,angle(horiz))
pause

reg lrgdpchlight lrgdpchsurveys if base_sample==1
global a1=_b[_cons]
global b1=_b[lrgdpchsurveys]
scatter lrgdpchlight lrgdpchsurveys if base_sample==1, msiz(small) || function y=${a1}+${b1}*x, range(lrgdpchsurveys) ///
     legend(off) title("Scatter of Lights per Capita on Survey Means", siz(4)) ///
	 xtitle("Log Survey Means") ytitle("Log Lights per Capita") ylabel(,angle(horiz))
pause
