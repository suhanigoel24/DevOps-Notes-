
Okay so prometheus.yml file is already present when we install prometheus onto our server, now what we do is we can add a static config under scrape_configs in order to add a application or we can say an endpoint that the prometheus can pull the metrics from. 

we can build this config file ourselves as well, which we usually do in our paytm system. Rather than building the file we mostly add the static configs and all the necessary thingies in it.

So, talking about rules, rules kind of help us to precompute the queries and then save it again in the form of metrics. Rather than calculating a rule again and again we save them in the form of a query which help us to do the computation and everything at a much faster rate. So in the the prometheus.rules.yaml file, we define the promQL expression which calculates and display the metrics according to that and then we give them a name for easy access.

Lemme try and write a rules.yaml file:

```
groups:
	-name: cst_alerts
	 rules:
	 
	 -alerts: alertname
	  expr:
	  for:
	  labels:
		  priority:
		  severity:
		  team:
		  app:
```

While we are at it let us also discuss the basic structure if prometheus.yml file:

```
global: When and at what time interval the scrape should happen

alerting: links the prometheus.yml to the alert files where the alerts are written

rule_files: here the rules for the alerts are written

scrape_configs: Tells prometheus where it should scrape from, targets that need to be scraped to get the metrics
```

alertmanager.yml file:

```
- `global`: Default settings
    
- `route`: Traffic police for alerts
    
- `receivers`: The destinations
    
- `inhibit_rules`: Suppress noisy duplicates
    
- `templates`: Custom formatting for alerts

```