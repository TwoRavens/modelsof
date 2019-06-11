
******************************************************************************
******************************************************************************

** National Elections and the Dynamics of International Negotiations - 2016 **

******************************************************************************
******************************************************************************


// Note maximum date of dataset: 30/06/2009
// Note minimum date of dataset: 25/06/1965


clear 


*************************
*** DATA MANIPULATION ***
*************************


use "eup-10-0520-File005.dta"
save "EULO_NATEL.dta", replace
use "EULO_NATEL.dta"

drop ec9 ec10 ec12 ec15 ec25 ec27 postsea postteu postams postnice qmvbeforesea qmvpostsea qmvpostteu qmvpostams qmvpostnice


**Identify Data as Survival Data**
stset dexit, failure(event) id(case_id) enter(adt_bcommission_1)


**Split time by national elections and split for 30, 60 and 90 days before elections** 
/* The code below generates temporary variables that takes as value the dates corresponding to the election day and 90, 60 and 30 days prior to 
 elections. It then stsplits the dataset at these variables which are interpreted by stata as a numlist comprising only the number corresponding 
 to these dates. Permanent variables equal to the value of these dates are then created to be used in the creation of dummy variables. */


*************
*1. Germany *
*************

/// de 19 Sep 1965
local z=date("19 Sep 1965", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0965_a, at("`x'")
stsplit DE0965_b, at("`y'")
stsplit DE0965_c, at("`z'")
stsplit DE0965_d, at("`r'")

egen maxDE0965_a=max(DE0965_a)
egen maxDE0965_b=max(DE0965_b)
egen maxDE0965_c=max(DE0965_c)
egen maxDE0965_d=max(DE0965_d)

/// de 28 Sep 1969
local z=date("28 Sep 1969", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0969_a, at("`x'")
stsplit DE0969_b, at("`y'")
stsplit DE0969_c, at("`z'")
stsplit DE0969_d, at("`r'")

egen maxDE0969_a=max(DE0969_a)
egen maxDE0969_b=max(DE0969_b)
egen maxDE0969_c=max(DE0969_c)
egen maxDE0969_d=max(DE0969_d)

/// de 19 Nov 1972
local z=date("19 Nov 1972", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE1172_a, at("`x'")
stsplit DE1172_b, at("`y'")
stsplit DE1172_c, at("`z'")
stsplit DE1172_d, at("`r'")

egen maxDE1172_a=max(DE1172_a)
egen maxDE1172_b=max(DE1172_b)
egen maxDE1172_c=max(DE1172_c)
egen maxDE1172_d=max(DE1172_d)

/// de 3 Oct 1976
local z=date("3 Oct 1976", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE1076_a, at("`x'")
stsplit DE1076_b, at("`y'")
stsplit DE1076_c, at("`z'")
stsplit DE1076_d, at("`r'")

egen maxDE1076_a=max(DE1076_a)
egen maxDE1076_b=max(DE1076_b)
egen maxDE1076_c=max(DE1076_c)
egen maxDE1076_d=max(DE1076_d)

/// de 5 Oct 1980
local z=date("5 Oct 1980", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE1080_a, at("`x'")
stsplit DE1080_b, at("`y'")
stsplit DE1080_c, at("`z'")
stsplit DE1080_d, at("`r'")

egen maxDE1080_a=max(DE1080_a)
egen maxDE1080_b=max(DE1080_b)
egen maxDE1080_c=max(DE1080_c)
egen maxDE1080_d=max(DE1080_d)

/// de 6 Mar 1983
local z=date("6 Mar 1983", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0383_a, at("`x'")
stsplit DE0383_b, at("`y'")
stsplit DE0383_c, at("`z'")
stsplit DE0383_d, at("`r'")

egen maxDE0383_a=max(DE0383_a)
egen maxDE0383_b=max(DE0383_b)
egen maxDE0383_c=max(DE0383_c)
egen maxDE0383_d=max(DE0383_d)

/// de 25 Jan 1987
local z=date("25 Jan 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0187_a, at("`x'")
stsplit DE0187_b, at("`y'")
stsplit DE0187_c, at("`z'")
stsplit DE0187_d, at("`r'")

egen maxDE0187_a=max(DE0187_a)
egen maxDE0187_b=max(DE0187_b)
egen maxDE0187_c=max(DE0187_c)
egen maxDE0187_d=max(DE0187_d)

/// de 2 Dec 1990
local z=date("2 Dec 1990", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE1290_a, at("`x'")
stsplit DE1290_b, at("`y'")
stsplit DE1290_c, at("`z'")
stsplit DE1290_d, at("`r'")

egen maxDE1290_a=max(DE1290_a)
egen maxDE1290_b=max(DE1290_b)
egen maxDE1290_c=max(DE1290_c)
egen maxDE1290_d=max(DE1290_d)

/// de 16 Oct 1994
local z=date("16 Oct 1994", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE1094_a, at("`x'")
stsplit DE1094_b, at("`y'")
stsplit DE1094_c, at("`z'")
stsplit DE1094_d, at("`r'")

egen maxDE1094_a=max(DE1094_a)
egen maxDE1094_b=max(DE1094_b)
egen maxDE1094_c=max(DE1094_c)
egen maxDE1094_d=max(DE1094_d)

/// de 27 Sep 1998
local z=date("27 Sep 1998", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0998_a, at("`x'")
stsplit DE0998_b, at("`y'")
stsplit DE0998_c, at("`z'")
stsplit DE0998_d, at("`r'")

egen maxDE0998_a=max(DE0998_a)
egen maxDE0998_b=max(DE0998_b)
egen maxDE0998_c=max(DE0998_c)
egen maxDE0998_d=max(DE0998_d)

/// de 22 Sep 2002
local z=date("22 Sep 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0902_a, at("`x'")
stsplit DE0902_b, at("`y'")
stsplit DE0902_c, at("`z'")
stsplit DE0902_d, at("`r'")

egen maxDE0902_a=max(DE0902_a)
egen maxDE0902_b=max(DE0902_b)
egen maxDE0902_c=max(DE0902_c)
egen maxDE0902_d=max(DE0902_d)

/// de 18 sept 2005
local z=date("18 sept 2005", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0905_a, at("`x'")
stsplit DE0905_b, at("`y'")
stsplit DE0905_c, at("`z'")
stsplit DE0905_d, at("`r'")

egen maxDE0905_a=max(DE0905_a)
egen maxDE0905_b=max(DE0905_b)
egen maxDE0905_c=max(DE0905_c)
egen maxDE0905_d=max(DE0905_d)

/// de 27 Sep 2009
local z=date("27 Sep 2009", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DE0909_a, at("`x'")
stsplit DE0909_b, at("`y'")
stsplit DE0909_c, at("`z'")
stsplit DE0909_d, at("`r'")

egen maxDE0909_a=max(DE0909_a)
egen maxDE0909_b=max(DE0909_b)
egen maxDE0909_c=max(DE0909_c)
egen maxDE0909_d=max(DE0909_d)



*************
* 2. France *
*************

*Presidential*

/// fr 19 Dec 1965
local z=date("19 Dec 1965", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR1265_a, at("`x'")
stsplit FR1265_b, at("`y'")
stsplit FR1265_c, at("`z'")
stsplit FR1265_d, at("`r'")

egen maxFR1265_a=max(FR1265_a)
egen maxFR1265_b=max(FR1265_b)
egen maxFR1265_c=max(FR1265_c)
egen maxFR1265_d=max(FR1265_d)

/// fr 15 Jun 1969
local z=date("15 Jun 1969", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0669_a, at("`x'")
stsplit FR0669_b, at("`y'")
stsplit FR0669_c, at("`z'")
stsplit FR0669_d, at("`r'")

egen maxFR0669_a=max(FR0669_a)
egen maxFR0669_b=max(FR0669_b)
egen maxFR0669_c=max(FR0669_c)
egen maxFR0669_d=max(FR0669_d)

/// fr 19 May 1974
local z=date("19 May 1974", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0574_a, at("`x'")
stsplit FR0574_b, at("`y'")
stsplit FR0574_c, at("`z'")
stsplit FR0574_d, at("`r'")

egen maxFR0574_a=max(FR0574_a)
egen maxFR0574_b=max(FR0574_b)
egen maxFR0574_c=max(FR0574_c)
egen maxFR0574_d=max(FR0574_d)

/// fr 10 May 1981
local z=date("10 May 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0581_a, at("`x'")
stsplit FR0581_b, at("`y'")
stsplit FR0581_c, at("`z'")
stsplit FR0581_d, at("`r'")

egen maxFR0581_a=max(FR0581_a)
egen maxFR0581_b=max(FR0581_b)
egen maxFR0581_c=max(FR0581_c)
egen maxFR0581_d=max(FR0581_d)

/// fr 8 May 1988
local z=date("8 May 1988", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0588_a, at("`x'")
stsplit FR0588_b, at("`y'")
stsplit FR0588_c, at("`z'")
stsplit FR0588_d, at("`r'")

egen maxFR0588_a=max(FR0588_a)
egen maxFR0588_b=max(FR0588_b)
egen maxFR0588_c=max(FR0588_c)
egen maxFR0588_d=max(FR0588_d)

/// fr 7 May 1995
local z=date("7 May 1995", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0595_a, at("`x'")
stsplit FR0595_b, at("`y'")
stsplit FR0595_c, at("`z'")
stsplit FR0595_d, at("`r'")

egen maxFR0595_a=max(FR0595_a)
egen maxFR0595_b=max(FR0595_b)
egen maxFR0595_c=max(FR0595_c)
egen maxFR0595_d=max(FR0595_d)

/// fr 5 May 2002
local z=date("5 May 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0502_a, at("`x'")
stsplit FR0502_b, at("`y'")
stsplit FR0502_c, at("`z'")
stsplit FR0502_d, at("`r'")

egen maxFR0502_a=max(FR0502_a)
egen maxFR0502_b=max(FR0502_b)
egen maxFR0502_c=max(FR0502_c)
egen maxFR0502_d=max(FR0502_d)

/// fr 6 May 2007
local z=date("6 May 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0507_a, at("`x'")
stsplit FR0507_b, at("`y'")
stsplit FR0507_c, at("`z'")
stsplit FR0507_d, at("`r'")

egen maxFR0507_a=max(FR0507_a)
egen maxFR0507_b=max(FR0507_b)
egen maxFR0507_c=max(FR0507_c)
egen maxFR0507_d=max(FR0507_d)


*Parliamentary*

/// fr 12 March 1967
local z=date("12 Mar 1967", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0367_a, at("`x'")
stsplit FR0367_b, at("`y'")
stsplit FR0367_c, at("`z'")
stsplit FR0367_d, at("`r'")

egen maxFR0367_a=max(FR0367_a)
egen maxFR0367_b=max(FR0367_b)
egen maxFR0367_c=max(FR0367_c)
egen maxFR0367_d=max(FR0367_d)

/// fr 30 Jun 1968
local z=date("30 Jun 1968", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0668_a, at("`x'")
stsplit FR0668_b, at("`y'")
stsplit FR0668_c, at("`z'")
stsplit FR0668_d, at("`r'")

egen maxFR0668_a=max(FR0668_a)
egen maxFR0668_b=max(FR0668_b)
egen maxFR0668_c=max(FR0668_c)
egen maxFR0668_d=max(FR0668_d)

/// fr 11 Mar 1973
local z=date("11 Mar 1973", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0373_a, at("`x'")
stsplit FR0373_b, at("`y'")
stsplit FR0373_c, at("`z'")
stsplit FR0373_d, at("`r'")

egen maxFR0373_a=max(FR0373_a)
egen maxFR0373_b=max(FR0373_b)
egen maxFR0373_c=max(FR0373_c)
egen maxFR0373_d=max(FR0373_d)

/// fr 19 March 78
local z=date("19 Mar 1978", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0378_a, at("`x'")
stsplit FR0378_b, at("`y'")
stsplit FR0378_c, at("`z'")
stsplit FR0378_d, at("`r'")

egen maxFR0378_a=max(FR0378_a)
egen maxFR0378_b=max(FR0378_b)
egen maxFR0378_c=max(FR0378_c)
egen maxFR0378_d=max(FR0378_d)

/// fr 21 Jun 1981
local z=date("21 Jun 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0681_a, at("`x'")
stsplit FR0681_b, at("`y'")
stsplit FR0681_c, at("`z'")
stsplit FR0681_d, at("`r'")

egen maxFR0681_a=max(FR0681_a)
egen maxFR0681_b=max(FR0681_b)
egen maxFR0681_c=max(FR0681_c)
egen maxFR0681_d=max(FR0681_d)

/// fr 16 Mar 1986
local z=date("16 Mar 1986", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0386_a, at("`x'")
stsplit FR0386_b, at("`y'")
stsplit FR0386_c, at("`z'")
stsplit FR0386_d, at("`r'")

egen maxFR0386_a=max(FR0386_a)
egen maxFR0386_b=max(FR0386_b)
egen maxFR0386_c=max(FR0386_c)
egen maxFR0386_d=max(FR0386_d)

/// fr 12 Jun 1988
local z=date("12 Jun 1988", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0688_a, at("`x'")
stsplit FR0688_b, at("`y'")
stsplit FR0688_c, at("`z'")
stsplit FR0688_d, at("`r'")

egen maxFR0688_a=max(FR0688_a)
egen maxFR0688_b=max(FR0688_b)
egen maxFR0688_c=max(FR0688_c)
egen maxFR0688_d=max(FR0688_d)

/// fr 28 march 1993
local z=date("28 march 1993", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0393_a, at("`x'")
stsplit FR0393_b, at("`y'")
stsplit FR0393_c, at("`z'")
stsplit FR0393_d, at("`r'")

egen maxFR0393_a=max(FR0393_a)
egen maxFR0393_b=max(FR0393_b)
egen maxFR0393_c=max(FR0393_c)
egen maxFR0393_d=max(FR0393_d)

/// fr 1 Jun 1997
local z=date("1 Jun 1997", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0697_a, at("`x'")
stsplit FR0697_b, at("`y'")
stsplit FR0697_c, at("`z'")
stsplit FR0697_d, at("`r'")

egen maxFR0697_a=max(FR0697_a)
egen maxFR0697_b=max(FR0697_b)
egen maxFR0697_c=max(FR0697_c)
egen maxFR0697_d=max(FR0697_d)

/// fr 16 Jun 2002
local z=date("16 Jun 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0602_a, at("`x'")
stsplit FR0602_b, at("`y'")
stsplit FR0602_c, at("`z'")
stsplit FR0602_d, at("`r'")

egen maxFR0602_a=max(FR0602_a)
egen maxFR0602_b=max(FR0602_b)
egen maxFR0602_c=max(FR0602_c)
egen maxFR0602_d=max(FR0602_d)

/// fr 17 june 2007
local z=date("17 june 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FR0607_a, at("`x'")
stsplit FR0607_b, at("`y'")
stsplit FR0607_c, at("`z'")
stsplit FR0607_d, at("`r'")

egen maxFR0607_a=max(FR0607_a)
egen maxFR0607_b=max(FR0607_b)
egen maxFR0607_c=max(FR0607_c)
egen maxFR0607_d=max(FR0607_d)


*********
* 3. UK *
*********

/// uk 28 Feb 1974
local z=date("28 Feb 1974", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0274_a, at("`x'")
stsplit UK0274_b, at("`y'")
stsplit UK0274_c, at("`z'")
stsplit UK0274_d, at("`r'")

egen maxUK0274_a=max(UK0274_a)
egen maxUK0274_b=max(UK0274_b)
egen maxUK0274_c=max(UK0274_c)
egen maxUK0274_d=max(UK0274_d)

/// uk 10 Oct 1974
local z=date("10 Oct 1974", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK1074_a, at("`x'")
stsplit UK1074_b, at("`y'")
stsplit UK1074_c, at("`z'")
stsplit UK1074_d, at("`r'")

egen maxUK1074_a=max(UK1074_a)
egen maxUK1074_b=max(UK1074_b)
egen maxUK1074_c=max(UK1074_c)
egen maxUK1074_d=max(UK1074_d)

/// uk 3 May 1979
local z=date("3 May 1979", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0579_a, at("`x'")
stsplit UK0579_b, at("`y'")
stsplit UK0579_c, at("`z'")
stsplit UK0579_d, at("`r'")

egen maxUK0579_a=max(UK0579_a)
egen maxUK0579_b=max(UK0579_b)
egen maxUK0579_c=max(UK0579_c)
egen maxUK0579_d=max(UK0579_d)

/// uk 9 Jun 1983
local z=date("9 Jun 1983", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0683_a, at("`x'")
stsplit UK0683_b, at("`y'")
stsplit UK0683_c, at("`z'")
stsplit UK0683_d, at("`r'")

egen maxUK0683_a=max(UK0683_a)
egen maxUK0683_b=max(UK0683_b)
egen maxUK0683_c=max(UK0683_c)
egen maxUK0683_d=max(UK0683_d)

/// uk 11 Jun 1987
local z=date("11 Jun 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0687_a, at("`x'")
stsplit UK0687_b, at("`y'")
stsplit UK0687_c, at("`z'")
stsplit UK0687_d, at("`r'")

egen maxUK0687_a=max(UK0687_a)
egen maxUK0687_b=max(UK0687_b)
egen maxUK0687_c=max(UK0687_c)
egen maxUK0687_d=max(UK0687_d)

/// uk 9 Apr 1992
local z=date("9 Apr 1992", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0492_a, at("`x'")
stsplit UK0492_b, at("`y'")
stsplit UK0492_c, at("`z'")
stsplit UK0492_d, at("`r'")

egen maxUK0492_a=max(UK0492_a)
egen maxUK0492_b=max(UK0492_b)
egen maxUK0492_c=max(UK0492_c)
egen maxUK0492_d=max(UK0492_d)

/// uk 1 May 1997
local z=date("1 May 1997", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0597_a, at("`x'")
stsplit UK0597_b, at("`y'")
stsplit UK0597_c, at("`z'")
stsplit UK0597_d, at("`r'")

egen maxUK0597_a=max(UK0597_a)
egen maxUK0597_b=max(UK0597_b)
egen maxUK0597_c=max(UK0597_c)
egen maxUK0597_d=max(UK0597_d)

/// uk 7 Jun 2001
local z=date("7 Jun 2001", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0601_a, at("`x'")
stsplit UK0601_b, at("`y'")
stsplit UK0601_c, at("`z'")
stsplit UK0601_d, at("`r'")

egen maxUK0601_a=max(UK0601_a)
egen maxUK0601_b=max(UK0601_b)
egen maxUK0601_c=max(UK0601_c)
egen maxUK0601_d=max(UK0601_d)

/// uk 5 may 05
local z=date("5 may 2005", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit UK0505_a, at("`x'")
stsplit UK0505_b, at("`y'")
stsplit UK0505_c, at("`z'")
stsplit UK0505_d, at("`r'")

egen maxUK0505_a=max(UK0505_a)
egen maxUK0505_b=max(UK0505_b)
egen maxUK0505_c=max(UK0505_c)
egen maxUK0505_d=max(UK0505_d)


************
* 4. Italy *
************

/// it 19 May 1968
local z=date("19 May 1968", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0568_a, at("`x'")
stsplit IT0568_b, at("`y'")
stsplit IT0568_c, at("`z'")
stsplit IT0568_d, at("`r'")

egen maxIT0568_a=max(IT0568_a)
egen maxIT0568_b=max(IT0568_b)
egen maxIT0568_c=max(IT0568_c)
egen maxIT0568_d=max(IT0568_d)

/// it 07 May 1972
local z=date("07 May 1972", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0572_a, at("`x'")
stsplit IT0572_b, at("`y'")
stsplit IT0572_c, at("`z'")
stsplit IT0572_d, at("`r'")

egen maxIT0572_a=max(IT0572_a)
egen maxIT0572_b=max(IT0572_b)
egen maxIT0572_c=max(IT0572_c)
egen maxIT0572_d=max(IT0572_d)

/// it 20 Jun 1976
local z=date("20 Jun 1976", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0676_a, at("`x'")
stsplit IT0676_b, at("`y'")
stsplit IT0676_c, at("`z'")
stsplit IT0676_d, at("`r'")

egen maxIT0676_a=max(IT0676_a)
egen maxIT0676_b=max(IT0676_b)
egen maxIT0676_c=max(IT0676_c)
egen maxIT0676_d=max(IT0676_d)

/// it 03 Jun 1979
local z=date("03 Jun 1979", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0679_a, at("`x'")
stsplit IT0679_b, at("`y'")
stsplit IT0679_c, at("`z'")
stsplit IT0679_d, at("`r'")

egen maxIT0679_a=max(IT0679_a)
egen maxIT0679_b=max(IT0679_b)
egen maxIT0679_c=max(IT0679_c)
egen maxIT0679_d=max(IT0679_d)

/// it 26 Jun 1983
local z=date("26 Jun 1983", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0683_a, at("`x'")
stsplit IT0683_b, at("`y'")
stsplit IT0683_c, at("`z'")
stsplit IT0683_d, at("`r'")

egen maxIT0683_a=max(IT0683_a)
egen maxIT0683_b=max(IT0683_b)
egen maxIT0683_c=max(IT0683_c)
egen maxIT0683_d=max(IT0683_d)

/// it 14 Jun 1987
local z=date("14 Jun 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0687_a, at("`x'")
stsplit IT0687_b, at("`y'")
stsplit IT0687_c, at("`z'")
stsplit IT0687_d, at("`r'")

egen maxIT0687_a=max(IT0687_a)
egen maxIT0687_b=max(IT0687_b)
egen maxIT0687_c=max(IT0687_c)
egen maxIT0687_d=max(IT0687_d)

/// it 05 Apr 1992
local z=date("05 Apr 1992", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0492_a, at("`x'")
stsplit IT0492_b, at("`y'")
stsplit IT0492_c, at("`z'")
stsplit IT0492_d, at("`r'")

egen maxIT0492_a=max(IT0492_a)
egen maxIT0492_b=max(IT0492_b)
egen maxIT0492_c=max(IT0492_c)
egen maxIT0492_d=max(IT0492_d)

/// it 27 Mar 1994
local z=date("27 Mar 1994", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0394_a, at("`x'")
stsplit IT0394_b, at("`y'")
stsplit IT0394_c, at("`z'")
stsplit IT0394_d, at("`r'")

egen maxIT0394_a=max(IT0394_a)
egen maxIT0394_b=max(IT0394_b)
egen maxIT0394_c=max(IT0394_c)
egen maxIT0394_d=max(IT0394_d)

/// it 21 Apr 1996
local z=date("21 Apr 1996", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0496_a, at("`x'")
stsplit IT0496_b, at("`y'")
stsplit IT0496_c, at("`z'")
stsplit IT0496_d, at("`r'")

egen maxIT0496_a=max(IT0496_a)
egen maxIT0496_b=max(IT0496_b)
egen maxIT0496_c=max(IT0496_c)
egen maxIT0496_d=max(IT0496_d)

/// it 13 May 2001
local z=date("13 May 2001", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0501_a, at("`x'")
stsplit IT0501_b, at("`y'")
stsplit IT0501_c, at("`z'")
stsplit IT0501_d, at("`r'")

egen maxIT0501_a=max(IT0501_a)
egen maxIT0501_b=max(IT0501_b)
egen maxIT0501_c=max(IT0501_c)
egen maxIT0501_d=max(IT0501_d)

/// it 09 Apr 2006
local z=date("09 Apr 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0406_a, at("`x'")
stsplit IT0406_b, at("`y'")
stsplit IT0406_c, at("`z'")
stsplit IT0406_d, at("`r'")

egen maxIT0406_a=max(IT0406_a)
egen maxIT0406_b=max(IT0406_b)
egen maxIT0406_c=max(IT0406_c)
egen maxIT0406_d=max(IT0406_d)

/// it 13 Apr 2008
local z=date("13 Apr 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IT0408_a, at("`x'")
stsplit IT0408_b, at("`y'")
stsplit IT0408_c, at("`z'")
stsplit IT0408_d, at("`r'")

egen maxIT0408_a=max(IT0408_a)
egen maxIT0408_b=max(IT0408_b)
egen maxIT0408_c=max(IT0408_c)
egen maxIT0408_d=max(IT0408_d)



************
* 5. Spain *
************

/// sp 22 Jun 1986
local z=date("22 Jun 1986", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP0686_a, at("`x'")
stsplit SP0686_b, at("`y'")
stsplit SP0686_c, at("`z'")
stsplit SP0686_d, at("`r'")

egen maxSP0686_a=max(SP0686_a)
egen maxSP0686_b=max(SP0686_b)
egen maxSP0686_c=max(SP0686_c)
egen maxSP0686_d=max(SP0686_d)

/// sp 29 Oct 1989
local z=date("29 Oct 1989", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP1089_a, at("`x'")
stsplit SP1089_b, at("`y'")
stsplit SP1089_c, at("`z'")
stsplit SP1089_d, at("`r'")

egen maxSP1089_a=max(SP1089_a)
egen maxSP1089_b=max(SP1089_b)
egen maxSP1089_c=max(SP1089_c)
egen maxSP1089_d=max(SP1089_d)

/// sp 06 Jun 1993
local z=date("06 Jun 1993", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP0693_a, at("`x'")
stsplit SP0693_b, at("`y'")
stsplit SP0693_c, at("`z'")
stsplit SP0693_d, at("`r'")

egen maxSP0693_a=max(SP0693_a)
egen maxSP0693_b=max(SP0693_b)
egen maxSP0693_c=max(SP0693_c)
egen maxSP0693_d=max(SP0693_d)

/// sp 03 Mar 1996
local z=date("03 Mar 1996", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP0396_a, at("`x'")
stsplit SP0396_b, at("`y'")
stsplit SP0396_c, at("`z'")
stsplit SP0396_d, at("`r'")

egen maxSP0396_a=max(SP0396_a)
egen maxSP0396_b=max(SP0396_b)
egen maxSP0396_c=max(SP0396_c)
egen maxSP0396_d=max(SP0396_d)

/// sp 12 Mar 2000
local z=date("12 Mar 2000", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP0300_a, at("`x'")
stsplit SP0300_b, at("`y'")
stsplit SP0300_c, at("`z'")
stsplit SP0300_d, at("`r'")

egen maxSP0300_a=max(SP0300_a)
egen maxSP0300_b=max(SP0300_b)
egen maxSP0300_c=max(SP0300_c)
egen maxSP0300_d=max(SP0300_d)

/// sp 14 Mar 2004
local z=date("14 Mar 2004", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP0304_a, at("`x'")
stsplit SP0304_b, at("`y'")
stsplit SP0304_c, at("`z'")
stsplit SP0304_d, at("`r'")

egen maxSP0304_a=max(SP0304_a)
egen maxSP0304_b=max(SP0304_b)
egen maxSP0304_c=max(SP0304_c)
egen maxSP0304_d=max(SP0304_d)

/// sp 09 Mar 2008
local z=date("09 Mar 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SP0308_a, at("`x'")
stsplit SP0308_b, at("`y'")
stsplit SP0308_c, at("`z'")
stsplit SP0308_d, at("`r'")

egen maxSP0308_a=max(SP0308_a)
egen maxSP0308_b=max(SP0308_b)
egen maxSP0308_c=max(SP0308_c)
egen maxSP0308_d=max(SP0308_d)


******************
* 6. Netherlands *
******************

/// nd 15 Feb 1967
local z=date("15 Feb 1967", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0267_a, at("`x'")
stsplit ND0267_b, at("`y'")
stsplit ND0267_c, at("`z'")
stsplit ND0267_d, at("`r'")

egen maxND0267_a=max(ND0267_a)
egen maxND0267_b=max(ND0267_b)
egen maxND0267_c=max(ND0267_c)
egen maxND0267_d=max(ND0267_d)

/// nd 28 Mar 1971
local z=date("28 Mar 1971", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0371_a, at("`x'")
stsplit ND0371_b, at("`y'")
stsplit ND0371_c, at("`z'")
stsplit ND0371_d, at("`r'")

egen maxND0371_a=max(ND0371_a)
egen maxND0371_b=max(ND0371_b)
egen maxND0371_c=max(ND0371_c)
egen maxND0371_d=max(ND0371_d)

/// nd 29 Nov 1972
local z=date("29 Nov 1972", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND1172_a, at("`x'")
stsplit ND1172_b, at("`y'")
stsplit ND1172_c, at("`z'")
stsplit ND1172_d, at("`r'")

egen maxND1172_a=max(ND1172_a)
egen maxND1172_b=max(ND1172_b)
egen maxND1172_c=max(ND1172_c)
egen maxND1172_d=max(ND1172_d)

/// nd 25 May 1977
local z=date("25 May 1977", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0577_a, at("`x'")
stsplit ND0577_b, at("`y'")
stsplit ND0577_c, at("`z'")
stsplit ND0577_d, at("`r'")

egen maxND0577_a=max(ND0577_a)
egen maxND0577_b=max(ND0577_b)
egen maxND0577_c=max(ND0577_c)
egen maxND0577_d=max(ND0577_d)

/// nd 26 May 1981
local z=date("26 May 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0581_a, at("`x'")
stsplit ND0581_b, at("`y'")
stsplit ND0581_c, at("`z'")
stsplit ND0581_d, at("`r'")

egen maxND0581_a=max(ND0581_a)
egen maxND0581_b=max(ND0581_b)
egen maxND0581_c=max(ND0581_c)
egen maxND0581_d=max(ND0581_d)

/// nd 08 Sep 1982
local z=date("08 Sep 1982", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0982_a, at("`x'")
stsplit ND0982_b, at("`y'")
stsplit ND0982_c, at("`z'")
stsplit ND0982_d, at("`r'")

egen maxND0982_a=max(ND0982_a)
egen maxND0982_b=max(ND0982_b)
egen maxND0982_c=max(ND0982_c)
egen maxND0982_d=max(ND0982_d)

/// nd 21 May 1986
local z=date("21 May 1986", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0586_a, at("`x'")
stsplit ND0586_b, at("`y'")
stsplit ND0586_c, at("`z'")
stsplit ND0586_d, at("`r'")

egen maxND0586_a=max(ND0586_a)
egen maxND0586_b=max(ND0586_b)
egen maxND0586_c=max(ND0586_c)
egen maxND0586_d=max(ND0586_d)

/// nd 06 Sep 1989
local z=date("06 Sep 1989", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0989_a, at("`x'")
stsplit ND0989_b, at("`y'")
stsplit ND0989_c, at("`z'")
stsplit ND0989_d, at("`r'")

egen maxND0989_a=max(ND0989_a)
egen maxND0989_b=max(ND0989_b)
egen maxND0989_c=max(ND0989_c)
egen maxND0989_d=max(ND0989_d)

/// nd 03 May 1994
local z=date("03 May 1994", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0594_a, at("`x'")
stsplit ND0594_b, at("`y'")
stsplit ND0594_c, at("`z'")
stsplit ND0594_d, at("`r'")

egen maxND0594_a=max(ND0594_a)
egen maxND0594_b=max(ND0594_b)
egen maxND0594_c=max(ND0594_c)
egen maxND0594_d=max(ND0594_d)

/// nd 06 May 1998
local z=date("06 May 1998", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0598_a, at("`x'")
stsplit ND0598_b, at("`y'")
stsplit ND0598_c, at("`z'")
stsplit ND0598_d, at("`r'")

egen maxND0598_a=max(ND0598_a)
egen maxND0598_b=max(ND0598_b)
egen maxND0598_c=max(ND0598_c)
egen maxND0598_d=max(ND0598_d)

/// nd 15 May 2002
local z=date("15 May 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0502_a, at("`x'")
stsplit ND0502_b, at("`y'")
stsplit ND0502_c, at("`z'")
stsplit ND0502_d, at("`r'")

egen maxND0502_a=max(ND0502_a)
egen maxND0502_b=max(ND0502_b)
egen maxND0502_c=max(ND0502_c)
egen maxND0502_d=max(ND0502_d)

/// nd 22 Jan 2003
local z=date("22 Jan 2003", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND0103_a, at("`x'")
stsplit ND0103_b, at("`y'")
stsplit ND0103_c, at("`z'")
stsplit ND0103_d, at("`r'")

egen maxND0103_a=max(ND0103_a)
egen maxND0103_b=max(ND0103_b)
egen maxND0103_c=max(ND0103_c)
egen maxND0103_d=max(ND0103_d)

/// nd 22 Nov 2006
local z=date("22 Nov 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ND1106_a, at("`x'")
stsplit ND1106_b, at("`y'")
stsplit ND1106_c, at("`z'")
stsplit ND1106_d, at("`r'")

egen maxND1106_a=max(ND1106_a)
egen maxND1106_b=max(ND1106_b)
egen maxND1106_c=max(ND1106_c)
egen maxND1106_d=max(ND1106_d)


**************
* 7. Belgium *
**************

/// be 31 Mar 1968
local z=date("31 Mar 1968", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0368_a, at("`x'")
stsplit BE0368_b, at("`y'")
stsplit BE0368_c, at("`z'")
stsplit BE0368_d, at("`r'")

egen maxBE0368_a=max(BE0368_a)
egen maxBE0368_b=max(BE0368_b)
egen maxBE0368_c=max(BE0368_c)
egen maxBE0368_d=max(BE0368_d)

/// be 07 Nov 1971
local z=date("07 Nov 1971", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE1171_a, at("`x'")
stsplit BE1171_b, at("`y'")
stsplit BE1171_c, at("`z'")
stsplit BE1171_d, at("`r'")

egen maxBE1171_a=max(BE1171_a)
egen maxBE1171_b=max(BE1171_b)
egen maxBE1171_c=max(BE1171_c)
egen maxBE1171_d=max(BE1171_d)

/// be 10 Mar 1974
local z=date("10 Mar 1974", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0374_a, at("`x'")
stsplit BE0374_b, at("`y'")
stsplit BE0374_c, at("`z'")
stsplit BE0374_d, at("`r'")

egen maxBE0374_a=max(BE0374_a)
egen maxBE0374_b=max(BE0374_b)
egen maxBE0374_c=max(BE0374_c)
egen maxBE0374_d=max(BE0374_d)

/// be 17 Apr 1977
local z=date("17 Apr 1977", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0477_a, at("`x'")
stsplit BE0477_b, at("`y'")
stsplit BE0477_c, at("`z'")
stsplit BE0477_d, at("`r'")

egen maxBE0477_a=max(BE0477_a)
egen maxBE0477_b=max(BE0477_b)
egen maxBE0477_c=max(BE0477_c)
egen maxBE0477_d=max(BE0477_d)

/// be 17 Dec 1978
local z=date("17 Dec 1978", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE1278_a, at("`x'")
stsplit BE1278_b, at("`y'")
stsplit BE1278_c, at("`z'")
stsplit BE1278_d, at("`r'")

egen maxBE1278_a=max(BE1278_a)
egen maxBE1278_b=max(BE1278_b)
egen maxBE1278_c=max(BE1278_c)
egen maxBE1278_d=max(BE1278_d)

/// be 08 Nov 1981
local z=date("08 Nov 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE1181_a, at("`x'")
stsplit BE1181_b, at("`y'")
stsplit BE1181_c, at("`z'")
stsplit BE1181_d, at("`r'")

egen maxBE1181_a=max(BE1181_a)
egen maxBE1181_b=max(BE1181_b)
egen maxBE1181_c=max(BE1181_c)
egen maxBE1181_d=max(BE1181_d)

/// be 13 Oct 1985
local z=date("13 Oct 1985", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE1085_a, at("`x'")
stsplit BE1085_b, at("`y'")
stsplit BE1085_c, at("`z'")
stsplit BE1085_d, at("`r'")

egen maxBE1085_a=max(BE1085_a)
egen maxBE1085_b=max(BE1085_b)
egen maxBE1085_c=max(BE1085_c)
egen maxBE1085_d=max(BE1085_d)

/// be 13 Dec 1987
local z=date("13 Dec 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE1287_a, at("`x'")
stsplit BE1287_b, at("`y'")
stsplit BE1287_c, at("`z'")
stsplit BE1287_d, at("`r'")

egen maxBE1287_a=max(BE1287_a)
egen maxBE1287_b=max(BE1287_b)
egen maxBE1287_c=max(BE1287_c)
egen maxBE1287_d=max(BE1287_d)

/// be 24 Nov 1991
local z=date("24 Nov 1991", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE1191_a, at("`x'")
stsplit BE1191_b, at("`y'")
stsplit BE1191_c, at("`z'")
stsplit BE1191_d, at("`r'")

egen maxBE1191_a=max(BE1191_a)
egen maxBE1191_b=max(BE1191_b)
egen maxBE1191_c=max(BE1191_c)
egen maxBE1191_d=max(BE1191_d)

/// be 21 May 1995
local z=date("21 May 1995", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0595_a, at("`x'")
stsplit BE0595_b, at("`y'")
stsplit BE0595_c, at("`z'")
stsplit BE0595_d, at("`r'")

egen maxBE0595_a=max(BE0595_a)
egen maxBE0595_b=max(BE0595_b)
egen maxBE0595_c=max(BE0595_c)
egen maxBE0595_d=max(BE0595_d)

/// be 13 Jun 1999
local z=date("13 Jun 1999", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0699_a, at("`x'")
stsplit BE0699_b, at("`y'")
stsplit BE0699_c, at("`z'")
stsplit BE0699_d, at("`r'")

egen maxBE0699_a=max(BE0699_a)
egen maxBE0699_b=max(BE0699_b)
egen maxBE0699_c=max(BE0699_c)
egen maxBE0699_d=max(BE0699_d)

/// be 18 May 2003
local z=date("18 May 2003", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0503_a, at("`x'")
stsplit BE0503_b, at("`y'")
stsplit BE0503_c, at("`z'")
stsplit BE0503_d, at("`r'")

egen maxBE0503_a=max(BE0503_a)
egen maxBE0503_b=max(BE0503_b)
egen maxBE0503_c=max(BE0503_c)
egen maxBE0503_d=max(BE0503_d)

/// be 10 Jun 2007
local z=date("10 Jun 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BE0607_a, at("`x'")
stsplit BE0607_b, at("`y'")
stsplit BE0607_c, at("`z'")
stsplit BE0607_d, at("`r'")

egen maxBE0607_a=max(BE0607_a)
egen maxBE0607_b=max(BE0607_b)
egen maxBE0607_c=max(BE0607_c)
egen maxBE0607_d=max(BE0607_d)


*************
* 8. Greece *
*************

/// gr 18 Oct 1981
local z=date("18 Oct 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR1081_a, at("`x'")
stsplit GR1081_b, at("`y'")
stsplit GR1081_c, at("`z'")
stsplit GR1081_d, at("`r'")

egen maxGR1081_a=max(GR1081_a)
egen maxGR1081_b=max(GR1081_b)
egen maxGR1081_c=max(GR1081_c)
egen maxGR1081_d=max(GR1081_d)

/// gr 02 Jun 1985
local z=date("02 Jun 1985", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0685_a, at("`x'")
stsplit GR0685_b, at("`y'")
stsplit GR0685_c, at("`z'")
stsplit GR0685_d, at("`r'")

egen maxGR0685_a=max(GR0685_a)
egen maxGR0685_b=max(GR0685_b)
egen maxGR0685_c=max(GR0685_c)
egen maxGR0685_d=max(GR0685_d)

/// gr 18 Jun 1989
local z=date("18 Jun 1989", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0689_a, at("`x'")
stsplit GR0689_b, at("`y'")
stsplit GR0689_c, at("`z'")
stsplit GR0689_d, at("`r'")

egen maxGR0689_a=max(GR0689_a)
egen maxGR0689_b=max(GR0689_b)
egen maxGR0689_c=max(GR0689_c)
egen maxGR0689_d=max(GR0689_d)

/// gr 05 Nov 1989
local z=date("05 Nov 1989", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR1189_a, at("`x'")
stsplit GR1189_b, at("`y'")
stsplit GR1189_c, at("`z'")
stsplit GR1189_d, at("`r'")

egen maxGR1189_a=max(GR1189_a)
egen maxGR1189_b=max(GR1189_b)
egen maxGR1189_c=max(GR1189_c)
egen maxGR1189_d=max(GR1189_d)

/// gr 08 Apr 1990
local z=date("08 Apr 1990", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0490_a, at("`x'")
stsplit GR0490_b, at("`y'")
stsplit GR0490_c, at("`z'")
stsplit GR0490_d, at("`r'")

egen maxGR0490_a=max(GR0490_a)
egen maxGR0490_b=max(GR0490_b)
egen maxGR0490_c=max(GR0490_c)
egen maxGR0490_d=max(GR0490_d)

/// gr 10 Oct 1993
local z=date("10 Oct 1993", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR1093_a, at("`x'")
stsplit GR1093_b, at("`y'")
stsplit GR1093_c, at("`z'")
stsplit GR1093_d, at("`r'")

egen maxGR1093_a=max(GR1093_a)
egen maxGR1093_b=max(GR1093_b)
egen maxGR1093_c=max(GR1093_c)
egen maxGR1093_d=max(GR1093_d)

/// gr 22 Sep 1996
local z=date("22 Sep 1996", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0996_a, at("`x'")
stsplit GR0996_b, at("`y'")
stsplit GR0996_c, at("`z'")
stsplit GR0996_d, at("`r'")

egen maxGR0996_a=max(GR0996_a)
egen maxGR0996_b=max(GR0996_b)
egen maxGR0996_c=max(GR0996_c)
egen maxGR0996_d=max(GR0996_d)

/// gr 09 Apr 2000
local z=date("09 Apr 2000", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0400_a, at("`x'")
stsplit GR0400_b, at("`y'")
stsplit GR0400_c, at("`z'")
stsplit GR0400_d, at("`r'")

egen maxGR0400_a=max(GR0400_a)
egen maxGR0400_b=max(GR0400_b)
egen maxGR0400_c=max(GR0400_c)
egen maxGR0400_d=max(GR0400_d)

/// gr 07 Mar 2004
local z=date("07 Mar 2004", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0304_a, at("`x'")
stsplit GR0304_b, at("`y'")
stsplit GR0304_c, at("`z'")
stsplit GR0304_d, at("`r'")

egen maxGR0304_a=max(GR0304_a)
egen maxGR0304_b=max(GR0304_b)
egen maxGR0304_c=max(GR0304_c)
egen maxGR0304_d=max(GR0304_d)

/// gr 16 Sep 2007
local z=date("16 Sep 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit GR0907_a, at("`x'")
stsplit GR0907_b, at("`y'")
stsplit GR0907_c, at("`z'")
stsplit GR0907_d, at("`r'")

egen maxGR0907_a=max(GR0907_a)
egen maxGR0907_b=max(GR0907_b)
egen maxGR0907_c=max(GR0907_c)
egen maxGR0907_d=max(GR0907_d)


***************
* 9. Portugal *
***************

/// pt 19 Jul 1987
local z=date("19 Jul 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT0787_a, at("`x'")
stsplit PT0787_b, at("`y'")
stsplit PT0787_c, at("`z'")
stsplit PT0787_d, at("`r'")

egen maxPT0787_a=max(PT0787_a)
egen maxPT0787_b=max(PT0787_b)
egen maxPT0787_c=max(PT0787_c)
egen maxPT0787_d=max(PT0787_d)

/// pt 06 Oct 1991
local z=date("06 Oct 1991", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT1091_a, at("`x'")
stsplit PT1091_b, at("`y'")
stsplit PT1091_c, at("`z'")
stsplit PT1091_d, at("`r'")

egen maxPT1091_a=max(PT1091_a)
egen maxPT1091_b=max(PT1091_b)
egen maxPT1091_c=max(PT1091_c)
egen maxPT1091_d=max(PT1091_d)

/// pt 01 Oct 1995
local z=date("01 Oct 1995", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT1095_a, at("`x'")
stsplit PT1095_b, at("`y'")
stsplit PT1095_c, at("`z'")
stsplit PT1095_d, at("`r'")

egen maxPT1095_a=max(PT1095_a)
egen maxPT1095_b=max(PT1095_b)
egen maxPT1095_c=max(PT1095_c)
egen maxPT1095_d=max(PT1095_d)

/// pt 10 Oct 1999
local z=date("01 Oct 1999", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT1099_a, at("`x'")
stsplit PT1099_b, at("`y'")
stsplit PT1099_c, at("`z'")
stsplit PT1099_d, at("`r'")

egen maxPT1099_a=max(PT1099_a)
egen maxPT1099_b=max(PT1099_b)
egen maxPT1099_c=max(PT1099_c)
egen maxPT1099_d=max(PT1099_d)

/// pt 17 Mar 2002
local z=date("17 Mar 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT0302_a, at("`x'")
stsplit PT0302_b, at("`y'")
stsplit PT0302_c, at("`z'")
stsplit PT0302_d, at("`r'")

egen maxPT0302_a=max(PT0302_a)
egen maxPT0302_b=max(PT0302_b)
egen maxPT0302_c=max(PT0302_c)
egen maxPT0302_d=max(PT0302_d)

/// pt 20 Feb 2005
local z=date("20 Feb 2005", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT0205_a, at("`x'")
stsplit PT0205_b, at("`y'")
stsplit PT0205_c, at("`z'")
stsplit PT0205_d, at("`r'")

egen maxPT0205_a=max(PT0205_a)
egen maxPT0205_b=max(PT0205_b)
egen maxPT0205_c=max(PT0205_c)
egen maxPT0205_d=max(PT0205_d)

/// pt 27 Sep 2009
local z=date("27 Sep 2009", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PT0909_a, at("`x'")
stsplit PT0909_b, at("`y'")
stsplit PT0909_c, at("`z'")
stsplit PT0909_d, at("`r'")

egen maxPT0909_a=max(PT0909_a)
egen maxPT0909_b=max(PT0909_b)
egen maxPT0909_c=max(PT0909_c)
egen maxPT0909_d=max(PT0909_d)


**************
* 10. Sweden *
**************

/// sw 20 Sep 1998
local z=date("20 Sep 1998", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SW0998_a, at("`x'")
stsplit SW0998_b, at("`y'")
stsplit SW0998_c, at("`z'")
stsplit SW0998_d, at("`r'")

egen maxSW0998_a=max(SW0998_a)
egen maxSW0998_b=max(SW0998_b)
egen maxSW0998_c=max(SW0998_c)
egen maxSW0998_d=max(SW0998_d)

/// sw 15 Sep 2002
local z=date("15 Sep 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SW0902_a, at("`x'")
stsplit SW0902_b, at("`y'")
stsplit SW0902_c, at("`z'")
stsplit SW0902_d, at("`r'")

egen maxSW0902_a=max(SW0902_a)
egen maxSW0902_b=max(SW0902_b)
egen maxSW0902_c=max(SW0902_c)
egen maxSW0902_d=max(SW0902_d)

/// sw 17 Sep 2006
local z=date("17 Sep 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SW0906_a, at("`x'")
stsplit SW0906_b, at("`y'")
stsplit SW0906_c, at("`z'")
stsplit SW0906_d, at("`r'")

egen maxSW0906_a=max(SW0906_a)
egen maxSW0906_b=max(SW0906_b)
egen maxSW0906_c=max(SW0906_c)
egen maxSW0906_d=max(SW0906_d)


***************
* 11. Austria *
***************

/// au 17 Dec 1995
local z=date("17 Dec 1995", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit AU1295_a, at("`x'")
stsplit AU1295_b, at("`y'")
stsplit AU1295_c, at("`z'")
stsplit AU1295_d, at("`r'")

egen maxAU1295_a=max(AU1295_a)
egen maxAU1295_b=max(AU1295_b)
egen maxAU1295_c=max(AU1295_c)
egen maxAU1295_d=max(AU1295_d)

/// au 03 Oct 1999
local z=date("03 Oct 1999", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit AU1099_a, at("`x'")
stsplit AU1099_b, at("`y'")
stsplit AU1099_c, at("`z'")
stsplit AU1099_d, at("`r'")

egen maxAU1099_a=max(AU1099_a)
egen maxAU1099_b=max(AU1099_b)
egen maxAU1099_c=max(AU1099_c)
egen maxAU1099_d=max(AU1099_d)

/// au 24 Nov 2002
local z=date("24 Nov 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit AU1102_a, at("`x'")
stsplit AU1102_b, at("`y'")
stsplit AU1102_c, at("`z'")
stsplit AU1102_d, at("`r'")

egen maxAU1102_a=max(AU1102_a)
egen maxAU1102_b=max(AU1102_b)
egen maxAU1102_c=max(AU1102_c)
egen maxAU1102_d=max(AU1102_d)

/// au 01 Oct 2006
local z=date("01 Oct 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit AU1006_a, at("`x'")
stsplit AU1006_b, at("`y'")
stsplit AU1006_c, at("`z'")
stsplit AU1006_d, at("`r'")

egen maxAU1006_a=max(AU1006_a)
egen maxAU1006_b=max(AU1006_b)
egen maxAU1006_c=max(AU1006_c)
egen maxAU1006_d=max(AU1006_d)

/// au 28 Sep 2008
local z=date("28 Sep 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit AU0908_a, at("`x'")
stsplit AU0908_b, at("`y'")
stsplit AU0908_c, at("`z'")
stsplit AU0908_d, at("`r'")

egen maxAU0908_a=max(AU0908_a)
egen maxAU0908_b=max(AU0908_b)
egen maxAU0908_c=max(AU0908_c)
egen maxAU0908_d=max(AU0908_d)


***************
* 12. Denmark *
***************

/// dk 04 Dec 1973
local z=date("04 Dec 1973", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK1273_a, at("`x'")
stsplit DK1273_b, at("`y'")
stsplit DK1273_c, at("`z'")
stsplit DK1273_d, at("`r'")

egen maxDK1273_a=max(DK1273_a)
egen maxDK1273_b=max(DK1273_b)
egen maxDK1273_c=max(DK1273_c)
egen maxDK1273_d=max(DK1273_d)

/// dk 09 Jan 1975
local z=date("09 Jan 1975", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0175_a, at("`x'")
stsplit DK0175_b, at("`y'")
stsplit DK0175_c, at("`z'")
stsplit DK0175_d, at("`r'")

egen maxDK0175_a=max(DK0175_a)
egen maxDK0175_b=max(DK0175_b)
egen maxDK0175_c=max(DK0175_c)
egen maxDK0175_d=max(DK0175_d)

/// dk 15 Feb 1977
local z=date("15 Feb 1977", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0277_a, at("`x'")
stsplit DK0277_b, at("`y'")
stsplit DK0277_c, at("`z'")
stsplit DK0277_d, at("`r'")

egen maxDK0277_a=max(DK0277_a)
egen maxDK0277_b=max(DK0277_b)
egen maxDK0277_c=max(DK0277_c)
egen maxDK0277_d=max(DK0277_d)

/// dk 23 Oct 1979
local z=date("23 Oct 1979", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK1079_a, at("`x'")
stsplit DK1079_b, at("`y'")
stsplit DK1079_c, at("`z'")
stsplit DK1079_d, at("`r'")

egen maxDK1079_a=max(DK1079_a)
egen maxDK1079_b=max(DK1079_b)
egen maxDK1079_c=max(DK1079_c)
egen maxDK1079_d=max(DK1079_d)

/// dk 08 Dec 1981
local z=date("08 Dec 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK1281_a, at("`x'")
stsplit DK1281_b, at("`y'")
stsplit DK1281_c, at("`z'")
stsplit DK1281_d, at("`r'")

egen maxDK1281_a=max(DK1281_a)
egen maxDK1281_b=max(DK1281_b)
egen maxDK1281_c=max(DK1281_c)
egen maxDK1281_d=max(DK1281_d)

/// dk 10 Jan 1984
local z=date("10 Jan 1984", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0184_a, at("`x'")
stsplit DK0184_b, at("`y'")
stsplit DK0184_c, at("`z'")
stsplit DK0184_d, at("`r'")

egen maxDK0184_a=max(DK0184_a)
egen maxDK0184_b=max(DK0184_b)
egen maxDK0184_c=max(DK0184_c)
egen maxDK0184_d=max(DK0184_d)

/// dk 08 Sep 1987
local z=date("08 Sep 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0987_a, at("`x'")
stsplit DK0987_b, at("`y'")
stsplit DK0987_c, at("`z'")
stsplit DK0987_d, at("`r'")

egen maxDK0987_a=max(DK0987_a)
egen maxDK0987_b=max(DK0987_b)
egen maxDK0987_c=max(DK0987_c)
egen maxDK0987_d=max(DK0987_d)

/// dk 10 May 1988
local z=date("10 May 1988", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0588_a, at("`x'")
stsplit DK0588_b, at("`y'")
stsplit DK0588_c, at("`z'")
stsplit DK0588_d, at("`r'")

egen maxDK0588_a=max(DK0588_a)
egen maxDK0588_b=max(DK0588_b)
egen maxDK0588_c=max(DK0588_c)
egen maxDK0588_d=max(DK0588_d)

/// dk 12 Dec 1990
local z=date("12 Dec 1990", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK1290_a, at("`x'")
stsplit DK1290_b, at("`y'")
stsplit DK1290_c, at("`z'")
stsplit DK1290_d, at("`r'")

egen maxDK1290_a=max(DK1290_a)
egen maxDK1290_b=max(DK1290_b)
egen maxDK1290_c=max(DK1290_c)
egen maxDK1290_d=max(DK1290_d)

/// dk 21 Sep 1994
local z=date("21 Sep 1994", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0994_a, at("`x'")
stsplit DK0994_b, at("`y'")
stsplit DK0994_c, at("`z'")
stsplit DK0994_d, at("`r'")

egen maxDK0994_a=max(DK0994_a)
egen maxDK0994_b=max(DK0994_b)
egen maxDK0994_c=max(DK0994_c)
egen maxDK0994_d=max(DK0994_d)

/// dk 11 Mar 1998
local z=date("11 Mar 1998", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0398_a, at("`x'")
stsplit DK0398_b, at("`y'")
stsplit DK0398_c, at("`z'")
stsplit DK0398_d, at("`r'")

egen maxDK0398_a=max(DK0398_a)
egen maxDK0398_b=max(DK0398_b)
egen maxDK0398_c=max(DK0398_c)
egen maxDK0398_d=max(DK0398_d)

/// dk 20 Nov 2001
local z=date("20 Nov 2001", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK1101_a, at("`x'")
stsplit DK1101_b, at("`y'")
stsplit DK1101_c, at("`z'")
stsplit DK1101_d, at("`r'")

egen maxDK1101_a=max(DK1101_a)
egen maxDK1101_b=max(DK1101_b)
egen maxDK1101_c=max(DK1101_c)
egen maxDK1101_d=max(DK1101_d)

/// dk 08 Feb 2005
local z=date("08 Feb 2005", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK0205_a, at("`x'")
stsplit DK0205_b, at("`y'")
stsplit DK0205_c, at("`z'")
stsplit DK0205_d, at("`r'")

egen maxDK0205_a=max(DK0205_a)
egen maxDK0205_b=max(DK0205_b)
egen maxDK0205_c=max(DK0205_c)
egen maxDK0205_d=max(DK0205_d)

/// dk 13 Nov 2007
local z=date("13 Nov 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit DK1107_a, at("`x'")
stsplit DK1107_b, at("`y'")
stsplit DK1107_c, at("`z'")
stsplit DK1107_d, at("`r'")

egen maxDK1107_a=max(DK1107_a)
egen maxDK1107_b=max(DK1107_b)
egen maxDK1107_c=max(DK1107_c)
egen maxDK1107_d=max(DK1107_d)


***************
* 13. Finland *
***************

/// fn 19 Mar 1995
local z=date("19 Mar 1995", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FN0395_a, at("`x'")
stsplit FN0395_b, at("`y'")
stsplit FN0395_c, at("`z'")
stsplit FN0395_d, at("`r'")

egen maxFN0395_a=max(FN0395_a)
egen maxFN0395_b=max(FN0395_b)
egen maxFN0395_c=max(FN0395_c)
egen maxFN0395_d=max(FN0395_d)

/// fn 21 Mar 1999
local z=date("21 Mar 1999", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FN0399_a, at("`x'")
stsplit FN0399_b, at("`y'")
stsplit FN0399_c, at("`z'")
stsplit FN0399_d, at("`r'")

egen maxFN0399_a=max(FN0399_a)
egen maxFN0399_b=max(FN0399_b)
egen maxFN0399_c=max(FN0399_c)
egen maxFN0399_d=max(FN0399_d)

/// fn 16 Mar 2003
local z=date("16 Mar 2003", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FN0303_a, at("`x'")
stsplit FN0303_b, at("`y'")
stsplit FN0303_c, at("`z'")
stsplit FN0303_d, at("`r'")

egen maxFN0303_a=max(FN0303_a)
egen maxFN0303_b=max(FN0303_b)
egen maxFN0303_c=max(FN0303_c)
egen maxFN0303_d=max(FN0303_d)

/// fn 18 Mar 2007
local z=date("18 Mar 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit FN0307_a, at("`x'")
stsplit FN0307_b, at("`y'")
stsplit FN0307_c, at("`z'")
stsplit FN0307_d, at("`r'")

egen maxFN0307_a=max(FN0307_a)
egen maxFN0307_b=max(FN0307_b)
egen maxFN0307_c=max(FN0307_c)
egen maxFN0307_d=max(FN0307_d)


***************
* 14. Ireland *
***************

/// ir 28 Feb 1973
local z=date("28 Feb 1973", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0273_a, at("`x'")
stsplit IR0273_b, at("`y'")
stsplit IR0273_c, at("`z'")
stsplit IR0273_d, at("`r'")

egen maxIR0273_a=max(IR0273_a)
egen maxIR0273_b=max(IR0273_b)
egen maxIR0273_c=max(IR0273_c)
egen maxIR0273_d=max(IR0273_d)

/// ir 16 Jun 1977
local z=date("16 Jun 1977", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0677_a, at("`x'")
stsplit IR0677_b, at("`y'")
stsplit IR0677_c, at("`z'")
stsplit IR0677_d, at("`r'")

egen maxIR0677_a=max(IR0677_a)
egen maxIR0677_b=max(IR0677_b)
egen maxIR0677_c=max(IR0677_c)
egen maxIR0677_d=max(IR0677_d)

/// ir 11 Jun 1981
local z=date("11 Jun 1981", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0681_a, at("`x'")
stsplit IR0681_b, at("`y'")
stsplit IR0681_c, at("`z'")
stsplit IR0681_d, at("`r'")

egen maxIR0681_a=max(IR0681_a)
egen maxIR0681_b=max(IR0681_b)
egen maxIR0681_c=max(IR0681_c)
egen maxIR0681_d=max(IR0681_d)

/// ir 18 Feb 1982
local z=date("18 Feb 1982", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0282_a, at("`x'")
stsplit IR0282_b, at("`y'")
stsplit IR0282_c, at("`z'")
stsplit IR0282_d, at("`r'")

egen maxIR0282_a=max(IR0282_a)
egen maxIR0282_b=max(IR0282_b)
egen maxIR0282_c=max(IR0282_c)
egen maxIR0282_d=max(IR0282_d)

/// ir 24 Nov 1982
local z=date("24 Nov 1982", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR1182_a, at("`x'")
stsplit IR1182_b, at("`y'")
stsplit IR1182_c, at("`z'")
stsplit IR1182_d, at("`r'")

egen maxIR1182_a=max(IR1182_a)
egen maxIR1182_b=max(IR1182_b)
egen maxIR1182_c=max(IR1182_c)
egen maxIR1182_d=max(IR1182_d)

/// ir 17 Feb 1987
local z=date("17 Feb 1987", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0287_a, at("`x'")
stsplit IR0287_b, at("`y'")
stsplit IR0287_c, at("`z'")
stsplit IR0287_d, at("`r'")

egen maxIR0287_a=max(IR0287_a)
egen maxIR0287_b=max(IR0287_b)
egen maxIR0287_c=max(IR0287_c)
egen maxIR0287_d=max(IR0287_d)

/// ir 15 Jun 1989
local z=date("15 Jun 1989", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0689_a, at("`x'")
stsplit IR0689_b, at("`y'")
stsplit IR0689_c, at("`z'")
stsplit IR0689_d, at("`r'")

egen maxIR0689_a=max(IR0689_a)
egen maxIR0689_b=max(IR0689_b)
egen maxIR0689_c=max(IR0689_c)
egen maxIR0689_d=max(IR0689_d)

/// ir 25 Nov 1992
local z=date("25 Nov 1992", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR1192_a, at("`x'")
stsplit IR1192_b, at("`y'")
stsplit IR1192_c, at("`z'")
stsplit IR1192_d, at("`r'")

egen maxIR1192_a=max(IR1192_a)
egen maxIR1192_b=max(IR1192_b)
egen maxIR1192_c=max(IR1192_c)
egen maxIR1192_d=max(IR1192_d)

/// ir 06 Jun 1997
local z=date("06 Jun 1997", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0697_a, at("`x'")
stsplit IR0697_b, at("`y'")
stsplit IR0697_c, at("`z'")
stsplit IR0697_d, at("`r'")

egen maxIR0697_a=max(IR0697_a)
egen maxIR0697_b=max(IR0697_b)
egen maxIR0697_c=max(IR0697_c)
egen maxIR0697_d=max(IR0697_d)

/// ir 17 May 2002
local z=date("17 May 2002", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0502_a, at("`x'")
stsplit IR0502_b, at("`y'")
stsplit IR0502_c, at("`z'")
stsplit IR0502_d, at("`r'")

egen maxIR0502_a=max(IR0502_a)
egen maxIR0502_b=max(IR0502_b)
egen maxIR0502_c=max(IR0502_c)
egen maxIR0502_d=max(IR0502_d)

/// ir 24 May 2007
local z=date("24 May 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit IR0507_a, at("`x'")
stsplit IR0507_b, at("`y'")
stsplit IR0507_c, at("`z'")
stsplit IR0507_d, at("`r'")

egen maxIR0507_a=max(IR0507_a)
egen maxIR0507_b=max(IR0507_b)
egen maxIR0507_c=max(IR0507_c)
egen maxIR0507_d=max(IR0507_d)


******************
* 15. Luxembourg *
******************

/// lu 15 Dec 1968
local z=date("15 Dec 1968", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU1268_a, at("`x'")
stsplit LU1268_b, at("`y'")
stsplit LU1268_c, at("`z'")
stsplit LU1268_d, at("`r'")

egen maxLU1268_a=max(LU1268_a)
egen maxLU1268_b=max(LU1268_b)
egen maxLU1268_c=max(LU1268_c)
egen maxLU1268_d=max(LU1268_d)

/// lu 26 May 1974
local z=date("26 May 1974", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0574_a, at("`x'")
stsplit LU0574_b, at("`y'")
stsplit LU0574_c, at("`z'")
stsplit LU0574_d, at("`r'")

egen maxLU0574_a=max(LU0574_a)
egen maxLU0574_b=max(LU0574_b)
egen maxLU0574_c=max(LU0574_c)
egen maxLU0574_d=max(LU0574_d)

/// lu 10 Jun 1979
local z=date("10 Jun 1979", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0679_a, at("`x'")
stsplit LU0679_b, at("`y'")
stsplit LU0679_c, at("`z'")
stsplit LU0679_d, at("`r'")

egen maxLU0679_a=max(LU0679_a)
egen maxLU0679_b=max(LU0679_b)
egen maxLU0679_c=max(LU0679_c)
egen maxLU0679_d=max(LU0679_d)

/// lu 17 Jun 1984
local z=date("17 Jun 1984", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0684_a, at("`x'")
stsplit LU0684_b, at("`y'")
stsplit LU0684_c, at("`z'")
stsplit LU0684_d, at("`r'")

egen maxLU0684_a=max(LU0684_a)
egen maxLU0684_b=max(LU0684_b)
egen maxLU0684_c=max(LU0684_c)
egen maxLU0684_d=max(LU0684_d)

/// lu 18 Jun 1989
local z=date("18 Jun 1989", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0689_a, at("`x'")
stsplit LU0689_b, at("`y'")
stsplit LU0689_c, at("`z'")
stsplit LU0689_d, at("`r'")

egen maxLU0689_a=max(LU0689_a)
egen maxLU0689_b=max(LU0689_b)
egen maxLU0689_c=max(LU0689_c)
egen maxLU0689_d=max(LU0689_d)

/// lu 12 Jun 1994
local z=date("12 Jun 1994", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0694_a, at("`x'")
stsplit LU0694_b, at("`y'")
stsplit LU0694_c, at("`z'")
stsplit LU0694_d, at("`r'")

egen maxLU0694_a=max(LU0694_a)
egen maxLU0694_b=max(LU0694_b)
egen maxLU0694_c=max(LU0694_c)
egen maxLU0694_d=max(LU0694_d)

/// lu 13 Jun 1999
local z=date("13 Jun 1999", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0699_a, at("`x'")
stsplit LU0699_b, at("`y'")
stsplit LU0699_c, at("`z'")
stsplit LU0699_d, at("`r'")

egen maxLU0699_a=max(LU0699_a)
egen maxLU0699_b=max(LU0699_b)
egen maxLU0699_c=max(LU0699_c)
egen maxLU0699_d=max(LU0699_d)

/// lu 13 Jun 2004
local z=date("13 Jun 2004", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0604_a, at("`x'")
stsplit LU0604_b, at("`y'")
stsplit LU0604_c, at("`z'")
stsplit LU0604_d, at("`r'")

egen maxLU0604_a=max(LU0604_a)
egen maxLU0604_b=max(LU0604_b)
egen maxLU0604_c=max(LU0604_c)
egen maxLU0604_d=max(LU0604_d)

/// lu 07 Jun 2009
local z=date("07 Jun 2009", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LU0609_a, at("`x'")
stsplit LU0609_b, at("`y'")
stsplit LU0609_c, at("`z'")
stsplit LU0609_d, at("`r'")

egen maxLU0609_a=max(LU0609_a)
egen maxLU0609_b=max(LU0609_b)
egen maxLU0609_c=max(LU0609_c)
egen maxLU0609_d=max(LU0609_d)


**************
* 16. Poland *
**************

/// pl 25 Sep 2005
local z=date("25 Sep 2005", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PL0905_a, at("`x'")
stsplit PL0905_b, at("`y'")
stsplit PL0905_c, at("`z'")
stsplit PL0905_d, at("`r'")

egen maxPL0905_a=max(PL0905_a)
egen maxPL0905_b=max(PL0905_b)
egen maxPL0905_c=max(PL0905_c)
egen maxPL0905_d=max(PL0905_d)

/// pl 21 Oct 2007
local z=date("21 Oct 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit PL1007_a, at("`x'")
stsplit PL1007_b, at("`y'")
stsplit PL1007_c, at("`z'")
stsplit PL1007_d, at("`r'")

egen maxPL1007_a=max(PL1007_a)
egen maxPL1007_b=max(PL1007_b)
egen maxPL1007_c=max(PL1007_c)
egen maxPL1007_d=max(PL1007_d)


*****************
* 17. Czech Rep *
*****************

/// cz 02 Jun 2006
local z=date("02 Jun 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit CZ0606_a, at("`x'")
stsplit CZ0606_b, at("`y'")
stsplit CZ0606_c, at("`z'")
stsplit CZ0606_d, at("`r'")

egen maxCZ0606_a=max(CZ0606_a)
egen maxCZ0606_b=max(CZ0606_b)
egen maxCZ0606_c=max(CZ0606_c)
egen maxCZ0606_d=max(CZ0606_d)


***************
* 18. Hungary *
***************

/// hu 23 Apr 2006
local z=date("23 Apr 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit HU0406_a, at("`x'")
stsplit HU0406_b, at("`y'")
stsplit HU0406_c, at("`z'")
stsplit HU0406_d, at("`r'")

egen maxHU0406_a=max(HU0406_a)
egen maxHU0406_b=max(HU0406_b)
egen maxHU0406_c=max(HU0406_c)
egen maxHU0406_d=max(HU0406_d)


***************
* 19. Slovakia *
***************

/// sk 17 Jun 2006
local z=date("17 Jun 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SK0606_a, at("`x'")
stsplit SK0606_b, at("`y'")
stsplit SK0606_c, at("`z'")
stsplit SK0606_d, at("`r'")

egen maxSK0606_a=max(SK0606_a)
egen maxSK0606_b=max(SK0606_b)
egen maxSK0606_c=max(SK0606_c)
egen maxSK0606_d=max(SK0606_d)


*****************
* 20. Lithuania *
*****************

/// lt 24 Oct 2004
local z=date("24 Oct 2004", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LT1004_a, at("`x'")
stsplit LT1004_b, at("`y'")
stsplit LT1004_c, at("`z'")
stsplit LT1004_d, at("`r'")

egen maxLT1004_a=max(LT1004_a)
egen maxLT1004_b=max(LT1004_b)
egen maxLT1004_c=max(LT1004_c)
egen maxLT1004_d=max(LT1004_d)

/// lt 26 Oct 2008
local z=date("26 Oct 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LT1008_a, at("`x'")
stsplit LT1008_b, at("`y'")
stsplit LT1008_c, at("`z'")
stsplit LT1008_d, at("`r'")

egen maxLT1008_a=max(LT1008_a)
egen maxLT1008_b=max(LT1008_b)
egen maxLT1008_c=max(LT1008_c)
egen maxLT1008_d=max(LT1008_d)


****************
* 21. Slovenia *
****************

/// sv 03 Oct 2004
local z=date("03 Oct 2004", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SV1004_a, at("`x'")
stsplit SV1004_b, at("`y'")
stsplit SV1004_c, at("`z'")
stsplit SV1004_d, at("`r'")

egen maxSV1004_a=max(SV1004_a)
egen maxSV1004_b=max(SV1004_b)
egen maxSV1004_c=max(SV1004_c)
egen maxSV1004_d=max(SV1004_d)

/// sv 21 Sep 2008
local z=date("21 Sep 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit SV0908_a, at("`x'")
stsplit SV0908_b, at("`y'")
stsplit SV0908_c, at("`z'")
stsplit SV0908_d, at("`r'")

egen maxSV0908_a=max(SV0908_a)
egen maxSV0908_b=max(SV0908_b)
egen maxSV0908_c=max(SV0908_c)
egen maxSV0908_d=max(SV0908_d)


**************
* 22. Latvia *
**************

/// lv 07 Oct 2006
local z=date("07 Oct 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit LV1006_a, at("`x'")
stsplit LV1006_b, at("`y'")
stsplit LV1006_c, at("`z'")
stsplit LV1006_d, at("`r'")

egen maxLV1006_a=max(LV1006_a)
egen maxLV1006_b=max(LV1006_b)
egen maxLV1006_c=max(LV1006_c)
egen maxLV1006_d=max(LV1006_d)


***************
* 23. Estonia *
***************

/// es 04 Mar 2007
local z=date("04 Mar 2007", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit ES0307_a, at("`x'")
stsplit ES0307_b, at("`y'")
stsplit ES0307_c, at("`z'")
stsplit ES0307_d, at("`r'")

egen maxES0307_a=max(ES0307_a)
egen maxES0307_b=max(ES0307_b)
egen maxES0307_c=max(ES0307_c)
egen maxES0307_d=max(ES0307_d)


**************
* 24. Cyprus *
**************

/// cy 21 May 2006 (House of representatives)
local z=date("21 May 2006", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit CY0506_a, at("`x'")
stsplit CY0506_b, at("`y'")
stsplit CY0506_c, at("`z'")
stsplit CY0506_d, at("`r'")

egen maxCY0506_a=max(CY0506_a)
egen maxCY0506_b=max(CY0506_b)
egen maxCY0506_c=max(CY0506_c)
egen maxCY0506_d=max(CY0506_d)

/// cy 17 Feb 2008 (President)
local z=date("17 Feb 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit CY0208_a, at("`x'")
stsplit CY0208_b, at("`y'")
stsplit CY0208_c, at("`z'")
stsplit CY0208_d, at("`r'")

egen maxCY0208_a=max(CY0208_a)
egen maxCY0208_b=max(CY0208_b)
egen maxCY0208_c=max(CY0208_c)
egen maxCY0208_d=max(CY0208_d)


*************
* 25. Malta *
*************

/// ma 08 Mar 2008
local z=date("08 Mar 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit MA0308_a, at("`x'")
stsplit MA0308_b, at("`y'")
stsplit MA0308_c, at("`z'")
stsplit MA0308_d, at("`r'")

egen maxMA0308_a=max(MA0308_a)
egen maxMA0308_b=max(MA0308_b)
egen maxMA0308_c=max(MA0308_c)
egen maxMA0308_d=max(MA0308_d)


***************
* 26. Romania *
***************

/// ro 30 Nov 2008
local z=date("30 Nov 2008", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit RO1108_a, at("`x'")
stsplit RO1108_b, at("`y'")
stsplit RO1108_c, at("`z'")
stsplit RO1108_d, at("`r'")

egen maxRO1108_a=max(RO1108_a)
egen maxRO1108_b=max(RO1108_b)
egen maxRO1108_c=max(RO1108_c)
egen maxRO1108_d=max(RO1108_d)


****************
* 27. Bulgaria *
****************

/// bu 5 Jul 2009
local z=date("5 Jul 2009", "DMY")
local x=`z'-90
local y=`z'-60
local r=`z'-30
stsplit BU0709_a, at("`x'")
stsplit BU0709_b, at("`y'")
stsplit BU0709_c, at("`z'")
stsplit BU0709_d, at("`r'")

egen maxBU0709_a=max(BU0709_a)
egen maxBU0709_b=max(BU0709_b)
egen maxBU0709_c=max(BU0709_c)
egen maxBU0709_d=max(BU0709_d)



***************************************************************
**Generate pre-election dummies using 5% and 60 days criteria**
***************************************************************


**Dummy for 60 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgpret5el60=0
replace lgpret5el60=1 if ///
(DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1172_b==maxDE1172_b & DE1172_c==0) | (DE1080_b==maxDE1080_b & DE1080_c==0) | ///
(DE0902_b==maxDE0902_b & DE0902_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0) | (FR0574_b==maxFR0574_b & FR0574_c==0) | ///
(FR0378_b==maxFR0378_b & FR0378_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | (FR0393_b==maxFR0393_b & FR0393_c==0) | ///
(FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0607_b==maxFR0607_b & FR0607_c==0) | (UK0274_b==maxUK0274_b & UK0274_c==0) | ///
(UK1074_b==maxUK1074_b & UK1074_c==0) | (UK0505_b==maxUK0505_b & UK0505_c==0) | (IT0676_b==maxIT0676_b & IT0676_c==0) | ///
(IT0683_b==maxIT0683_b & IT0683_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) | (IT0406_b==maxIT0406_b & IT0406_c==0) | ///
(SP0693_b==maxSP0693_b & SP0693_c==0) | (SP0396_b==maxSP0396_b & SP0396_c==0) | (SP0304_b==maxSP0304_b & SP0304_c==0) | ///
(SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smpret5el60=0
replace smpret5el60=1 if ///
(ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | (ND0577_b==maxND0577_b & ND0577_c==0) | ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | (ND0586_b==maxND0586_b & ND0586_c==0) | ///
(ND0989_b==maxND0989_b & ND0989_c==0) | (ND0594_b==maxND0594_b & ND0594_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | ///
(ND0103_b==maxND0103_b & ND0103_c==0) | (BE0374_b==maxBE0374_b & BE0374_c==0) | (BE0477_b==maxBE0477_b & BE0477_c==0) | ///
(BE1287_b==maxBE1287_b & BE1287_c==0) | (BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0595_b==maxBE0595_b & BE0595_c==0) | ///
(BE0699_b==maxBE0699_b & BE0699_c==0) | (BE0503_b==maxBE0503_b & BE0503_c==0) | (GR0685_b==maxGR0685_b & GR0685_c==0) | ///
(GR0689_b==maxGR0689_b & GR0689_c==0) | (GR1189_b==maxGR1189_b & GR1189_c==0) | (GR0996_b==maxGR0996_b & GR0996_c==0) | ///
(GR0400_b==maxGR0400_b & GR0400_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | (GR0907_b==maxGR0907_b & GR0907_c==0) | ///
(PT0302_b==maxPT0302_b & PT0302_c==0) | (AU1006_b==maxAU1006_b & AU1006_c==0) | (AU0908_b==maxAU0908_b & AU0908_c==0) | ///
(DK1101_b==maxDK1101_b & DK1101_c==0) | (DK0205_b==maxDK0205_b & DK0205_c==0) | (DK1107_b==maxDK1107_b & DK1107_c==0) | ///
(FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | (FN0307_b==maxFN0307_b & FN0307_c==0) | ///
(LU0574_b==maxLU0574_b & LU0574_c==0) | (LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0694_b==maxLU0694_b & LU0694_c==0) | ///
(PL0905_b==maxPL0905_b & PL0905_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | (HU0406_b==maxHU0406_b & HU0406_c==0) | ///
(LT1008_b==maxLT1008_b & LT1008_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | (LV1006_b==maxLV1006_b & LV1006_c==0) | ///
(CY0506_b==maxCY0506_b & CY0506_c==0) | (MA0308_b==maxMA0308_b & MA0308_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0)

*1. Germany*
generate depret5el60=0
replace depret5el60=1 if (DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1172_b==maxDE1172_b & DE1172_c==0) | (DE1080_b==maxDE1080_b & DE1080_c==0) | ///
(DE0902_b==maxDE0902_b & DE0902_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0)

*2. France*
generate frpret5el60=0
replace frpret5el60=1 if (FR0574_b==maxFR0574_b & FR0574_c==0) | (FR0378_b==maxFR0378_b & FR0378_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | ///
(FR0393_b==maxFR0393_b & FR0393_c==0) | (FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0607_b==maxFR0607_b & FR0607_c==0)

*3. UK*
generate ukpret5el60=0
replace ukpret5el60=1 if  (UK0274_b==maxUK0274_b & UK0274_c==0) | (UK1074_b==maxUK1074_b & UK1074_c==0) | UK0505_b==maxUK0505_b & UK0505_c==0

*4. Italy*
generate itpret5el60=0
replace itpret5el60=1 if (IT0676_b==maxIT0676_b & IT0676_c==0) | (IT0683_b==maxIT0683_b & IT0683_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) ///
| (IT0406_b==maxIT0406_b & IT0406_c==0) 

*5. Spain*
generate sppret5el60=0
replace sppret5el60=1 if (SP0693_b==maxSP0693_b & SP0693_c==0) | (SP0396_b==maxSP0396_b & SP0396_c==0) | (SP0304_b==maxSP0304_b & SP0304_c==0) ///
| (SP0308_b==maxSP0308_b & SP0308_c==0)

*6. Netherlands*
generate ndpret5el60=0
replace ndpret5el60=1 if (ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | ///
(ND0577_b==maxND0577_b & ND0577_c==0) | (ND0581_b==maxND0581_b & ND0581_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | ///
(ND0586_b==maxND0586_b & ND0586_c==0) | (ND0989_b==maxND0989_b & ND0989_c==0) | (ND0594_b==maxND0594_b & ND0594_c==0) | ///
(ND0598_b==maxND0598_b & ND0598_c==0) | (ND0103_b==maxND0103_b & ND0103_c==0)

*7. Belgium*
generate bepret5el60=0
replace bepret5el60=1 if (BE0374_b==maxBE0374_b & BE0374_c==0) | (BE0477_b==maxBE0477_b & BE0477_c==0) | ///
(BE1287_b==maxBE1287_b & BE1287_c==0) | (BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0595_b==maxBE0595_b & BE0595_c==0) | ///
(BE0699_b==maxBE0699_b & BE0699_c==0) | (BE0503_b==maxBE0503_b & BE0503_c==0)

*8. Greece*
generate grpret5el60=0
replace grpret5el60=1 if (GR0685_b==maxGR0685_b & GR0685_c==0) | (GR0689_b==maxGR0689_b & GR0689_c==0) | (GR1189_b==maxGR1189_b & GR1189_c==0) | ///
(GR0996_b==maxGR0996_b & GR0996_c==0) | (GR0400_b==maxGR0400_b & GR0400_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | ///
(GR0907_b==maxGR0907_b & GR0907_c==0)

*9. Portugal*
generate ptpret5el60=0
replace ptpret5el60=1 if (PT0302_b==maxPT0302_b & PT0302_c==0)

*10. Sweden*
// NO CLOSE ELECTIONS IN SWEDEN

*11. Austria*
generate aupret5el60=0
replace aupret5el60=1 if (AU1006_b==maxAU1006_b & AU1006_c==0) | (AU0908_b==maxAU0908_b & AU0908_c==0)

*12. Denmark*
generate dkpret5el60=0
replace dkpret5el60=1 if (DK1101_b==maxDK1101_b & DK1101_c==0) | (DK0205_b==maxDK0205_b & DK0205_c==0) | (DK1107_b==maxDK1107_b & DK1107_c==0)

*13. Finland*
generate fnpret5el60=0
replace fnpret5el60=1 if (FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | (FN0307_b==maxFN0307_b & FN0307_c==0)

*14. Ireland*
// NO CLOSE ELECTIONS IN IRELAND

*15. Luxembourg*
generate lupret5el60=0
replace lupret5el60=1 if (LU0574_b==maxLU0574_b & LU0574_c==0) | (LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0694_b==maxLU0694_b & LU0694_c==0)

*16. Poland*
generate plpret5el60=0
replace plpret5el60=1 if (PL0905_b==maxPL0905_b & PL0905_c==0)

*17. Czech Republic*
generate czpret5el60=0
replace czpret5el60=1 if (CZ0606_b==maxCZ0606_b & CZ0606_c==0)

*18. Hungary*
generate hupret5el60=0
replace hupret5el60=1 if (HU0406_b==maxHU0406_b & HU0406_c==0)

*19. Slovakia*
// NO CLOSE ELECTIONS IN SLOVAKIA SINCE 2004 

*20. Lithuania*
generate ltpret5el60=0
replace ltpret5el60=1 if (LT1008_b==maxLT1008_b & LT1008_c==0) 

*21. Slovenia*
generate svpret5el60=0
replace svpret5el60=1 if (SV0908_b==maxSV0908_b & SV0908_c==0)

*22. Latvia*
generate lvpret5el60=0
replace lvpret5el60=1 if (LV1006_b==maxLV1006_b & LV1006_c==0)

*23. Estonia*
// NO CLOSE ELECTIONS IN ESTONIA SINCE 2004 

*24. Cyprus*
generate cypret5el60=0
replace cypret5el60=1 if (CY0506_b==maxCY0506_b & CY0506_c==0) 

*25. Malta*
generate mapret5el60=0
replace mapret5el60=1 if (MA0308_b==maxMA0308_b & MA0308_c==0)

*26. Romania*
generate ropret5el60=0
replace ropret5el60=1 if (RO1108_b==maxRO1108_b & RO1108_c==0)

*27. Bulgaria*
// NO CLOSE ELECTIONS IN ESTONIA SINCE 2007



**Dummy for 60 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprent5el60=0
replace lgprent5el60=1 if ///
(DE0965_b==maxDE0965_b & DE0965_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | ///
(DE0187_b==maxDE0187_b & DE0187_c==0) | (DE1290_b==maxDE1290_b & DE1290_c==0) | (DE1094_b==maxDE1094_b & DE1094_c==0) | ///
(DE0998_b==maxDE0998_b & DE0998_c==0) | (FR1265_b==maxFR1265_b & FR1265_c==0) | ///
(FR0669_b==maxFR0669_b & FR0669_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | ///
(FR0507_b==maxFR0507_b & FR0507_c==0) | (FR0367_b==maxFR0367_b & FR0367_c==0) | (FR0668_b==maxFR0668_b & FR0668_c==0) | ///
(FR0373_b==maxFR0373_b & FR0373_c==0) | (FR0681_b==maxFR0681_b & FR0681_c==0) | (FR0386_b==maxFR0386_b & FR0386_c==0) | ///
(FR0688_b==maxFR0688_b & FR0688_c==0) | (FR0697_b==maxFR0697_b & FR0697_c==0) | (FR0602_b==maxFR0602_b & FR0602_c==0) | ///
(UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | (UK0687_b==maxUK0687_b & UK0687_c==0) | ///
(UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | (UK0601_b==maxUK0601_b & UK0601_c==0) | ///
(IT0568_b==maxIT0568_b & IT0568_c==0) | (IT0572_b==maxIT0572_b & IT0572_c==0) | (IT0679_b==maxIT0679_b & IT0679_c==0) | ///
(IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | (IT0394_b==maxIT0394_b & IT0394_c==0) | ///
(IT0501_b==maxIT0501_b & IT0501_c==0) | (IT0408_b==maxIT0408_b & IT0408_c==0) | (SP0686_b==maxSP0686_b & SP0686_c==0) | ///
(SP1089_b==maxSP1089_b & SP1089_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0)


*Small countries*
generate smprent5el60=0
replace smprent5el60=1 if ///
(ND1172_b==maxND1172_b & ND1172_c==0) | (ND0502_b==maxND0502_b & ND0502_c==0) | (ND1106_b==maxND1106_b & ND1106_c==0) | ///
(BE0368_b==maxBE0368_b & BE0368_c==0) | (BE1171_b==maxBE1171_b & BE1171_c==0) | (BE1278_b==maxBE1278_b & BE1278_c==0) | ///
(BE1181_b==maxBE1181_b & BE1181_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | (BE0607_b==maxBE0607_b & BE0607_c==0) | ///
(GR1081_b==maxGR1081_b & GR1081_c==0) | (GR0490_b==maxGR0490_b & GR0490_c==0) | (GR1093_b==maxGR1093_b & GR1093_c==0) | ///
(PT0787_b==maxPT0787_b & PT0787_c==0) | (PT1091_b==maxPT1091_b & PT1091_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | ///
(PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0205_b==maxPT0205_b & PT0205_c==0) | ///
(SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) | ///
(AU1295_b==maxAU1295_b & AU1295_c==0) | (AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0) | ///
(DK1273_b==maxDK1273_b & DK1273_c==0) | (DK0175_b==maxDK0175_b & DK0175_c==0) | (DK0277_b==maxDK0277_b & DK0277_c==0) | ///
(DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | (DK0184_b==maxDK0184_b & DK0184_c==0) | ///
(DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | (DK1290_b==maxDK1290_b & DK1290_c==0) | ///
(DK0994_b==maxDK0994_b & DK0994_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0) | (FN0395_b==maxFN0395_b & FN0395_c==0) | ///
(IR0273_b==maxIR0273_b & IR0273_c==0) | (IR0677_b==maxIR0677_b & IR0677_c==0) | (IR0681_b==maxIR0681_b & IR0681_c==0) | ///
(IR0282_b==maxIR0282_b & IR0282_c==0) | (IR1182_b==maxIR1182_b & IR1182_c==0) | (IR0287_b==maxIR0287_b & IR0287_c==0) | ///
(IR0689_b==maxIR0689_b & IR0689_c==0) | (IR1192_b==maxIR1192_b & IR1192_c==0) | (IR0697_b==maxIR0697_b & IR0697_c==0) | ///
(IR0502_b==maxIR0502_b & IR0502_c==0) | (IR0507_b==maxIR0507_b & IR0507_c==0) | (LU1268_b==maxLU1268_b & LU1268_c==0) | ///
(LU0679_b==maxLU0679_b & LU0679_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0699_b==maxLU0699_b & LU0699_c==0) | ///
(LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | (PL1007_b==maxPL1007_b & PL1007_c==0) | ///
(SK0606_b==maxSK0606_b & SK0606_c==0) | (LT1004_b==maxLT1004_b & LT1004_c==0) | (SV1004_b==maxSV1004_b & SV1004_c==0) | ///
(ES0307_b==maxES0307_b & ES0307_c==0) | (CY0208_b==maxCY0208_b & CY0208_c==0) | (BU0709_b==maxBU0709_b & BU0709_c==0)


*1. Germany*
generate deprent5el60=0
replace deprent5el60=1 if (DE0965_b==maxDE0965_b & DE0965_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | ///
(DE0383_b==maxDE0383_b & DE0383_c==0) | (DE0187_b==maxDE0187_b & DE0187_c==0) | (DE1290_b==maxDE1290_b & DE1290_c==0) | ///
(DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0)

*2. France*
generate frprent5el60=0
replace frprent5el60=1 if (FR1265_b==maxFR1265_b & FR1265_c==0) | (FR0669_b==maxFR0669_b & FR0669_c==0) | ///
(FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | ///
(FR0367_b==maxFR0367_b & FR0367_c==0) | (FR0668_b==maxFR0668_b & FR0668_c==0) | (FR0373_b==maxFR0373_b & FR0373_c==0) | ///
(FR0681_b==maxFR0681_b & FR0681_c==0) | (FR0386_b==maxFR0386_b & FR0386_c==0) | (FR0688_b==maxFR0688_b & FR0688_c==0) | ///
(FR0697_b==maxFR0697_b & FR0697_c==0) | (FR0602_b==maxFR0602_b & FR0602_c==0)

*3. UK*
generate ukprent5el60=0
replace ukprent5el60=1 if (UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | ///
(UK0687_b==maxUK0687_b & UK0687_c==0) | (UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | ///
(UK0601_b==maxUK0601_b & UK0601_c==0)

*4. Italy*
generate itprent5el60=0
replace itprent5el60=1 if (IT0568_b==maxIT0568_b & IT0568_c==0) | (IT0572_b==maxIT0572_b & IT0572_c==0) | ///
(IT0679_b==maxIT0679_b & IT0679_c==0) | (IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | ///
(IT0394_b==maxIT0394_b & IT0394_c==0) | (IT0501_b==maxIT0501_b & IT0501_c==0) | (IT0408_b==maxIT0408_b & IT0408_c==0)

*5. Spain*
generate spprent5el60=0
replace spprent5el60=1 if (SP0686_b==maxSP0686_b & SP0686_c==0) | (SP1089_b==maxSP1089_b & SP1089_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0)

*6. Netherlands*
generate ndprent5el60=0
replace ndprent5el60=1 if (ND1172_b==maxND1172_b & ND1172_c==0) | (ND0502_b==maxND0502_b & ND0502_c==0) | (ND1106_b==maxND1106_b & ND1106_c==0)

*7. Belgium*
generate beprent5el60=0
replace beprent5el60=1 if (BE0368_b==maxBE0368_b & BE0368_c==0) | (BE1171_b==maxBE1171_b & BE1171_c==0) | ///
(BE1278_b==maxBE1278_b & BE1278_c==0) | (BE1181_b==maxBE1181_b & BE1181_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | ///
(BE0607_b==maxBE0607_b & BE0607_c==0)

*8. Greece*
generate grprent5el60=0
replace grprent5el60=1 if (GR1081_b==maxGR1081_b & GR1081_c==0) | (GR0490_b==maxGR0490_b & GR0490_c==0) | (GR1093_b==maxGR1093_b & GR1093_c==0)

*9. Portugal*
generate ptprent5el60=0
replace ptprent5el60=1 if (PT0787_b==maxPT0787_b & PT0787_c==0) | (PT1091_b==maxPT1091_b & PT1091_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | ///
(PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0205_b==maxPT0205_b & PT0205_c==0)

*10. Sweden*
generate swprent5el60=0
replace swprent5el60=1 if (SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) 

*11. Austria*
generate auprent5el60=0
replace auprent5el60=1 if (AU1295_b==maxAU1295_b & AU1295_c==0) | (AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0)

*12. Denmark*
generate dkprent5el60=0
replace dkprent5el60=1 if (DK1273_b==maxDK1273_b & DK1273_c==0) | (DK0175_b==maxDK0175_b & DK0175_c==0) | ///
(DK0277_b==maxDK0277_b & DK0277_c==0) | (DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | ///
(DK0184_b==maxDK0184_b & DK0184_c==0) | (DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | ///
(DK1290_b==maxDK1290_b & DK1290_c==0) | (DK0994_b==maxDK0994_b & DK0994_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0)

*13. Finland*
generate fnprent5el60=0
replace fnprent5el60=1 if (FN0395_b==maxFN0395_b & FN0395_c==0)

*14. Ireland*
generate irprent5el60=0
replace irprent5el60=1 if (IR0273_b==maxIR0273_b & IR0273_c==0) | (IR0677_b==maxIR0677_b & IR0677_c==0) | ///
(IR0681_b==maxIR0681_b & IR0681_c==0) | (IR0282_b==maxIR0282_b & IR0282_c==0) | (IR1182_b==maxIR1182_b & IR1182_c==0) | ///
(IR0287_b==maxIR0287_b & IR0287_c==0) | (IR0689_b==maxIR0689_b & IR0689_c==0) | (IR1192_b==maxIR1192_b & IR1192_c==0) | ///
(IR0697_b==maxIR0697_b & IR0697_c==0) | (IR0502_b==maxIR0502_b & IR0502_c==0) | (IR0507_b==maxIR0507_b & IR0507_c==0)

*15. Luxembourg*
generate luprent5el60=0
replace luprent5el60=1 if (LU1268_b==maxLU1268_b & LU1268_c==0) | (LU0679_b==maxLU0679_b & LU0679_c==0) | ///
(LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0699_b==maxLU0699_b & LU0699_c==0) | (LU0604_b==maxLU0604_b & LU0604_c==0) | ///
(LU0609_b==maxLU0609_b & LU0609_c==0) 

*16. Poland*
generate plprent5el60=0
replace plprent5el60=1 if (PL1007_b==maxPL1007_b & PL1007_c==0)

*17. Czech Republic*
//NO NON-CLOSE ELECTIONS SINCE 2004

*18. Hungary*
//NO NON-CLOSE ELECTIONS BETWEEN 2004 AND SEPTEMBER 2009

*19. Slovakia*
generate skprent5el60=0
replace skprent5el60=1 if (SK0606_b==maxSK0606_b & SK0606_c==0)

*20. Lithuania*
generate ltprent5el60=0
replace ltprent5el60=1 if (LT1004_b==maxLT1004_b & LT1004_c==0) 

*21. Slovenia*
generate svprent5el60=0
replace svprent5el60=1 if (SV1004_b==maxSV1004_b & SV1004_c==0)

*22. Latvia*
//NO NON-CLOSE ELECTIONS BETWEEN 2004 AND SEPTEMBER 2009

*23. Estonia*
generate esprent5el60=0
replace esprent5el60=1 if (ES0307_b==maxES0307_b & ES0307_c==0)

*24. Cyprus*
generate cyprent5el60=0
replace cyprent5el60=1 if (CY0208_b==maxCY0208_b & CY0208_c==0)

*25. Malta*
//NO NON-CLOSE ELECTIONS BETWEEN 2004 AND SEPTEMBER 2009

*26. Romania*
//NO NON-CLOSE ELECTIONS BETWEEN 2004 AND SEPTEMBER 2009

*27. Bulgaria*
generate buprent5el60=0
replace buprent5el60=1 if (BU0709_b==maxBU0709_b & BU0709_c==0)



********************************************************************
**Generate pre-election dummies all elections and 60 days criteria**
********************************************************************


generate preel60=0
replace preel60=1 if (lgpret5el60==1 | smpret5el60==1 | lgprent5el60==1 | smprent5el60==1)


*****************************************************************************************
**Generate pre-election dummies close vs. non-close, all elections and 60 days criteria**
*****************************************************************************************

generate pretel60=0
replace pretel60=1 if (lgpret5el60==1 | smpret5el60==1)

generate prentel60=0
replace prentel60=1 if (lgprent5el60==1 | smprent5el60==1)





*******************************************************************
**Generate pre-election dummies using 5%, 30 and 90 days criteria**
*******************************************************************



**Dummy for 30 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgpret5el30=0
replace lgpret5el30=1 if ///
(DE0969_d==maxDE0969_d & DE0969_c==0) | (DE1172_d==maxDE1172_d & DE1172_c==0) | (DE1080_d==maxDE1080_d & DE1080_c==0) | ///
(DE0902_d==maxDE0902_d & DE0902_c==0) | (DE0905_d==maxDE0905_d & DE0905_c==0) | (FR0574_d==maxFR0574_d & FR0574_c==0) | ///
(FR0378_d==maxFR0378_d & FR0378_c==0) | (FR0581_d==maxFR0581_d & FR0581_c==0) | (FR0393_d==maxFR0393_d & FR0393_c==0) | ///
(FR0595_d==maxFR0595_d & FR0595_c==0) | (FR0607_d==maxFR0607_d & FR0607_c==0) | (UK0274_d==maxUK0274_d & UK0274_c==0) | ///
(UK1074_d==maxUK1074_d & UK1074_c==0) | (UK0505_d==maxUK0505_d & UK0505_c==0) | (IT0676_d==maxIT0676_d & IT0676_c==0) | ///
(IT0683_d==maxIT0683_d & IT0683_c==0) | (IT0496_d==maxIT0496_d & IT0496_c==0) | (IT0406_d==maxIT0406_d & IT0406_c==0) | ///
(SP0693_d==maxSP0693_d & SP0693_c==0) | (SP0396_d==maxSP0396_d & SP0396_c==0) | (SP0304_d==maxSP0304_d & SP0304_c==0) | ///
(SP0308_d==maxSP0308_d & SP0308_c==0)

*Small countries*
generate smpret5el30=0
replace smpret5el30=1 if ///
(ND0267_d==maxND0267_d & ND0267_c==0) | (ND0371_d==maxND0371_d & ND0371_c==0) | (ND0577_d==maxND0577_d & ND0577_c==0) | ///
(ND0581_d==maxND0581_d & ND0581_c==0) | (ND0982_d==maxND0982_d & ND0982_c==0) | (ND0586_d==maxND0586_d & ND0586_c==0) | ///
(ND0989_d==maxND0989_d & ND0989_c==0) | (ND0594_d==maxND0594_d & ND0594_c==0) | (ND0598_d==maxND0598_d & ND0598_c==0) | ///
(ND0103_d==maxND0103_d & ND0103_c==0) | (BE0374_d==maxBE0374_d & BE0374_c==0) | (BE0477_d==maxBE0477_d & BE0477_c==0) | ///
(BE1287_d==maxBE1287_d & BE1287_c==0) | (BE1191_d==maxBE1191_d & BE1191_c==0) | (BE0595_d==maxBE0595_d & BE0595_c==0) | ///
(BE0699_d==maxBE0699_d & BE0699_c==0) | (BE0503_d==maxBE0503_d & BE0503_c==0) | (GR0685_d==maxGR0685_d & GR0685_c==0) | ///
(GR0689_d==maxGR0689_d & GR0689_c==0) | (GR1189_d==maxGR1189_d & GR1189_c==0) | (GR0996_d==maxGR0996_d & GR0996_c==0) | ///
(GR0400_d==maxGR0400_d & GR0400_c==0) | (GR0304_d==maxGR0304_d & GR0304_c==0) | (GR0907_d==maxGR0907_d & GR0907_c==0) | ///
(PT0302_d==maxPT0302_d & PT0302_c==0) | (AU1006_d==maxAU1006_d & AU1006_c==0) | (AU0908_d==maxAU0908_d & AU0908_c==0) | ///
(DK1101_d==maxDK1101_d & DK1101_c==0) | (DK0205_d==maxDK0205_d & DK0205_c==0) | (DK1107_d==maxDK1107_d & DK1107_c==0) | ///
(FN0399_d==maxFN0399_d & FN0399_c==0) | (FN0303_d==maxFN0303_d & FN0303_c==0) | (FN0307_d==maxFN0307_d & FN0307_c==0) | ///
(LU0574_d==maxLU0574_d & LU0574_c==0) | (LU0684_d==maxLU0684_d & LU0684_c==0) | (LU0694_d==maxLU0694_d & LU0694_c==0) | ///
(PL0905_d==maxPL0905_d & PL0905_c==0) | (CZ0606_d==maxCZ0606_d & CZ0606_c==0) | (HU0406_d==maxHU0406_d & HU0406_c==0) | ///
(LT1008_d==maxLT1008_d & LT1008_c==0) | (SV0908_d==maxSV0908_d & SV0908_c==0) | (LV1006_d==maxLV1006_d & LV1006_c==0) | ///
(CY0506_d==maxCY0506_d & CY0506_c==0) | (MA0308_d==maxMA0308_d & MA0308_c==0) | (RO1108_d==maxRO1108_d & RO1108_c==0)


**Dummy for 30 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprent5el30=0
replace lgprent5el30=1 if ///
(DE0965_d==maxDE0965_d & DE0965_c==0) | (DE1076_d==maxDE1076_d & DE1076_c==0) | (DE0383_d==maxDE0383_d & DE0383_c==0) | ///
(DE0187_d==maxDE0187_d & DE0187_c==0) | (DE1290_d==maxDE1290_d & DE1290_c==0) | (DE1094_d==maxDE1094_d & DE1094_c==0) | ///
(DE0998_d==maxDE0998_d & DE0998_c==0) | (FR1265_d==maxFR1265_d & FR1265_c==0) | ///
(FR0669_d==maxFR0669_d & FR0669_c==0) | (FR0588_d==maxFR0588_d & FR0588_c==0) | (FR0502_d==maxFR0502_d & FR0502_c==0) | ///
(FR0507_d==maxFR0507_d & FR0507_c==0) | (FR0367_d==maxFR0367_d & FR0367_c==0) | (FR0668_d==maxFR0668_d & FR0668_c==0) | ///
(FR0373_d==maxFR0373_d & FR0373_c==0) | (FR0681_d==maxFR0681_d & FR0681_c==0) | (FR0386_d==maxFR0386_d & FR0386_c==0) | ///
(FR0688_d==maxFR0688_d & FR0688_c==0) | (FR0697_d==maxFR0697_d & FR0697_c==0) | (FR0602_d==maxFR0602_d & FR0602_c==0) | ///
(UK0579_d==maxUK0579_d & UK0579_c==0) | (UK0683_d==maxUK0683_d & UK0683_c==0) | (UK0687_d==maxUK0687_d & UK0687_c==0) | ///
(UK0492_d==maxUK0492_d & UK0492_c==0) | (UK0597_d==maxUK0597_d & UK0597_c==0) | (UK0601_d==maxUK0601_d & UK0601_c==0) | ///
(IT0568_d==maxIT0568_d & IT0568_c==0) | (IT0572_d==maxIT0572_d & IT0572_c==0) | (IT0679_d==maxIT0679_d & IT0679_c==0) | ///
(IT0687_d==maxIT0687_d & IT0687_c==0) | (IT0492_d==maxIT0492_d & IT0492_c==0) | (IT0394_d==maxIT0394_d & IT0394_c==0) | ///
(IT0501_d==maxIT0501_d & IT0501_c==0) | (IT0408_d==maxIT0408_d & IT0408_c==0) | (SP0686_d==maxSP0686_d & SP0686_c==0) | ///
(SP1089_d==maxSP1089_d & SP1089_c==0) | (SP0300_d==maxSP0300_d & SP0300_c==0)

*Small countries*
generate smprent5el30=0
replace smprent5el30=1 if ///
(ND1172_d==maxND1172_d & ND1172_c==0) | (ND0502_d==maxND0502_d & ND0502_c==0) | (ND1106_d==maxND1106_d & ND1106_c==0) | ///
(BE0368_d==maxBE0368_d & BE0368_c==0) | (BE1171_d==maxBE1171_d & BE1171_c==0) | (BE1278_d==maxBE1278_d & BE1278_c==0) | ///
(BE1181_d==maxBE1181_d & BE1181_c==0) | (BE1085_d==maxBE1085_d & BE1085_c==0) | (BE0607_d==maxBE0607_d & BE0607_c==0) | ///
(GR1081_d==maxGR1081_d & GR1081_c==0) | (GR0490_d==maxGR0490_d & GR0490_c==0) | (GR1093_d==maxGR1093_d & GR1093_c==0) | ///
(PT0787_d==maxPT0787_d & PT0787_c==0) | (PT1091_d==maxPT1091_d & PT1091_c==0) | (PT1095_d==maxPT1095_d & PT1095_c==0) | ///
(PT1099_d==maxPT1099_d & PT1099_c==0) | (PT0205_d==maxPT0205_d & PT0205_c==0) | ///
(SW0998_d==maxSW0998_d & SW0998_c==0) | (SW0902_d==maxSW0902_d & SW0902_c==0) | (SW0906_d==maxSW0906_d & SW0906_c==0) | ///
(AU1295_d==maxAU1295_d & AU1295_c==0) | (AU1099_d==maxAU1099_d & AU1099_c==0) | (AU1102_d==maxAU1102_d & AU1102_c==0) | ///
(DK1273_d==maxDK1273_d & DK1273_c==0) | (DK0175_d==maxDK0175_d & DK0175_c==0) | (DK0277_d==maxDK0277_d & DK0277_c==0) | ///
(DK1079_d==maxDK1079_d & DK1079_c==0) | (DK1281_d==maxDK1281_d & DK1281_c==0) | (DK0184_d==maxDK0184_d & DK0184_c==0) | ///
(DK0987_d==maxDK0987_d & DK0987_c==0) | (DK0588_d==maxDK0588_d & DK0588_c==0) | (DK1290_d==maxDK1290_d & DK1290_c==0) | ///
(DK0994_d==maxDK0994_d & DK0994_c==0) | (DK0398_d==maxDK0398_d & DK0398_c==0) | (FN0395_d==maxFN0395_d & FN0395_c==0) | ///
(IR0273_d==maxIR0273_d & IR0273_c==0) | (IR0677_d==maxIR0677_d & IR0677_c==0) | (IR0681_d==maxIR0681_d & IR0681_c==0) | ///
(IR0282_d==maxIR0282_d & IR0282_c==0) | (IR1182_d==maxIR1182_d & IR1182_c==0) | (IR0287_d==maxIR0287_d & IR0287_c==0) | ///
(IR0689_d==maxIR0689_d & IR0689_c==0) | (IR1192_d==maxIR1192_d & IR1192_c==0) | (IR0697_d==maxIR0697_d & IR0697_c==0) | ///
(IR0502_d==maxIR0502_d & IR0502_c==0) | (IR0507_d==maxIR0507_d & IR0507_c==0) | (LU1268_d==maxLU1268_d & LU1268_c==0) | ///
(LU0679_d==maxLU0679_d & LU0679_c==0) | (LU0689_d==maxLU0689_d & LU0689_c==0) | (LU0699_d==maxLU0699_d & LU0699_c==0) | ///
(LU0604_d==maxLU0604_d & LU0604_c==0) | (LU0609_d==maxLU0609_d & LU0609_c==0) | (PL1007_d==maxPL1007_d & PL1007_c==0) | ///
(SK0606_d==maxSK0606_d & SK0606_c==0) | (LT1004_d==maxLT1004_d & LT1004_c==0) | (SV1004_d==maxSV1004_d & SV1004_c==0) | ///
(ES0307_d==maxES0307_d & ES0307_c==0) | (CY0208_d==maxCY0208_d & CY0208_c==0) | (BU0709_d==maxBU0709_d & BU0709_c==0)




**Dummy for 90 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgpret5el90=0
replace lgpret5el90=1 if ///
(DE0969_a==maxDE0969_a & DE0969_c==0) | (DE1172_a==maxDE1172_a & DE1172_c==0) | (DE1080_a==maxDE1080_a & DE1080_c==0) | ///
(DE0902_a==maxDE0902_a & DE0902_c==0) | (DE0905_a==maxDE0905_a & DE0905_c==0) | (FR0574_a==maxFR0574_a & FR0574_c==0) | ///
(FR0378_a==maxFR0378_a & FR0378_c==0) | (FR0581_a==maxFR0581_a & FR0581_c==0) | (FR0393_a==maxFR0393_a & FR0393_c==0) | ///
(FR0595_a==maxFR0595_a & FR0595_c==0) | (FR0607_a==maxFR0607_a & FR0607_c==0) | (UK0274_a==maxUK0274_a & UK0274_c==0) | ///
(UK1074_a==maxUK1074_a & UK1074_c==0) | (UK0505_a==maxUK0505_a & UK0505_c==0) | (IT0676_a==maxIT0676_a & IT0676_c==0) | ///
(IT0683_a==maxIT0683_a & IT0683_c==0) | (IT0496_a==maxIT0496_a & IT0496_c==0) | (IT0406_a==maxIT0406_a & IT0406_c==0) | ///
(SP0693_a==maxSP0693_a & SP0693_c==0) | (SP0396_a==maxSP0396_a & SP0396_c==0) | (SP0304_a==maxSP0304_a & SP0304_c==0) | ///
(SP0308_a==maxSP0308_a & SP0308_c==0)

*Small countries*
generate smpret5el90=0
replace smpret5el90=1 if ///
(ND0267_a==maxND0267_a & ND0267_c==0) | (ND0371_a==maxND0371_a & ND0371_c==0) | (ND0577_a==maxND0577_a & ND0577_c==0) | ///
(ND0581_a==maxND0581_a & ND0581_c==0) | (ND0982_a==maxND0982_a & ND0982_c==0) | (ND0586_a==maxND0586_a & ND0586_c==0) | ///
(ND0989_a==maxND0989_a & ND0989_c==0) | (ND0594_a==maxND0594_a & ND0594_c==0) | (ND0598_a==maxND0598_a & ND0598_c==0) | ///
(ND0103_a==maxND0103_a & ND0103_c==0) | (BE0374_a==maxBE0374_a & BE0374_c==0) | (BE0477_a==maxBE0477_a & BE0477_c==0) | ///
(BE1287_a==maxBE1287_a & BE1287_c==0) | (BE1191_a==maxBE1191_a & BE1191_c==0) | (BE0595_a==maxBE0595_a & BE0595_c==0) | ///
(BE0699_a==maxBE0699_a & BE0699_c==0) | (BE0503_a==maxBE0503_a & BE0503_c==0) | (GR0685_a==maxGR0685_a & GR0685_c==0) | ///
(GR0689_a==maxGR0689_a & GR0689_c==0) | (GR1189_a==maxGR1189_a & GR1189_c==0) | (GR0996_a==maxGR0996_a & GR0996_c==0) | ///
(GR0400_a==maxGR0400_a & GR0400_c==0) | (GR0304_a==maxGR0304_a & GR0304_c==0) | (GR0907_a==maxGR0907_a & GR0907_c==0) | ///
(PT0302_a==maxPT0302_a & PT0302_c==0) | (AU1006_a==maxAU1006_a & AU1006_c==0) | (AU0908_a==maxAU0908_a & AU0908_c==0) | ///
(DK1101_a==maxDK1101_a & DK1101_c==0) | (DK0205_a==maxDK0205_a & DK0205_c==0) | (DK1107_a==maxDK1107_a & DK1107_c==0) | ///
(FN0399_a==maxFN0399_a & FN0399_c==0) | (FN0303_a==maxFN0303_a & FN0303_c==0) | (FN0307_a==maxFN0307_a & FN0307_c==0) | ///
(LU0574_a==maxLU0574_a & LU0574_c==0) | (LU0684_a==maxLU0684_a & LU0684_c==0) | (LU0694_a==maxLU0694_a & LU0694_c==0) | ///
(PL0905_a==maxPL0905_a & PL0905_c==0) | (CZ0606_a==maxCZ0606_a & CZ0606_c==0) | (HU0406_a==maxHU0406_a & HU0406_c==0) | ///
(LT1008_a==maxLT1008_a & LT1008_c==0) | (SV0908_a==maxSV0908_a & SV0908_c==0) | (LV1006_a==maxLV1006_a & LV1006_c==0) | ///
(CY0506_a==maxCY0506_a & CY0506_c==0) | (MA0308_a==maxMA0308_a & MA0308_c==0) | (RO1108_a==maxRO1108_a & RO1108_c==0) 


**Dummy for 90 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprent5el90=0
replace lgprent5el90=1 if ///
(DE0965_a==maxDE0965_a & DE0965_c==0) | (DE1076_a==maxDE1076_a & DE1076_c==0) | (DE0383_a==maxDE0383_a & DE0383_c==0) | ///
(DE0187_a==maxDE0187_a & DE0187_c==0) | (DE1290_a==maxDE1290_a & DE1290_c==0) | (DE1094_a==maxDE1094_a & DE1094_c==0) | ///
(DE0998_a==maxDE0998_a & DE0998_c==0) | (DE0909_a==maxDE0909_a & DE0909_c==0) | (FR1265_a==maxFR1265_a & FR1265_c==0) | ///
(FR0669_a==maxFR0669_a & FR0669_c==0) | (FR0588_a==maxFR0588_a & FR0588_c==0) | (FR0502_a==maxFR0502_a & FR0502_c==0) | ///
(FR0507_a==maxFR0507_a & FR0507_c==0) | (FR0681_a==maxFR0681_a & FR0681_c==0) | (FR0386_a==maxFR0386_a & FR0386_c==0) | ///
(FR0367_a==maxFR0367_a & FR0367_c==0) | (FR0668_a==maxFR0668_a & FR0668_c==0) | (FR0373_a==maxFR0373_a & FR0373_c==0) | ///
(FR0688_a==maxFR0688_a & FR0688_c==0) | (FR0697_a==maxFR0697_a & FR0697_c==0) | (FR0602_a==maxFR0602_a & FR0602_c==0) | ///
(UK0579_a==maxUK0579_a & UK0579_c==0) | (UK0683_a==maxUK0683_a & UK0683_c==0) | (UK0687_a==maxUK0687_a & UK0687_c==0) | ///
(UK0492_a==maxUK0492_a & UK0492_c==0) | (UK0597_a==maxUK0597_a & UK0597_c==0) | (UK0601_a==maxUK0601_a & UK0601_c==0) | ///
(IT0568_a==maxIT0568_a & IT0568_c==0) | (IT0572_a==maxIT0572_a & IT0572_c==0) | (IT0679_a==maxIT0679_a & IT0679_c==0) | ///
(IT0687_a==maxIT0687_a & IT0687_c==0) | (IT0492_a==maxIT0492_a & IT0492_c==0) | (IT0394_a==maxIT0394_a & IT0394_c==0) | ///
(IT0501_a==maxIT0501_a & IT0501_c==0) | (IT0408_a==maxIT0408_a & IT0408_c==0) | (SP0686_a==maxSP0686_a & SP0686_c==0) | ///
(SP1089_a==maxSP1089_a & SP1089_c==0) | (SP0300_a==maxSP0300_a & SP0300_c==0)


*Small countries*
generate smprent5el90=0
replace smprent5el90=1 if ///
(ND1172_a==maxND1172_a & ND1172_c==0) | (ND0502_a==maxND0502_a & ND0502_c==0) | (ND1106_a==maxND1106_a & ND1106_c==0) | ///
(BE0368_a==maxBE0368_a & BE0368_c==0) | (BE1171_a==maxBE1171_a & BE1171_c==0) | (BE1278_a==maxBE1278_a & BE1278_c==0) | ///
(BE1181_a==maxBE1181_a & BE1181_c==0) | (BE1085_a==maxBE1085_a & BE1085_c==0) | (BE0607_a==maxBE0607_a & BE0607_c==0) | ///
(GR1081_a==maxGR1081_a & GR1081_c==0) | (GR0490_a==maxGR0490_a & GR0490_c==0) | (GR1093_a==maxGR1093_a & GR1093_c==0) | ///
(PT0787_a==maxPT0787_a & PT0787_c==0) | (PT1091_a==maxPT1091_a & PT1091_c==0) | (PT1095_a==maxPT1095_a & PT1095_c==0) | ///
(PT1099_a==maxPT1099_a & PT1099_c==0) | (PT0205_a==maxPT0205_a & PT0205_c==0) | (PT0909_a==maxPT0909_a & PT0909_c==0) | ///
(SW0998_a==maxSW0998_a & SW0998_c==0) | (SW0902_a==maxSW0902_a & SW0902_c==0) | (SW0906_a==maxSW0906_a & SW0906_c==0) | ///
(AU1295_a==maxAU1295_a & AU1295_c==0) | (AU1099_a==maxAU1099_a & AU1099_c==0) | (AU1102_a==maxAU1102_a & AU1102_c==0) | ///
(DK1273_a==maxDK1273_a & DK1273_c==0) | (DK0175_a==maxDK0175_a & DK0175_c==0) | (DK0277_a==maxDK0277_a & DK0277_c==0) | ///
(DK1079_a==maxDK1079_a & DK1079_c==0) | (DK1281_a==maxDK1281_a & DK1281_c==0) | (DK0184_a==maxDK0184_a & DK0184_c==0) | ///
(DK0987_a==maxDK0987_a & DK0987_c==0) | (DK0588_a==maxDK0588_a & DK0588_c==0) | (DK1290_a==maxDK1290_a & DK1290_c==0) | ///
(DK0994_a==maxDK0994_a & DK0994_c==0) | (DK0398_a==maxDK0398_a & DK0398_c==0) | (FN0395_a==maxFN0395_a & FN0395_c==0) | ///
(IR0273_a==maxIR0273_a & IR0273_c==0) | (IR0677_a==maxIR0677_a & IR0677_c==0) | (IR0681_a==maxIR0681_a & IR0681_c==0) | ///
(IR0282_a==maxIR0282_a & IR0282_c==0) | (IR1182_a==maxIR1182_a & IR1182_c==0) | (IR0287_a==maxIR0287_a & IR0287_c==0) | ///
(IR0689_a==maxIR0689_a & IR0689_c==0) | (IR1192_a==maxIR1192_a & IR1192_c==0) | (IR0697_a==maxIR0697_a & IR0697_c==0) | ///
(IR0502_a==maxIR0502_a & IR0502_c==0) | (IR0507_a==maxIR0507_a & IR0507_c==0) | (LU1268_a==maxLU1268_a & LU1268_c==0) | ///
(LU0679_a==maxLU0679_a & LU0679_c==0) | (LU0689_a==maxLU0689_a & LU0689_c==0) | (LU0699_a==maxLU0699_a & LU0699_c==0) | ///
(LU0604_a==maxLU0604_a & LU0604_c==0) | (LU0609_a==maxLU0609_a & LU0609_c==0) | (PL1007_a==maxPL1007_a & PL1007_c==0) | ///
(SK0606_a==maxSK0606_a & SK0606_c==0) | (LT1004_a==maxLT1004_a & LT1004_c==0) | (SV1004_a==maxSV1004_a & SV1004_c==0) | ///
(ES0307_a==maxES0307_a & ES0307_c==0) | (CY0208_a==maxCY0208_a & CY0208_c==0) | (BU0709_a==maxBU0709_a & BU0709_c==0)





*******************************************************************
**Generate pre-election dummies using 60 days, 3% and 7% criteria**
*******************************************************************


**Dummy for 3% PRIOR TO CLOSE elections**
*****************************************

*Large countries*
generate lgpret3el60=0
replace lgpret3el60=1 if ///
(DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1172_b==maxDE1172_b & DE1172_c==0) | (DE1080_b==maxDE1080_b & DE1080_c==0) | ///
(DE0902_b==maxDE0902_b & DE0902_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0) | (FR0574_b==maxFR0574_b & FR0574_c==0) | ///
(FR0378_b==maxFR0378_b & FR0378_c==0) | (FR0393_b==maxFR0393_b & FR0393_c==0) | (UK0274_b==maxUK0274_b & UK0274_c==0) | ///
(UK0505_b==maxUK0505_b & UK0505_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) | (IT0406_b==maxIT0406_b & IT0406_c==0) | ///
(SP0396_b==maxSP0396_b & SP0396_c==0)

*Small countries*
generate smpret3el60=0
replace smpret3el60=1 if ///
(ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | (ND0577_b==maxND0577_b & ND0577_c==0) | ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | (ND0586_b==maxND0586_b & ND0586_c==0) | ///
(ND0594_b==maxND0594_b & ND0594_c==0) | (ND0103_b==maxND0103_b & ND0103_c==0) | (BE0477_b==maxBE0477_b & BE0477_c==0) | ///
(BE0699_b==maxBE0699_b & BE0699_c==0) | (BE0503_b==maxBE0503_b & BE0503_c==0) | (GR0400_b==maxGR0400_b & GR0400_c==0) | ///
(PT0302_b==maxPT0302_b & PT0302_c==0) | (AU1006_b==maxAU1006_b & AU1006_c==0) | (DK1101_b==maxDK1101_b & DK1101_c==0) | ///
(DK1107_b==maxDK1107_b & DK1107_c==0) | (FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | ///
(FN0307_b==maxFN0307_b & FN0307_c==0) | (LU0574_b==maxLU0574_b & LU0574_c==0) | (PL0905_b==maxPL0905_b & PL0905_c==0) | ///
(HU0406_b==maxHU0406_b & HU0406_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | (LV1006_b==maxLV1006_b & LV1006_c==0) | ///
(CY0506_b==maxCY0506_b & CY0506_c==0) | (MA0308_b==maxMA0308_b & MA0308_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0)


**Dummy for 3% PRIOR TO NON-CLOSE elections**
*********************************************

*Large countries*
generate lgprent3el60=0
replace lgprent3el60=1 if ///
(DE0965_b==maxDE0965_b & DE0965_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | ///
(DE0187_b==maxDE0187_b & DE0187_c==0) | (DE1290_b==maxDE1290_b & DE1290_c==0) | (DE1094_b==maxDE1094_b & DE1094_c==0) | ///
(DE0998_b==maxDE0998_b & DE0998_c==0) | (FR1265_b==maxFR1265_b & FR1265_c==0) | ///
(FR0669_b==maxFR0669_b & FR0669_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | ///
(FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | ///
(FR0367_b==maxFR0367_b & FR0367_c==0) | (FR0668_b==maxFR0668_b & FR0668_c==0) | (FR0373_b==maxFR0373_b & FR0373_c==0) | ///
(FR0681_b==maxFR0681_b & FR0681_c==0) | (FR0386_b==maxFR0386_b & FR0386_c==0) | (FR0688_b==maxFR0688_b & FR0688_c==0) | ///
(FR0697_b==maxFR0697_b & FR0697_c==0) | (FR0602_b==maxFR0602_b & FR0602_c==0) | (FR0607_b==maxFR0607_b & FR0607_c==0) | ///
(UK1074_b==maxUK1074_b & UK1074_c==0) | (UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | ///
(UK0687_b==maxUK0687_b & UK0687_c==0) | (UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | ///
(UK0601_b==maxUK0601_b & UK0601_c==0) | (IT0676_b==maxIT0676_b & IT0676_c==0) | (IT0568_b==maxIT0568_b & IT0568_c==0) | ///
(IT0572_b==maxIT0572_b & IT0572_c==0) | (IT0679_b==maxIT0679_b & IT0679_c==0) | (IT0683_b==maxIT0683_b & IT0683_c==0) | ///
(IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | (IT0394_b==maxIT0394_b & IT0394_c==0) | ///
(IT0501_b==maxIT0501_b & IT0501_c==0) | (IT0408_b==maxIT0408_b & IT0408_c==0) | (SP0686_b==maxSP0686_b & SP0686_c==0) | ///
(SP1089_b==maxSP1089_b & SP1089_c==0) | (SP0693_b==maxSP0693_b & SP0693_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0) | ///
(SP0304_b==maxSP0304_b & SP0304_c==0) | (SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smprent3el60=0
replace smprent3el60=1 if ///
(ND1172_b==maxND1172_b & ND1172_c==0) | (ND0989_b==maxND0989_b & ND0989_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | ///
(ND0502_b==maxND0502_b & ND0502_c==0) | (ND1106_b==maxND1106_b & ND1106_c==0) | (BE0368_b==maxBE0368_b & BE0368_c==0) | ///
(BE1171_b==maxBE1171_b & BE1171_c==0) | (BE0374_b==maxBE0374_b & BE0374_c==0) | (BE1278_b==maxBE1278_b & BE1278_c==0) | ///
(BE1181_b==maxBE1181_b & BE1181_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | (BE1287_b==maxBE1287_b & BE1287_c==0) | ///
(BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0595_b==maxBE0595_b & BE0595_c==0) | (BE0607_b==maxBE0607_b & BE0607_c==0) | ///
(GR1081_b==maxGR1081_b & GR1081_c==0) | (GR0685_b==maxGR0685_b & GR0685_c==0) | (GR0689_b==maxGR0689_b & GR0689_c==0) | ///
(GR1189_b==maxGR1189_b & GR1189_c==0) | (GR0490_b==maxGR0490_b & GR0490_c==0) | (GR1093_b==maxGR1093_b & GR1093_c==0) | ///
(GR0996_b==maxGR0996_b & GR0996_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | (GR0907_b==maxGR0907_b & GR0907_c==0) | ///
(PT0787_b==maxPT0787_b & PT0787_c==0) | (PT1091_b==maxPT1091_b & PT1091_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | ///
(PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0205_b==maxPT0205_b & PT0205_c==0) | ///
(SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) | ///
(AU1295_b==maxAU1295_b & AU1295_c==0) | (AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0) | ///
(AU0908_b==maxAU0908_b & AU0908_c==0) | (DK1273_b==maxDK1273_b & DK1273_c==0) | (DK0175_b==maxDK0175_b & DK0175_c==0) | ///
(DK0277_b==maxDK0277_b & DK0277_c==0) | (DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | ///
(DK0184_b==maxDK0184_b & DK0184_c==0) | (DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | ///
(DK1290_b==maxDK1290_b & DK1290_c==0) | (DK0994_b==maxDK0994_b & DK0994_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0) | ///
(DK0205_b==maxDK0205_b & DK0205_c==0) | (FN0395_b==maxFN0395_b & FN0395_c==0) | (IR0273_b==maxIR0273_b & IR0273_c==0) | ///
(IR0677_b==maxIR0677_b & IR0677_c==0) | (IR0282_b==maxIR0681_b & IR0681_c==0) | (IR0282_b==maxIR0282_b & IR0282_c==0) | ///
(IR1182_b==maxIR1182_b & IR1182_c==0) | (IR0287_b==maxIR0287_b & IR0287_c==0) | (IR0689_b==maxIR0689_b & IR0689_c==0) | ///
(IR1192_b==maxIR1192_b & IR1192_c==0) | (IR0697_b==maxIR0697_b & IR0697_c==0) | (IR0502_b==maxIR0502_b & IR0502_c==0) | ///
(IR0507_b==maxIR0507_b & IR0507_c==0) | (LU1268_b==maxLU1268_b & LU1268_c==0) | (LU0679_b==maxLU0679_b & LU0679_c==0) | ///
(LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0694_b==maxLU0694_b & LU0694_c==0) | ///
(LU0699_b==maxLU0699_b & LU0699_c==0) | (LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | ///
(PL1007_b==maxPL1007_b & PL1007_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | (SK0606_b==maxSK0606_b & SK0606_c==0) | ///
(LT1004_b==maxLT1004_b & LT1004_c==0) | (LT1008_b==maxLT1008_b & LT1008_c==0) | (SV1004_b==maxSV1004_b & SV1004_c==0) | ///
(ES0307_b==maxES0307_b & ES0307_c==0) | (CY0208_b==maxCY0208_b & CY0208_c==0) | (BU0709_b==maxBU0709_b & BU0709_c==0)




**Dummy for 7% PRIOR TO CLOSE elections**
*****************************************

*Large countries*
generate lgpret7el60=0
replace lgpret7el60=1 if ///
(DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1172_b==maxDE1172_b & DE1172_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | ///
(DE1080_b==maxDE1080_b & DE1080_c==0) | (DE0902_b==maxDE0902_b & DE0902_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0) | ///
(DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | (FR0574_b==maxFR0574_b & FR0574_c==0) | ///
(FR0378_b==maxFR0378_b & FR0378_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | (FR0393_b==maxFR0393_b & FR0393_c==0) | ///
(FR0507_b==maxFR0507_b & FR0507_c==0) | (FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0607_b==maxFR0607_b & FR0607_c==0) | ///
(UK1074_b==maxUK1074_b & UK1074_c==0) | (UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0505_b==maxUK0505_b & UK0505_c==0) | ///
(IT0676_b==maxIT0676_b & IT0676_c==0) | (IT0683_b==maxIT0683_b & IT0683_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) | ///
(IT0406_b==maxIT0406_b & IT0406_c==0) | (SP0693_b==maxSP0693_b & SP0693_c==0) | (SP0396_b==maxSP0396_b & SP0396_c==0) | ///
(SP0304_b==maxSP0304_b & SP0304_c==0) | (SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smpret7el60=0
replace smpret7el60=1 if ///
(ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | (ND0577_b==maxND0577_b & ND0577_c==0) | ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | (ND0586_b==maxND0586_b & ND0586_c==0) | ///
(ND0989_b==maxND0989_b & ND0989_c==0) | (ND0594_b==maxND0594_b & ND0594_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | ///
(ND0103_b==maxND0103_b & ND0103_c==0) | (ND1106_b==maxND1106_b & ND1106_c==0) | (BE0374_b==maxBE0374_b & BE0374_c==0) | ///
(BE0477_b==maxBE0477_b & BE0477_c==0) | (BE1181_b==maxBE1181_b & BE1181_c==0) | (BE1287_b==maxBE1287_b & BE1287_c==0) | ///
(BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0595_b==maxBE0595_b & BE0595_c==0) | (BE0699_b==maxBE0699_b & BE0699_c==0) | ///
(BE0503_b==maxBE0503_b & BE0503_c==0) | (BE0607_b==maxBE0607_b & BE0607_c==0) | (GR0685_b==maxGR0685_b & GR0685_c==0) | ///
(GR0689_b==maxGR0689_b & GR0689_c==0) | (GR1189_b==maxGR1189_b & GR1189_c==0) | (GR0996_b==maxGR0996_b & GR0996_c==0) | ///
(GR0400_b==maxGR0400_b & GR0400_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | (GR0907_b==maxGR0907_b & GR0907_c==0) | ///
(PT0302_b==maxPT0302_b & PT0302_c==0) | (AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0) | ///
(AU1006_b==maxAU1006_b & AU1006_c==0) | (AU0908_b==maxAU0908_b & AU0908_c==0) | (DK0175_b==maxDK0175_b & DK0175_c==0) | ///
(DK1101_b==maxDK1101_b & DK1101_c==0) | (DK0205_b==maxDK0205_b & DK0205_c==0) | (DK1107_b==maxDK1107_b & DK1107_c==0) | ///
(FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | (FN0307_b==maxFN0307_b & FN0307_c==0) | ///
(IR1182_b==maxIR1182_b & IR1182_c==0) | (LU1268_b==maxLU1268_b & LU1268_c==0) | (LU0574_b==maxLU0574_b & LU0574_c==0) | ///
(LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0694_b==maxLU0694_b & LU0694_c==0) | ///
(PL0905_b==maxPL0905_b & PL0905_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | (HU0406_b==maxHU0406_b & HU0406_c==0) | ///
(LT1008_b==maxLT1008_b & LT1008_c==0) | (SV1004_b==maxSV1004_b & SV1004_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | ///
(LV1006_b==maxLV1006_b & LV1006_c==0) | (ES0307_b==maxES0307_b & ES0307_c==0) | (CY0506_b==maxCY0506_b & CY0506_c==0) | ///
(CY0208_b==maxCY0208_b & CY0208_c==0) | (MA0308_b==maxMA0308_b & MA0308_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0) | ///
(BU0709_b==maxBU0709_b & BU0709_c==0)



**Dummy for 7% PRIOR TO NON-CLOSE elections**
*********************************************

*Large countries*
generate lgprent7el60=0
replace lgprent7el60=1 if ///
(DE0965_b==maxDE0965_b & DE0965_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | (DE0187_b==maxDE0187_b & DE0187_c==0) | ///
(DE1290_b==maxDE1290_b & DE1290_c==0) | (FR1265_b==maxFR1265_b & FR1265_c==0) | ///
(FR0669_b==maxFR0669_b & FR0669_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | ///
(FR0367_b==maxFR0367_b & FR0367_c==0) | (FR0668_b==maxFR0668_b & FR0668_c==0) | (FR0373_b==maxFR0373_b & FR0373_c==0) | ///
(FR0681_b==maxFR0681_b & FR0681_c==0) | (FR0386_b==maxFR0386_b & FR0386_c==0) | (FR0688_b==maxFR0688_b & FR0688_c==0) | ///
(FR0697_b==maxFR0697_b & FR0697_c==0) | (FR0602_b==maxFR0602_b & FR0602_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | ///
(UK0687_b==maxUK0687_b & UK0687_c==0) | (UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | ///
(UK0601_b==maxUK0601_b & UK0601_c==0) | (IT0568_b==maxIT0568_b & IT0568_c==0) | (IT0572_b==maxIT0572_b & IT0572_c==0) | ///
(IT0679_b==maxIT0679_b & IT0679_c==0) | (IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | ///
(IT0394_b==maxIT0394_b & IT0394_c==0) | (IT0501_b==maxIT0501_b & IT0501_c==0) | (IT0408_b==maxIT0408_b & IT0408_c==0) | ///
(SP0686_b==maxSP0686_b & SP0686_c==0) | (SP1089_b==maxSP1089_b & SP1089_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0)

*Small countries*
generate smprent7el60=0
replace smprent7el60=1 if ///
(ND1172_b==maxND1172_b & ND1172_c==0) | (ND0502_b==maxND0502_b & ND0502_c==0) | (BE0368_b==maxBE0368_b & BE0368_c==0) | ///
(BE1171_b==maxBE1171_b & BE1171_c==0) | (BE1278_b==maxBE1278_b & BE1278_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | ///
(GR1081_b==maxGR1081_b & GR1081_c==0) | (GR0490_b==maxGR0490_b & GR0490_c==0) | (GR1093_b==maxGR1093_b & GR1093_c==0) | ///
(PT0787_b==maxPT0787_b & PT0787_c==0) | (PT1091_b==maxPT1091_b & PT1091_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | ///
(PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0205_b==maxPT0205_b & PT0205_c==0) | ///
(SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) | ///
(AU1295_b==maxAU1295_b & AU1295_c==0) | (DK1273_b==maxDK1273_b & DK1273_c==0) | (DK0277_b==maxDK0277_b & DK0277_c==0) | ///
(DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | (DK0184_b==maxDK0184_b & DK0184_c==0) | ///
(DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | (DK1290_b==maxDK1290_b & DK1290_c==0) | ///
(DK0994_b==maxDK0994_b & DK0994_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0) | (FN0395_b==maxFN0395_b & FN0395_c==0) | ///
(IR0273_b==maxIR0273_b & IR0273_c==0) | (IR0677_b==maxIR0677_b & IR0677_c==0) | (IR0681_b==maxIR0681_b & IR0681_c==0) | ///
(IR0282_b==maxIR0282_b & IR0282_c==0) | (IR0287_b==maxIR0287_b & IR0287_c==0) | (IR0689_b==maxIR0689_b & IR0689_c==0) | ///
(IR1192_b==maxIR1192_b & IR1192_c==0) | (IR0697_b==maxIR0697_b & IR0697_c==0) | (IR0502_b==maxIR0502_b & IR0502_c==0) | ///
(IR0507_b==maxIR0507_b & IR0507_c==0) | (LU0679_b==maxLU0679_b & LU0679_c==0) | (LU0699_b==maxLU0699_b & LU0699_c==0) | ///
(LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | (PL1007_b==maxPL1007_b & PL1007_c==0) | ///
(SK0606_b==maxSK0606_b & SK0606_c==0) | (LT1004_b==maxLT1004_b & LT1004_c==0) | (BU0709_b==maxBU0709_b & BU0709_c==0)




***********************************************************
**Generate pre-election dummies excluding snap elections **
***********************************************************


**Dummy for 60 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgpret5el60NS=0
replace lgpret5el60NS=1 if ///
(DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1080_b==maxDE1080_b & DE1080_c==0) | (DE0902_b==maxDE0902_b & DE0902_c==0) | ///
(FR0574_b==maxFR0574_b & FR0574_c==0) | (FR0378_b==maxFR0378_b & FR0378_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | ///
(FR0393_b==maxFR0393_b & FR0393_c==0) | (FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0607_b==maxFR0607_b & FR0607_c==0) | ///
(IT0406_b==maxIT0406_b & IT0406_c==0) | (SP0304_b==maxSP0304_b & SP0304_c==0) | (SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smpret5el60NS=0
replace smpret5el60NS=1 if ///
(ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | (ND0577_b==maxND0577_b & ND0577_c==0) | ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0594_b==maxND0594_b & ND0594_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | ///
(BE0374_b==maxBE0374_b & BE0374_c==0) | (BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0699_b==maxBE0699_b & BE0699_c==0) | ///
(BE0503_b==maxBE0503_b & BE0503_c==0) | (GR0689_b==maxGR0689_b & GR0689_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | ///
(FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | (FN0307_b==maxFN0307_b & FN0307_c==0) | ///
(LU0574_b==maxLU0574_b & LU0574_c==0) | (LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0694_b==maxLU0694_b & LU0694_c==0) | ///
(PL0905_b==maxPL0905_b & PL0905_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | (HU0406_b==maxHU0406_b & HU0406_c==0) | ///
(LT1008_b==maxLT1008_b & LT1008_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | (LV1006_b==maxLV1006_b & LV1006_c==0) | ///
(CY0506_b==maxCY0506_b & CY0506_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0)


**Dummy for 60 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprent5el60NS=0
replace lgprent5el60NS=1 if ///
(DE0965_b==maxDE0965_b & DE0965_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0187_b==maxDE0187_b & DE0187_c==0) | ///
(DE1290_b==maxDE1290_b & DE1290_c==0) | (DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | ///
(FR1265_b==maxFR1265_b & FR1265_c==0) | (FR0669_b==maxFR0669_b & FR0669_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | ///
(FR0502_b==maxFR0502_b & FR0502_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | (FR0367_b==maxFR0367_b & FR0367_c==0) | ///
(FR0668_b==maxFR0668_b & FR0668_c==0) | (FR0373_b==maxFR0373_b & FR0373_c==0) | (FR0386_b==maxFR0386_b & FR0386_c==0) | ///
(FR0602_b==maxFR0602_b & FR0602_c==0) | (UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | ///
(IT0568_b==maxIT0568_b & IT0568_c==0) | (IT0572_b==maxIT0572_b & IT0572_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | ///
(IT0501_b==maxIT0501_b & IT0501_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0)


*Small countries*
generate smprent5el60NS=0
replace smprent5el60NS=1 if ///
(ND1172_b==maxND1172_b & ND1172_c==0) | (ND0502_b==maxND0502_b & ND0502_c==0) | (BE0368_b==maxBE0368_b & BE0368_c==0) | ///
(BE1171_b==maxBE1171_b & BE1171_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | (BE0607_b==maxBE0607_b & BE0607_c==0) | ///
(PT1091_b==maxPT1091_b & PT1091_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | (PT1099_b==maxPT1099_b & PT1099_c==0) | ///
(SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) | ///
(AU1099_b==maxAU1099_b & AU1099_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0) | (FN0395_b==maxFN0395_b & FN0395_c==0) | ///
(IR0502_b==maxIR0502_b & IR0502_c==0) | (IR0507_b==maxIR0507_b & IR0507_c==0) | (LU1268_b==maxLU1268_b & LU1268_c==0) | ///
(LU0679_b==maxLU0679_b & LU0679_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0699_b==maxLU0699_b & LU0699_c==0) | ///
(LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | (LT1004_b==maxLT1004_b & LT1004_c==0) | ///
(SV1004_b==maxSV1004_b & SV1004_c==0) | (ES0307_b==maxES0307_b & ES0307_c==0) | (CY0208_b==maxCY0208_b & CY0208_c==0) | ///
(BU0709_b==maxBU0709_b & BU0709_c==0)






*********************************************************************************************************
**Generate pre-election dummies using normalised closeness, based on total average and 60 days criteria**
*********************************************************************************************************


**Dummy for 60 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgpretNTel60=0
replace lgpretNTel60=1 if ///
(DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1172_b==maxDE1172_b & DE1172_c==0) | (DE1080_b==maxDE1080_b & DE1080_c==0) | ///
(DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | (DE0902_b==maxDE0902_b & DE0902_c==0) | ///
(DE0905_b==maxDE0905_b & DE0905_c==0) | (FR0574_b==maxFR0574_b & FR0574_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | ///
(FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | (FR0378_b==maxFR0378_b & FR0378_c==0) | ///
(FR0386_b==maxFR0386_b & FR0386_c==0) | (FR0393_b==maxFR0393_b & FR0393_c==0) | (FR0602_b==maxFR0602_b & FR0602_c==0) | ///
(FR0607_b==maxFR0607_b & FR0607_c==0) | (UK0274_b==maxUK0274_b & UK0274_c==0) | (UK1074_b==maxUK1074_b & UK1074_c==0) | ///
(UK0505_b==maxUK0505_b & UK0505_c==0) | (IT0676_b==maxIT0676_b & IT0676_c==0) | (IT0679_b==maxIT0679_b & IT0679_c==0) | ///
(IT0683_b==maxIT0683_b & IT0683_c==0) | (IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) | ///
(IT0406_b==maxIT0406_b & IT0406_c==0) | (IT0408_b==maxIT0408_b & IT0408_c==0) | (SP0693_b==maxSP0693_b & SP0693_c==0) | ///
(SP0396_b==maxSP0396_b & SP0396_c==0) | (SP0304_b==maxSP0304_b & SP0304_c==0) | (SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smpretNTel60=0
replace smpretNTel60=1 if ///
(ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | (ND0577_b==maxND0577_b & ND0577_c==0) | ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | (ND0586_b==maxND0586_b & ND0586_c==0) | ///
(ND0594_b==maxND0594_b & ND0594_c==0) | (ND0103_b==maxND0103_b & ND0103_c==0) | (BE0374_b==maxBE0374_b & BE0374_c==0) | ///
(BE0477_b==maxBE0477_b & BE0477_c==0) | (BE1287_b==maxBE1287_b & BE1287_c==0) | (BE1191_b==maxBE1191_b & BE1191_c==0) | ///
(BE0595_b==maxBE0595_b & BE0595_c==0) | (BE0699_b==maxBE0699_b & BE0699_c==0) | (BE0503_b==maxBE0503_b & BE0503_c==0) | ///
(BE0607_b==maxBE0607_b & BE0607_c==0) | (GR0685_b==maxGR0685_b & GR0685_c==0) | (GR0689_b==maxGR0689_b & GR0689_c==0) | ///
(GR1189_b==maxGR1189_b & GR1189_c==0) | (GR0996_b==maxGR0996_b & GR0996_c==0) | (GR0400_b==maxGR0400_b & GR0400_c==0) | ///
(GR0304_b==maxGR0304_b & GR0304_c==0) | (GR0907_b==maxGR0907_b & GR0907_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | ///
(PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0302_b==maxPT0302_b & PT0302_c==0) | (SW0998_b==maxSW0998_b & SW0998_c==0) | ///
(SW0906_b==maxSW0906_b & SW0906_c==0) | (AU1006_b==maxAU1006_b & AU1006_c==0) | (AU0908_b==maxAU0908_b & AU0908_c==0) | ///
(DK1273_b==maxDK1273_b & DK1273_c==0) | (DK0175_b==maxDK0175_b & DK0175_c==0) | (DK0184_b==maxDK0184_b & DK0184_c==0) | ///
(DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | (DK0994_b==maxDK0994_b & DK0994_c==0) | ///
(DK0398_b==maxDK0398_b & DK0398_c==0) | (DK1101_b==maxDK1101_b & DK1101_c==0) | (DK0205_b==maxDK0205_b & DK0205_c==0) | ///
(DK1107_b==maxDK1107_b & DK1107_c==0) | (FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | ///
(FN0307_b==maxFN0307_b & FN0307_c==0) | (IR0273_b==maxIR0273_b & IR0273_c==0) | (IR0681_b==maxIR0681_b & IR0681_c==0) | ///
(IR0282_b==maxIR0282_b & IR0282_c==0) | (IR1182_b==maxIR1182_b & IR1182_c==0) | (IR0697_b==maxIR0697_b & IR0697_c==0) | ///
(IR0507_b==maxIR0507_b & IR0507_c==0) | (LU1268_b==maxLU1268_b & LU1268_c==0) | (LU0574_b==maxLU0574_b & LU0574_c==0) | ///
(LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0694_b==maxLU0694_b & LU0694_c==0) | ///
(LU0699_b==maxLU0699_b & LU0699_c==0) | (PL0905_b==maxPL0905_b & PL0905_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | ///
(HU0406_b==maxHU0406_b & HU0406_c==0) | (LT1004_b==maxLT1004_b & LT1004_c==0) | (LT1008_b==maxLT1008_b & LT1008_c==0) | ///
(SV1004_b==maxSV1004_b & SV1004_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | (LV1006_b==maxLV1006_b & LV1006_c==0) | ///
(ES0307_b==maxES0307_b & ES0307_c==0) | (CY0506_b==maxCY0506_b & CY0506_c==0) | (CY0208_b==maxCY0208_b & CY0208_c==0) | ///
(MA0308_b==maxMA0308_b & MA0308_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0)



**Dummy for 60 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprentNTel60=0
replace lgprentNTel60=1 if ///
(DE0965_b==maxDE0965_b & DE0965_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | ///
(DE0187_b==maxDE0187_b & DE0187_c==0) | (DE1290_b==maxDE1290_b & DE1290_c==0) | (FR1265_b==maxFR1265_b & FR1265_c==0) | ///
(FR0669_b==maxFR0669_b & FR0669_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | ///
(FR0367_b==maxFR0367_b & FR0367_c==0) | (FR0668_b==maxFR0668_b & FR0668_c==0) | (FR0373_b==maxFR0373_b & FR0373_c==0) | ///
(FR0681_b==maxFR0681_b & FR0681_c==0) | (FR0688_b==maxFR0688_b & FR0688_c==0) | (FR0697_b==maxFR0697_b & FR0697_c==0) | ///
(UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | (UK0687_b==maxUK0687_b & UK0687_c==0) | ///
(UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | (UK0601_b==maxUK0601_b & UK0601_c==0) | ///
(IT0568_b==maxIT0568_b & IT0568_c==0) | (IT0572_b==maxIT0572_b & IT0572_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | ///
(IT0394_b==maxIT0394_b & IT0394_c==0) | (IT0501_b==maxIT0501_b & IT0501_c==0) | (SP0686_b==maxSP0686_b & SP0686_c==0) | ///
(SP1089_b==maxSP1089_b & SP1089_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0)


*Small countries*
generate smprentNTel60=0
replace smprentNTel60=1 if ///
(ND1172_b==maxND1172_b & ND1172_c==0) | (ND0989_b==maxND0989_b & ND0989_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | ///
(ND0502_b==maxND0502_b & ND0502_c==0) | (ND1106_b==maxND1106_b & ND1106_c==0) | (BE0368_b==maxBE0368_b & BE0368_c==0) | ///
(BE1171_b==maxBE1171_b & BE1171_c==0) | (BE1278_b==maxBE1278_b & BE1278_c==0) | (BE1181_b==maxBE1181_b & BE1181_c==0) | ///
(BE1085_b==maxBE1085_b & BE1085_c==0) | (GR1081_b==maxGR1081_b & GR1081_c==0) | (GR0490_b==maxGR0490_b & GR0490_c==0) | ///
(GR1093_b==maxGR1093_b & GR1093_c==0) | (PT0787_b==maxPT0787_b & PT0787_c==0) | (PT1091_b==maxPT1091_b & PT1091_c==0) | ///
(PT0205_b==maxPT0205_b & PT0205_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (AU1295_b==maxAU1295_b & AU1295_c==0) | ///
(AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0) | (DK0277_b==maxDK0277_b & DK0277_c==0) | ///
(DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | (DK1290_b==maxDK1290_b & DK1290_c==0) | ///
(FN0395_b==maxFN0395_b & FN0395_c==0) | (IR0677_b==maxIR0677_b & IR0677_c==0) | (IR0287_b==maxIR0287_b & IR0287_c==0) | ///
(IR0689_b==maxIR0689_b & IR0689_c==0) | (IR1192_b==maxIR1192_b & IR1192_c==0) | (IR0502_b==maxIR0502_b & IR0502_c==0) | ///
(LU0679_b==maxLU0679_b & LU0679_c==0) | (LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | ///
(PL1007_b==maxPL1007_b & PL1007_c==0) | (SK0606_b==maxSK0606_b & SK0606_c==0) | (BU0709_b==maxBU0709_b & BU0709_c==0)





***********************************************************************************************************
**Generate pre-election dummies using normalised closeness, based on rolling average and 60 days criteria**
***********************************************************************************************************


**Dummy for 60 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgpretNRel60=0
replace lgpretNRel60=1 if ///
(DE0969_b==maxDE0969_b & DE0969_c==0) | (DE1172_b==maxDE1172_b & DE1172_c==0) | (DE1080_b==maxDE1080_b & DE1080_c==0) | ///
(DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | (DE0902_b==maxDE0902_b & DE0902_c==0) | ///
(DE0905_b==maxDE0905_b & DE0905_c==0) | (FR0574_b==maxFR0574_b & FR0574_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | ///
(FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | (FR0378_b==maxFR0378_b & FR0378_c==0) | ///
(FR0386_b==maxFR0386_b & FR0386_c==0) | (FR0393_b==maxFR0393_b & FR0393_c==0) | (FR0602_b==maxFR0602_b & FR0602_c==0) | ///
(FR0607_b==maxFR0607_b & FR0607_c==0) | (UK0274_b==maxUK0274_b & UK0274_c==0) | (UK1074_b==maxUK1074_b & UK1074_c==0) | ///
(UK0505_b==maxUK0505_b & UK0505_c==0) | (IT0568_b==maxIT0568_b & IT0568_c==0) | (IT0572_b==maxIT0572_b & IT0572_c==0) | ///
(IT0676_b==maxIT0676_b & IT0676_c==0) | (IT0679_b==maxIT0679_b & IT0679_c==0) | (IT0683_b==maxIT0683_b & IT0683_c==0) | ///
(IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) | (IT0406_b==maxIT0406_b & IT0406_c==0) | ///
(IT0408_b==maxIT0408_b & IT0408_c==0) | (SP0693_b==maxSP0693_b & SP0693_c==0) | (SP0396_b==maxSP0396_b & SP0396_c==0) | ///
(SP0300_b==maxSP0300_b & SP0300_c==0) | (SP0304_b==maxSP0304_b & SP0304_c==0) | (SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smpretNRel60=0
replace smpretNRel60=1 if ///
(ND0577_b==maxND0577_b & ND0577_c==0) | ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | (ND0586_b==maxND0586_b & ND0586_c==0) | ///
(ND0594_b==maxND0594_b & ND0594_c==0) | (ND0103_b==maxND0103_b & ND0103_c==0) | (BE0368_b==maxBE0368_b & BE0368_c==0) | ///
(BE1171_b==maxBE1171_b & BE1171_c==0) | (BE0374_b==maxBE0374_b & BE0374_c==0) | (BE0477_b==maxBE0477_b & BE0477_c==0) | ///
(BE1181_b==maxBE1181_b & BE1181_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | (BE1287_b==maxBE1287_b & BE1287_c==0) | ///
(BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0595_b==maxBE0595_b & BE0595_c==0) | (BE0699_b==maxBE0699_b & BE0699_c==0) | ///
(BE0503_b==maxBE0503_b & BE0503_c==0) | (BE0607_b==maxBE0607_b & BE0607_c==0) | (GR1081_b==maxGR1081_b & GR1081_c==0) | ///
(GR0685_b==maxGR0685_b & GR0685_c==0) | (GR0689_b==maxGR0689_b & GR0689_c==0) | (GR1189_b==maxGR1189_b & GR1189_c==0) | ///
(GR0490_b==maxGR0490_b & GR0490_c==0) | (GR1093_b==maxGR1093_b & GR1093_c==0) | (GR0996_b==maxGR0996_b & GR0996_c==0) | ///
(GR0400_b==maxGR0400_b & GR0400_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | (GR0907_b==maxGR0907_b & GR0907_c==0) | ///
(PT1095_b==maxPT1095_b & PT1095_c==0) | (PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0302_b==maxPT0302_b & PT0302_c==0) | ///
(SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) | (AU1006_b==maxAU1006_b & AU1006_c==0) | ///
(AU0908_b==maxAU0908_b & AU0908_c==0) | (DK1273_b==maxDK1273_b & DK1273_c==0) | (DK0175_b==maxDK0175_b & DK0175_c==0) | ///
(DK0184_b==maxDK0184_b & DK0184_c==0) | (DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | ///
(DK0994_b==maxDK0994_b & DK0994_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0) | (FN0399_b==maxFN0399_b & FN0399_c==0) | ///
(DK1101_b==maxDK1101_b & DK1101_c==0) | (DK0205_b==maxDK0205_b & DK0205_c==0) | (DK1107_b==maxDK1107_b & DK1107_c==0) | ///
(FN0303_b==maxFN0303_b & FN0303_c==0) | (FN0307_b==maxFN0307_b & FN0307_c==0) | (IR0273_b==maxIR0273_b & IR0273_c==0) | ///
(IR0681_b==maxIR0681_b & IR0681_c==0) | (IR0282_b==maxIR0282_b & IR0282_c==0) | (IR1182_b==maxIR1182_b & IR1182_c==0) | ///
(IR0697_b==maxIR0697_b & IR0697_c==0) | (IR0507_b==maxIR0507_b & IR0507_c==0) | (LU1268_b==maxLU1268_b & LU1268_c==0) | ///
(LU0574_b==maxLU0574_b & LU0574_c==0) | (LU0684_b==maxLU0684_b & LU0684_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | ///
(LU0694_b==maxLU0694_b & LU0694_c==0) | (PL0905_b==maxPL0905_b & PL0905_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | ///
(HU0406_b==maxHU0406_b & HU0406_c==0) | (LT1004_b==maxLT1004_b & LT1004_c==0) | (LT1008_b==maxLT1008_b & LT1008_c==0) | ///
(SV1004_b==maxSV1004_b & SV1004_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | (LV1006_b==maxLV1006_b & LV1006_c==0) | ///
(ES0307_b==maxES0307_b & ES0307_c==0) | (CY0506_b==maxCY0506_b & CY0506_c==0) | (CY0208_b==maxCY0208_b & CY0208_c==0) | ///
(MA0308_b==maxMA0308_b & MA0308_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0)



**Dummy for 60 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprentNRel60=0
replace lgprentNRel60=1 if ///
(DE0965_b==maxDE0965_b & DE0965_c==0) | (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | ///
(DE0187_b==maxDE0187_b & DE0187_c==0) | (DE1290_b==maxDE1290_b & DE1290_c==0) | (FR1265_b==maxFR1265_b & FR1265_c==0) | ///
(FR0669_b==maxFR0669_b & FR0669_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | ///
(FR0367_b==maxFR0367_b & FR0367_c==0) | (FR0668_b==maxFR0668_b & FR0668_c==0) | (FR0373_b==maxFR0373_b & FR0373_c==0) | ///
(FR0681_b==maxFR0681_b & FR0681_c==0) | (FR0688_b==maxFR0688_b & FR0688_c==0) | (FR0697_b==maxFR0697_b & FR0697_c==0) | ///
(UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | (UK0687_b==maxUK0687_b & UK0687_c==0) | ///
(UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | (UK0601_b==maxUK0601_b & UK0601_c==0) | ///
(IT0492_b==maxIT0492_b & IT0492_c==0) | (IT0394_b==maxIT0394_b & IT0394_c==0) | (IT0501_b==maxIT0501_b & IT0501_c==0) | ///
(SP0686_b==maxSP0686_b & SP0686_c==0) | (SP1089_b==maxSP1089_b & SP1089_c==0)


*Small countries*
generate smprentNRel60=0
replace smprentNRel60=1 if ///
(ND0267_b==maxND0267_b & ND0267_c==0) | (ND0371_b==maxND0371_b & ND0371_c==0) | (ND1172_b==maxND1172_b & ND1172_c==0) | ///
(ND0989_b==maxND0989_b & ND0989_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | (ND0502_b==maxND0502_b & ND0502_c==0) | ///
(ND1106_b==maxND1106_b & ND1106_c==0) | (BE1278_b==maxBE1278_b & BE1278_c==0) | (PT0787_b==maxPT0787_b & PT0787_c==0) | ///
(PT1091_b==maxPT1091_b & PT1091_c==0) | (PT0205_b==maxPT0205_b & PT0205_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | ///
(AU1295_b==maxAU1295_b & AU1295_c==0) | (AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0) | ///
(DK0277_b==maxDK0277_b & DK0277_c==0) | (DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | ///
(DK1290_b==maxDK1290_b & DK1290_c==0) | (FN0395_b==maxFN0395_b & FN0395_c==0) | (IR0677_b==maxIR0677_b & IR0677_c==0) | ///
(IR0287_b==maxIR0287_b & IR0287_c==0) | (IR0689_b==maxIR0689_b & IR0689_c==0) | (IR1192_b==maxIR1192_b & IR1192_c==0) | ///
(IR0502_b==maxIR0502_b & IR0502_c==0) | (LU0679_b==maxLU0679_b & LU0679_c==0) | (LU0699_b==maxLU0699_b & LU0699_c==0) | ///
(LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | (PL1007_b==maxPL1007_b & PL1007_c==0) | ///
(SK0606_b==maxSK0606_b & SK0606_c==0) | (BU0709_b==maxBU0709_b & BU0709_c==0)





*******************************************************************************************************
**Generate pre-election dummies using poll data (5% and 60 days criteria) - Only fully available data**
*******************************************************************************************************

**Dummy for 60 days PRIOR TO CLOSE elections**
**********************************************

*0. All countries*
generate precpoll=0
replace precpoll=1 if (DE1080_b==maxDE1080_b & DE1080_c==0) | (DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | ///
(DE0902_b==maxDE0902_b & DE0902_c==0) | (FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | ///
(UK0505_b==maxUK0505_b & UK0505_c==0) | (UK0492_b==maxUK0492_b & UK0492_c==0) 

*1. Germany*
generate deprecpoll=0
replace deprecpoll=1 if (DE1080_b==maxDE1080_b & DE1080_c==0) | (DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | ///
(DE0902_b==maxDE0902_b & DE0902_c==0)

*2. France*
generate frprecpoll=0
replace frprecpoll=1 if (FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0)

*3. UK*
generate ukprecpoll=0
replace ukprecpoll=1 if (UK0505_b==maxUK0505_b & UK0505_c==0) | (UK0492_b==maxUK0492_b & UK0492_c==0) 


**Dummy for 60 days PRIOR TO NON-CLOSE elections**
**************************************************

*0. All countries*
generate prencpoll=0
replace prencpoll=1 if (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | (DE0187_b==maxDE0187_b & DE0187_c==0) | ///
(DE1290_b==maxDE1290_b & DE1290_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | ///
(FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | (UK0579_b==maxUK0579_b & UK0579_c==0) | ///
(UK0683_b==maxUK0683_b & UK0683_c==0) | (UK0687_b==maxUK0687_b & UK0687_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | ///
(UK0601_b==maxUK0601_b & UK0601_c==0)

*1. Germany*
generate deprencpoll=0
replace deprencpoll=1 if (DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | (DE0187_b==maxDE0187_b & DE0187_c==0) | ///
(DE1290_b==maxDE1290_b & DE1290_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0)

*2. France*
generate frprencpoll=0
replace frprencpoll=1 if (FR0581_b==maxFR0581_b & FR0581_c==0) | (FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0)

*3. UK*
generate ukprencpoll=0
replace ukprencpoll=1 if (UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | (UK0687_b==maxUK0687_b & UK0687_c==0) | ///
(UK0597_b==maxUK0597_b & UK0597_c==0) | (UK0601_b==maxUK0601_b & UK0601_c==0)



**********************************************************************************************************************
**Generate pre-election dummies using poll data (5% and 60 days criteria) - Fill-in missing data with actual results**
**********************************************************************************************************************

**Dummy for 60 days PRIOR TO CLOSE elections**
**********************************************

*Large countries*
generate lgprecpoll=0
replace lgprecpoll=1 if ///
(DE1080_b==maxDE1080_b & DE1080_c==0) | (DE1094_b==maxDE1094_b & DE1094_c==0) | (DE0998_b==maxDE0998_b & DE0998_c==0) | ///
(DE0902_b==maxDE0902_b & DE0902_c==0) | (FR0378_b==maxFR0378_b & FR0378_c==0) | (FR0393_b==maxFR0393_b & FR0393_c==0) | ///
(FR0595_b==maxFR0595_b & FR0595_c==0) | (FR0502_b==maxFR0502_b & FR0502_c==0) | (FR0607_b==maxFR0607_b & FR0607_c==0) | ///
(UK0492_b==maxUK0492_b & UK0492_c==0) | (UK0505_b==maxUK0505_b & UK0505_c==0) | (IT0676_b==maxIT0676_b & IT0676_c==0) | ///
(IT0683_b==maxIT0683_b & IT0683_c==0) | (IT0496_b==maxIT0496_b & IT0496_c==0) | (IT0406_b==maxIT0406_b & IT0406_c==0) | ///
(SP0693_b==maxSP0693_b & SP0693_c==0) | (SP0396_b==maxSP0396_b & SP0396_c==0) | (SP0304_b==maxSP0304_b & SP0304_c==0)

*Small countries*
generate smprecpoll=0
replace smprecpoll=1 if ///
(ND0577_b==maxND0577_b & ND0577_c==0) | (ND0982_b==maxND0982_b & ND0982_c==0) | (ND0989_b==maxND0989_b & ND0989_c==0) | ///
(ND0594_b==maxND0594_b & ND0594_c==0) | (ND0103_b==maxND0103_b & ND0103_c==0) | (BE0477_b==maxBE0477_b & BE0477_c==0) | ///
(BE1287_b==maxBE1287_b & BE1287_c==0) | (BE1191_b==maxBE1191_b & BE1191_c==0) | (BE0595_b==maxBE0595_b & BE0595_c==0) | ///
(BE0699_b==maxBE0699_b & BE0699_c==0) | (BE0503_b==maxBE0503_b & BE0503_c==0) | (GR0685_b==maxGR0685_b & GR0685_c==0) | ///
(GR0689_b==maxGR0689_b & GR0689_c==0) | (GR1189_b==maxGR1189_b & GR1189_c==0) | (GR0996_b==maxGR0996_b & GR0996_c==0) | ///
(GR0400_b==maxGR0400_b & GR0400_c==0) | (GR0304_b==maxGR0304_b & GR0304_c==0) | (GR0907_b==maxGR0907_b & GR0907_c==0) | ///
(AU1006_b==maxAU1006_b & AU1006_c==0) | (AU0908_b==maxAU0908_b & AU0908_c==0) | (DK0184_b==maxDK0184_b & DK0184_c==0) | ///
(DK1101_b==maxDK1101_b & DK1101_c==0) | (DK0205_b==maxDK0205_b & DK0205_c==0) | (DK1107_b==maxDK1107_b & DK1107_c==0) | ///
(FN0399_b==maxFN0399_b & FN0399_c==0) | (FN0303_b==maxFN0303_b & FN0303_c==0) | (FN0307_b==maxFN0307_b & FN0307_c==0) | ///
(IR1182_b==maxIR1182_b & IR1182_c==0) | (LU0574_b==maxLU0574_b & LU0574_c==0) | (LU0684_b==maxLU0684_b & LU0684_c==0) | ///
(LU0694_b==maxLU0694_b & LU0694_c==0) | (PL0905_b==maxPL0905_b & PL0905_c==0) | (CZ0606_b==maxCZ0606_b & CZ0606_c==0) | ///
(HU0406_b==maxHU0406_b & HU0406_c==0) | (LT1008_b==maxLT1008_b & LT1008_c==0) | (SV0908_b==maxSV0908_b & SV0908_c==0) | ///
(LV1006_b==maxLV1006_b & LV1006_c==0) | (CY0506_b==maxCY0506_b & CY0506_c==0) | (CY0208_b==maxCY0208_b & CY0208_c==0) | ///
(MA0308_b==maxMA0308_b & MA0308_c==0) | (RO1108_b==maxRO1108_b & RO1108_c==0)


**Dummy for 60 days PRIOR TO NON-CLOSE elections**
**************************************************

*Large countries*
generate lgprencpoll=0
replace lgprencpoll=1 if ///
(DE1076_b==maxDE1076_b & DE1076_c==0) | (DE0383_b==maxDE0383_b & DE0383_c==0) | (DE0187_b==maxDE0187_b & DE0187_c==0) | ///
(DE1290_b==maxDE1290_b & DE1290_c==0) | (DE0905_b==maxDE0905_b & DE0905_c==0) | (FR0581_b==maxFR0581_b & FR0581_c==0) | ///
(FR0588_b==maxFR0588_b & FR0588_c==0) | (FR0507_b==maxFR0507_b & FR0507_c==0) | (FR0681_b==maxFR0681_b & FR0681_c==0) | ///
(FR0386_b==maxFR0386_b & FR0386_c==0) | (FR0688_b==maxFR0688_b & FR0688_c==0) | (FR0697_b==maxFR0697_b & FR0697_c==0) | ///
(FR0602_b==maxFR0602_b & FR0602_c==0) | (UK0579_b==maxUK0579_b & UK0579_c==0) | (UK0683_b==maxUK0683_b & UK0683_c==0) | ///
(UK0687_b==maxUK0687_b & UK0687_c==0) | (UK0597_b==maxUK0597_b & UK0597_c==0) | (UK0601_b==maxUK0601_b & UK0601_c==0) | ///
(IT0679_b==maxIT0679_b & IT0679_c==0) | (IT0687_b==maxIT0687_b & IT0687_c==0) | (IT0492_b==maxIT0492_b & IT0492_c==0) | ///
(IT0394_b==maxIT0394_b & IT0394_c==0) | (IT0501_b==maxIT0501_b & IT0501_c==0) | (IT0408_b==maxIT0408_b & IT0408_c==0) | ///
(SP0686_b==maxSP0686_b & SP0686_c==0) | (SP1089_b==maxSP1089_b & SP1089_c==0) | (SP0300_b==maxSP0300_b & SP0300_c==0) | ///
(SP0308_b==maxSP0308_b & SP0308_c==0)

*Small countries*
generate smprencpoll=0
replace smprencpoll=1 if ///
(ND0581_b==maxND0581_b & ND0581_c==0) | (ND0586_b==maxND0586_b & ND0586_c==0) | (ND0598_b==maxND0598_b & ND0598_c==0) | ///
(ND0502_b==maxND0502_b & ND0502_c==0) | (ND1106_b==maxND1106_b & ND1106_c==0) | (BE1278_b==maxBE1278_b & BE1278_c==0) | ///
(BE1181_b==maxBE1181_b & BE1181_c==0) | (BE1085_b==maxBE1085_b & BE1085_c==0) | (BE0607_b==maxBE0607_b & BE0607_c==0) | ///
(GR1081_b==maxGR1081_b & GR1081_c==0) | (GR0490_b==maxGR0490_b & GR0490_c==0) | (GR1093_b==maxGR1093_b & GR1093_c==0) | ///
(PT0787_b==maxPT0787_b & PT0787_c==0) | (PT1091_b==maxPT1091_b & PT1091_c==0) | (PT1095_b==maxPT1095_b & PT1095_c==0) | ///
(PT1099_b==maxPT1099_b & PT1099_c==0) | (PT0302_b==maxPT0302_b & PT0302_c==0) | (PT0205_b==maxPT0205_b & PT0205_c==0) | ///
(SW0998_b==maxSW0998_b & SW0998_c==0) | (SW0902_b==maxSW0902_b & SW0902_c==0) | (SW0906_b==maxSW0906_b & SW0906_c==0) | ///
(AU1295_b==maxAU1295_b & AU1295_c==0) | (AU1099_b==maxAU1099_b & AU1099_c==0) | (AU1102_b==maxAU1102_b & AU1102_c==0) | ///
(DK0277_b==maxDK0277_b & DK0277_c==0) | (DK1079_b==maxDK1079_b & DK1079_c==0) | (DK1281_b==maxDK1281_b & DK1281_c==0) | ///
(DK0987_b==maxDK0987_b & DK0987_c==0) | (DK0588_b==maxDK0588_b & DK0588_c==0) | (DK1290_b==maxDK1290_b & DK1290_c==0) | ///
(DK0994_b==maxDK0994_b & DK0994_c==0) | (DK0398_b==maxDK0398_b & DK0398_c==0) | (FN0395_b==maxFN0395_b & FN0395_c==0) | ///
(IR0677_b==maxIR0677_b & IR0677_c==0) | (IR0681_b==maxIR0681_b & IR0681_c==0) | (IR0282_b==maxIR0282_b & IR0282_c==0) | ///
(IR0287_b==maxIR0287_b & IR0287_c==0) | (IR0689_b==maxIR0689_b & IR0689_c==0) | (IR1192_b==maxIR1192_b & IR1192_c==0) | ///
(IR0697_b==maxIR0697_b & IR0697_c==0) | (IR0502_b==maxIR0502_b & IR0502_c==0) | (IR0507_b==maxIR0507_b & IR0507_c==0) | ///
(LU0679_b==maxLU0679_b & LU0679_c==0) | (LU0689_b==maxLU0689_b & LU0689_c==0) | (LU0699_b==maxLU0699_b & LU0699_c==0) | ///
(LU0604_b==maxLU0604_b & LU0604_c==0) | (LU0609_b==maxLU0609_b & LU0609_c==0) | (PL1007_b==maxPL1007_b & PL1007_c==0) | ///
(SK0606_b==maxSK0606_b & SK0606_c==0) | (LT1004_b==maxLT1004_b & LT1004_c==0) | (SV1004_b==maxSV1004_b & SV1004_c==0) | ///
(ES0307_b==maxES0307_b & ES0307_c==0) | (BU0709_b==maxBU0709_b & BU0709_c==0)


drop DE0965_a-maxBU0709_d




***********************************
**Generate year and month dummies**
***********************************

**Generate year dummy variables**
forvalues x = 1965/2009 {
	gen y`x' = 0
	replace y`x' = 1 if adt_bcommission_1 >= d(01.01.`x') & adt_bcommission_1 <= d(31.12.`x')
}
//

generate year1976_06=.
forvalues x = 1976/2006 {
	replace year1976_06=1 if y`x' == 1
}
//

//For regression with economic variables, need to drop 1976-1981 as data not available
generate year1981_06=.
forvalues x = 1981/2006 {
	replace year1981_06=1 if y`x' == 1
}
//

gen year=year(dexit)

**Generate August dummy**

forvalues x = 1965/2008 {
	local y=date("8-1-`x'", "MDY")
	local z=date("8-31-`x'", "MDY")
	stsplit Aug1`x', at("`y'")
	stsplit Aug31`x', at("`z'")
	egen maxAug1`x'=max(Aug1`x')
	
}
//

generate Aug=0
replace Aug=1 if ///
(Aug11965==maxAug11965 & Aug311965==0) | (Aug11966==maxAug11966 & Aug311966==0) | ///
(Aug11967==maxAug11967 & Aug311967==0) | (Aug11968==maxAug11968 & Aug311968==0) | (Aug11969==maxAug11969 & Aug311969==0) | ///
(Aug11970==maxAug11970 & Aug311970==0) | (Aug11971==maxAug11971 & Aug311971==0) | (Aug11972==maxAug11972 & Aug311972==0) | ///
(Aug11973==maxAug11973 & Aug311973==0) | (Aug11974==maxAug11974 & Aug311974==0) | (Aug11975==maxAug11975 & Aug311975==0) | ///
(Aug11976==maxAug11976 & Aug311976==0) | (Aug11977==maxAug11977 & Aug311977==0) | (Aug11978==maxAug11978 & Aug311978==0) | ///
(Aug11979==maxAug11979 & Aug311979==0) | (Aug11980==maxAug11980 & Aug311980==0) | (Aug11981==maxAug11981 & Aug311981==0) | ///
(Aug11982==maxAug11982 & Aug311982==0) | (Aug11983==maxAug11983 & Aug311983==0) | (Aug11984==maxAug11984 & Aug311984==0) | ///
(Aug11985==maxAug11985 & Aug311985==0) | (Aug11986==maxAug11986 & Aug311986==0) | (Aug11987==maxAug11987 & Aug311987==0) | ///
(Aug11988==maxAug11988 & Aug311988==0) | (Aug11989==maxAug11989 & Aug311989==0) | (Aug11990==maxAug11990 & Aug311990==0) | ///
(Aug11991==maxAug11991 & Aug311991==0) | (Aug11992==maxAug11992 & Aug311992==0) | (Aug11993==maxAug11993 & Aug311993==0) | ///
(Aug11994==maxAug11994 & Aug311994==0) | (Aug11995==maxAug11995 & Aug311995==0) | (Aug11996==maxAug11996 & Aug311996==0) | ///
(Aug11997==maxAug11997 & Aug311997==0) | (Aug11998==maxAug11998 & Aug311998==0) | (Aug11999==maxAug11999 & Aug311999==0) | ///
(Aug12000==maxAug12000 & Aug312000==0) | (Aug12001==maxAug12001 & Aug312001==0) | (Aug12002==maxAug12002 & Aug312002==0) | ///
(Aug12003==maxAug12003 & Aug312003==0) | (Aug12004==maxAug12004 & Aug312004==0) | (Aug12005==maxAug12005 & Aug312005==0) | ///
(Aug12006==maxAug12006 & Aug312006==0) | (Aug12007==maxAug12007 & Aug312007==0) | (Aug12008==maxAug12008 & Aug312008==0) 
///| (Aug12009==maxAug12009 & Aug312009==0)

drop Aug11965-maxAug12008


save "EULO_NATEL.dta", replace




******************************
**Generate country size data**
******************************

**Import country-size data**

clear
import excel using "Demographic_data_Eurostat.xls", cellrange(A10:AB59) firstrow
save "EU_pop.dta", replace

gen year2=year(Year)
order year2, before(Year)
drop Year
rename year2 year
drop if year>2009

save "EU_pop.dta", replace
clear
use "EULO_NATEL.dta"

merge m:1 year using "EU_pop.dta"
sort year
drop if year==1969
drop _merge

save "EULO_NATEL.dta", replace

rename Belgium pop_BE
rename Bulgaria pop_BU	
rename CzechRepublic pop_CZ
rename Denmark pop_DK
rename Germany pop_DE
rename Estonia pop_ES
rename Ireland pop_IR
rename Greece pop_GR
rename Spain pop_SP
rename France pop_FR
rename Italy pop_IT
rename Cyprus pop_CY
rename Latvia pop_LV
rename Lithuania pop_LT
rename Luxembourg pop_LU
rename Hungary pop_HU
rename Malta pop_MA
rename Netherlands pop_ND
rename Austria pop_AU
rename Poland pop_PL
rename Portugal pop_PT
rename Romania pop_RO
rename Slovenia pop_SV
rename Slovakia pop_SK
rename Finland pop_FN
rename Sweden pop_SW
rename UnitedKingdom pop_UK


foreach x of varlist pop_BE-pop_UK {
	gen sc`x' = ln(1+`x'/1000000)

}
//


**Generate country-size-election interaction**
gen tel_size = depret5el60*scpop_DE+frpret5el60*scpop_FR+ukpret5el60*scpop_UK+itpret5el60*scpop_IT+sppret5el60*scpop_SP+ndpret5el60*scpop_ND+bepret5el60*scpop_BE+grpret5el60*scpop_GR+ptpret5el60*scpop_PT+aupret5el60*scpop_AU+dkpret5el60*scpop_DK+fnpret5el60*scpop_FN+lupret5el60*scpop_LU+plpret5el60*scpop_PL+czpret5el60*scpop_CZ+hupret5el60*scpop_HU+lvpret5el60*scpop_LV+cypret5el60*scpop_CY+ropret5el60*scpop_RO
gen ntel_size = deprent5el60*scpop_DE+frprent5el60*scpop_FR+ukprent5el60*scpop_UK+itprent5el60*scpop_IT+spprent5el60*scpop_SP+ndprent5el60*scpop_ND+beprent5el60*scpop_BE+grprent5el60*scpop_GR+ptprent5el60*scpop_PT+swprent5el60*scpop_SW+auprent5el60*scpop_AU+dkprent5el60*scpop_DK+fnprent5el60*scpop_FN+irprent5el60*scpop_IR+luprent5el60*scpop_LU+skprent5el60*scpop_SK+ltprent5el60*scpop_LT+svprent5el60*scpop_SV


drop pop_BE-scpop_UK
save "EULO_NATEL.dta", replace
erase "EU_pop.dta"


*******************************
**Generate voting weigth data**
*******************************

**Import voting weight data**

clear
import excel using "Voting_weights.xls", sheet("Data2") cellrange(A4:AB61) firstrow
save "voting_weights.dta", replace

gen year2=year(Year)
order year2, before(Year)
drop Year
rename year2 year
drop if year>2009

save "voting_weights.dta", replace
clear
use "EULO_NATEL.dta"

merge m:1 year using "voting_weights.dta"
sort year
drop _merge

save "EULO_NATEL.dta", replace

rename Austria vw_AU
rename Belgium vw_BE
rename Bulgaria vw_BU	
rename CzechRepublic vw_CZ
rename Denmark vw_DK
rename Germany vw_DE
rename Estonia vw_ES
rename Ireland vw_IR
rename Greece vw_GR
rename Spain vw_SP
rename France vw_FR
rename Italy vw_IT
rename Cyprus vw_CY
rename Latvia vw_LV
rename Lithuania vw_LT
rename Luxembourg vw_LU
rename Hungary vw_HU
rename Malta vw_MA
rename Netherlands vw_ND
rename Poland vw_PL
rename Portugal vw_PT
rename Romania vw_RO
rename Slovenia vw_SV
rename Slovakia vw_SK
rename Finland vw_FN
rename Sweden vw_SW
rename UnitedKingdom vw_UK


**Adjust for new weights implemented in November 2004 instead of January 2004**
local x=date("01 Nov 2004","DMY")
stsplit accession2004, at("`x'")
egen maxaccession2004=max(accession2004)

replace vw_AU = .0289855072464 if (accession2004==maxaccession2004 & year<2005)
replace vw_BE = .0347826086957 if (accession2004==maxaccession2004 & year<2005)
replace vw_BU = .0289855072464 if (accession2004==maxaccession2004 & year<2005)
replace vw_CY = .0115942028986 if (accession2004==maxaccession2004 & year<2005)
replace vw_CZ = .0347826086957 if (accession2004==maxaccession2004 & year<2005)
replace vw_DK = .0202898550725 if (accession2004==maxaccession2004 & year<2005)
replace vw_ES = .0115942028986 if (accession2004==maxaccession2004 & year<2005)
replace vw_FN = .0202898550725 if (accession2004==maxaccession2004 & year<2005)
replace vw_FR = .0840579710145 if (accession2004==maxaccession2004 & year<2005)
replace vw_DE = .0840579710145 if (accession2004==maxaccession2004 & year<2005)
replace vw_GR = .0347826086957 if (accession2004==maxaccession2004 & year<2005)
replace vw_HU = .0347826086957 if (accession2004==maxaccession2004 & year<2005)
replace vw_IR = .0202898550725 if (accession2004==maxaccession2004 & year<2005)
replace vw_IT = .0840579710145 if (accession2004==maxaccession2004 & year<2005)
replace vw_LV = .0115942028986 if (accession2004==maxaccession2004 & year<2005)
replace vw_LT = .0202898550725 if (accession2004==maxaccession2004 & year<2005)
replace vw_LU = .0115942028986 if (accession2004==maxaccession2004 & year<2005)
replace vw_MA = .0086956521739 if (accession2004==maxaccession2004 & year<2005)
replace vw_ND = .0376811594203 if (accession2004==maxaccession2004 & year<2005)
replace vw_PL = .0782608695652 if (accession2004==maxaccession2004 & year<2005)
replace vw_PT = .0347826086957 if (accession2004==maxaccession2004 & year<2005)
replace vw_RO = .0405797101449 if (accession2004==maxaccession2004 & year<2005)
replace vw_SV = .0115942028986 if (accession2004==maxaccession2004 & year<2005)
replace vw_SK = .0202898550725 if (accession2004==maxaccession2004 & year<2005)
replace vw_SP = .0782608695652 if (accession2004==maxaccession2004 & year<2005)
replace vw_SW = .0289855072464 if (accession2004==maxaccession2004 & year<2005)
replace vw_UK = .0840579710145 if (accession2004==maxaccession2004 & year<2005)


**Generate voting-weight-election interaction**
gen tel_vw1 = depret5el60*vw_DE+frpret5el60*vw_FR+ukpret5el60*vw_UK+itpret5el60*vw_IT+sppret5el60*vw_SP+ndpret5el60*vw_ND+bepret5el60*vw_BE+grpret5el60*vw_GR+ptpret5el60*vw_PT+aupret5el60*vw_AU+dkpret5el60*vw_DK+fnpret5el60*vw_FN+lupret5el60*vw_LU+plpret5el60*vw_PL+czpret5el60*vw_CZ+hupret5el60*vw_HU+lvpret5el60*vw_LV+cypret5el60*vw_CY+ropret5el60*vw_RO
gen ntel_vw1 = deprent5el60*vw_DE+frprent5el60*vw_FR+ukprent5el60*vw_UK+itprent5el60*vw_IT+spprent5el60*vw_SP+ndprent5el60*vw_ND+beprent5el60*vw_BE+grprent5el60*vw_GR+ptprent5el60*vw_PT+swprent5el60*vw_SW+auprent5el60*vw_AU+dkprent5el60*vw_DK+fnprent5el60*vw_FN+irprent5el60*vw_IR+luprent5el60*vw_LU+skprent5el60*vw_SK+ltprent5el60*vw_LT+svprent5el60*vw_SV

gen tel_vw = depret5el60*100*vw_DE+frpret5el60*vw_FR+ukpret5el60*100*vw_UK+itpret5el60*100*vw_IT+sppret5el60*100*vw_SP+ndpret5el60*100*vw_ND+bepret5el60*100*vw_BE+grpret5el60*100*vw_GR+ptpret5el60*100*vw_PT+aupret5el60*100*vw_AU+dkpret5el60*100*vw_DK+fnpret5el60*100*vw_FN+lupret5el60*100*vw_LU+plpret5el60*100*vw_PL+czpret5el60*100*vw_CZ+hupret5el60*100*vw_HU+lvpret5el60*100*vw_LV+cypret5el60*100*vw_CY+ropret5el60*100*vw_RO
gen ntel_vw = deprent5el60*100*vw_DE+frprent5el60*100*vw_FR+ukprent5el60*100*vw_UK+itprent5el60*100*vw_IT+spprent5el60*100*vw_SP+ndprent5el60*100*vw_ND+beprent5el60*100*vw_BE+grprent5el60*100*vw_GR+ptprent5el60*100*vw_PT+swprent5el60*100*vw_SW+auprent5el60*100*vw_AU+dkprent5el60*100*vw_DK+fnprent5el60*100*vw_FN+irprent5el60*100*vw_IR+luprent5el60*100*vw_LU+skprent5el60*100*vw_SK+ltprent5el60*100*vw_LT+svprent5el60*100*vw_SV

drop vw_AU-maxaccession2004
save "EULO_NATEL.dta", replace
erase "voting_weights.dta"


******************************
**Generate economic controls**
******************************

**1. Indicator for recession period**
//Source for original data: http://cepr.org/content/euro-area-business-cycle-dating-committee

local x=date("01 Oct 1974","DMY")
stsplit recess1974s, at("`x'")
local y=date("31 Mar 1975","DMY")
stsplit recess1974e, at("`y'")
egen maxrecess1974s=max(recess1974s)

local x=date("01 Apr 1980","DMY")
stsplit recess1980s, at("`x'")
local y=date("30 Sep 1982","DMY")
stsplit recess1980e, at("`y'")
egen maxrecess1980s=max(recess1980s)

local x=date("01 Apr 1992","DMY")
stsplit recess1992s, at("`x'")
local y=date("30 Sep 1993","DMY")
stsplit recess1992e, at("`y'")
egen maxrecess1992s=max(recess1992s)

local x=date("01 Apr 2008","DMY")
stsplit recess2008s, at("`x'")
local y=date("30 Jun 2009","DMY")
stsplit recess2008e, at("`y'")
egen maxrecess2008s=max(recess2008s)

gen recess=0
replace recess=1 if (recess1974s==maxrecess1974s & recess1974e==0) | (recess1980s==maxrecess1980s & recess1980e==0) | ///
(recess1992s==maxrecess1992s & recess1992e==0) | (recess2008s==maxrecess2008s & recess2008e==0)

drop recess1974s recess1974e maxrecess1974s recess1980s recess1980e maxrecess1980s recess1992s recess1992e maxrecess1992s recess2008s recess2008e maxrecess2008s

save "EULO_NATEL.dta", replace

**2. Value of EU GDP during period**
clear
import excel using "GDP_IMF.xlsx", cellrange(A1:D32) firstrow
save "EU_GDP.dta", replace

drop if year>2009

save "EU_GDP.dta", replace
clear
use "EULO_NATEL.dta"

merge m:1 year using "EU_GDP.dta"
drop unit _merge

save "EULO_NATEL.dta", replace
erase "EU_GDP.dta"

******************************************************
**Generate dummy for commission final year in office**
******************************************************

/// 1967-1970
local z=date("1 Jul 1970", "DMY")
local x=`z'-365
stsplit COM1970_a, at("`x'")
stsplit COM1970_b, at("`z'")
egen maxCOM1970_a=max(COM1970_a)

/// 1970-1972
local z=date("1 Mar 1972", "DMY")
local x=`z'-365
stsplit COM1972_a, at("`x'")
stsplit COM1972_b, at("`z'")
egen maxCOM1972_a=max(COM1972_a)

/// 1972-1973
local z=date("5 Jan 1973", "DMY")
local x=`z'-365
stsplit COM1973_a, at("`x'")
stsplit COM1973_b, at("`z'")
egen maxCOM1973_a=max(COM1973_a)

/// 1973-1977
local z=date("5 Jan 1977", "DMY")
local x=`z'-365
stsplit COM1977_a, at("`x'")
stsplit COM1977_b, at("`z'")
egen maxCOM1977_a=max(COM1977_a)

/// 1977-1981
local z=date("19 Jan 1981", "DMY")
local x=`z'-365
stsplit COM1981_a, at("`x'")
stsplit COM1981_b, at("`z'")
egen maxCOM1981_a=max(COM1981_a)

/// 1981-1985
local z=date("6 Jan 1985", "DMY")
local x=`z'-365
stsplit COM1985_a, at("`x'")
stsplit COM1985_b, at("`z'")
egen maxCOM1985_a=max(COM1985_a)

/// 1985-1995
local z=date("24 Jan 1995", "DMY")
local x=`z'-365
stsplit COM1995_a, at("`x'")
stsplit COM1995_b, at("`z'")
egen maxCOM1995_a=max(COM1995_a)

/// 1995-1999
local z=date("15 Mar 1999", "DMY")
local x=`z'-365
stsplit COM1999_a, at("`x'")
stsplit COM1999_b, at("`z'")
egen maxCOM1999_a=max(COM1999_a)

/// 1999-2004
local z=date("22 Nov 2004", "DMY")
local x=`z'-365
stsplit COM2004_a, at("`x'")
stsplit COM2004_b, at("`z'")
egen maxCOM2004_a=max(COM2004_a)

generate comfin=0
replace comfin=1 if ///
(COM1970_a==maxCOM1970_a & COM1970_b==0) | (COM1972_a==maxCOM1972_a & COM1972_b==0) | (COM1973_a==maxCOM1973_a & COM1973_b==0) | ///
(COM1977_a==maxCOM1977_a & COM1977_b==0) | (COM1981_a==maxCOM1981_a & COM1981_b==0) | (COM1985_a==maxCOM1985_a & COM1985_b==0) | ///
(COM1995_a==maxCOM1995_a & COM1995_b==0) | (COM1999_a==maxCOM1999_a & COM1999_b==0) | (COM2004_a==maxCOM2004_a & COM2004_b==0)

drop COM1970_a-maxCOM2004_a

save "EULO_NATEL.dta", replace



****************************
**Rescale backlog variable**
****************************

generate backlog100=backlog/100



************************************
** Prepare dataset for regression **
************************************


**Reset timing**
stset _t, origin(_t0) failure(_d) id(case_id)
save "EULO_NATEL.dta", replace


************************
** Summary statistics **
************************

**Duration statistics**
gen duration=finaladoption-adt_bcommission_1
*All*
sum duration if (dexit==finaladoption & year1976_06==1 & _st==1), detail
*Directives*
sum duration if (dexit==finaladoption & year1976_06==1 & _st==1 & directive==1), detail
*Regulation*
sum duration if (dexit==finaladoption & year1976_06==1 & _st==1 & regulation==1), detail
*Decision*
sum duration if (dexit==finaladoption & year1976_06==1 & _st==1 & decision==1), detail

**Number of episodes**
sum _st if (year1976_06==1 & _st==1)
sum _st if (year1976_06==1 & _st==1 & (lgpret5el60==1 | smpret5el60==1 | lgprent5el60==1 | smprent5el60==1))
sum _st if (year1976_06==1 & _st==1 & lgpret5el60==1)
sum _st if (year1976_06==1 & _st==1 & smpret5el60==1)
sum _st if (year1976_06==1 & _st==1 & lgprent5el60==1)
sum _st if (year1976_06==1 & _st==1 & smprent5el60==1)

save "EULO_NATEL.dta", replace


