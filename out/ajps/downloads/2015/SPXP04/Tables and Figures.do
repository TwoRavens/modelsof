use AJPSVetoRhetoric

**Calculating Weights**
	*All Riders weight*
	tab threatened othsource if removed !=1  & (crs==0 | crs== 1 & othsource ==1), col
	replace weight=.60 if threatened==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1)
	replace weight=1.14 if threatened==0 & removed !=1  & (crs==0 | crs== 1 & othsource ==1)
	
	*HAC House weight*
	tab threatened othsource if hacorigin ==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1), col
	replace weightHAChouse=.65 if threatened==1 & hacorigin ==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1)
	replace weightHAChouse=1.22 if threatened==0 & hacorigin ==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1)

	*HAC Senate weight*
	tab threatened othsource if hacorigin ==1 & removed !=1  & removedhf!=1 & (crs==0 | crs== 1 & othsource ==1), col
	replace weightHACsenate=.66 if threatened==1 & hacorigin ==1 & removed !=1  & removed!=2 & (crs==0 | crs== 1 & othsource ==1)
	replace weightHACsenate=1.23 if threatened==0 & hacorigin ==1 & removed !=1  & removed!=2 & (crs==0 | crs== 1 & othsource ==1)

	*HAC Senate NO SKIP weight*
	tab threatened othsource if hacorigin ==1 & removed !=1  & removedhf!=1 & (crs==0 | crs== 1 & othsource ==1) & skipsenate==0, col
	replace weightHACsenateNOSKIP=.69 if threatened==1 & hacorigin ==1 & removed !=1  & removed!=2 & skipsenate==0 &(crs==0 | crs== 1 & othsource ==1)
	replace weightHACsenateNOSKIP=1.15 if threatened==0 & hacorigin ==1 & removed !=1  & removed!=2 & skipsenate==0 &(crs==0 | crs== 1 & othsource ==1)
	
**Table 1**
	tab congress houseopp 
	tab congress opposen
	tab congress dempres
	tab congress origin if threatened==1

**Table 2**
	*Model 1*
	logit threatened  hacorigin  houseoppo opposen preshoneymoon  HACDaysBeforeDeadline wbush clinton if   (crs==0 | crs== 1  & othsource ==1) [pweight=weight], cluster(billnum )
	*Model 2*
	logit threatened  houseoppo opposen preshoneymoon  HACDaysBeforeDeadline wbush clinton if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) [pweight=weightHAChouse], cluster(billnum )
	*Model 3*
	logit willveto  hacorigin  houseoppo opposen preshoneymoon  HACDaysBeforeDeadline wbush clinton if   (crs==0 | crs== 1  & othsource ==1) [pweight=weight], cluster(billnum )
	*Model 4*
	logit willveto  houseoppo opposen preshoneymoon  HACDaysBeforeDeadline wbush clinton if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) [pweight=weightHAChouse], cluster(billnum )

**Figure 1**

	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1985 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1986 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1987 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1988 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1989 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1990 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1991 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1992 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1993 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1994 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1995 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1996 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1997 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1998 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1999 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2000 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2001 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2002 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2003 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2004 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2005 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2006 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2007 [aweight=weightHAChouse]
	sum HACDaysBeforeDeadline if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2008 [aweight=weightHAChouse]

**Figure 1-- Predicted Values and 95% Confidence Intervals**	
	
	logit threatened  houseoppo opposen preshoneymoon  HACDaysBeforeDeadline wbush clinton if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) [pweight=weightHAChouse], cluster(billnum )
	*Congress 99-1, 1985*
	margins, at(houseoppo=1 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=54.86667 wbush=0 clinton=0)
	*Congress 99-2, 1986*
	margins, at (houseoppo=1 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=75  wbush=0 clinton=0) 
	*Congress 100-1, 1987*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=102.25 wbush=0 clinton=0)
	*Congress 100-2, 1988*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=118.32 wbush=0 clinton=0)
	*Congress 101-1, 1989*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=1 HACDaysBeforeDeadline=65.56 wbush=0 clinton=0)
	*Congress 101-2, 1990*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=47.50 wbush=0 clinton=0)
	*Congress 102-1, 1991*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=115.96 wbush=0 clinton=0)
	*Congress 102-2, 1992*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=94.87 wbush=0 clinton=0)
	*Congress 103-1, 1993*
	margins, at (houseoppo=0 opposen=0 preshoneymoon=1 HACDaysBeforeDeadline=92.96 wbush=0 clinton=1)
	*Congress 103-2, 1994*
	margins, at (houseoppo=0 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=117.67 wbush=0 clinton=1)
	*Congress 104-1, 1995*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=78.70 wbush=0 clinton=1)
	*Congress 104-2, 1996*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=91.83 wbush=0 clinton=1)
	*Congress 105-1, 1997*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=71.83 wbush=0 clinton=1)
	*Congress 105-2, 1998*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=81.14 wbush=0 clinton=1)
	*Congress 106-1, 1999*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=-7.58 wbush=0 clinton=1)
	*Congress 106-2, 2000*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=118.56 wbush=0 clinton =1)
	*Congress 107-1, 2001*
	margins, at (houseoppo=0 opposen=1 preshoneymoon=1 HACDaysBeforeDeadline=70.75 wbush=1 clinton=0)
	*Congress 107-2, 2002*
	margins, at (houseoppo=0 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=79.90 wbush=1 clinton=0)
	*Congress 108-1, 2003*
	margins, at (houseoppo=0 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=75.44 wbush=1 clinton=0)
	*Congress 108-2, 2004*
	margins, at (houseoppo=0 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=63.40 wbush=1 clinton=0)
	*Congress 109-1, 2005*
	margins, at (houseoppo=0 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=109.43 wbush=1 clinton=0)
	*Congress 109-2, 2006*
	margins, at (houseoppo=0 opposen=0 preshoneymoon=0 HACDaysBeforeDeadline=127.58 wbush=1 clinton=0)
	*Congress 110-1, 2007*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=95.41 wbush=1 clinton=0)
	*Congress 110-2, 2008*
	margins, at (houseoppo=1 opposen=1 preshoneymoon=0 HACDaysBeforeDeadline=69.00 wbush=1 clinton=0)
	
**Figure 1-- Actual Values**
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1985 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1986 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1987 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1988 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1989 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1990 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1991 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1992 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1993 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1994 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1995 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1996 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1997 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1998 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==1999 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2000 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2001 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2002 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2003 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2004 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2005 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2006 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2007 [aweight=weightHAChouse]
	sum threatened if hacorigin==1&  (crs==0 | crs== 1  & othsource ==1) & year==2008 [aweight=weightHAChouse]

**Table 3**
	*Model 1*
	logit filibuster inthreatenedbill SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
	*Model 2*
	logit filibuster i.billvetoordinal SenateDaysBeforeDeadline  houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
	*Model 3*
	logit sacreported inthreatenedbill SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
	*Model 4*
	logit sacreported i.billvetoordinal SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
	*Model 5*
	logit skipsenate inthreatenedbill SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
	*Model 6*
	logit skipsenate i.billvetoordinal SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
	*Model 7*
	logit removedsf threatened SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  & skipsenate==0 & (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenateNOSKIP], cluster(billnum)
	*Model 8
	logit removedsf i.vetoordinal SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  & skipsenate==0 & (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenateNOSKIP], cluster(billnum)

	*Changes in percentages reported on page 22*
		*From Equation 3*
		logit sacreported inthreatenedbill SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
		margins, at(inthreatenedbill=(0 1)) atmeans
		display 1-.811885
		display 1-.5628756
		*From Equation 5*
		logit skipsenate inthreatenedbill SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum)
		margins, at(inthreatenedbill=(0 1)) atmeans
		
	*Eighty percent of unthreatened riders and 59 percent of threatened riders resided in bills that received full consideration on the Senate floor. Here too, threats influence Senate actions (2D). (pg. 23)
		tab threatened skipsenate if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1), row
		
	*Changes in percentages reported on page 23*
		*From Equation 7*
		logit removedsf threatened SenateDaysBeforeDeadline houseoppo opposen if hacorigin ==1 & removed!=1  & skipsenate==0 & (crs==0 |crs== 1 & othsource ==1) [pweight=weightHACsenateNOSKIP], cluster(billnum)
		margins, at(threatened=(0 1)) atmeans
	
	*Since threatened riders comprise a larger share of all riders in punted bills (pg. 23)*
		tab threatened skipsenate if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1), col
	
**Table 4**
	*Model 1*
	logit notinconf threatened removedsf skipsenate  houseoppo  opposen if hacorigin ==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1) [pweight=weightHACsenate ], cluster(billnum )
	*Model 2*
	xi: logit notinconf i.vetoordinal removedsf skipsenate houseoppo  opposen if hacorigin ==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1) [pweight=weightHACsenate ], cluster(billnum )

**Table 5**
	logit notinconf removedsf skipsenate  threatened houseoppo  opposen filibuster if hacorigin ==1 & removed !=1  & (crs==0 | crs== 1 & othsource ==1) [pweight=weightHACsenate], cluster(billnum )
	*Row 1, Col 1*
	margins, at(threatened=0 removedsf=0 skipsenate=0) atmeans
	*Row 1, Col 2*
	margins, at (threatened=1 removedsf=0 skipsenate=0) atmeans
	*Row 2, Col 1*
	margins, at (threatened=0 removedsf=0 skipsenate=1) atmeans
	*Row 2, Col 2*
	margins, at (threatened=1 removedsf=0 skipsenate=1) atmeans
	*Row 3, Col 1*
	margins, at (threatened=0 removedsf=1 skipsenate=0) atmeans
	*Row 3, Col 2*
	margins, at (threatened=1 removedsf=1 skipsenate=0) atmeans
	*Row 4, Col 1*
	margins, at (threatened=0) atmeans
	*Row 4, Col 2*
	margins, at (threatened=1) atmeans

	
	*With an estimated 41 percent of threatened HAC riders reaching the enrolled stage (pg. 26)*
	tab threatened notinconf if hacorigin ==1 & removed!=1  &  (crs==0 |crs== 1 & othsource ==1), row
	
	*and the president signing 88 percent into law (pg. 26)*
	tab threatened vetore if hacorigin ==1 & removed!=1  &  notinconf ==0 & (crs==0 |crs== 1 & othsource ==1), row
	
	*36 percent of the threatened riders became law (pg. 26)*
	tab threatened inlaw if hacorigin ==1 & removed!=1  & (crs==0 |crs== 1 & othsource ==1), row
	

**Of the 88 annual appropriations bills that presidents had earlier threatened because of objectionable HAC riders, 37 were free of such riders when they arrived on their desk. (pg. 26)	
	**Generating the number of removed riders**
	gen cut=0
	replace cut=1 if notinconf==1 | removed==2
	gen cutthreatened=0 if threatened==1
	replace cutthreatened=1 if threatened==1 & removed>0
	gen countriders=1
	
	**Collapsing by bill**
	collapse vetore billvetoordinal inthreatenedbill (sum) threatened cutthreatened cut countriders , by (billnum congress)
	
	**Number of remaining remaining threats**
	gen remainingriders=countriders -cut
	gen remainingthreats=threatened -cutthreatened

	gen noriderthreatsleft=1 if inthreatenedbill ==1
	replace noriderthreatsleft=0 if remainingthreats >0
	
	*Statement in text*
	tab noriderthreatsleft inthreatenedbill if inthreatenedbill ==1 & threatened >0

**And threatened riders were roughly twice as likely as unthreatened to reside in bills that the president vetoed (15 versus 8 percent) (pg. 26)*
	clear 
	use AJPSVetoRhetoric
	tab vetore if notinconf ==0 & threatened==1
	tab vetore if notinconf ==0 & threatened==0
