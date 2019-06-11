**Stata Do-Files Using Stata Version 14.2 for "Fiscal Accountability in Gubernatorial Elections"

**Notes to user: 1: Import data using file path where the dataset is saved on your computer**
**				 2: Seed for each bootstrap model must be set before each model is estimated or else standard errors will be slightly different each time due to different replication samples.

**Import Dataset**
use "Final_Published_Dataset_Fiscal_Accountability_in_Gubernatorial_Elections_SPPQ"

**Must clear panel data**
xtset, clear

**Commands for Table 1 Summary Statistics**
 summ incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if samp==1

**Commands for Models in Table 2 of the Article

**Main Bootstrap Model with Lagged DV for All Races Model (Column 1)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres
**Main Bootstrap with Lagged DV for Incumbent Races Model (Column 2)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1
**Main Bootstrap with Lagged DV for Cases of Unified Government Model (Column 3)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1
**Main Bootstrap Model with Lagged DV and Interactions with Governor's Budget Powers for All Races (Column 4)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres
**Main Bootstrap with Lagged DV and Interactions with Governor's Budget Powers for Incumbent Races (Column 5)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1
**Main Bootstrap with Lagged DV and Interactions with Governor's Budget Powers for Unified Government Races (Column 6)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1


**Commands to Create Figures 1-4 of Marginal Effects

**Figure 1 Marginal Effects of Fiscal Health Interacted with Governor's Budget Powers on Incumbent Party Vote Share in All Races
**Main Bootstrap Model with Lagged DV and Interactions with Governor's Budget Powers for All Races (Column 4)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres

**Creation of the Figure
margins, at(fiscalhealth=(-5 (5) 20) govbp=(2.5 3.5 4.5)) atmeans plot(level(90))
**Once the basic graphic was drawn from the marginal effects estimates, I used the graph editor in Stata to make changes to the following: (1) lines; (2) change to error bars; (3) legend labels for Budget Powers; (4) y-axis scale; and (5) titles. 

**Figures 2 and 3: 
*Main Bootstrap with Lagged DV and Interactions with Governor's Budget Powers for Incumbent Races (Column 5)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1

**Creation of Figure 2 Marginal Effects of Per Capita Spending Interacted with Governor's Budget Powers on Incumbent Party Vote Share in Incumbent Races
margins, at(eypcadjpercapspendrt=(-11 (5) 16) govbp=(2.5 3.5 4.5)) atmeans plot(level(90))
**Once the basic graphic was drawn from the marginal effects estimates, I used the graph editor in Stata to make changes to the following: (1) lines; (2) change to error bars; (3) legend labels for Budget Powers; (4) y-axis scale; and (5) titles. 

**Creation of Figure 3 Marginal Effects of Fiscal Health Interacted with Governor's Budget Powers on Incumbent Party Vote Share in Incumbent Races
margins, at(fiscalhealth=(-5 (5) 20) govbp=(2.5 3.5 4.5)) atmeans plot(level(90))
*Once the basic graphic was drawn from the marginal effects estimates, I used the graph editor in Stata to make changes to the following: (1) lines; (2) change to error bars; (3) legend labels for Budget Powers; (4) y-axis scale; and (5) titles. 

**Figure 4
**Main Bootstrap with Lagged DV and Interactions with Governor's Budget Powers for Unified Government Races (Column 6)
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1

**Creation of Figure 4 Marginal Effects of Per Capita Spending Interacted with Governor's Budget Powers on Incumbent Party Vote Share in Cases of Unified Government
margins, at(eypcadjpercapspendrt=(-11 (5) 16) govbp=(2.5 3.5 4.5)) atmeans plot(level(90))
*Once the basic graphic was drawn from the marginal effects estimates, I used the graph editor in Stata to make changes to the following: (1) lines; (2) change to error bars; (3) legend labels for Budget Powers; (4) y-axis scale; and (5) titles. 


**Model results from the specifications below do not appear in the article. They are either referenced in a footnote or are in tables from the online appendix.

**Footnote 2 - Models run with 2-year term variable
**Main Bootstrap Model with Lagged DV and 2-year term variable included for All Races*
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot elcy2yr   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres
**Main Bootstrap with Lagged DV and 2-year term variable included for Incumbent Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot elcy2yr   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1
**Main Bootstrap with Lagged DV and 2-year term variable included for Unified Government Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot elcy2yr   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1

**Footnote 3 - Alternative Measure of Fiscal Health (Dummy variable)
**Main Bootstrap Model with Lagged DV and 5% dummy for fiscal Health for All Races*
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fisheal5above  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres
**Main Bootstrap with Lagged DV and 5% dummy for fiscal health for Incumbent Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot    eypcadjpercapspendrt fisheal5above  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1
**Main Bootstrap with Lagged DV and 5% dummy for fiscal health for Unified Government Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot    eypcadjpercapspendrt fisheal5above  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1

**Footnote 8 Models - Models run with One-Year Change Real State Per Capita Spending
**Main Bootstrap Model with Lagged DV and One-Year Change in Real State Per Capita Spending*
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   yrspendrtch fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres
**Main Bootstrap with Lagged DV and One-Year Change in Real State Per Capita Spending for Incumbent Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   yrspendrtch fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1
**Main Bootstrap with Lagged DV and One-Year Change in Real State Per Capita Spending for Unified Government**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   yrspendrtch fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1
**Main Bootstrap Model with Lagged DV and Interactions with Governor's Budget Powers and One-Year Change in Real State Per Capita Spending for All Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.yrspendrtch##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres
**Main Bootstrap with Lagged DV and Interactions with Governor's Budget Powers and One-Year Change in Real State Per Capita Spending for Incumbent Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.yrspendrtch##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1
**Main Bootstrap with Lagged DV and Interactions with Governor's Budget Powers and One-Year Change in Real State Per Capita Spending for Unified Government Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.yrspendrtch##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1

**Models from Table 1A of the Online Appendix
**Random Effects Models with Fixed Effects For Year**
**Setting Panel Data**
xtset panel year
**Random-effects Model with Fixed Effects for Year for All Races**
xtreg  incum2ptytot laginc2ptytot eypcadjpercapspendrt  fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres i.year, re vce(robust)
**Random-effects Model with Fixed Effects for Year for Incumbent Races**
xtreg  incum2ptytot laginc2ptytot eypcadjpercapspendrt  fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres i.year if incumrunn==1, re vce(robust)
**Random-effects Model with Fixed Effects for Year for Unified Government Races** 
xtreg  incum2ptytot laginc2ptytot eypcadjpercapspendrt  fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres i.year if levug==1, re vce(robust)
**Random-effects Model with Fixed Effects for Year and Interactions with Governor's Budget Powers**
xtreg  incum2ptytot laginc2ptytot c.eypcadjpercapspendrt##c.govbp  c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres i.year, re vce(robust)
**Random-effects Model with Fixed Effects for Year and Interactions with Governor's Budget Powers for Incumbent Races**
xtreg  incum2ptytot laginc2ptytot C.eypcadjpercapspendrt##c.govbp  c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres i.year if incumrunn==1, re vce(robust)
**Random-effects Model with Fixed Effects for Year and Interactions with Governor's Budget Powers for Unified Government Races** 
xtreg  incum2ptytot laginc2ptytot c.eypcadjpercapspendrt##c.govbp  c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres i.year if levug==1, re vce(robust)


**Models from Table 2A and 3A of the Online Appendix
**Partisan Effect Models

**Models from Table 2A of the Online Appendix
**Must Clear Panel Data
xtset, clear
**Bootstrap Model with lagged DV for All Races by Party**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumpty==1
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumpty==0
**Bootstrap Model with Lagged DV for Incumbent Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1 & incumpty==1
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1 & incumpty==0
**Bootstrap Model with Lagged DV for Unified Government Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1 & incumpty==1
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1 & incumpty==0

**Partisan Effect Models**
**Models from Table 3A of the Online Appendix
**Bootstrap Model with Lagged DV and Interactions with Governor's Budget Powers for All Races by Party**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumpty==1
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumpty==0
**Bootstrap Model with Lagged DV and Interactions with Governor's Budget Powers for Incumbent Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1 & incumpty==1
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if incumrunn==1 & incumpty==0
**Bootstrap Model with Lagged DV and Interactions with Governor's Budget Powers for Unified Government Races**
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1 & incumpty==1
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if levug==1 & incumpty==0

**The Impact of Fiscal Health and Spending at Various Levels of Economic Growth (referenced in text)**
**Bootstrap Model at Low Levels of Economic Growth (below 1 SD below mean of % change in real state per capita income) for All Races
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if chadjpcincome<-1.4 
**Bootstrap Model at Moderate Levels of Economic Growth (above 1 SD below the mean and below 1 SD above mean of % change in real state per capita income) for All Races
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if chadjpcincome>-1.4 & chadjpcincome<12.2
**Bootstrap Model at Low Levels of Economic Growth (above 1 SD above mean of % change in real state per capita income) for All Races
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   eypcadjpercapspendrt fiscalhealth  chadjpcincome chnatpcismptypres presappr govbp incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if chadjpcincome>12.2

**All Races Models with Interactions with Governor's Budget Powers at Various Levels of Economic Growth (referenced in text)**
**Bootstrap Model with Interactions with Governor's Budget Powers at Low Levels of Economic Growth (below 1 SD below mean of % change in real state per capita income) for All Races
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if chadjpcincome<-1.4
**Bootstrap Model with Interactions with Governor's Budget Powers at Moderate Levels of Economic Growth (above 1 SD below the mean and below 1 SD above mean of % change in real state per capita income) for All Races
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if chadjpcincome>-1.4 & chadjpcincome<12.2
*Bootstrap Model with Interactions with Governor's Budget Powers at Low Levels of Economic Growth (above 1 SD above mean of % change in real state per capita income) for All Races
**Set seed for replications**
set seed 5
bootstrap, rep(1000) cluster(panel): reg  incum2ptytot laginc2ptytot   c.eypcadjpercapspendrt##c.govbp c.fiscalhealth##c.govbp  chadjpcincome chnatpcismptypres presappr incumrunn   logincsppervot logchallsppervot levug  favcideo codeficit  presmdterm govsmptypres mdterxsmptypres if chadjpcincome>12.2

**Note: N was too small for incumbent races and cases of unified government to estimate at various levels of economic growth.

**Footnote 9 - **Fiscal Health at Various Levels of % Change in Real State Per Capita Income**
**Fiscal Health at Low Levels of % Change in Per Capita Income (below 1 SD below mean)**
summ fiscalhealth if chadjpcincome<-1.4 & samp==1
**Fiscal Health at Moderate Levels of % Change in Per Capita Income(above 1 SD below mean and below 1 SD above mean)**
summ fiscalhealth if chadjpcincome>-1.4 & chadjpcincome<12.2 & samp==1
**Fiscal Health at High Levels of % Change in Per Capita Income (above 1 SD above mean)**
summ fiscalhealth if chadjpcincome>12.2 & samp==1
