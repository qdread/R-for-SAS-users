/* SAS code for "R for SAS users" lesson 
   Eventually snippets of this code will be included in the Rmd using SASmarkdown. 
   This file is for testing code. */

filename csvFile url "https://github.com/qdread/R-for-SAS-users/raw/main/data/NASS_soybean.csv";
proc import datafile=csvFile out=nass_soybeans replace dbms=csv; guessingrows=2000; run;

proc contents data = nass_soybeans; run;
proc print data = nass_soybeans(obs = 10); run;

data se_soybeans; set nass_soybeans;
	where state in ('Alabama', 'Arkansas', 'Florida', 'Georgia', 'Louisiana', 'Mississippi', 'North Carolina', 'South Carolina', 'Tennessee');
run;

data se_soybeans; set se_soybeans;
	total_yield = acres * yield;
run;

proc sort data = se_soybeans;
	by year state;
run;

proc transpose data = se_soybeans out = total_yield_wide;
	by year; id state; var total_yield;
run;

proc transpose data = total_yield_wide out = total_yield_long;
	by year;
run;

/* exploratory plots: time series of four states on a single panel and on different panels */
proc sgplot data=se_soybeans;
	where state in ('Arkansas', 'Tennessee', 'North Carolina', 'Georgia');
	series x=year y=total_yield / group=state; 
	yaxis type=log label='total yield (bu)';
run;

proc sgpanel data=se_soybeans;
	where state in ('Arkansas', 'Tennessee', 'North Carolina', 'Georgia');
	panelby state;
	series x=year y=total_yield;
	rowaxis type=log label='total yield (bu)';
run;

/* summary stats */

proc sql;
	select 
		year,
		sum(acres) as grand_total_acres,
		sum(total_yield) as grand_total_yield,
		sum(yield * acres) / sum(acres) as mean_yield
	from se_soybeans
	where mod(year, 10) = 0
	group by year;
quit;

/* linear model */
proc reg data = se_soybeans;
	model total_yield = year;
run;	

data se_soybeans; set se_soybeans;
	log_total_yield = log(total_yield);
run;

proc reg data = se_soybeans;
	model log_total_yield = year;
run;	

/* mixed model */
proc mixed data = se_soybeans plots = residualpanel;
	class state;
	model log_total_yield = year / solution;
	random state;
run;

proc glimmix data = se_soybeans plots = residualpanel;
	class state;
	model log_total_yield = year / solution;
	random intercept / subject = state;
	random year / type=ar(1) subject = state;
run;

/* GAM model */

/* Bayesian mixed model */
proc bglimm data=se_soybeans;

