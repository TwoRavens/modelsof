**Pivotal Politics and the Ideological Content of Landmark Laws**
**by Thomas Gray and Jeffery Jenkins**
**Journal of Public Policy 2017**

**Figure 2; Graph presented in the paper contains additional aesthetic customization**
graph twoway connected s1mintreat cong  

**Figure 3; Graph presented in the paper contains additional aesthetic customization**
graph twoway connected nomgrid cong

**Figure 4; Graph presented in the paper contains additional aesthetic customization**
graph twoway rarea gridleftbound gridrightbound cong, hor

*Table 1**
**Table 1 - Model 1**
newey s1mintreat nomgrid congress l1.s1mintreat, lag(1)
reg s1mintreat nomgrid congress l1.s1mintreat
estat dwatson
estat durbinalt, small
**Table 1 - Model 2**
newey s1mintreat nomgrid unifgov mood gdpgrowth war congress l1.s1mintreat, lag(1)
reg s1mintreat nomgrid unifgov mood gdpgrowth war congress l1.s1mintreat
estat dwatson
estat durbinalt, small

**Figure 5; Graph presented in the paper contains additional aesthetic customization**
graph twoway connected s1mintreat cong || connected s1ideo cong || connected s1nideo cong

**Table 2**
**Table 2 - Model 1**
newey s1ideo nomgrid unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo nomgrid unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small
**Table 2 - Model 2**
newey s1nideo nomgrid unifgov mood gdpgrowth war congress l1.s1nideo, lag(1)
reg s1nideo nomgrid unifgov mood gdpgrowth war congress l1.s1nideo
estat dwatson
estat durbinalt, small
**Table 2 - Model 3**
newey ideoport nomgrid unifgov mood gdpgrowth war congress l1.ideoport l2.ideoport, lag(2)
reg ideoport nomgrid unifgov mood gdpgrowth war congress l1.ideoport l2.ideoport
estat dwatson
estat durbinalt, small

**Table 3; in descending order of presentation in the table**
**Normal; Mean 0, sd 0.20**
newey s1ideo m0sd2per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo m0sd2per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean 0, sd 0.25**
newey s1ideo m0sd25per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo m0sd25per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean 0, sd 0.35**
newey s1ideo m0sd35per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo m0sd35per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean 0, sd 0.45**
newey s1ideo m0sd45per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo m0sd45per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean 0, sd 0.10**
newey s1ideo m0sd15per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo m0sd15per unifgov mood gdpgrowth war congress l1.s1ideo
**Uniform Distribution**
newey s1ideo uniformdist unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo uniformdist unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean avg. last 3 medians, sd .35**
newey s1ideo lag3medsd35per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo lag3medsd35per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean avg. last 5 medians, sd .35**
newey s1ideo lag5medsd35per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo lag5medsd35per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean avg. last 5 medians, sd .25**
newey s1ideo lag5medsd25per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo lag5medsd25per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean avg. last 3 medians, sd .25**
newey s1ideo lag3medsd25per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo lag3medsd25per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean last median, sd 0.35**
newey s1ideo medsd35per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo medsd35per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean 0, sd 0.10**
newey s1ideo m0sd1per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo m0sd1per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean avg. last 5 medians, sd .15**
newey s1ideo lag5medsd15per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo lag5medsd15per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean last median, sd .25**
newey s1ideo medsd25per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo medsd25per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean avg. last 3 medians, sd .15**
newey s1ideo lag3medsd15per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo lag3medsd15per unifgov mood gdpgrowth war congress l1.s1ideo
**Normal; Mean last median, sd .15**
newey s1ideo medsd15per unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo medsd15per unifgov mood gdpgrowth war congress l1.s1ideo

**Table 4**
**Table 4 - Model 1**
newey s1mintreat adagrid unifgov mood gdpgrowth war congress l1.s1mintreat, lag(1)
reg s1mintreat adagrid unifgov mood gdpgrowth war congress l1.s1mintreat
estat dwatson
estat durbinalt, small
**Table 4 - Model 2**
newey s1ideo nomgrid unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo nomgrid unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small
**Table 4 - Model 3**
newey s1nideo nomgrid unifgov mood gdpgrowth war congress l1.s1nideo, lag(1)
reg s1nideo nomgrid unifgov mood gdpgrowth war congress l1.s1nideo
estat dwatson
estat durbinalt, small

**Table 5**
**Table 5 - Model 1**
newey s1ideo nomgrid unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo nomgrid unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small
**Table 5 - Model 2**
newey s1ideo housecartel unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo housecartel unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small
**Table 5 - Model 3**
newey s1ideo housecartelpivpol unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo housecartelpivpol unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small
**Table 5 - Model 4**
newey s1ideo setter unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo setter unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small
**Table 5 - Model 5**
newey s1ideo setpiv unifgov mood gdpgrowth war congress l1.s1ideo, lag(1)
reg s1ideo setpiv unifgov mood gdpgrowth war congress l1.s1ideo
estat dwatson
estat durbinalt, small





