*Analyses from "Coercive or Corrosive: The Negative Impact of Economic Sanctions on Democracy." Dursun Peksen and Cooper Drury. International Interactions.
*Note: For purposes of replication, be sure to use the current version of xtfevd available at http://www.polsci.org/pluemper/ssc.html. It is also available from the second author on request.

*Table 1 Column 1
xtfevd rfhrate lrfhrate lsanctionmerge lgdppclog  lgdpgrowth lfdi lpoplog lpricwar loil arab if polity2<6, invariant(arab)

*Table 1 Column 2
xtfevd drfhrate dsanctionmerge dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab if polity2<6, invariant(arab)

*Table 1 Column 3
xtfevd rfhrate lrfhrate lextensivemerge llimitedmerge lgdppclog  lgdpgrowth lfdi lpoplog lpricwar loil arab if polity2<6, invariant(arab)

*Table 1 Column 4
xtfevd drfhrate dextensivemerge dlimitedmerge dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab if polity2<6, invariant(arab)


*Table 2 Column 1
xtfevd rfhrate lrfhrate lnsanc_dur lgdppclog  lgdpgrowth lfdi lpoplog lpricwar loil arab if polity2<6, invariant(arab)

*Table 2 Column 2
xtfevd drfhrate dlnsanc_dur dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab if polity2<6, invariant(arab)

*Table 2 Column 3
xtfevd rfhrate lrfhrate lnextsanc_dur lnlimsanc_dur lgdppclog  lgdpgrowth lfdi lpoplog lpricwar loil arab if polity2<6, invariant(arab)

*Table 2 Column 4
xtfevd drfhrate dlnextsanc_dur dlnlimsanc_dur dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab if polity2<6, invariant(arab)


*Appendix I Column 1
xtfevd drfhrate dsanctionmerge dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab, invariant(arab)

*Appendix I Column 2
xtfevd drfhrate dextensivemerge dlimitedmerge dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab, invariant(arab)

*Appendix I Column 3
xtfevd drfhrate dlnsanc_dur dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab, invariant(arab)

*Appendix I Column 4
xtfevd drfhrate dlnextsanc_dur dlnlimsanc_dur dgdppclog  dgdpgrowth dfdi dpoplog dpricwar doil arab, invariant(arab)


*Simultaneous Model (see page 254)
*Estimate unit-specific effects
xtreg rfhrate lrfhrate lsanctionmerge lgdppclog lgdpgrowth lfdi lpoplog lpricwar loil arab if polity2<6, fe
*Generate unit-specific error
predict u, u
*Estimate portion of unit-specific error caused by time-invariant variables
reg u arab if polity2<6
*Generate residuals (portion unexplained by time-invarient variables)
predict eta_dem, resid
drop u
*Generate sanction past polynomials
btscs sanctionmerge year ccode, g(timepast)
gen timepast2=timepast^2
gen timepast3=timepast^3
*Simultaneous Model
cdsimeq (rfhrate lrfhrate lgdppclog lgdpgrowth lfdi lpoplog lpricwar loil arab eta_dem) (sanctionmerge lgdppclog lgdpgrowth lfdi lpoplog lpricwar timepast timepast2 timepast3) if polity2<6
