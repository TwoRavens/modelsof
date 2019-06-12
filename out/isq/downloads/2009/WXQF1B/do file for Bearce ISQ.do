*these models originally estimated using Stata8*
*Table 1, model 1.1*
xtpcse ExchangeRateVar ExchangeRateVar_1 dejurefix cbi dejurefixXcbi growth inflation_rate inflation_vol long_term_i K_openness net_exports GDP_per_cap GDP_logged iyear_75-iyear_97
lincom dejurefix + (0*dejurefixXcbi)
lincom dejurefix + (.1*dejurefixXcbi)
lincom dejurefix + (.2*dejurefixXcbi)
lincom dejurefix + (.3*dejurefixXcbi)
lincom dejurefix + (.4*dejurefixXcbi)
lincom dejurefix + (.5*dejurefixXcbi)
lincom dejurefix + (.6*dejurefixXcbi)
lincom dejurefix + (.7*dejurefixXcbi)
lincom dejurefix + (.8*dejurefixXcbi)
lincom dejurefix + (.9*dejurefixXcbi)
lincom dejurefix + (1.0*dejurefixXcbi)
*these lincom commands were used to create Figure 1*
*Table 1, model 1.2*
xtpcse ExchangeRateVar ExchangeRateVar_1 dejurefix cbi_composite dejurefixXcbi_composite growth inflation_rate inflation_vol long_term_i K_openness net_exports GDP_per_cap GDP_logged iyear_75-iyear_97
*Table 1, model 1.3*
xtpcse ExchangeRateVar ExchangeRateVar_1 EMS Snake Unipeg cbi EMSXcbi SnakeXcbi UnipegXcbi growth inflation_rate inflation_vol long_term_i K_openness net_exports GDP_per_cap GDP_logged iyear_75-iyear_97
*Table 2, model 2.1*
oprobit defactofixityRRcoarse defactofixityRRcoarse_1 dejurefix cbi dejurefixXcbi growth inflation_rate inflation_vol long_term_i K_openness net_exports GDP_per_cap GDP_logged iyear_75-iyear_97
lincom dejurefix + (0*dejurefixXcbi)
lincom dejurefix + (.1*dejurefixXcbi)
lincom dejurefix + (.2*dejurefixXcbi)
lincom dejurefix + (.3*dejurefixXcbi)
lincom dejurefix + (.4*dejurefixXcbi)
lincom dejurefix + (.5*dejurefixXcbi)
lincom dejurefix + (.6*dejurefixXcbi)
lincom dejurefix + (.7*dejurefixXcbi)
lincom dejurefix + (.8*dejurefixXcbi)
lincom dejurefix + (.9*dejurefixXcbi)
lincom dejurefix + (1.0*dejurefixXcbi)
*these lincom commands were used to create Figure 2*
*Table 2, model 2.2*
oprobit defactofixityRRfine defactofixityRRfine_1 dejurefix cbi dejurefixXcbi growth inflation_rate inflation_vol long_term_i K_openness net_exports GDP_per_cap GDP_logged iyear_75-iyear_97
lincom dejurefix + (0*dejurefixXcbi)
lincom dejurefix + (.1*dejurefixXcbi)
lincom dejurefix + (.2*dejurefixXcbi)
lincom dejurefix + (.3*dejurefixXcbi)
lincom dejurefix + (.4*dejurefixXcbi)
lincom dejurefix + (.5*dejurefixXcbi)
lincom dejurefix + (.6*dejurefixXcbi)
lincom dejurefix + (.7*dejurefixXcbi)
lincom dejurefix + (.8*dejurefixXcbi)
lincom dejurefix + (.9*dejurefixXcbi)
lincom dejurefix + (1.0*dejurefixXcbi)
*these lincom commands were used to create Figure 2*
*Table 2, model 2.3*
oprobit defactofixityLYS defactofixityLYS_1 dejurefix cbi dejurefixXcbi growth inflation_rate inflation_vol long_term_i K_openness net_exports GDP_per_cap GDP_logged iyear_75-iyear_97
lincom dejurefix + (0*dejurefixXcbi)
lincom dejurefix + (.1*dejurefixXcbi)
lincom dejurefix + (.2*dejurefixXcbi)
lincom dejurefix + (.3*dejurefixXcbi)
lincom dejurefix + (.4*dejurefixXcbi)
lincom dejurefix + (.5*dejurefixXcbi)
lincom dejurefix + (.6*dejurefixXcbi)
lincom dejurefix + (.7*dejurefixXcbi)
lincom dejurefix + (.8*dejurefixXcbi)
lincom dejurefix + (.9*dejurefixXcbi)
lincom dejurefix + (1.0*dejurefixXcbi)
*these lincom commands were used to create Figure 2*
*Table 2, model 2.4*
oprobit defactofixityLYS defactofixityLYS_1 dejurefix cbi dejurefixXcbi growth inflation_rate inflation_vol K_openness net_exports GDP_logged iyear_75-iyear_97
