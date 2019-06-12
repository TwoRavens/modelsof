gen cpigdp = gdpcapl*ti_cpi05
*Table 1 Column 1
reg DALY c.ti_cpi05 differdaly W  newstate latitude c.gdpcapl gini, robust
eststo m1
*Table 1 Column 2
reg DALY c.ti_cpi05 differdaly W  newstate latitude c.gdpcapl gini cpigdp bot, robust
eststo m2
*Table 1 Column 3
reg DALY c.ti_cpi05 differdaly W  newstate latitude c.gdpcapl gini cpigdp bot  deathn91_97 contig_civil_war, robust
eststo m3
	

*Table 3 Column 1
reg DALY c.ti_cpi05 differdaly W  newstate latitude c.gdpcapl gini cpigdp bot afr
eststo m4
*Table 3 Column 2
reg DALY c.ti_cpi05 differdaly W  newstate latitude c.gdpcapl gini cpigdp if afr==0
eststo m5
*Table 3 Column 2
reg DALY c.ti_cpi05 differdaly W  newstate latitude c.gdpcapl gini cpigdp bot if afr==1
eststo m6



	



