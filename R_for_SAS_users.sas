/* R for SAS users: complete SAS code from lesson
   Quentin Read 2022-01-31                         */
   
/* Import data from URL */

filename csvFile url "https://github.com/qdread/R-for-SAS-users/raw/main/data/NASS_soybean.csv";
proc import datafile = csvFile out = nass_soybeans replace dbms = csv; guessingrows = 2000; run;

/* Examine data */

proc print data = nass_soybeans(obs = 10); run;

ods select variables;
proc contents data = nass_soybeans; run;
ods select default;

/* Subset data */

data se_soybeans; set nass_soybeans;
	where state in ('Alabama', 'Arkansas', 'Florida', 'Georgia', 'Louisiana', 'Mississippi', 'North Carolina', 'South Carolina', 'Tennessee');
run;

/* Calculate a new column */

data se_soybeans; set se_soybeans;
	total_yield = acres * yield;
run;

data se_soybeans; set nass_soybeans;
  where state in ('Alabama', 'Arkansas', 'Florida', 'Georgia', 'Louisiana', 'Mississippi', 'North Carolina', 'South Carolina', 'Tennessee');
	total_yield = acres * yield;
run;

/* Sort data */

proc sort data = se_soybeans;
	by year state;
run;

/* Reshape data */

proc transpose data = se_soybeans out = total_yield_wide;
	by year; id state; var total_yield;
run;

proc transpose data = total_yield_wide out = total_yield_long;
	by year;
run;

/* Exploratory plots: single panel and multi-panel */

proc sgplot data = se_soybeans;
	where state in ('Arkansas', 'Tennessee', 'North Carolina', 'Georgia');
	series x = year y = yield / group = state; 
	yaxis label='yield (bu/ac)';
run;

proc sgpanel data=se_soybeans;
	where state in ('Arkansas', 'Tennessee', 'North Carolina', 'Georgia');
	panelby state;
	series x = year y = yield;
	rowaxis label = 'yield (bu/ac)';
run;

/* Table of summary statistics */

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

/* Simple linear regression */

proc reg data = se_soybeans;
	model yield = year;
run;

/* Linear mixed model with repeated measures error structure */

proc glimmix data = se_soybeans plots = residualpanel;
	class state;
	model yield = year / solution;
	random intercept / subject = state;
	random year / type = ar(1) subject = state;
run;

/* Code for exercises */

/* Exercise 1 */
filename csvFile url "https://github.com/qdread/R-for-SAS-users/raw/main/data/Edwards_oats.csv";
proc import datafile = csvFile out = oats replace dbms = csv; run;

/* Exercise 2 */
data oats_subset; set oats;
	where year = 2001 & gen in ('Belle', 'Blaze', 'Brawn', 'Chaps');
run;

/* Exercise 3 */
proc sql;
	select 
		gen,
		avg(yield) as mean_yield,
		std(yield) as stdev_yield
	from oats_subset
	group by gen;
quit;

/* Exercise 4 */
proc sgplot data = oats_subset;
	vbox yield / group = gen;
run;

/* Exercise 5 */
proc glm data = oats_subset plots(unpack) = diagnostics;
	class gen;
	model yield = gen;
run;	

/* Exercise 6 */
proc glm data = oats_subset plots(unpack) = diagnostics;
	class gen loc;
	model yield = gen loc gen*loc;
run;	
