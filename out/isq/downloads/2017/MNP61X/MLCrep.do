use "MLCrep.dta"

********************
***NOTE FOR USERS***
********************

*The "solsch" variable is part of the "Change in Source of Leader Support" (CHISOLS) project. Please see the web appendix for a discussion of how this variable relates to the SOLS change variable in the CHISOLS data.
*For updated CHISOLS data, please check with Brett Ashley Leeds (leeds@rice.edu) or Michaela Mattes (m.mattes@berkeley.edu)


***************************
**Descriptive Statistics**
***************************

**Main Independent Variables
tab demboth if  logvotech!=. & interim==0 & regtrans==0
tab regtrans if  logvotech!=. & interim==0 
tab leadertrans if  logvotech!=. & interim==0 & demboth==1
tab leadertrans if  logvotech!=. & interim==0 & autboth==1
tab solsch if  logvotech!=. & interim==0 & demboth==1 & leadertrans==1
tab solsch if  logvotech!=. & interim==0 & autboth==1 & leadertrans==1
ttest leadertrans if  logvotech!=. & interim==0, by(demboth) unpaired unequal
ttest solsch if  logvotech!=. & interim==0, by(demboth) unpaired unequal

**Control Variables
tab CWend if  logvotech!=. & interim==0 
tab USally if  logvotech!=. & interim==0 
tab USSRally if  logvotech!=. & interim==0 
tab regtrans if  logvotech!=. & interim==0 

**Relationship between SOLS Change and Regime Transition
tab solsch if  logvotech!=. & interim==0 & regtrans==1
tab regtrans if  logvotech!=. & interim==0 & solsch==1
corr solsch regtrans if  logvotech!=. & interim==0 

**Frequencies of Non-leader Transition Years, Other Leader Transitions, and SOLS Changes across different Regime Types
tab nonleadertrans if demboth==1 & logvotech!=. & interim==0
tab nonleadertrans if autboth==1 & logvotech!=. & interim==0
tab nonleadertrans if regtrans==1 & logvotech!=. & interim==0
tab othldrtrans if demboth==1 & logvotech!=. & interim==0
tab othldrtrans if autboth==1 & logvotech!=. & interim==0
tab othldrtrans if regtrans==1 & logvotech!=. & interim==0
tab solsch if demboth==1 & logvotech!=. & interim==0
tab solsch if autboth==1 & logvotech!=. & interim==0
tab solsch if regtrans==1 & logvotech!=. & interim==0

**Relationship between SOLS Changes/Other Leader Transitions and Archigos Irregular Entry
tab irrentry if othldrtrans==1 & demboth==1 & leadertrans==1 & logvotech!=. & interim==0
tab irrentry if solsch==1 & demboth==1 & leadertrans==1 & logvotech!=. & interim==0
tab irrentry if othldrtrans==1 & demboth==0 & leadertrans==1 & logvotech!=. & interim==0
tab irrentry if solsch==1 & demboth==0 & leadertrans==1 & logvotech!=. & interim==0


*****************
** Main Models **
*****************

*Model 1: Basic Model--no controls
xtreg logvotech solsch othldrtrans demboth if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg logvotech solsch##demboth othldrtrans##demboth if interim==0, i(ccode) fe robust cluster(ccode)
test 1.solsch=1.othldrtrans
margins, dydx(solsch) at(demboth==1) at(demboth==0)
margins, dydx(othldrtrans) at(demboth==1) at(demboth==0)
*Model 4: Interaction Term--controls
xtreg logvotech solsch##demboth othldrtrans##demboth CWend regtrans USally USSRally if interim==0, i(ccode) fe robust cluster(ccode)
test 1.solsch=1.othldrtrans
margins, dydx(solsch) at(demboth==1) at(demboth==0)
margins, dydx(othldrtrans) at(demboth==1) at(demboth==0)


*********************
**Robustness Checks**
*********************

**Robustness Check # 1: Non-logged UNGA Vote Change
*Model 1: Basic Model--no controls
xtreg votech solsch othldrtrans demboth if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg votech solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg votech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg votech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check #2: Excluding Regime Transitions 
*Model 1: Basic Model--no controls
xtreg logvotech solsch othldrtrans demboth if interim!=1 & (demboth==1 |autboth==1), i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend USally USSRally if interim!=1 & (demboth==1 |autboth==1), i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth if interim!=1 & (demboth==1 |autboth==1), i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend USally USSRally if interim!=1 & (demboth==1 |autboth==1), i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check # 3: Including Interim Leaders
*Model 1: Basic Model--no controls
xtreg logvotech solsch othldrtrans demboth, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USally USSRally, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check #4: December Leaders 
*Model 1: Basic Model--no controls
xtreg logvotech solsch othldrtrans demboth if interim!=1 & dec==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1 & dec==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth if interim==0 & dec==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally if interim==0 & dec==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check #5: Affinity Score as Dependent Variable 
*Model 1: Basic Model--no controls
xtreg logabss3 solsch othldrtrans demboth if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg logabss3 solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg logabss3 solsch_demboth othldrtrans_demboth solsch othldrtrans demboth if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logabss3 solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check # 6: Alliance Control Variables
*With COW Data
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USallyC USSRallyC if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USallyC USSRallyC if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*With Alliance Dummy
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans ally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans ally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check # 7: Changes in Capabilities
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend  regtrans USally USSRally logcincperch if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally logcincperch if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check # 8: Changes in GDP per capita
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USally USSRally loggdpperch if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally loggdpperch if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check # 9: Cold War Period
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USally USSRally CW88 if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally CW88 if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans

**Robustness Check # 10: Disaggregating Cold War End
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth y1989 y1990 y1991 regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
test solsch=y1991
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth y1989 y1990 y1991 regtrans USally USSRally if interim!=1, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
test solsch=y1991

**Robustness Check # 11: Archigos Irregular Leader Transitions
*Model 1: Basic Model--no controls
xtreg logvotech solsch othldrtrans demboth if interim!=1 & irrentry==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 2: Basic Model--controls
xtreg logvotech solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1 & irrentry==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 3: Interaction Term--no controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth if interim!=1 & irrentry==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
*Model 4: Interaction Term--controls
xtreg logvotech solsch_demboth othldrtrans_demboth solsch othldrtrans demboth CWend regtrans USally USSRally if interim!=1 & irrentry==0, i(ccode) fe robust cluster(ccode)
test solsch=othldrtrans
