codebook abbrev ccode country ussd03 airape03 MilSize2001b pop geo ef civilconflict civilwar corruption TIcorruption gnipcT3 polity4 DemocHigh CGDhigh CGDlow accessD

*Table I:
corr ussd03 MilSize2001b pop geo ef civilconflict civilwar corruption gnipcT3 polity4 DemocHigh

*Table II:
oprobit ussd03 MilSize2001b ef civilconflict civilwar CGD*

*Table III, Model 2:
oprobit ussd03 MilSize2001b ef civilconflict civilwar

*Table III, Model 3:
oprobit ussd03 MilSize2001b ef civilconflict civilwar corruption

*Table III, Model 4:
oprobit ussd03 MilSize2001b ef civilconflict civilwar gnipcT3

*Table III, Model 5:
oprobit ussd03 MilSize2001b ef civilconflict civilwar polity4

*Table III, Model 6:
oprobit ussd03 MilSize2001b ef civilconflict civilwar DemocHigh

*Table AII:
tabstat corruption ussd03, by(country) stats(mean)

*Table AIII, Model A1:
oprobit ussd03 MilSize2001b ef civilconflict civilwar corruption gnipcT3 polity4

*Table AIII, Model A2:
oprobit ussd03 MilSize2001b ef civilconflict civilwar corruption gnipcT3 DemocHigh

*Table AIII, Model A3:
oprobit ussd03 MilSize2001b ef civilconflict civilwar corruption gnipcT3

*Table AIII, Model A4:
oprobit ussd03 MilSize2001b ef civilconflict civilwar corruption polity4

*Table AIII, Model A5:
oprobit ussd03 MilSize2001b ef civilconflict civilwar corruption DemocHigh

*ICRC Access assessment, note 8:
tab accessD ussd03
tabi 19 20 \ 91 31, col chi2
