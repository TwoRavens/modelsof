*SPPQ "Access Denied: Investigating Voter Registration Rejections in Florida
*Author: Thessalia Merivaki (lia.merivaki@pspa.msstate.edu)
*Replication file for all analysis in manuscript
*Date: July 2, 2018


*Figure 1: statewide monthly submissions per method of voter registration
use "SPPQ-FL 2012 Statewide Monthly dataset 1.2.dta", replace
twoway (line perdmv monthid ) (line  permail monthid ) (line  perstateagencies monthid ) ( line perpublicagencies monthid ) (line  perPVRO monthid ) (line  perSoE monthid )
graph save "Fig.1 Monthly Per VR Submissions Statewide JanDec2012 GRAPH.gph", replace
*Open Stata graph editor to edit the graph:
**Y-axis rule: Label size: medium-small, label angle: horizontal. Click "Edit or add individual ticks and labels". Edit 0: 0%, click "custom style": Color: Black, Size: Medum Small, Angle: Horizontal, Text gap: 0.6944. Repeat for 20, 40, 60, 80, 100.
**X-axis rule: Label size: medium-small, lavel angle: horizontal. Click "Range Delta" Min: 1, Max: 12, Delta:1. Click "Edit or add individual ticks and labels". Edit 1: Jan, 2: Feb, and repeat until 12: Dec. 
**Double-click on "monthid" box, delete text, Apply
** Double-clik on graph line description box. Click on "perdmv" until "Textbox properties" box opens. Replace "perdmv" with DMV, "perstateagencies" with State Agencies, "perPVRO" with Registration Drives, "permail" with Mail Applications, "perpublicagencies" with Public Agencies, and "perSOE" with In-Person.
** Line for DMV: Color: Dark Navy, Width: Medium, Pattern: Solid
** Line for State Agencies: Color: Dark Navy, Width: Medium, Pattern: Short-dash dot
** Line for Registration Drives: Color: Dark Navy, Width: Medium, Pattern: Short-dash
** Line for Mail Applications: Color: Dark Navy, Width: Medium, Pattern: Long-dash
** Line for Public Agencies: Color: Dark Navy, Width: Medium, Pattern: Dash 3-dots
** Line for In-Person: Color: Dark Navy, Width: Medium, Pattern: Long-dash short-dash
** Click on light blue space: Color: White, Scale 1: Colums: 2

*Figure 2: Time-series county/month submissions per method of voter registration 
use "SPPQ-FL 2012 County per month time-series dataset 1.2.dta", replace

twoway (line perdmv monthid ) (line permail monthid) (line perstateagencies monthid) (line perpublicagencies monthid) (line per3pvro monthid) (line persoe monthid) if countid==16
graph save "Fig2_2012 submissionrates_agency_MIA GRAPH.gph", replace


twoway (line perdmv monthid ) (line permail monthid) (line perstateagencies monthid) (line perpublicagencies monthid) (line per3pvro monthid) (line persoe monthid) if countid==66

graph save "Fig2_2012 submissionrates_agency_WAL GRAPH.gph", replace
gr combine "Fig2_2012 submissionrates_agency_MIA GRAPH.gph" "Fig2_2012 submissionrates_agency_WAL GRAPH.gph"
graph save "Fig2_2012 graphcombined MIAWAL.gph", replace

*Open Stata graph editor to edit the graph: 
*Left Graph (Miami-Dade), Right Graph (Walton)
**Y-axis rule: Label size: medium-small, label angle: horizontal. Click "Edit or add individual ticks and labels". Click "Edit or add individual ticks and labels". Edit 0: 0%, click click "custom style": Color: Black, Size: Small, Angle: Horizontal, Text gap: 0.6944. Repeat for 20, 40, 60, 80, 100.
**X-axis rule: Label size: small, lavel angle: horizontal. Click "Range Delta" Min: 1, Max: 12, Delta:1. Click "Edit or add individual ticks and labels". Edit 1: Jan, 2: Feb, and repeat until 12: Dec. 
**Double-click on "monthid" box, delete text, Apply
** Double-clik on graph line description box. Click on "perdmv" until "Textbox properties" box opens. Replace "perdmv" with DMV, "perstateagencies" with State Agencies, "perPVRO" with Registration Drives, "permail" with Mail Applications, "perpublicagencies" with Public Agencies, and "perSOE" with In-Person.
** Line for DMV: Color: Dark Navy, Width: Medium, Pattern: Solid
** Line for State Agencies: Color: Dark Navy, Width: Medium, Pattern: Short-dash dot
** Line for Registration Drives: Color: Dark Navy, Width: Medium, Pattern: Short-dash
** Line for Mail Applications: Color: Dark Navy, Width: Medium, Pattern: Long-dash
** Line for Public Agencies: Color: Dark Navy, Width: Medium, Pattern: Dash 3-dots
** Line for In-Person: Color: Dark Navy, Width: Medium, Pattern: Long-dash short-dash
** Click on light blue font box: Color: White, Scale 1: Colums: 2. same for any light blue boxes.
*****REPEAT FOR SECOND GRAPH
** Graph on the left: Insert text box on top left: Text: Miami-Dade County, in Color: Teal, Size: Medium-Small, Margin:Zero. Insert second text box below first. Text: 1,316 persons/sq. mile, Color: Team, Size: Small, Margin: Zero.
** Graph on the right: Insert text box on top left: Text: Walton County, in Color: Teal, Size: Medium-Small, Margin:Zero. Text: 53 persons/sq. mile, Color: Team, Size: Small, Margin: Zero.

twoway (line perdmv monthid ) (line permail monthid) (line perstateagencies monthid) (line perpublicagencies monthid) (line per3pvro monthid) (line persoe monthid) if countid==52
graph save "Fig2_2012 submissionrates_agency_PIN GRAPH.gph", replace

twoway (line perdmv monthid ) (line permail monthid) (line perstateagencies monthid) (line perpublicagencies monthid) (line per3pvro monthid) (line persoe monthid) if countid==51
graph save "Fig2_2012 submissionrates_agency_PAS GRAPH.gph", replace
gr combine "Fig2_2012 submissionrates_agency_PIN GRAPH.gph" "Fig2_2012 submissionrates_agency_PAS GRAPH.gph"
graph save "Fig2_2012 graphcombined PINPAS.gph", replace
*Open Stata graph editor to edit the graph: 
*Left Graph (Pinellas), Right Graph (Pasco)
**Y-axis rule: Label size: medium-small, label angle: horizontal. Click "Edit or add individual ticks and labels". Click "Edit or add individual ticks and labels". Edit 0: 0%, click click "custom style": Color: Black, Size: Small, Angle: Horizontal, Text gap: 0.6944. Repeat for 20, 40, 60, 80, 100.
**X-axis rule: Label size: small, lavel angle: horizontal. Click "Range Delta" Min: 1, Max: 12, Delta:1. Click "Edit or add individual ticks and labels". Edit 1: Jan, 2: Feb, and repeat until 12: Dec. 
**Double-click on "monthid" box, delete text, Apply
** Double-clik on graph line description box. Click on "perdmv" until "Textbox properties" box opens. Replace "perdmv" with DMV, "perstateagencies" with State Agencies, "perPVRO" with Registration Drives, "permail" with Mail Applications, "perpublicagencies" with Public Agencies, and "perSOE" with In-Person.
** Line for DMV: Color: Dark Navy, Width: Medium, Pattern: Solid
** Line for State Agencies: Color: Dark Navy, Width: Medium, Pattern: Short-dash dot
** Line for Registration Drives: Color: Dark Navy, Width: Medium, Pattern: Short-dash
** Line for Mail Applications: Color: Dark Navy, Width: Medium, Pattern: Long-dash
** Line for Public Agencies: Color: Dark Navy, Width: Medium, Pattern: Dash 3-dots
** Line for In-Person: Color: Dark Navy, Width: Medium, Pattern: Long-dash short-dash
** Click on light blue font box: Color: White, Scale 1: Colums: 2. same for any light blue boxes.
*****REPEAT FOR SECOND GRAPH
** Graph on the left: Insert text box on top left: Text: Pinellas County, in Color: Teal, Size: Medium-Small, Margin:Zero. Insert second text box below first. Text: 3,486 persons/sq. mile, Color: Team, Size: Small, Margin: Zero.
** Graph on the right: Insert text box on top left: Text: Walton County, in Color: Teal, Size: Medium-Small, Margin:Zero. Text: 664 persons/sq. mile, Color: Team, Size: Small, Margin: Zero.


*Figure 3: statewide rejections per month, average county rejections per population density, county rejections in October
*Figure 3a: statewide voter registration rejections per month
use "SPPQ-FL 2012 Statewide Monthly dataset 1.2.dta", replace
twoway (bar perrejected monthid)
graph save "Fig3a statewiderejections barGRAPH.gph", replace

*Figure 3b: Average county rejections January-December 2012 per population density
use "SPPQ-FL Aggregated January_December county dataset for Fig3 1.2.dta"

*code for Figure 3b
twoway scatter perreject popdensity_2012, mlabel(countyabr)
graph save "Scatter Average rejections_ppldensity 12months GRAPH.gph", replace

*Combine Figs 3a and 3b
gr combine "Fig3a statewiderejections barGRAPH.gph" "Scatter Average rejections_ppldensity 12months GRAPH.gph"
graph save "Fig3a3b combined Graph.gph", replace
*Open Stata graph editor to edit the graph:
*Left Graph (bar graph), Right Graph (Scatter)
**Y-axis rule: Label size: Medium Small, Label Angle: horizontal. Click "Range Delta: Min:0, Max: 25, Delta 5. "Click "Edit or add individual ticks and labels". Edit 0: 0%, click click "custom style": Color: Black, Size: Medium Small, Angle: Horizontal, Text gap: 0.6944. Repeat for 5, 10, 15, 20, 25.
**X-axis rule: Label size: small, lavel angle: horizontal. Click "Range Delta" Min: 1, Max: 12, Delta:1. Click "Edit or add individual ticks and labels". Edit 1: Jan, 2: Feb, and repeat until 12: Dec. Click "Custom label", Size: small, Angle: Horizontal, Text gap: 0.6944.
**Plottype: Width=.5
**Double-click on "monthid" box, delete text, Apply. repeat for "%rejected" text box
**Click on light blue font box: Color: White, Scale:2 1, Colums: 2, same for any light blue boxes.
*Right Graph
**Y-axis rule: Label size: Medium Small, Label Angle: horizontal. Click "Range Delta: Min:0, Max: 20, Delta 2.5. "Click "Edit or add individual ticks and labels". Click "Edit or add individual ticks and labels". Edit 0: 0%, click click "custom style": Color: Black, Size:  Medium Small, Angle: Horizontal, Text gap: 0.6944. Repeat for 2.5, 7.5, 10, 12.5, 15, 17.5.
**Double-click on "perRejected" box, delete text, Apply
**X-axis rule: Label size: small, lavel angle: horizontal. Click "Range Delta" Min: 10, Max: 40000, Delta:500. Click "Edit or add individual ticks and labels". Edit 10: 10 (for consistent visual and because min is 10), 510: 500, and repeat until 4,010: 4,000. Click "Custom label", Size: small, Angle: Horizontal, Text gap: 0.6944.
**Double-click on "popdensity_2012" box, delete text, Apply
**Insert text box below scatterplot: Text: Persons per sq. mile, Size: Medium Small, Color: teal, Margin: Zero.

 
*Figure 3c: County voter registration rejections in October per population density
use "SPPQ-FL 2012 County per month time-series dataset 1.2.dta", replace

twoway scatter perrejected rescalepopdensity if monthid==10, mlabel( countyabr)
graph save "Scatter Average rejections_ppldensity October GRAPH.gph", replace
**Open Stata graph editor to edit the graph:
**Y-axis rule: Label size: Medium Small, Label Angle: horizontal. Click "Range Delta: Min:0, Max: 40, Delta 10. "Click "Edit or add individual ticks and labels". Edit 0: 0%, click click "custom style": Color: Black, Size: Medium Small, Angle: Horizontal, Text gap: 0.6944. Repeat for 10, 20, 30, 40.
**X-axis rule: Label size: Medium small, lavel angle: horizontal. Click "Range Delta" Min: 10, Max: 40000, Delta:500. Click "Edit or add individual ticks and labels". Edit 10: 10 (for consistent visual and because min is 10), 510: 500, and repeat until 4,010: 4,000. Click "Custom label", Size: Medium small, Angle: Horizontal, Text gap: 0.6944.
**Double-click on "popdensity_2012" box, delete text, Apply
**Double-click on "perRejected" box, delete text, Apply
**Insert text box on top of scatterplot: Text: County Rejections in October , Size: Medium Small, Color: teal, Margin: Zero.
**Click on light blue font box: Color: White, same for any light blue boxes.


*Feasible GLS regressions and coefficient plots for Figures 4 and 5

***Regressions
*open "SPPQ-FL 2012 County per month time-series dataset 1.2.dta"

*volume of applications highly correlated with population density (corr 68%). Will remove volume as an IV
corr wkapplicationsreceived wpopdensity_2012

*Figure 4; Model 1: Impact of voter registration methods on voter registration rejections in Florida in 2012

*Baseline Methods FGLS with robust S.Es, clustered by county
reg wperrejected wperdmv wpermail wper3pvro wperstateagencies wperpublicagencies wpersoe soepid20120d wpopdensity_2012 w, cluster(countid) robust noc
findit coefplot
*click to install the package
*only plot stat. significant coefficients
coefplot, drop(w wperdmv wperstateagencies wpersoe soepid20120d wpopdensity_2012) xline(0)
graph save "FIG4Baseline TimeSeries GRAPH.gph", replace
*full coeffs in Appendix
*Open Stata Graph editor to edit the graph:
*Y-line Axis rule:Label size: Small, Label Angle: horizontal. "Click "Edit or add individual ticks and labels". Edit wpermail: Mail Applications, wper3pvro: Applications via registration Drives, wperpublicagencies: Applications in Public Agencies. 
*X-line Axis rule: Label size: Small, Label Angle: horizontal. Click "Range Delta": Min:-6, Max: 0, Delta 2. "Click "Edit or add individual ticks and labels". Click "Custom style" on each label, Color: Black, Size: Small, Angle: Horizontal, Text gap: 0.6944.
**Click on light blue font box: Color: White, same for any light blue boxes.

**Figure 5: Seasonal and Administrative Impact on Rates of Voter Registration Rejections in Florida in 2012
****** On differences between clustering and fixed effects: *https://stats.stackexchange.com/questions/185378/when-to-use-fixed-effects-vs-using-cluster-ses

*Model 2: FGLS Time-Fixed Effects with robust S.Es, clustered by county
reg wperrejected wperdmv wpermail wper3pvro wperstateagencies wperpublicagencies wpersoe soepid20120d wpopdensity_2012 w Jan Feb Mar Apr May Jun Jul Aug Oct Nov Dec , cluster(countid) robust noc
coefplot, drop(w wperdmv wpermail wper3pvro wperstateagencies  wpersoe soepid20120d Jan Jul Aug Oct Nov Dec) xline(0)
graph save "FIG4TimeFixed GRAPH.gph", replace

*testing for equality of month coefficients
test Jan=Feb=Mar=Apr=May=Jun=Jul=Aug=Oct=Nov=Dec
*F(10,66)= 9.14, prob=.000
*as expected, statistically significant at p=.000

*Model3: FGLS time-fixed and county-fixed with robust s.es, Pinellas is reference county

reg wperrejected wperdmv wpermail wper3pvro wperstateagencies wperpublicagencies wpersoe soepid20120d wpopdensity_2012 w Jan Feb Mar Apr May Jun Jul Aug Oct Nov Dec ALA BAK BAY BRA BRE BRO CAL CHA CIT CLA CLL CLM DAD DES DIX DUV ESC FLA FRA GAD GIL GLA GUL HAM HAR HEN HER HIG HOL HIL IND JAC JEF LAF LAK LEE LEO LEV LIB MAD MAN MON MRN MRT NAS OKA OKE ORA OSC PAL PAS POL PUT SAN SAR SEM STJ STL SUM SUW TAY UNI VOL WAK WAL WAS , robust noc
coefplot, drop(w wperdmv wperstateagencies wper3pvro wpersoe  popdensity_2012  Jan Mar Apr May Jul  Aug Nov Dec  BAK BAY BRA BRE BRO CIT CLA CLL CLM DAD DES DUV ESC FLA FRA GAD GIL GLA GUL HAM HAR HEN HIG HOL HIL JEF LAF LAK LIB MRT NAS OKA OKE ORA OSC PAS POL PUT SAN SEM STJ STL SUW TAY UNI VOL WAK WAS) xline(0)

 *testing for equality of county coefficients
 test ALA=BAK=BAY=BRA=BRE=BRO=CAL=CHA=CIT=CLA=CLL=CLM=DAD=DES=DIX=DUV=ESC=FLA=FRA=GAD=GIL=GLA=HAM=HAR=HEN=HER=HIG=HOL=HIL=IND=JAC=JEF=LAF=LAK=LEE=LEO=LEV=LIB=MAD=MAN=MON=MRN=MRT=NAS=OKA=OKE=ORA=OSC=PAL=PAS=POL=PUT=SAN=SAR=SEM=STJ=STL=SUM=SUW=TAY=UNI=VOL=WAK=WAL=WAS
*F(64, 715)=8.42, prob=.000
 *as expected, statistically significant at p=.000
graph save "FIG4Time and County Fixed GRAPH.gph", replace
gr combine "FIG4TimeFixed GRAPH.gph" "FIG4Time and County Fixed GRAPH.gph"
graph save "Fig4 Combined Time and County Fixed GRAPH", replace
**Open Stata Graph Editor to edit the graphs:
*Left graph (Model 2), Right graph (Model 3)
*Y-Axis rule: Label size: Small, Label Angle: horizontal. "Click "Edit or add individual ticks and labels". Edit wperpublicagencies: Applications in Public Agencies, popdensity_2012: Population Density, Feb: February, Mar: March, Apr: April, May: May, Jun: June. 
*X-Axis rule: No edits. 

*Y-Axis rule: Label size: Small, Label Angle: horizontal. "Click "Edit or add individual ticks and labels". Edit wpermail: Mail Applications, wperpublicagencies: Applications in Public Agencies, soepid20120d: Republican Supervisor of Elections, popdensity_2012: Population Density, Feb: February, Jun: June, Oct: October, Ala: Alachua, Cal, Calhoun, Cha: harlotte, Dix: Dixie, Her: Hernando, Ind: Indian River, Jac: Jackson, Lee: Lee, Leo; Leon, Lev: Levy, Mad: Madison, Man: Manatee, Mon: Monroe, Mrn: Marion, Pal: Palm Beach, Sar: Sarasota, Sum: Sumter, Wal: Walton.
*X-Axis rule: No edits. 
**Click on light blue font box: Color: White, same for any light blue boxes.

































