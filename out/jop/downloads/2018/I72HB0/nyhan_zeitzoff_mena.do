clear 
set more off

cd "/Users/bnyhan/Documents/Dropbox/Intergroup misinformation/YouGov MENA data/Replication"

import excel "DXB_FTJ_2016_008_Conspiracy_cleaned(XLS)_v3.xls", sheet("DXB_FTJ_2016_008_Conspiracy_cle") firstrow

**Setting up the control/treatment conditions (high and low); baseline is placebo***
**Control	1	Placebo treatment
**	2	High control condition
**	3	Low control condition

gen high_control=.
replace high_control=0 if Control==3 | Control==1
replace high_control=1 if Control==2 

gen low_control=.
replace low_control=0 if Control==2 | Control==1
replace low_control=1 if Control==3 

**Summary Statistics**

**Country of Residence (Egypt =3 and Saudi Arabia =14)
**1007 Egypt 1008 Saudi Arabia**
tab country

gen egypt_res=.
replace egypt_res=0 if country==14
replace egypt_res= 1 if country==3

gen ksa_res=.
replace ksa_res=0 if country==3
replace ksa_res= 1 if country==14

**Gender (Male =1 and Female 2)

gen male=0
replace male=1 if gender==1
replace male=0 if gender==2

tab male 

**Employment 

**1	Working full time (30 or more hours per week)
**2	Working part time (8 - 29 hours per week)
**3	Working part time (Less than 8 hours a week)
**4	Full time student
**5	Retired
**6	Full-time home-maker or housewife
**7	Unemployed
**8	Other

 **employment |      Freq.     Percent        Cum.
**------------+-----------------------------------
**          1 |        940       48.55       48.55
**          2 |        196       10.12       58.68
**          3 |         74        3.82       62.50
**          4 |        219       11.31       73.81
**          5 |         47        2.43       76.24
**          6 |        230       11.88       88.12
**          7 |        188        9.71       97.83
**          8 |         42        2.17      100.00
**------------+-----------------------------------
**      Total |      1,936      100.00

gen unemployed=.
replace unemployed=0 if employment!=7
replace unemployed=1 if employment==7

**Income
/*1	Less than $266
2	$266 to $532
3	$533 to $799
4	$800 to $1,065
5	$1,066 to $1,599
6	$1,600 to $2,132
7	$2,133 to $2,665
8	$2,666 to $3,999
9	$4,000 to $5,332
10	$5,333 to $6,665
11	$6,666 to $7,999
12	$8,000 to $10,665
13	$10,666 to $13,332
14	$13,333 or more 
15	Prefer not to say
16	Don't know */

/*tab income

     income |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        308       15.41       15.41
          2 |        371       18.56       33.97
          3 |        180        9.00       42.97
          4 |        176        8.80       51.78
          5 |        141        7.05       58.83
          6 |         95        4.75       63.58
          7 |         63        3.15       66.73
          8 |        109        5.45       72.19
          9 |         66        3.30       75.49
         10 |         33        1.65       77.14
         11 |         19        0.95       78.09
         12 |         15        0.75       78.84
         13 |         12        0.60       79.44
         14 |         15        0.75       80.19
         15 |        190        9.50       89.69
         16 |        206       10.31      100.00
------------+-----------------------------------
      Total |      1,999      100.00 */
	  
gen monthly_income=.
replace monthly_income= income if income<15
tab monthly_income, missing   

**Education
/*tab education

  education |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         32        1.59        1.59
          2 |        378       18.76       20.35
          3 |        131        6.50       26.85
          4 |      1,133       56.23       83.08
          5 |        259       12.85       95.93
          6 |         57        2.83       98.76
          7 |         25        1.24      100.00
------------+-----------------------------------
      Total |      2,015      100.00 */


/* 1	Elementary school
2	Secondary school
3	Vocational college education (e.g. to qualify as an electrician, nurse)
4	University first degree (e.g. BA, BSc)
5	University higher degree (Masters, MBA, PhD)
6	Professional higher education (e.g. to qualify as a lawyer, accountant)
7	None of these */

gen education_level=.
replace education_level= education if education <7
tab education_level

recode education_level (6=5) /*group post-grad degrees*/

**Marital Status
/* 1	Single - never married
2	Married with Children
3	Married without Children
4	Divorced
5	Widowed
tab maritalstatus
maritalstat |
         us |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        743       36.97       36.97
          2 |        889       44.23       81.19
          3 |        310       15.42       96.62
          4 |         47        2.34       98.96
          5 |         21        1.04      100.00
------------+-----------------------------------
      Total |      2,010      100.00 */

gen married=.
replace married=1 if maritalst==2 | maritalstatus==3

replace married=0 if maritalstatus==1 | maritalstatus==4 | maritalstatus==5

**Religion 

/*1	None - not religious
2	Islam
3	Christianity
4	Hinduism
5	Sikhism
6	Judaism
7	Buddhism
8	Jainism
9	Zoroastrianism
tab religion 

   religion |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |          8        0.62        0.62
          2 |      1,243       95.62       96.23
          3 |         47        3.62       99.85
          8 |          1        0.08       99.92
         10 |          1        0.08      100.00
------------+-----------------------------------
      Total |      1,300      100.00 */

gen christian=.
replace christian=0 if religion!=3 & religion!=.
replace christian=1 if religion ==3
tab christian

bysort country: tab christian, missing

**Citizenship***
/*1 Algeria
2 Bahrain
3 Egypt
5 Jordan
7 Lebanon
8 Libya
10  Morocco
12 Palestine
14 KSA
15 Sudan
16  Syria
18 UAE
19 Yemen
198 Somalia

tab nationality

nationality |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |          2        0.10        0.10
          2 |          2        0.10        0.20
          3 |      1,128       55.98       56.18
          5 |         33        1.64       57.82
          7 |          4        0.20       58.01
          8 |          1        0.05       58.06
         10 |         12        0.60       58.66
         12 |         18        0.89       59.55
         14 |        681       33.80       93.35
         15 |         27        1.34       94.69
         16 |         51        2.53       97.22
         18 |          1        0.05       97.27
         19 |         49        2.43       99.70
        198 |          6        0.30      100.00
------------+-----------------------------------
      Total |      2,015      100.00 */
	  

/*. tab nationality if egypt_res==1

nationality |      Freq.     Percent        Cum.
------------+-----------------------------------
          3 |      1,007      100.00      100.00
------------+-----------------------------------
      Total |      1,007      100.00

. tab nationality if ksa_res==1

nationality |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |          2        0.20        0.20
          2 |          2        0.20        0.40
          3 |        121       12.00       12.40
          5 |         33        3.27       15.67
          7 |          4        0.40       16.07
          8 |          1        0.10       16.17
         10 |         12        1.19       17.36
         12 |         18        1.79       19.15
         14 |        681       67.56       86.71
         15 |         27        2.68       89.38
         16 |         51        5.06       94.44
         18 |          1        0.10       94.54
         19 |         49        4.86       99.40
        198 |          6        0.60      100.00
------------+-----------------------------------
      Total |      1,008      100.00 */
	  
gen saudi_national=.
replace saudi_national=0 if nationality!=14
replace saudi_national=1 if nationality==14

gen non_saudi_national=(ksa_res==1 & saudi_national==0)
gen egyptian_in_ksa=(ksa_res==1 & nationality==3)
gen nonegyptian_in_ksa=(ksa_res==1 & nationality!=3 & nationality!=14)
gen saudi_in_ksa=(ksa_res==1 & nationality==14)

tab non_saudi_national

***Demographics 
tab country

gen college=(education_level>3 & education_level<7) 

gen condition=0
replace condition=1 if low_control==1
replace condition=2 if high_control==1

/*Table B1*/
tab male
bysort condition: su male

tab college
bysort condition: su college

su age
bysort condition: su age

tab unemployed
bysort condition: su unemployed

tab non_saudi_national if ksa_res==1
bysort condition: su non_saudi_national if ksa_res==1

tab ksa_res
bysort condition: su ksa_res

reg male high_control low_control
reg college high_control low_control
reg age high_control low_control
reg unemployed high_control low_control
reg non_saudi_national high_control low_control
reg ksa_res high_control low_control

**Other independent Variables****************

**Pre Treatment Measure of control

/*1	Strongly disagree
2	Somewhat disagree
3	Somewhat agree
4	Strongly agree

HIGHER VALUES=> HIGHER LEVELS OF CONTROL
Q3_Q3_1_Q3_grid	17	I can solve the problems I have.* 
Q3_Q3_2_Q3_grid	18	I sometimes feel I am being pushed around.
Q3_Q3_3_Q3_grid	19	I have little control over what happens to me.
Q3_Q3_4_Q3_grid	20	I can do just about anything I really set my mind to.*
Q3_Q3_5_Q3_grid	21	I often feel helpless in dealing with the problems of life.
Q3_Q3_6_Q3_grid	22	What happens to me in the future depends mostly on me.*
Q3_Q3_7_Q3_grid	23	There is little I can do to change important things in my life. 

*/

alpha Q3_Q3_1_Q3_grid Q3_Q3_2_Q3_grid Q3_Q3_3_Q3_grid Q3_Q3_4_Q3_grid Q3_Q3_5_Q3_grid  Q3_Q3_6_Q3_grid Q3_Q3_7_Q3_grid, item 

/*Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q3_Q3_1_Q3~d | 2015    -       0.5295        0.3503        .1475986      0.5663
Q3_Q3_2_Q3~d | 2015    +       0.6071        0.3737        .1288997      0.5527
Q3_Q3_3_Q3~d | 2015    +       0.5233        0.2912        .1467399      0.5820
Q3_Q3_4_Q3~d | 2015    -       0.4623        0.2488        .1582178      0.5940
Q3_Q3_5_Q3~d | 2015    +       0.6934        0.5009        .1110301      0.5042
Q3_Q3_6_Q3~d | 2015    -       0.3366        0.0726        .1849426      0.6529c
Q3_Q3_7_Q3~d | 2015    +       0.6625        0.4557        .1173458      0.5215
-------------+-----------------------------------------------------------------
Test scale   |                                             .1421106      0.6087
------------------------------------------------------------------------------- */

**Factor Analysis**

factor Q3_Q3_1_Q3_grid Q3_Q3_2_Q3_grid Q3_Q3_3_Q3_grid Q3_Q3_4_Q3_grid Q3_Q3_5_Q3_grid  Q3_Q3_6_Q3_grid Q3_Q3_7_Q3_grid, pcf
rotate, varimax 

/*
Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: (unrotated)                        Number of params =         13

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.25297      0.57582            0.3219       0.3219
        Factor2  |      1.67714      0.91180            0.2396       0.5614
        Factor3  |      0.76534      0.10206            0.1093       0.6708
        Factor4  |      0.66328      0.03408            0.0948       0.7655
        Factor5  |      0.62920      0.10077            0.0899       0.8554
        Factor6  |      0.52843      0.04480            0.0755       0.9309
        Factor7  |      0.48363            .            0.0691       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(21) = 2366.36 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
    Q3_Q3_1_Q3~d |  -0.3988    0.7030 |      0.3468  
    Q3_Q3_2_Q3~d |   0.6876    0.2233 |      0.4773  
    Q3_Q3_3_Q3~d |   0.6064    0.3525 |      0.5080  
    Q3_Q3_4_Q3~d |  -0.2818    0.7397 |      0.3735  
    Q3_Q3_5_Q3~d |   0.7860    0.0821 |      0.3754  
    Q3_Q3_6_Q3~d |  -0.0447    0.6644 |      0.5565  
    Q3_Q3_7_Q3~d |   0.7444    0.1164 |      0.4323  
    -------------------------------------------------

. rotate,varimax

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: orthogonal varimax (Kaiser off)    Number of params =         13

    --------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.19961      0.46911            0.3142       0.3142
        Factor2  |      1.73050            .            0.2472       0.5614
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(21) = 2366.36 Prob>chi2 = 0.0000

Rotated factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
    Q3_Q3_1_Q3~d |  -0.1659    0.7910 |      0.3468  
    Q3_Q3_2_Q3~d |   0.7229    0.0034 |      0.4773  
    Q3_Q3_3_Q3~d |   0.6850    0.1512 |      0.5080  
    Q3_Q3_4_Q3~d |  -0.0433    0.7903 |      0.3735  
    Q3_Q3_5_Q3~d |   0.7737   -0.1611 |      0.3754  
    Q3_Q3_6_Q3~d |   0.1596    0.6465 |      0.5565  
    Q3_Q3_7_Q3~d |   0.7445   -0.1157 |      0.4323  
    -------------------------------------------------
*/

factor Q3_Q3_1_Q3_grid Q3_Q3_2_Q3_grid Q3_Q3_3_Q3_grid Q3_Q3_4_Q3_grid Q3_Q3_5_Q3_grid  Q3_Q3_6_Q3_grid Q3_Q3_7_Q3_grid, pcf
rotate, promax 

factor Q3_Q3_1_Q3_grid Q3_Q3_2_Q3_grid Q3_Q3_3_Q3_grid Q3_Q3_4_Q3_grid Q3_Q3_5_Q3_grid  Q3_Q3_6_Q3_grid Q3_Q3_7_Q3_grid
rotate, varimax 

/*per prereg, generate separately*/
alpha Q3_Q3_1_Q3_grid Q3_Q3_4_Q3_grid Q3_Q3_6_Q3_grid, item gen(pretreat_high_control_mean) /*.60*/
factor Q3_Q3_1_Q3_grid Q3_Q3_4_Q3_grid Q3_Q3_6_Q3_grid, pcf
predict pretreat_high_control

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q3_Q3_1_Q3~d | 2015    +       0.7452        0.4622         .195894      0.4253
Q3_Q3_4_Q3~d | 2015    +       0.7638        0.4492        .1816882      0.4274
Q3_Q3_6_Q3~d | 2015    +       0.7329        0.3212        .2686983      0.6391
-------------+-----------------------------------------------------------------
Test scale   |                                             .2154268      0.5950
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          3

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      1.69186      0.91171            0.5640       0.5640
        Factor2  |      0.78015      0.25215            0.2600       0.8240
        Factor3  |      0.52800            .            0.1760       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(3)  =  726.97 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
    Q3_Q3_1_Q3~d |   0.8030 |      0.3552  
    Q3_Q3_4_Q3~d |   0.7993 |      0.3611  
    Q3_Q3_6_Q3~d |   0.6388 |      0.5919  
    ---------------------------------------
*/

alpha Q3_Q3_2_Q3_grid Q3_Q3_3_Q3_grid Q3_Q3_5_Q3_grid Q3_Q3_7_Q3_grid, item gen(pretreat_low_control_mean) /*.72*/
factor Q3_Q3_2_Q3_grid Q3_Q3_3_Q3_grid Q3_Q3_5_Q3_grid Q3_Q3_7_Q3_grid, pcf

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q3_Q3_2_Q3~d | 2015    +       0.7341        0.4899        .3396938      0.6645
Q3_Q3_3_Q3~d | 2015    +       0.6855        0.4445         .383591      0.6892
Q3_Q3_5_Q3~d | 2015    +       0.7706        0.5602        .3096846      0.6210
Q3_Q3_7_Q3~d | 2015    +       0.7505        0.5251        .3263764      0.6424
-------------+-----------------------------------------------------------------
Test scale   |                                             .3398364      0.7171
-------------------------------------------------------------------------------


Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          4

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.16690      1.47519            0.5417       0.5417
        Factor2  |      0.69171      0.04717            0.1729       0.7147
        Factor3  |      0.64454      0.14770            0.1611       0.8758
        Factor4  |      0.49685            .            0.1242       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(6)  = 1477.37 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
    Q3_Q3_2_Q3~d |   0.7233 |      0.4769  
    Q3_Q3_3_Q3~d |   0.6773 |      0.5413  
    Q3_Q3_5_Q3~d |   0.7831 |      0.3867  
    Q3_Q3_7_Q3~d |   0.7562 |      0.4281  
    ---------------------------------------
*/

predict pretreat_low_control

/*almost uncorrelated (r=-.09)*/
corr pretreat_low_control pretreat_high_control

/*

	1	Strongly disagree
	2	Somewhat disagree
	3	Somewhat agree
	4	Strongly agree
	
Q3_Q3_1_Q3_grid	17	I can solve the problems I have.* 
Q3_Q3_2_Q3_grid	18	I sometimes feel I am being pushed around.
Q3_Q3_3_Q3_grid	19	I have little control over what happens to me.
Q3_Q3_4_Q3_grid	20	I can do just about anything I really set my mind to.*
Q3_Q3_5_Q3_grid	21	I often feel helpless in dealing with the problems of life.
Q3_Q3_6_Q3_grid	22	What happens to me in the future depends mostly on me.*
Q3_Q3_7_Q3_grid	23	There is little I can do to change important things in my life. 
*/

**Anti Western Attitudes

/*
recode so unfavorable = higher
4	Very unfavorable
3	Somewhat unfavorable
2	Somewhat favorable
1	Very favorable */

foreach var of varlist Q5_Q5_1_Q5_grid Q5_Q5_7_Q5_grid Q5_Q5_9_Q5_grid {
recode `var' (1=4)(2=3)(3=2)(4=1)
}

rename Q5_Q5_1_Q5_grid usa_unfav
rename Q5_Q5_7_Q5_grid israel_unfav
rename Q5_Q5_9_Q5_grid uk_unfav

/*
. tab usa_unfav

Q5_Q5_1_Q5_ |
       grid |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        344       17.07       17.07
          2 |        726       36.03       53.10
          3 |        504       25.01       78.11
          4 |        441       21.89      100.00
------------+-----------------------------------
      Total |      2,015      100.00


. tab israel_unfav

Q5_Q5_7_Q5_ |
       grid |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         71        3.52        3.52
          2 |        125        6.20        9.73
          3 |        194        9.63       19.35
          4 |      1,625       80.65      100.00
------------+-----------------------------------
      Total |      2,015      100.00


. tab uk_unfav

Q5_Q5_9_Q5_ |
       grid |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        484       24.02       24.02
          2 |        881       43.72       67.74
          3 |        420       20.84       88.59
          4 |        230       11.41      100.00
------------+-----------------------------------
      Total |      2,015      100.00*/

**Jews, Christians, Americans**
/*
recode so unfavorable = higher
4	Very unfavorable
3	Somewhat unfavorable
2	Somewhat favorable
1	Very favorable */

foreach var of varlist Q6_Q6_1_Q6_grid Q6_Q6_3_Q6_grid Q6_Q6_4_Q6_grid {
recode `var' (1=4)(2=3)(3=2)(4=1)
}

rename Q6_Q6_1_Q6_grid jews_unfav
rename Q6_Q6_3_Q6_grid christians_unfav
rename Q6_Q6_4_Q6_grid americans_unfav

/*. tab jews_unfav

Q6_Q6_1_Q6_ |
       grid |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         92        4.57        4.57
          2 |        248       12.31       16.87
          3 |        404       20.05       36.92
          4 |      1,271       63.08      100.00
------------+-----------------------------------
      Total |      2,015      100.00

. tab christians_un

Q6_Q6_3_Q6_ |
       grid |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        404       20.05       20.05
          2 |        995       49.38       69.43
          3 |        374       18.56       87.99
          4 |        242       12.01      100.00
------------+-----------------------------------
      Total |      2,015      100.00



. tab americans_unf

Q6_Q6_4_Q6_ |
       grid |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        316       15.68       15.68
          2 |        938       46.55       62.23
          3 |        483       23.97       86.20
          4 |        278       13.80      100.00
------------+-----------------------------------
      Total |      2,015      100.00
 */
	  
*USA, UK, Americans scales together and Jews/Israel scales together; Christians ambiguous 
alpha usa_unfav israel_unfav uk_unfav christians_unfav jews_unfav americans_unfav, item

factor usa_unfav israel_unfav uk_unfav christians_unfav jews_unfav americans_unfav, pcf
rotate, varimax 

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
usa_unfav      | 2015    +       0.7651        0.5978        .2176401      0.6656
israel_unfav   | 2015    +       0.5584        0.3878        .2984375      0.7268
uk_unfav       | 2015    +       0.6895        0.5087        .2491848      0.6946
christians~v | 2015    +       0.5646        0.3524        .2910936      0.7383
jews_unfav     | 2015    +       0.6185        0.4288        .2750243      0.7171
americans_~v | 2015    +       0.7452        0.5928         .232815      0.6699
-------------+-----------------------------------------------------------------
Test scale   |                                             .2606992      0.7406
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: (unrotated)                        Number of params =         11

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.63681      1.50430            0.4395       0.4395
        Factor2  |      1.13251      0.22542            0.1888       0.6282
        Factor3  |      0.90709      0.34809            0.1512       0.7794
        Factor4  |      0.55900      0.09937            0.0932       0.8726
        Factor5  |      0.45962      0.15466            0.0766       0.9492
        Factor6  |      0.30497            .            0.0508       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(15) = 3118.90 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
         usa_unfav |   0.7890   -0.3762 |      0.2359  
      israel_unfav |   0.5579    0.5434 |      0.3935  
          uk_unfav |   0.7012   -0.4489 |      0.3068  
    christians~v |   0.5173    0.1764 |      0.7013  
        jews_unfav |   0.5970    0.6444 |      0.2283  
    americans_~v |   0.7664   -0.2186 |      0.3648  
    -------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: orthogonal varimax (Kaiser off)    Number of params =         11

    --------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.13788      0.50643            0.3563       0.3563
        Factor2  |      1.63145            .            0.2719       0.6282
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(15) = 3118.90 Prob>chi2 = 0.0000

Rotated factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
         usa_unfav |   0.8617    0.1468 |      0.2359  
      israel_unfav |   0.1431    0.7655 |      0.3935  
          uk_unfav |   0.8318    0.0368 |      0.3068  
    christians~v |   0.3213    0.4422 |      0.7013  
        jews_unfav |   0.1169    0.8706 |      0.2283  
    americans_~v |   0.7524    0.2627 |      0.3648  
    -------------------------------------------------

*/

alpha usa_unfav uk_unfav americans_unfav, item
factor usa_unfav uk_unfav americans_unfav, pcf
predict west_unfav

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
usa_unfav      | 2015    +       0.8892        0.7116        .3584467      0.5964
uk_unfav       | 2015    +       0.8126        0.5861        .5427612      0.7397
americans_~v | 2015    +       0.7981        0.5699        .5765739      0.7563
-------------+-----------------------------------------------------------------
Test scale   |                                             .4925939      0.7816
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          3

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.08807      1.51272            0.6960       0.6960
        Factor2  |      0.57535      0.23878            0.1918       0.8878
        Factor3  |      0.33658            .            0.1122       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(3)  = 1822.84 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
         usa_unfav |   0.8892 |      0.2094  
          uk_unfav |   0.8112 |      0.3420  
    americans_~v |   0.7997 |      0.3605  
    ---------------------------------------

Scoring coefficients (method = regression)

    ------------------------
        Variable |  Factor1 
    -------------+----------
         usa_unfav |  0.42583 
          uk_unfav |  0.38848 
    americans_~v |  0.38297 
    ------------------------

*/

alpha jews_unfav israel_unfav, item
factor jews_unfav israel_unfav, pcf
predict jews_israel_unfav

/*
Test scale = mean(unstandardized items)

Average interitem covariance:     .3115987
Number of items in the scale:            2
Scale reliability coefficient:      0.6417

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          1

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      1.47847      0.95693            0.7392       0.7392
        Factor2  |      0.52153            .            0.2608       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(1)  =  523.46 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
        jews_unfav |   0.8598 |      0.2608  
      israel_unfav |   0.8598 |      0.2608  
    ---------------------------------------

Scoring coefficients (method = regression)

    ------------------------
        Variable |  Factor1 
    -------------+----------
        jews_unfav |  0.58154 
      israel_unfav |  0.58154 
    ------------------------
*/

/*correlated at r=.34*/
corr west_unfav jews_israel_unfav

**Political Knowledge

gen know1=(Q8==1) /*Assad*/
gen know2=(Q9==3) /*Iran*/
gen know3=(Q10==1) /*Cameron*/
gen know4=(Q11==4) /*A-bomb*/
gen know5=(Q12==1) /*Berlin Wall*/
gen know6=(Q13==1) /*Gandhi*/

/*Table B2*/
su know1-know6
gen knowledge=know1+know2+know3+know4+know5+know6
tab knowledge

alpha know1-know6, item
factor know1-know6, pcf
rotate, varimax

/*middle east political knowledge loads separately from general/historical*/
/*computed as sum given prereg*/

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
know1        | 2015    +       0.2359        0.1370        .0481367      0.6303
know2        | 2015    +       0.5355        0.2774        .0367339      0.5991
know3        | 2015    +       0.6734        0.3981        .0284019      0.5511
know4        | 2015    +       0.6750        0.4201        .0282508      0.5385
know5        | 2015    +       0.6747        0.4615        .0286977      0.5224
know6        | 2015    +       0.6007        0.3838        .0331485      0.5573
-------------+-----------------------------------------------------------------
Test scale   |                                             .0338949      0.6151
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: (unrotated)                        Number of params =         11

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.07665      1.07456            0.3461       0.3461
        Factor2  |      1.00209      0.15750            0.1670       0.5131
        Factor3  |      0.84459      0.08299            0.1408       0.6539
        Factor4  |      0.76160      0.09747            0.1269       0.7808
        Factor5  |      0.66413      0.01318            0.1107       0.8915
        Factor6  |      0.65095            .            0.1085       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(15) = 1100.67 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
           know1 |   0.2588    0.8650 |      0.1848  
           know2 |   0.4940    0.3315 |      0.6461  
           know3 |   0.6446   -0.2818 |      0.5051  
           know4 |   0.6688   -0.2404 |      0.4949  
           know5 |   0.7100   -0.0803 |      0.4895  
           know6 |   0.6315    0.0188 |      0.6009  
    -------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: orthogonal varimax (Kaiser off)    Number of params =         11

    --------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      1.97942      0.88010            0.3299       0.3299
        Factor2  |      1.09932            .            0.1832       0.5131
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(15) = 1100.67 Prob>chi2 = 0.0000

Rotated factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
           know1 |  -0.0134    0.9028 |      0.1848  
           know2 |   0.3714    0.4647 |      0.6461  
           know3 |   0.6995   -0.0749 |      0.5051  
           know4 |   0.7102   -0.0281 |      0.4949  
           know5 |   0.7013    0.1369 |      0.4895  
           know6 |   0.5966    0.2079 |      0.6009  
    -------------------------------------------------

Factor rotation matrix

    --------------------------------
                 | Factor1  Factor2 
    -------------+------------------
         Factor1 |  0.9537   0.3008 
         Factor2 | -0.3008   0.9537 
    --------------------------------
*/

**Manipulation check

/*Some people feel they have completely free choice and control over their lives, while other people feel that what they do has no real control over what happens to them. In general, how much control do you feel you have over what happens in your life?

No control
Very little control
Some control
Quite a bit of control
A great deal of control
Total control*/

rename Q20 manip_check_control
tab manip_check_control

**Outcome measures

/*
-The United States is secretly trying to help the Islamic State (ISIS) take power in Syria and Iraq.
-Abu Bakr Al-Bagdadi, the leader of the Islamic State (ISIS), is an Israeli intelligence agent.
-Millions of Jews died in the Holocaust in Europe during World War II.*
-The number of Jews who died in the Holocaust has been greatly exaggerated.
-The United States is trying to destroy the Islamic State (ISIS).*
-Jewish leaders are secretly conspiring to achieve world domination.
-Arabs carried out the attacks against the United States (the World Trade Center and the Pentagon) on September 11, 2001.*
-Jews carried out the September 11, 2001 attacks against the World Trade Center and the Pentagon in the United States.
*/

/*Original coding:
1	Very accurate
2	Somewhat accurate
3	Not very accurate
4	Not at all accurate
*/

/*
recode false ones so higher values=greater misperceptions for all
4	Very accurate
3	Somewhat accurate
2	Not very accurate
1	Not at all accurate
*/

alpha Q21_Q21_1-Q21_Q21_8, item gen(original_dv_mean)

tab Q21_Q21_1

foreach var of varlist Q21_Q21_1 Q21_Q21_2 Q21_Q21_4 Q21_Q21_6 Q21_Q21_8 {
recode `var' (1=4) (2=3) (3=2) (4=1)
}

tab Q21_Q21_1

alpha Q21_Q21_1-Q21_Q21_8, item
factor Q21_Q21_1-Q21_Q21_8, pcf
rotate, varimax

/*Truth scales separately from conspiracy theories*/

/*

Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q21_Q21_1_~d | 2015    +       0.7371        0.5931        .1150382      0.5035
Q21_Q21_2_~d | 2015    +       0.6723        0.5047        .1267381      0.5314
Q21_Q21_3_~d | 2015    -       0.1962       -0.0479        .2138641      0.6842
Q21_Q21_4_~d | 2015    +       0.5063        0.2942        .1568235      0.5938
Q21_Q21_5_~d | 2015    +       0.4169        0.1990        .1727488      0.6191
Q21_Q21_6_~d | 2015    +       0.6907        0.5315        .1238354      0.5238
Q21_Q21_7_~d | 2015    +       0.2633        0.0364        .1991382      0.6588
Q21_Q21_8_~d | 2015    +       0.6825        0.5070        .1230212      0.5275
-------------+-----------------------------------------------------------------
Test scale   |                                             .1539009      0.6197
-------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: (unrotated)                        Number of params =         15

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.60485      1.04427            0.3256       0.3256
        Factor2  |      1.56057      0.63065            0.1951       0.5207
        Factor3  |      0.92993      0.15874            0.1162       0.6369
        Factor4  |      0.77118      0.13217            0.0964       0.7333
        Factor5  |      0.63902      0.08838            0.0799       0.8132
        Factor6  |      0.55063      0.03154            0.0688       0.8820
        Factor7  |      0.51910      0.09438            0.0649       0.9469
        Factor8  |      0.42472            .            0.0531       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(28) = 2990.20 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
    Q21_Q21_1_~d |   0.7821    0.0172 |      0.3880  
    Q21_Q21_2_~d |   0.7202   -0.1693 |      0.4527  
    Q21_Q21_3_~d |  -0.0816    0.7267 |      0.4653  
    Q21_Q21_4_~d |   0.5293    0.0368 |      0.7185  
    Q21_Q21_5_~d |   0.3315    0.6730 |      0.4373  
    Q21_Q21_6_~d |   0.7376   -0.1472 |      0.4343  
    Q21_Q21_7_~d |   0.1019    0.7243 |      0.4650  
    Q21_Q21_8_~d |   0.7235   -0.0553 |      0.4735  
    -------------------------------------------------

. rotate, varimax

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: orthogonal varimax (Kaiser off)    Number of params =         15

    --------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.58637      1.00731            0.3233       0.3233
        Factor2  |      1.57905            .            0.1974       0.5207
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(28) = 2990.20 Prob>chi2 = 0.0000

Rotated factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
    Q21_Q21_1_~d |   0.7728    0.1211 |      0.3880  
    Q21_Q21_2_~d |   0.7363   -0.0720 |      0.4527  
    Q21_Q21_3_~d |  -0.1775    0.7093 |      0.4653  
    Q21_Q21_4_~d |   0.5197    0.1069 |      0.7185  
    Q21_Q21_5_~d |   0.2390    0.7111 |      0.4373  
    Q21_Q21_6_~d |   0.7506   -0.0478 |      0.4343  
    Q21_Q21_7_~d |   0.0047    0.7314 |      0.4650  
    Q21_Q21_8_~d |   0.7245    0.0414 |      0.4735  
    -------------------------------------------------

Factor rotation matrix

    --------------------------------
                 | Factor1  Factor2 
    -------------+------------------
         Factor1 |  0.9911   0.1330 
         Factor2 | -0.1330   0.9911 
    -------------------------------- 

*/

alpha Q21_Q21_1 Q21_Q21_2 Q21_Q21_4 Q21_Q21_6 Q21_Q21_8, item gen(conspiracy_dvs)
factor Q21_Q21_1 Q21_Q21_2 Q21_Q21_4 Q21_Q21_6 Q21_Q21_8, pcf

/*

Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q21_Q21_1_~d | 2015    +       0.7468        0.5748        .3288076      0.6846
Q21_Q21_2_~d | 2015    +       0.7157        0.5293        .3455999      0.7013
Q21_Q21_4_~d | 2015    +       0.5987        0.3684         .409013      0.7577
Q21_Q21_6_~d | 2015    +       0.7388        0.5654        .3341429      0.6883
Q21_Q21_8_~d | 2015    +       0.7375        0.5479        .3290086      0.6941
-------------+-----------------------------------------------------------------
Test scale   |                                             .3493144      0.7505
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          5

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.52502      1.70617            0.5050       0.5050
        Factor2  |      0.81884      0.21866            0.1638       0.6688
        Factor3  |      0.60019      0.03804            0.1200       0.7888
        Factor4  |      0.56215      0.06834            0.1124       0.9012
        Factor5  |      0.49381            .            0.0988       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(10) = 2144.78 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
    Q21_Q21_1_~d |   0.7627 |      0.4182  
    Q21_Q21_2_~d |   0.7289 |      0.4687  
    Q21_Q21_4_~d |   0.5492 |      0.6984  
    Q21_Q21_6_~d |   0.7517 |      0.4349  
    Q21_Q21_8_~d |   0.7384 |      0.4548  
    ---------------------------------------

*/

alpha Q21_Q21_3 Q21_Q21_5 Q21_Q21_7, item gen(truth_dvs)
factor Q21_Q21_3 Q21_Q21_5 Q21_Q21_7, pcf

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q21_Q21_3_~d | 2015    +       0.7141        0.3171        .2693362      0.4845
Q21_Q21_5_~d | 2015    +       0.7199        0.3525         .238685      0.4252
Q21_Q21_7_~d | 2015    +       0.7267        0.3734        .2198265      0.3930
-------------+-----------------------------------------------------------------
Test scale   |                                             .2426159      0.5350
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          3

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      1.55793      0.79325            0.5193       0.5193
        Factor2  |      0.76468      0.08730            0.2549       0.7742
        Factor3  |      0.67738            .            0.2258       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(3)  =  431.72 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
    Q21_Q21_3_~d |   0.6828 |      0.5337  
    Q21_Q21_5_~d |   0.7287 |      0.4690  
    Q21_Q21_7_~d |   0.7488 |      0.4394  
    ---------------------------------------
*/

/*almost uncorrelated - r=-.07*/
pwcorr conspiracy_dvs truth_dvs

/*survey marginals*/

/*
-The United States is secretly trying to help the Islamic State (ISIS) take power in Syria and Iraq.
-Abu Bakr Al-Bagdadi, the leader of the Islamic State (ISIS), is an Israeli intelligence agent.
-Millions of Jews died in the Holocaust in Europe during World War II.*
-The number of Jews who died in the Holocaust has been greatly exaggerated.
-The United States is trying to destroy the Islamic State (ISIS).*
-Jewish leaders are secretly conspiring to achieve world domination.
-Arabs carried out the attacks against the United States (the World Trade Center and the Pentagon) on September 11, 2001.*
-Jews carried out the September 11, 2001 attacks against the World Trade Center and the Pentagon in the United States.
*/


/*default coding:
1	Very accurate
2	Somewhat accurate
3	Not very accurate
4	Not at all accurate
*/

*false/CT ones

/*
-The United States is secretly trying to help the Islamic State (ISIS) take power in Syria and Iraq.
-Abu Bakr Al-Bagdadi, the leader of the Islamic State (ISIS), is an Israeli intelligence agent.
-Millions of Jews died in the Holocaust in Europe during World War II.*
-The number of Jews who died in the Holocaust has been greatly exaggerated.
-The United States is trying to destroy the Islamic State (ISIS).*
-Jewish leaders are secretly conspiring to achieve world domination.
-Arabs carried out the attacks against the United States (the World Trade Center and the Pentagon) on September 11, 2001.*
-Jews carried out the September 11, 2001 attacks against the World Trade Center and the Pentagon in the United States.
*/

tab Q21_Q21_1 
ttest Q21_Q21_1,by(ksa_res) unequal 

tab Q21_Q21_2
ttest Q21_Q21_2,by(ksa_res) unequal 

tab Q21_Q21_4
ttest Q21_Q21_4,by(ksa_res) unequal 

tab Q21_Q21_6
ttest Q21_Q21_6,by(ksa_res) unequal 

tab Q21_Q21_8
ttest Q21_Q21_8,by(ksa_res) unequal

gen totalendorsed=(Q21_Q21_1>2 & Q21_Q21_1<5)+(Q21_Q21_2>2 & Q21_Q21_2<5)+(Q21_Q21_4>2 & Q21_Q21_4<5)+(Q21_Q21_6>2 & Q21_Q21_6<5)+(Q21_Q21_8>2 & Q21_Q21_8<5)

gen usisis=(Q21_Q21_1>2 & Q21_Q21_1<5)
gen abb=(Q21_Q21_2>2 & Q21_Q21_2<5)
gen holdenial=(Q21_Q21_4>2 & Q21_Q21_4<5)
gen worlddom=(Q21_Q21_6>2 & Q21_Q21_6<5)
gen jew911=(Q21_Q21_8>2 & Q21_Q21_8<5)

su usisis-jew911

/*Figure B1*/
graph bar (mean) usisis abb holdenial worlddom jew911, graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") scheme(s2mono) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) legend(lab(1 "US helping ISIS") lab(2 "Al-Bagdadi Israeli agent") lab(3 "Holocaust exaggerated") lab(4 "Jewish conspiracy") lab(5 "Jews carried out 9/11") rows(2) size(*.75) symxsize(*.75) symysize(*.75)) caption(`"Proportion of respondents indicating claim is "Somewhat accurate" or "Very accurate""', size(*.65))
graph export "survey-marginals.pdf", replace

graph bar (mean) usisis abb holdenial worlddom jew911 if ksa==0, graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") scheme(s2mono) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%",angle(0)) legend(lab(1 "US helping ISIS") lab(2 "Al-Bagdadi Israeli agent") lab(3 "Holocaust exaggerated") lab(4 "Jewish conspiracy") lab(5 "Jews carried out 9/11") rows(2) size(*.75) symxsize(*.75) symysize(*.75)) yscale(r(0 .8)) saving(egypt, replace) title("Egypt") ysize(5) xsize(10)
graph export "survey-marginals-ksa.pdf", replace

graph bar (mean) usisis abb holdenial worlddom jew911 if ksa==1, graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") scheme(s2mono) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%",angle(0)) legend(lab(1 "US helping ISIS") lab(2 "Al-Bagdadi Israeli agent") lab(3 "Holocaust exaggerated") lab(4 "Jewish conspiracy") lab(5 "Jews carried out 9/11") rows(2) size(*.75) symxsize(*.75) symysize(*.75)) yscale(r(0 .8)) saving(ksa, replace) title("Saudi Arabia") ysize(5) xsize(10)
graph export "survey-marginals-egypt.pdf", replace

grc1leg "egypt.gph" "ksa.gph" , caption(`"Proportion of YouGov MENA panel respondents indicating claim is "Somewhat accurate" or "Very accurate""', size(*.65)) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ysize(5) xsize(20)
graph export "survey-marginals-combined.pdf", replace

*true ones

tab Q21_Q21_3
bysort country: tab Q21_Q21_3

tab Q21_Q21_5
bysort country: tab Q21_Q21_5

tab Q21_Q21_7
bysort country: tab Q21_Q21_7

**Attitudes Toward Democracy/Security

/*
In a democracy, the economy runs badly
Democracies are indecisive and have too much quibbling
Democracies are not good at maintaining order 
Democracy is a Western form of government which is not compatible with Islam
Please indicate whether you agree or disagree with the following statement: Respect for human rights in $country is important, but promoting security and stability is more important.

1	Strongly disagree
2	Somewhat disagree
3	Somewhat agree
4	Strongly agree
*/

alpha Q23_Q23_* Q24, item
factor Q23_Q23_* Q24, pcf
predict antidem_post

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q23_Q23_1_~d | 2015    +       0.8061        0.6825        .4606782      0.7472
Q23_Q23_2_~d | 2015    +       0.7944        0.6589        .4620191      0.7533
Q23_Q23_3_~d | 2015    +       0.8489        0.7419        .4246844      0.7267
Q23_Q23_4_~d | 2015    +       0.7836        0.6319        .4601202      0.7613
Q24          | 2015    +       0.5407        0.3064        .6287494      0.8560
-------------+-----------------------------------------------------------------
Test scale   |                                             .4872503      0.8094
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          5

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.93724      2.07297            0.5874       0.5874
        Factor2  |      0.86428      0.36835            0.1729       0.7603
        Factor3  |      0.49593      0.09047            0.0992       0.8595
        Factor4  |      0.40546      0.10837            0.0811       0.9406
        Factor5  |      0.29709            .            0.0594       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(10) = 3795.88 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
    Q23_Q23_1_~d |   0.8311 |      0.3092  
    Q23_Q23_2_~d |   0.8133 |      0.3386  
    Q23_Q23_3_~d |   0.8745 |      0.2352  
    Q23_Q23_4_~d |   0.7922 |      0.3723  
             Q24 |   0.4389 |      0.8074  
    ---------------------------------------
*/

**Attitudes Towards ISIS

/*
Please indicate whether you agree or disagree with the following statement: <br> Even though I don’t agree with everything they do, I can understand why someone would go to fight for the Islamic State (ISIS).

1	Strongly disagree
2	Somewhat disagree
3	Somewhat agree
4	Strongly agree
*/

rename Q25 ISIS_sympathy
tab ISIS_sympathy

/*
        Q25 |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        665       33.00       33.00
          2 |        461       22.88       55.88
          3 |        581       28.83       84.71
          4 |        308       15.29      100.00
------------+-----------------------------------
      Total |      2,015      100.00
*/

**Post Treatment Anti-West

/*


Q29	1	Western music, movies, and television have hurt morality in our country
	2	Western music, movies and television have NOT hurt morality in our country

Q30 questions:
	1	Yes, associate
	2	No, do not associate
	3	Don’t know

	Selfish
	Respectful*
	Tolerant*
	Honest*
	Generous*
	Violent
	Greedy
	Immoral
	Arrogant
*/

recode Q29 (2=0)
foreach var of varlist Q30_Q30* {
recode `var' (3=2)(1=3)(2=1)
}

*positives load separately
alpha Q29 Q30*, item
factor Q29 Q30*, pcf

/*

Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q29          | 2015    +       0.0832       -0.0014         .248574      0.8360
Q30_Q30_1_~d | 2015    +       0.7275        0.6261        .1829483      0.7893
Q30_Q30_2_~d | 2015    +       0.5367        0.4100        .2082722      0.8129
Q30_Q30_3_~d | 2015    +       0.6228        0.5002        .1964904      0.8038
Q30_Q30_4_~d | 2015    +       0.6211        0.4939        .1957357      0.8047
Q30_Q30_5_~d | 2015    +       0.6252        0.5219        .2009923      0.8019
Q30_Q30_6_~d | 2015    +       0.6644        0.5506        .1915717      0.7982
Q30_Q30_7_~d | 2015    +       0.7276        0.6257        .1827848      0.7893
Q30_Q30_8_~d | 2015    +       0.6681        0.5611        .1928972      0.7972
Q30_Q30_9_~d | 2015    +       0.6967        0.5904        .1876806      0.7936
-------------+-----------------------------------------------------------------
Test scale   |                                             .1987947      0.8197
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          2
    Rotation: (unrotated)                        Number of params =         19

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      3.91384      2.43625            0.3914       0.3914
        Factor2  |      1.47759      0.58196            0.1478       0.5391
        Factor3  |      0.89563      0.20930            0.0896       0.6287
        Factor4  |      0.68633      0.06573            0.0686       0.6973
        Factor5  |      0.62060      0.08320            0.0621       0.7594
        Factor6  |      0.53740      0.02455            0.0537       0.8131
        Factor7  |      0.51284      0.01002            0.0513       0.8644
        Factor8  |      0.50283      0.04592            0.0503       0.9147
        Factor9  |      0.45690      0.06086            0.0457       0.9604
       Factor10  |      0.39604            .            0.0396       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(45) = 5820.53 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    -------------------------------------------------
        Variable |  Factor1   Factor2 |   Uniqueness 
    -------------+--------------------+--------------
             Q29 |   0.0077    0.5379 |      0.7107  
    Q30_Q30_1_~d |   0.7401    0.2946 |      0.3655  
    Q30_Q30_2_~d |   0.5244   -0.4764 |      0.4981  
    Q30_Q30_3_~d |   0.6145   -0.4431 |      0.4261  
    Q30_Q30_4_~d |   0.6082   -0.4660 |      0.4130  
    Q30_Q30_5_~d |   0.6343   -0.3516 |      0.4740  
    Q30_Q30_6_~d |   0.6659    0.3136 |      0.4582  
    Q30_Q30_7_~d |   0.7393    0.3090 |      0.3580  
    Q30_Q30_8_~d |   0.6745    0.2769 |      0.4684  
    Q30_Q30_9_~d |   0.7045    0.2588 |      0.4367  
    -------------------------------------------------
*/

alpha Q29 Q30_Q30_1 Q30_Q30_6 Q30_Q30_7 Q30_Q30_8 Q30_Q30_9, item
factor Q29 Q30_Q30_1 Q30_Q30_6 Q30_Q30_7 Q30_Q30_8 Q30_Q30_9, pcf
predict neg_west_post

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q29          | 2015    +       0.2093        0.0859        .3559102      0.8303
Q30_Q30_1_~d | 2015    +       0.7978        0.6652        .2118527      0.7303
Q30_Q30_6_~d | 2015    +       0.7392        0.5852        .2307894      0.7518
Q30_Q30_7_~d | 2015    +       0.8012        0.6696         .210583      0.7290
Q30_Q30_8_~d | 2015    +       0.7315        0.5836        .2359749      0.7523
Q30_Q30_9_~d | 2015    +       0.7572        0.6103        .2254459      0.7453
-------------+-----------------------------------------------------------------
Test scale   |                                             .2450927      0.7932
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          6

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.99090      1.99840            0.4985       0.4985
        Factor2  |      0.99250      0.37870            0.1654       0.6639
        Factor3  |      0.61380      0.08415            0.1023       0.7662
        Factor4  |      0.52965      0.05274            0.0883       0.8545
        Factor5  |      0.47691      0.08068            0.0795       0.9340
        Factor6  |      0.39624            .            0.0660       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(15) = 3424.19 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
             Q29 |   0.1279 |      0.9836  
    Q30_Q30_1_~d |   0.8079 |      0.3473  
    Q30_Q30_6_~d |   0.7364 |      0.4578  
    Q30_Q30_7_~d |   0.8103 |      0.3435  
    Q30_Q30_8_~d |   0.7360 |      0.4583  
    Q30_Q30_9_~d |   0.7625 |      0.4186  
    ---------------------------------------
*/

alpha Q30_Q30_2 Q30_Q30_3 Q30_Q30_4 Q30_Q30_5, item
factor Q30_Q30_2 Q30_Q30_3 Q30_Q30_4 Q30_Q30_5, pcf
predict pos_west_post

/*
Test scale = mean(unstandardized items)

                                                            average
                             item-test     item-rest       interitem
Item         |  Obs  Sign   correlation   correlation     covariance      alpha
-------------+-----------------------------------------------------------------
Q30_Q30_2_~d | 2015    +       0.7065        0.4803        .3099178      0.7251
Q30_Q30_3_~d | 2015    +       0.7848        0.5779        .2543079      0.6719
Q30_Q30_4_~d | 2015    +       0.7951        0.5860        .2454156      0.6673
Q30_Q30_5_~d | 2015    +       0.7342        0.5395        .2970337      0.6959
-------------+-----------------------------------------------------------------
Test scale   |                                             .2766687      0.7493
-------------------------------------------------------------------------------

Factor analysis/correlation                      Number of obs    =      2,015
    Method: principal-component factors          Retained factors =          1
    Rotation: (unrotated)                        Number of params =          4

    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |      2.28757      1.60364            0.5719       0.5719
        Factor2  |      0.68393      0.16477            0.1710       0.7429
        Factor3  |      0.51916      0.00982            0.1298       0.8727
        Factor4  |      0.50934            .            0.1273       1.0000
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(6)  = 1776.51 Prob>chi2 = 0.0000

Factor loadings (pattern matrix) and unique variances

    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
    Q30_Q30_2_~d |   0.6951 |      0.5169  
    Q30_Q30_3_~d |   0.7847 |      0.3843  
    Q30_Q30_4_~d |   0.7894 |      0.3769  
    Q30_Q30_5_~d |   0.7521 |      0.4343  
    ---------------------------------------
*/

/*For H1, we estimate the correlation between pre-treatment anti-Western attitudes and conspiracy and misperception belief in a model that controls for fixed effects as well as demographic controls for age, sex, religion (Egyptian Coptic Christians), socioeconomic status, education, and an indicator for non-citizen residents of Saudi Arabia. */

/*For RQ1, we will estimate the same model as H1 but also interact our measure of pre-treatment anti-Western attitudes with either a measure of political knowledge or a measure of respondent education in separate models.*/

reg conspiracy_dvs west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store A

gen west_unfavXcollege=west_unfav*college
gen jews_israel_unfavXcollege=jews_unfav*college

reg conspiracy_dvs west_unfav west_unfavXcollege jews_israel_unfav jews_israel_unfavXcollege age male unemployed college non_saudi_national ksa_res, robust
est store B 

xtile pk=polknow,nq(4)

gen pk2=(pk==2)
gen pk3=(pk==3)

gen west_unfavXpk2=west_unfav*pk2
gen west_unfavXpk3=west_unfav*pk3

gen jews_israel_unfavXpk2=jews_israel_unfav*pk2
gen jews_israel_unfavXpk3=jews_israel_unfav*pk3

reg conspiracy_dvs west_unfav jews_israel_unfav college age male unemployed ksa_res non_saudi_national pk2 pk3 west_unfavXpk* jews_israel_unfavXpk*, robust
est store C

/*Table 1*/
estout A B C, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

reg conspiracy_dvs west_unfav jews_israel_unfav college age male unemployed egyptian_in_ksa nonegyptian_in_ksa saudi_in_ksa pk2 pk3 west_unfavXpk* jews_israel_unfavXpk*, robust
est store C2

/*Table B3*/
estout A B C2, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*exploratory individual item analysis*/

/*gen usisis=(Q21_Q21_1>2 & Q21_Q21_1<5)
gen abb=(Q21_Q21_2>2 & Q21_Q21_2<5)
gen holdenial=(Q21_Q21_4>2 & Q21_Q21_4<5)
gen worlddom=(Q21_Q21_6>2 & Q21_Q21_6<5)
gen jew911=(Q21_Q21_8>2 & Q21_Q21_8<5)*/

reg Q21_Q21_1 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store A
reg Q21_Q21_2 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store B
reg Q21_Q21_4 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store C
reg Q21_Q21_6 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store D
reg Q21_Q21_8 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store E

/*Table B4*/
estout A B C D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01)

oprobit Q21_Q21_1 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store A
oprobit Q21_Q21_2 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store B
oprobit Q21_Q21_4 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store C
oprobit Q21_Q21_6 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store D
oprobit Q21_Q21_8 west_unfav jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust
est store E

estout A B C D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*marginal effects plot*/

preserve

reg conspiracy_dvs c.west_unfav##i.pk c.jews_israel_unfav##i.pk college age male unemployed non_saudi_national ksa_res, robust
test 2.pk#c.west_unfav=3.pk#c.west_unfav=0 
test 2.pk#c.jews_israel_unfav=3.pk#c.jews_israel_unfav=0

lincom 2.pk#c.west_unfav-3.pk#c.west_unfav
lincom 2.pk#c.jews_israel_unfav-3.pk#c.jews_israel_unfav

lincom west_unfav+2.pk#c.west_unfav
lincom west_unfav+3.pk#c.west_unfav

lincom jews_israel_unfav+2.pk#c.jews_israel_unfav
lincom jews_israel_unfav+3.pk#c.jews_israel_unfav

reg conspiracy_dvs c.west_unfav##i.pk c.jews_israel_unfav college age male unemployed non_saudi_national ksa_res, robust
test 2.pk#c.west_unfav=3.pk#c.west_unfav=0 /*.18*/
lincom west_unfav+2.pk#c.west_unfav
lincom west_unfav+3.pk#c.west_unfav
lincom 2.pk#c.west_unfav-3.pk#c.west_unfav

reg conspiracy_dvs c.west_unfav c.jews_israel_unfav##i.pk college age male unemployed non_saudi_national ksa_res, robust
test 2.pk#c.jews_israel_unfav=3.pk#c.jews_israel_unfav=0 /*p<.05*/
lincom jews_israel_unfav+2.pk#c.jews_israel_unfav
lincom jews_israel_unfav+3.pk#c.jews_israel_unfav
lincom 2.pk#c.jews_israel_unfav-3.pk#c.jews_israel_unfav

reg conspiracy_dvs c.west_unfav##i.pk c.jews_israel_unfav##i.pk college age male unemployed non_saudi_national ksa_res, robust
matrix define A = (.,.,.\.,.,.\.,.,.)
matrix define B = r(table)
matrix A[1,1]=B[1,1]
matrix A[1,2]=B[5,1]
matrix A[1,3]=B[6,1]
lincom west_unfav+2.pk#c.west_unfav
matrix A[2,1]=r(estimate)
matrix A[2,2]=r(estimate)-1.96*r(se)
matrix A[2,3]=r(estimate)+1.96*r(se)
lincom west_unfav+3.pk#c.west_unfav
matrix A[3,1]=r(estimate)
matrix A[3,2]=r(estimate)-1.96*r(se)
matrix A[3,3]=r(estimate)+1.96*r(se)
matrix list A
svmat A
rename A1 westimate
rename A2 wll
rename A3 wul

reg conspiracy_dvs c.west_unfav##i.pk c.jews_israel_unfav##i.pk college age male unemployed non_saudi_national ksa_res, robust
matrix define A = (.,.,.\.,.,.\.,.,.)
matrix define B = r(table)
matrix A[1,1]=B[1,8]
matrix A[1,2]=B[5,8]
matrix A[1,3]=B[6,8]
lincom jews_israel_unfav+2.pk#c.jews_israel_unfav
matrix A[2,1]=r(estimate)
matrix A[2,2]=r(estimate)-1.96*r(se)
matrix A[2,3]=r(estimate)+1.96*r(se)
lincom jews_israel_unfav+3.pk#c.jews_israel_unfav
matrix A[3,1]=r(estimate)
matrix A[3,2]=r(estimate)-1.96*r(se)
matrix A[3,3]=r(estimate)+1.96*r(se)
matrix list A
svmat A
rename A1 jestimate
rename A2 jll
rename A3 jul

gen dupey=1
gen obs=_n
replace dupey=2 if westimate!=.
expand dupey
bysort obs: gen numobs=_n

replace polknow=3 if obs==1 & numobs==1 
replace polknow=5 if obs==2 & numobs==1
replace polknow=6 if obs==3 & numobs==1

gen pipe="|"
gen where=-.015 

gen wintnoise=polknow+.5*runiform()-.5*runiform() if obs>3 | (obs<4 & numobs!=1) /*rug plot - jitter for visibility*/

twoway (rcap wul wll polknow if numobs==1,graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") yscale(r(0 .2)) ylabel(,angle(0) labsize(*1.25)) scheme(s2mono) xscale(r(0 6)) xlabel(0(1)6, labsize(*1.25)) xtitle("Political knowledge", size(*1.25))) (scatter where wintnoise, msymbol(none) mlabel(pipe) mlabpos(0) mcolor(gs3) legend(off) title("Anti-Western views") saving(me1,replace)) (scatter westimate polknow if numobs==1,msymbol(s)) 
graph export "wtercile.pdf", replace

twoway (rcap jul jll polknow if numobs==1,graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") scheme(s2mono) xscale(r(0 6)) ylabel(,angle(0) labsize(*1.25)) xlabel(0(1)6, labsize(*1.25)) xtitle("Political knowledge", size(*1.25))) (scatter where wintnoise, msymbol(none) mlabel(pipe) mlabpos(0) mcolor(gs3) legend(off) title("Anti-Jewish/Israeli views") saving(me2,replace)) (scatter jestimate polknow if numobs==1,msymbol(s))
graph export "jtercile.pdf", replace

/*Figure 1*/
graph combine "me1.gph" "me2.gph", graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ysize(5) xsize(10) 
graph export "mes-combined.pdf", replace

restore

/*For H2a, we estimate the correlation between self-reported feelings of control and conspiracy and misperception belief in a model that controls for fixed effects as well as demographic controls for age, sex, religion (Egyptian Coptic Christians), socioeconomic status, education, and an indicator for non-citizen residents of Saudi Arabia. */

reg conspiracy_dvs pretreat_high_control pretreat_low_control age male unemployed college non_saudi_national ksa_res, robust 
est store A

reg truth_dvs pretreat_high_control pretreat_low_control age male unemployed college non_saudi_national ksa_res, robust 

/*For H2b and RQ2, we will use OLS with robust standard errors to estimate the effects of the low control manipulation on our composite measure of conspiracy and misperception belief. The effect of the low control manipulation will be estimated relative to both the high control manipulation (for H2b) and the placebo (for RQ2). The model will be specified as y=b0+b1*low_control+b2*high_control+b3*saudi_arabia. We will then compute the low control effect as b2-b1 for H2 and examine b1 for RQ2. (We may also estimate the model with the standard set of demographic covariates described above in addition to the KSA fixed effect if including those demographic measures has a substantively important effect on the precision of our treatment effect estimate but in that case both models will be reported.)*/

reg conspiracy_dvs low_control high_control ksa_res, robust
lincom low_control-high_control

reg conspiracy_dvs low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store B

/*Table 2/B6*/
estout A B, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*In evaluating these findings and H3a/H3b, we will also consider the effects of the treatment on our manipulation check measure. This outcome variable will be evaluated using the same model/approach as H2b and RQ2.*/ 

reg manip_check_control low_control high_control ksa_res, robust
lincom low_control-high_control 

reg manip_check_control low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control 

/*exploratory individual DV analysis*/

pwcorr Q21_Q21_1 Q21_Q21_2 Q21_Q21_4 Q21_Q21_6 Q21_Q21_8 conspiracy_dvs

**US is secretly trying to help ISIS
reg Q21_Q21_1 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store A

*Bagdadi is a US intel agent
reg Q21_Q21_2 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store B

*Number of Jews who died in Holocaust has been exaggerated
reg Q21_Q21_4 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store C

*Jewish leaders secretly conspiring
reg Q21_Q21_6 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store D

*Jews carried out 9/11
reg Q21_Q21_8 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store E

/*Table B7*/
estout A B C D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

**US is secretly trying to help ISIS
oprobit Q21_Q21_1 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
est store A

*Bagdadi is a US intel agent
oprobit Q21_Q21_2 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
est store B

*Number of Jews who died in Holocaust has been exaggerated
oprobit Q21_Q21_4 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
est store C

*Jewish leaders secretly conspiring
oprobit Q21_Q21_6 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
est store D

*Jews carried out 9/11
oprobit Q21_Q21_8 low_control high_control age male unemployed college non_saudi_national ksa_res, robust
est store E

estout A B C D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

reg Q21_Q21_1 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store A
reg Q21_Q21_2 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store B
reg Q21_Q21_4 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store C
reg Q21_Q21_6 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store D
reg Q21_Q21_8 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store E

/*Table B5*/
estout A B C D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

oprobit Q21_Q21_1 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store A
oprobit Q21_Q21_2 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store B
oprobit Q21_Q21_4 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store C
oprobit Q21_Q21_6 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store D
oprobit Q21_Q21_8 west_unfav jews_israel_unfav pk2 pk3 college age male unemployed ksa_res non_saudi_national west_unfavXpk* jews_israel_unfavXpk*, robust
est store E

estout A B C D E, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

preserve

gen cond=0
replace cond=.5 if low_control==1 
replace cond=1 if high_control==1

gen mcse=manip_check
gen cdse=conspiracy_dvs

collapse (mean) manip_check conspiracy_dvs (sem) mcse cdse,by(cond) 

gen mcul=manip_check+1.96*mcse
gen mcll=manip_check-1.96*mcse

gen cdul=conspiracy_dvs+1.96*cdse
gen cdll=conspiracy_dvs-1.96*cdse

twoway (rcap mcul mcll cond,graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") yscale(r(1 6)) ylabel(1 "No control" 2 "Very little control" 3 "Some control" 4 "Quite a bit of control" 5 "A great deal of control" 6 "Total control",angle(0) labsize(*.75)) ytick(2(1)5) scheme(s2mono) xlabel(0 "Placebo" .5 "Low control" 1 "High control",labsize(*.75)) xtitle("")) (scatter manip_check cond,msymbol(s) saving(cont1,replace) legend(off) xscale(r(-.3 1.3)) title("Manipulation check")) 

twoway (rcap cdul cdll cond,graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("") yscale(r(1 4)) ylabel(1 "Not at all accurate" 2 "Not very accurate" 3 "Somewhat accurate" 4 "Very accurate",angle(0) labsize(*.75)) scheme(s2mono) xlabel(0 "Placebo" .5 "Low control" 1 "High control",labsize(*.75)) xtitle("")) (scatter conspiracy_dvs cond,msymbol(s) saving(cont2,replace) legend(off) xscale(r(-.3 1.3)) title("Conspiracy belief"))

/*Figure B2*/
graph combine "cont1.gph" "cont2.gph", graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ysize(5) xsize(10) 
graph export "control-panels.pdf", replace

restore

/*If the low control manipulation has a large and statistically significant effect on our post-treatment measure of self-reported feelings of control (i.e., meets the criteria for a strong instrument), we will also estimate an instrumental variables regression that uses assignment to the low control condition as an instrument for post- treatment self-reported feelings of control. We will then estimate a local average treatment effect (LATE) of variation in feelings of control for people whose feelings of control were affected by the experimental manipulation.*/

ivreg2 conspiracy_dvs (manip_check_control=low_control high_control) ksa_res, robust first
ivreg2 conspiracy_dvs (manip_check_control=low_control high_control) age male unemployed college non_saudi_national ksa_res, robust first

ivreg2 conspiracy_dvs (manip_check_control=high_control) ksa_res if low_control==1 | high_control==1, robust first
ivreg2 conspiracy_dvs (manip_check_control=high_control) age male unemployed college non_saudi_national ksa_res if low_control==1 | high_control==1, robust first

ivreg2 truth_dvs (manip_check_control=low_control high_control) ksa_res, robust first
ivreg2 truth_dvs (manip_check_control=low_control high_control) age male unemployed college non_saudi_national ksa_res, robust first

ivreg2 truth_dvs (manip_check_control=high_control) ksa_res if low_control==1 | high_control==1, robust first
ivreg2 truth_dvs (manip_check_control=high_control) age male unemployed college non_saudi_national ksa_res if low_control==1 | high_control==1, robust first

/*For H3a, we estimate whether the association between pre-treatment self-reported feelings of control and conspiracy and misperception belief is moderated by pre- treatment anti-Western attitudes in a model that also controls for fixed effects as well as demographic controls for age, sex, religion (Egyptian Coptic Christians), socioeconomic status, education, and an indicator for non-citizen residents of Saudi Arabia. (This model will again use the measures of feelings of control and anti- Western attitudes constructed according to the procedure described above for H2a and H1, respectively.)*/

reg conspiracy_dvs c.pretreat_high_control##c.west_unfav c.pretreat_low_control##c.west_unfav age male unemployed college non_saudi_national ksa_res, robust 
reg conspiracy_dvs c.pretreat_high_control##c.jews_israel_unfav c.pretreat_low_control##c.jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust /*low control * jews unfav interaction*/

reg truth_dvs c.pretreat_high_control##c.west_unfav c.pretreat_low_control##c.west_unfav age male unemployed college non_saudi_national ksa_res, robust 
reg truth_dvs c.pretreat_high_control##c.jews_israel_unfav c.pretreat_low_control##c.jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust 

/*For H3b, we will estimate a similar model to H2b but interact our indicators for our low and high control conditions with our measure of pre-treatment anti-Western attitudes as used in H1. We will use this interaction to see if the effect of our
treatments on conspiracy and misperception belief is moderated by anti-Western attitudes. The model will be specified as y=b0+b1*low_control+b2*high_control+b3*anti_Western_attitudes+b4*low_control anti_western+b5*high_controlXanti_western+b6*saudi_arabia. We will then compute the marginal effect of low versus high control over the range of anti- Western attitudes using a procedure similar to that described in Brambor et al. 2006 but implementing the robustness checks and recommendations of Hainmeuller et al. (N.d.). (Note: We may again estimate the model with the standard set of demographic covariates described above in addition to the KSA fixed effect if including those demographic measures has a substantively important effect on the precision of our treatment effect estimate but in that case both models will be reported.)*/

reg conspiracy_dvs low_control##c.west_unfav high_control##c.west_unfav ksa_res, robust
reg conspiracy_dvs low_control##c.jews_israel_unfav high_control##c.jews_israel_unfav ksa_res, robust

reg conspiracy_dvs low_control##c.west_unfav high_control##c.west_unfav age male unemployed college non_saudi_national ksa_res, robust
reg conspiracy_dvs low_control##c.jews_israel_unfav high_control##c.jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust

reg truth_dvs low_control##c.west_unfav high_control##c.west_unfav ksa_res, robust
reg truth_dvs low_control##c.jews_israel_unfav high_control##c.jews_israel_unfav ksa_res, robust

reg truth_dvs low_control##c.west_unfav high_control##c.west_unfav age male unemployed college non_saudi_national ksa_res, robust
reg truth_dvs low_control##c.jews_israel_unfav high_control##c.jews_israel_unfav age male unemployed college non_saudi_national ksa_res, robust

/*If the country or group-based measures of anti-Western attitudes do not scale well together, we will analyze each group separately, considering attitudes towards Christians, Jews, Americans, the US, the UK, and Israel separately. (We will also evaluate RQ3a using this model, which allows us to estimate whether belief in conspiracy theories and misperceptions differs between respondents in Egypt and Saudi Arabia conditional on the observable characteristics described above. We will also estimate a version of the model in which we omit the control, religion, socioeconomic status, and education variables, which are arguably post-treatment for country-level difference. If the results are substantively different in this model, we will report it instead.)*/

reg conspiracy_dvs age male non_saudi_national ksa_res, robust
est store A

/*To test RQ3b, we will also evaluate whether the effect of reminders of feelings of low control on belief in conspiracy theories and misperceptions differs between respondents in Egypt and Saudi Arabia (compared to respondents in the high control condition). This model will be specified as y=b0+b1*low_control+b2*high_control+b3*saudi_arabia+b4*low_controlXsaudi_ara bia+b5*high_controlXsaudi_arabia. We will estimate the marginal effect of low control (versus high) for both Egypt and Saudia Arabia and also evaluate whether the difference between the marginal effects is statistically significant.*/

gen low_controlXksa_res=low_control*ksa_res
gen high_controlXksa_res=high_control*ksa_res

reg conspiracy_dvs low_control high_control ksa_res low_controlXksa_res high_controlXksa_res non_saudi_national, robust
est store A
estout A, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

reg conspiracy_dvs low_control high_control ksa_res low_controlXksa_res high_controlXksa_res age male unemployed college non_saudi_national, robust
est store B

/*Table B8*/
estout A B, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

lincom low_control-high_control
lincom (low_control+low_controlXksa_res)-(high_control+high_controlXksa_res)
lincom low_controlXksa_res-high_controlXksa_res
reg truth_dvs low_control high_control ksa_res low_controlXksa_res high_controlXksa_res, robust
lincom low_control-high_control
lincom (low_control+low_controlXksa_res)-(high_control+high_controlXksa_res)
lincom low_controlXksa_res-high_controlXksa_res

/*Finally, our analyses for RQ4a-RQ4c will repeat the analysis described above for H2b but with the dependent variable as attitudes towards democracy (RQ4a), sympathy for fighting for the Islamic State (RQ4b), and attitudes toward the West (RQ4c), which will be measured as described above.*/

reg antidem_post low_control high_control ksa_res, robust
lincom low_control-high_control

reg antidem_post low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store A

reg ISIS_sympathy low_control high_control ksa_res, robust
lincom low_control-high_control

reg ISIS_sympathy low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store B
reg neg_west_post low_control high_control ksa_res, robust
lincom low_control-high_control

reg neg_west_post low_control high_control age male unemployed college non_saudi_national ksa_res, robust
lincom low_control-high_control
est store C

/*Table B9*/
estout A B C, label style(tex) replace varwidth(25) collabels("") cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 
