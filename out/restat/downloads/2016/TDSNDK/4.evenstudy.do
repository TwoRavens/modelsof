*these are homebuilder stocks from Homebuilding - NEC industry classification on google finance.  spy is a etf for the s&p500

insheet using eventstudy.txt,clear
rename tol stock1
rename ryl stock2
rename bzh stock3
rename phm stock4
rename dh stock5
rename kbk stock6
rename wlh stock7
rename hxm stock8
drop stock8

reshape long stock, i(date) j (test)
graph twoway (lfit stock cs ) (scatter stock cs),ylabel(-.04 (.02) .06) xlabel(-.02 (.02) .04) xtitle("Case-Shiller Surprise") ytitle("Stock Price Change")


reg stock cs,cl(date)


*partial out the effect of the spy on housing stocks; get the movements that are unexplained by movements in broader market
reg stock spy
predict stockresid,r

graph twoway (lfit stockresid cs ) (scatter stockresid cs),ylabel(-.04 (.02) .06) xlabel(-.02 (.02) .04) xtitle("Case-Shiller Surprise") ytitle("Stock Price Change") 



*preferred
gen stock2=stock-spy
reg stock2 cs,cl(date)

graph twoway (lfit stock2 cs ) (scatter stock2 cs),ylabel(-.04 (.02) .06) xlabel(-.02 (.02) .04) xtitle("Case-Shiller Surprise") ytitle("Stock Price Change")  legend(off) 

graph export event.ps,replace
!ps2pdf event.ps event.pdf


**EXCLUDING OBSERVATIONS ASSOCIATED WITH LARGE CASE SHILLER SURPRISE

reg stock2 cs if cs<.03,cl(date)

