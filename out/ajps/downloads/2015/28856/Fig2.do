
* REPLICATION CODE: JENNINGS & WLEZIEN, 'THE COMPARATIVE TIMELINE OF ELECTIONS', AMERICAN JOURNAL OF POLITICAL SCIENCE *

* FIGURE 2 

use LONG_MI.dta, clear

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==900 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("900 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_900, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==500 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("500 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_500, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==300 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("300 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_300, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==200 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("200 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_200, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==150 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("150 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_150, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==100 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("100 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_100, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==75 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("75 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_075, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==50 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("50 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_050, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==30 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("30 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_030, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==20 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("20 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_020, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==10 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("10 Days") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_010, replace) 

* 
scatter /*
*/ vote_ poll_ /*
*/ if daysbeforeED==1 /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ msymbol(circle_hollow) /*
*/ xtitle("Polls") /*
*/ ytitle("Vote") /*
*/ title("1 Day") /*
*/ ytick(0(20)100) /*
*/ ylabel(0(20)100, gmax angle(horizontal)) /*
*/ xscale(titlegap(2)) /*
*/ xlabel(0(20)100) /*
*/ legend(off) /*
*/ saving(scatter_001, replace) 

graph combine scatter_900.gph scatter_500.gph scatter_300.gph scatter_200.gph scatter_150.gph scatter_100.gph scatter_075.gph scatter_050.gph scatter_030.gph scatter_020.gph scatter_010.gph  scatter_001.gph, saving(Fig2.gph, replace)
graph export Fig2.tif
