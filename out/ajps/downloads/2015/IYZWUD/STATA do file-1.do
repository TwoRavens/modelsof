version 13
use "C:\Users\Ian-Laptop\Dropbox\Executive Nominations\Article-Delay\AJPS Public Data\exec noms 100-112.

* Figure 1: Kaplan-Meier Survivor Function for Executive Nominations
  sts graph, ylabel(0(.2)1) xlabel(0(100)700) title("") ytitle("Proportion of Nominees Remaining") xtitle("Days Since Nomination") graphregion(color(white))


* Table 1: Time to Decision by Presidential Term & Congress
mean delay, over(congress)
tab congress


* Table 2: Delay Time in Days by Level of Position
mean delay, over(tier)


* Table 3: Duration of Nomination Decisions in the 100 to 112 Congresses

 xi: streg sendivide polarization pres_app_m first90 preselection lameduck i.idprez i.tier female priorconfirm workload defense Infrastructure Social, dist(weibull)


* Figure 2: Predicted Hazard Ratios
*    This Figure uses results from the output of the model described in 
*    Table 3 above.  R was used to create the figure and the code is
*    found in the associated R file.


* Duration Model (Table 3) without Agency Ideology Scores (Footnote 4)

 xi: streg sendivide polarization pres_app_m first90 preselection lameduck i.tier female priorconfirm workload defense Infrastructure Social, dist(weibull)
