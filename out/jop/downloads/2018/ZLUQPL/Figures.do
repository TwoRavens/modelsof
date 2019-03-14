*Figure 1
use "Figures.dta", clear

serrbar mean_incdiff se_incdiff treat, scale(1.41) ///
xlabel(0 " " 1 "Upward comparison" 2 "Control" 3 "Downward comparison" 4 " ") ///
yscale(range(-.4 .4)) ylabel(-.4(.1).4) xtitle("") ytitle("") ///
title("Gov't Reduce Income Differences")

 
serrbar mean_spend se_spend treat, scale(1.41) ///
xlabel(0 " " 1 "Upward comparison" 2 "Control" 3 "Downward comparison" 4 " ") ///
yscale(range(-.4 .4)) ylabel(-.4(.1).4) xtitle("") ytitle("") ///
title("Redistributive Spending Scale") 

*Play "Fig1edits.grec" from Graph Editor to format the figure as shown in Figure 1


*Figure 2
serrbar mean se treat2, scale(1.41) ///
xlab(1(1)12) yscale(range(-.3 .3)) ylabel(-.3(.1).3) xtitle("") ytitle("")
*Play "Fig2edits.grec" from Graph Editor to format the figure as shown in Figure 2



