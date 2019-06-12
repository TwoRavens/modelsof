clear

use "extra credit_replication data.dta", clear


**** TABLE 1: All Countries

*** Baseline Model
xtabond2 sp L.sp wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade, ivstyle(wto) robust gmmstyle(L3.sp L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade trade),laglimits(0 5) collapse) twostep artests(3)
xtabond2 moody L.moody wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade, ivstyle(wto) robust gmmstyle(L3.moody L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade trade),laglimits(0 5) collapse) twostep artests(3)
xtabond2 fitch L.fitch wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade, ivstyle(wto) robust gmmstyle(L3.fitch L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade trade),laglimits(0 5) collapse) twostep artests(3)

***Expanded Model

xtabond2 sp L.sp wto polity2 polconiii govfrac right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres, ivstyle(wto polity2 polconiii govfrac) robust gmmstyle(L3.sp L.(right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres),laglimits(0 5) collapse) twostep artests(3)
xtabond2 moody L.moody wto polity2 polconiii govfrac right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres,ivstyle(wto polity2 polconiii govfrac) robust gmmstyle(L3.moody L.(right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres),laglimits(0 5) collapse) twostep artests(3)
xtabond2 fitch L.fitch wto polity2 polconiii govfrac right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres, ivstyle(wto polity2 polconiii govfrac) robust gmmstyle(L3.fitch L.(right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres),laglimits(0 5) collapse) twostep artests(3)


****  TABLE 2: Developing Countries

*** Baseline Model

xtabond2 sp L.sp wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade if oecd==0, ivstyle(wto) robust gmmstyle(L3.sp L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade trade),laglimits(0 5) collapse) twostep artest(3)
xtabond2 moody L.moody wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade if oecd==0, ivstyle(wto) robust gmmstyle(L3.moody L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade trade),laglimits(0 5) collapse) twostep artest(3)
xtabond2 fitch L.fitch wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade if oecd==0, ivstyle(wto) robust gmmstyle(L3.fitch L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade trade),laglimits(0 5) collapse) twostep artest(3)

*** Expanded Model

xtabond2 sp L.sp wto polity2 polconiii govfrac right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres if oecd==0, ivstyle(wto polity2 polconiii govfrac) robust gmmstyle(L3.sp L.(right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres),laglimits(0 5) collapse) twostep artest(3)
xtabond2 moody L.moody wto polity2 polconiii govfrac right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres if oecd==0,ivstyle(wto polity2 polconiii govfrac) robust gmmstyle(L3.moody L.(right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres),laglimits(0 5) collapse) twostep artest(3)
xtabond2 fitch L.fitch wto polity2 polconiii govfrac right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres if oecd==0, ivstyle(wto polity2 polconiii govfrac) robust gmmstyle(L3.fitch L.(right icrglaw default curracnt inflation lpgdppc gdppcgrowth ptatrade trade lgovtdebt forres),laglimits(0 5) collapse) twostep artest(3)


**** TABLE 3: Overall Trade Omitted

*** All Countries

xtabond2 sp L.sp wto default curracnt inflation lpgdppc gdppcgrowth ptatrade , ivstyle(wto) robust gmmstyle(L3.sp L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep artest(3)
xtabond2 moody L.moody wto default curracnt inflation lpgdppc gdppcgrowth ptatrade , ivstyle(wto) robust gmmstyle(L3.moody L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep artest(3)
xtabond2 fitch L.fitch wto default curracnt inflation lpgdppc gdppcgrowth ptatrade, ivstyle(wto) robust gmmstyle(L3.fitch L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep artest(3)

*** Developing Countries

xtabond2 sp L.sp wto default curracnt inflation lpgdppc gdppcgrowth ptatrade if oecd==0, ivstyle(wto) robust gmmstyle(L3.sp L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep artest(3)
xtabond2 moody L.moody wto default curracnt inflation lpgdppc gdppcgrowth ptatrade if oecd==0, ivstyle(wto) robust gmmstyle(L3.moody L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep artest(3)
xtabond2 fitch L.fitch wto default curracnt inflation lpgdppc gdppcgrowth ptatrade if oecd==0, ivstyle(wto) robust gmmstyle(L3.fitch L.(default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep artest(3)


**** TABLE 4: Including PTA Trade Volatility

*** All Countries

xtabond2 sp L.sp wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade fvol , ivstyle(wto fvol) robust gmmstyle(L3.sp L.( default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep 
xtabond2 moody L.moody wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade fvol , ivstyle(wto fvol) robust gmmstyle(L3.moody L.( default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep 
xtabond2 fitch L.fitch wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade fvol , ivstyle(wto fvol) robust gmmstyle(L3.fitch L.( default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse ) twostep 

*** Developing Countries

xtabond2 sp L.sp wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade fvol if oecd==0, ivstyle(wto fvol) robust gmmstyle(L3.sp L.( default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep 
xtabond2 moody L.moody wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade fvol if oecd==0, ivstyle(wto fvol) robust gmmstyle(L3.moody L.( default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep 
xtabond2 fitch L.fitch wto default curracnt inflation lpgdppc gdppcgrowth ptatrade trade fvol if oecd==0, ivstyle(wto fvol) robust gmmstyle(L3.fitch L.( default curracnt inflation lpgdppc gdppcgrowth ptatrade ),laglimits(0 5) collapse) twostep 

