filename csvFile url "https://github.com/qdread/R-for-SAS-users/raw/main/data/Edwards_oats.csv";
proc import datafile = csvFile out = oats replace dbms = csv; run;

data oats_subset; set oats;
	where year = 2001 & gen in ('Belle', 'Blaze', 'Brawn', 'Chaps');
run;

proc sql;
	select 
		gen,
		avg(yield) as mean_yield,
		std(yield) as stdev_yield
	from oats_subset
	group by gen;
quit;

proc sgplot data = oats_subset;
	vbox yield / group = gen;
run;

proc glm data = oats_subset plots(unpack) = diagnostics;
	class gen;
	model yield = gen;
run;	

proc glm data = oats_subset plots(unpack) = diagnostics;
	class gen loc;
	model yield = gen loc gen*loc;
run;	
