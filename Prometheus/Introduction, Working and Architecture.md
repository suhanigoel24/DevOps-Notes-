## INTRODUCTION
Prometheus is an **open-source monitoring tool** that:

- 📥 **Collects (scrapes)** metrics from apps/servers.
    
- 🗄️ **Stores** them in a time-series database.
    
- 🔎 Lets you **query & visualize** data (often with Grafana).
    
- 🚨 Works with **Alertmanager** to send alerts when issues happen.

 In short: **Prometheus = Collect + Store + Monitor + Alert.**
 
 **How it works**

1. **Pull-based model** → Prometheus **scrapes (pulls)** metrics from targets (apps, services, nodes) at regular intervals.
    
    - Applications expose metrics at an HTTP endpoint (like `/metrics`).
        
    - Prometheus collects them periodically.
        
2. **Stores data locally** in its own time-series database.
    
3. **Alertmanager** integrates with Prometheus to send alerts via email, Slack, PagerDuty, etc.
 
 
 **What are Metrics?**

- Metrics = **numeric measurements** that describe the **state, performance, or behavior** of a system.
    
- Think of them like a system’s **vital signs** (CPU, memory, requests, errors, etc.).
    
- Collected regularly over time to monitor **trends, performance, and health**.

**Why are Metrics Important?**

- Help detect issues early (e.g., CPU too high).
    
- Allow capacity planning (e.g., memory trend growing fast).
    
- Provide insights for debugging and optimization.
    
- Enable automated alerts when something goes wrong.


**It collects metrics by scraping the HTTP endpoints of the targets which are configured(bare metal servers, db instance, kubernetes cluster, an application exposing metrics etc). Along with Alertmanager, prometheus works as a monitoring and alerting tool.**

## PROMETHEUS WORKING AND ARCHITECTURE

**1. "Prometheus collects metrics from the configured targets at a given time interval"**

- Targets = Things you want to monitor (apps, servers, containers, databases).
    
- Each target provides numbers (metrics) through an endpoint (usually `/metrics`).
    
- Prometheus doesn’t wait for targets to push data. Instead, it **pulls (scrapes)** data every X seconds (e.g., every 15s).  
    👉 Example:
    
    - Your Node Exporter target says:
        
        - CPU usage: 40%
            
        - Memory used: 2GB
            
    - Prometheus will come every 15s, ask “Hey, what’s your CPU/memory now?”, and write it down.

**2. "Stores them in a local/configured time-series database"**

- Prometheus saves data in its own **time-series database (TSDB)**.
    
- Time-series means: every metric is stored with **a timestamp**.  
    👉 Example:
    
    - At 10:00 → CPU = 40%
        
    - At 10:15 → CPU = 45%
        
    - At 10:30 → CPU = 70%
        
- This way you can **see trends** over time, not just the latest value.

**3. "Evaluates rule expressions"**

- Prometheus has a query language (**PromQL**) where you can write rules.
    
- Rules are like formulas or conditions to check.  
    👉 Example:
    
    - Rule: If CPU > 80% for 5 minutes → that’s too high.
        
    - Rule: If website errors > 1% → something’s broken.

Prometheus keeps evaluating these rules in the background.

**4. "Displays the result"**

- Prometheus has a simple web UI where you can run queries and see results.
    
- Most people connect Prometheus to **Grafana**, which makes beautiful dashboards and graphs.  
    👉 Example:
    
- A graph showing CPU usage slowly rising from 20% to 90%.
    
- A panel showing number of requests per second.

**5. "Can trigger an alert if some conditions evaluate to true"**

- If a rule condition is true (e.g., CPU > 80% for 5 minutes), Prometheus triggers an **alert**.
    
- The alert is sent to **Alertmanager**, which decides where to send it (Slack, Email, PagerDuty, etc.).  


![[Screenshot 2025-09-15 at 5.09.52 PM.png]]

### 1. **Prometheus Server**

- This is the **heart/brain** of Prometheus.
    
- Its main job:
    
    1. **Scrape** (collect) metrics from targets at regular intervals.
        
    2. **Store** those metrics in its time-series database (with timestamps).
        
    3. **Do calculations** on metrics (for example, compute average CPU usage).
        
    4. **Generate new metrics** from old ones (like converting request count into request rate).
    
👉 Think of the Prometheus server as a **data collector + calculator + storage box**.
### 2. **Service Discovery (SD)**

- In cloud environments (like AWS, Kubernetes, Azure), servers and containers are **constantly changing** (new ones created, old ones deleted).
    
- Hardcoding target details in `prometheus.yml` doesn’t work well here.
    
- **Service Discovery** solves this:
    
    - Prometheus can **talk to APIs** of platforms like **Kubernetes, AWS EC2, Azure, GCP**.
        
    - These APIs give Prometheus the **latest list of targets** to monitor.
    
👉 Imagine you’re a delivery person. Instead of asking every house for its address daily, you connect to the city’s official database that always has the updated addresses.
### 3. **Push Gateway**

- Normally, Prometheus **pulls** metrics.
    
- But what if the job is very short-lived? (e.g., a batch job that runs for just 10 seconds) → Prometheus might miss it.
    
- Solution: **Push Gateway**.
    
    - Short-lived jobs **push** their metrics to the Push Gateway.
        
    - Prometheus then **pulls metrics from Push Gateway** instead of directly from the job.

👉 Think of it like this: If you want to leave a message for someone but they may not be home, you leave it with the **security guard (Push Gateway)**. The person (Prometheus) can then pick it up from the guard later.
### 4. **Client Libraries**

- Sometimes, you don’t just want system metrics (CPU, RAM, disk). You want **custom metrics from your application**.
    
- Example:
    
    - How many users signed up?
        
    - How long API requests take?
        
- To do this, you add **instrumentation code** inside your app using **Prometheus client libraries**.
    
- Supported in languages like **Go, Java, Python, Ruby**, plus many others through third-party libraries.

👉 Think of client libraries as **tiny sensors** you add inside your app to measure things specific to your business.
### 5. **Exporters**

- Some systems (like Linux kernel, MySQL, Windows, HAProxy) cannot be directly modified to expose Prometheus metrics.
    
- Exporters act as **translators**:
    
    - They take existing system metrics.
        
    - Convert them into **Prometheus format**.
        
    - Expose them via HTTP for Prometheus to scrape.
        

👉 Example exporters:

- **Node Exporter** → Linux system metrics (CPU, RAM, disk).
    
- **Windows Exporter** → Windows system metrics.
    
- **MySQL Exporter** → Database metrics.

👉 Think of exporters as **reporters** who interview the system and then translate answers into a language Prometheus understands.
### 6. **AlertManager**

- Prometheus server detects problems based on **alerting rules** (like CPU > 90% for 5 minutes).
    
- When conditions are true, Prometheus sends the alert to **AlertManager**.
    
- **AlertManager decides what to do**:
    
    - Send notification to Slack, Email, PagerDuty, etc.
        
    - Group similar alerts together.
        
    - Silence alerts during maintenance.
        

👉 Think of AlertManager as a **control room operator**: Prometheus detects the fire, but AlertManager decides whom to call — the fire department, the hospital, or just send a warning.

### 7. **Web UI & Visualization**

- Prometheus comes with a **built-in web UI** called **Expression Browser**.
    
    - You can write PromQL queries and see results as tables or simple graphs.
        
    - Great for **debugging and ad-hoc queries**.
        
- For **beautiful dashboards and production monitoring**, Grafana is used (it integrates with Prometheus easily).
    

👉 Think of Prometheus’s web UI as a **basic calculator**, while Grafana is like **Excel with charts and dashboards**.

## Prometheus Flow (Step by Step)

**1. Applications & Exporters → expose metrics**

- **Client Libraries in Applications** expose custom business metrics (e.g., API latency, signups).
    
- **Exporters** (Node Exporter, MySQL Exporter, etc.) expose system/service metrics.
    
- Both expose these metrics at **HTTP endpoints** (e.g., `/metrics`).

**2. Service Discovery → updates Prometheus**

- Service Discovery (Kubernetes, AWS, Azure, GCP, etc.) provides Prometheus with the **list of targets** and their endpoints.

**3. Prometheus Server (Scraping & Storing)**

- Scrapes the metrics from those HTTP endpoints.
    
- Stores them in **TSDB (time-series database)**.
    
- Evaluates **Recording Rules** → creates new derived metrics (like request rates, averages).

**4. Prometheus Server (Alerting)**

- Evaluates **Alerting Rules** (written in PromQL).
    
- If a condition is met (e.g., CPU > 90% for 5m), it **fires an alert**.

**5. AlertManager**

- Receives alerts from Prometheus.
    
- Handles deduplication, grouping, silencing.
    
- Sends notifications to **Slack, Email, PagerDuty, etc.**

**6. Visualization**

- Prometheus Web UI → for debugging/ad-hoc queries.
    
- Grafana → for dashboards and production monitoring.

```

[ Applications + Client Libraries ]        [ Exporters ]
                 ↓                                ↓
        Expose metrics over HTTP endpoints (/metrics)
                 ↓
         [ Service Discovery ]
                 ↓
         [ Prometheus Server ]
   ┌─────────────────────────────────────┐
   │ - Scrape metrics                    │
   │ - Store in TSDB                     │
   │ - Recording Rules (derived metrics) │
   │ - Alerting Rules (check conditions) │
   └─────────────────────────────────────┘
                 ↓
           [ AlertManager ]
                 ↓
      Sends alerts → Slack, Email, etc.
                 ↓
         [ Visualization Layer ]
   Prometheus UI (basic) / Grafana (dashboards)

```


## Metric Names & Labels

### 1. **Metric Name**

- Think of this as the **category or main counter you’re measuring**.
    
- Example:
    
    - `http_requests_total` → the total number of HTTP requests your server received.
        
    - `cpu_usage_seconds_total` → how much time CPU has been busy.
        

👉 The **metric name** answers:  
_“What am I measuring?”_

---

### 2. **Labels**

- Labels are like **tags** that give more detail about the metric.
    
- Each metric name can have many **dimensions** depending on labels.
    
- Labels are **key=value pairs**.
    

👉 Example:

- Metric: `http_requests_total` (total HTTP requests).
    
- With labels:
    
    - `http_requests_total{method="GET", handler="/home"}`
        
    - `http_requests_total{method="POST", handler="/login"}`
        
    - `http_requests_total{method="DELETE", handler="/file"}`
        

Each different **label combination = new time series**.

---

### 3. **Why Labels Matter**

Without labels:

- You’d only know **total requests** (e.g., 1,000 requests).
    

With labels:

- You can **break it down by dimensions**:
    
    - How many were `GET` requests?
        
    - How many were `POST` requests?
        
    - How many hit `/login`?
        

👉 This is what makes Prometheus so powerful → it’s not just raw counts, it’s **dimensional metrics**.


## Prometheus Metric Types
### 1. **Counter**

- **Definition:** A value that **only increases** (or resets to zero when restarted).
    
- Good for **things that only grow**.
    
- Cannot decrease.

👉 Example use-cases:

- **HTTP requests served** → `http_requests_total`
    
- **Errors occurred** → `errors_total`
    
- **Jobs completed** → `batch_jobs_completed_total`
    

🔑 Think of a counter like the **odometer of a car** → it only moves forward, never backward.

### 2. **Gauge**

- **Definition:** A value that can go **up and down**.
    
- Good for **current values** that change frequently.
    

👉 Example use-cases:

- **CPU usage** (`cpu_usage_percent`)
    
- **Memory usage** (`memory_bytes`)
    
- **Temperature** (`room_temperature_celsius`)
    
- **Concurrent users** (`active_sessions`)
    

🔑 Think of a gauge like a **thermometer** → the reading can rise or fall.

### 3. **Histogram**

- **Definition:** Collects data samples (observations) and **groups them into buckets**.
    
- Also provides:
    
    - `count` (number of observations)
        
    - `sum` (total of all observations)
        
    - Buckets (distribution across ranges).
        

👉 Example use-cases:

- **Request duration (latency)** → how many requests took <1s, <5s, <10s.
    
- **Response sizes** → how many responses were under 1KB, 10KB, 100KB.
    

🔑 Think of a histogram like a **speed radar gun** → it not only measures speeds but also tells you how many cars were in each speed range.

### 4. **Summary**

- **Definition:** Similar to histogram but calculates **quantiles** (like median, 95th percentile, etc.) over a time window.
    
- Provides:
    
    - `count` (number of observations)
        
    - `sum` (total value)
        
    - Quantiles (e.g., 0.5 = median, 0.95 = 95th percentile).
        

👉 Example use-cases:

- **Request latency (quantiles)** → "95% of requests finish in <1s."
    
- **Transaction amounts** → see distribution of amounts.
#### What are quantiles?

Quantiles are a way of **breaking data into pieces** so you can understand _where most of the values lie_.

Think of it like:  
👉 You have a **big class of students** and you record everyone’s test scores.  
Instead of looking at all scores, you want to know things like:

- “What score do half the class score below?”
    
- “What score do 90% of the class score below?”
    

That’s exactly what quantiles tell you.

🔑 Think of a summary like a **medical report** → it not only shows total tests done but also gives insights like “most people’s BP is between X and Y.”

#### 📌 Quick Comparison

|Metric Type|Goes up only?|Can go up & down?|Distribution (Buckets)?|Percentiles/Quantiles?|Example|
|---|---|---|---|---|---|
|**Counter**|✅ Yes|❌ No|❌ No|❌ No|Requests served|
|**Gauge**|❌ No|✅ Yes|❌ No|❌ No|CPU usage|
|**Histogram**|❌ No|✅ Yes (via buckets)|✅ Yes (buckets)|❌ No|Request duration|
|**Summary**|❌ No|✅ Yes|❌ No (no buckets)|✅ Yes (quantiles)|Latency (95th percentile)|

## Jobs & Instances in Prometheus

### 🔹 1. **Instance**

- An **instance** is just **one endpoint (host:port)** that Prometheus scrapes.
    
- Think of it as a **single server, app, or exporter** that exposes `/metrics`.
    

👉 Example:

- `172.21.157.123:3814`
    
- `172.21.157.456:3814`
    

Each of these is **one instance**.

---

### 🔹 2. **Job**

- A **job** is a group of instances doing the same kind of work.
    
- It’s basically a **logical name** for a collection of targets.
    

👉 Example:

- Job name: `web_server`
    
- Instances under it:
    
    - `172.21.157.123:3814`
        
    - `172.21.157.456:3814`
        

So → job = **web server**, instances = **individual replicas**.

---

### 🔹 3. **Auto Labels Prometheus Adds**

When Prometheus scrapes, it **automatically attaches labels** to time series so you know where the data came from:

- `job`: The job name you configured.
    
- `instance`: The exact target (host:port).
    

👉 Example metric after scraping:

`http_requests_total{job="web_server", instance="172.21.157.123:3814", method="POST"}`

This means:

- Metric name = `http_requests_total`
    
- Labels =
    
    - `job="web_server"`
        
    - `instance="172.21.157.123:3814"`
        
    - `method="POST"`
---

## Core Features of Prometheus

- **Dimensional Data Model**
    
- **Metrics Transfer Format**
    
- **PromQL (Query Language)**
    
- **Integrated Alerting**
    
- **Service Discovery**

### **Prometheus Data Model**

- Prometheus works with **Time Series Data**:
    
    - Time series = numeric values **changing over time**, sampled when Prometheus scrapes.
        
- Each time series =
    
    - **Metric name** → describes "what is being measured".
        
    - **Labels (key=value pairs)** → allow breakdown into multiple dimensions.
        
- Example:
    
    `http_requests_total{method="POST", status="200"}`
    
- Prometheus also auto-attaches **target labels**:
    
    - `job` = job name (configured in Prometheus).
        
    - `instance` = host:port of target.
      
### **Metrics Transfer Format**

- Services expose metrics via an **HTTP endpoint** in a **text-based format**.
    
- Each line = **current value** of a metric + labels.
    
- Example:
    
    `http_requests_total{status="200"} 1050 process_open_fds 20`
    
- Key points:
    
    - Only **current value** sent (no history).
        
    - Prometheus decides scrape frequency.
        
    - Format is **easy to generate** → works for almost any system.
        
    - Since pull-based, you can **open endpoint in browser** to see metrics live.
      
### ###**PromQL (Prometheus Query Language)**

- Designed for **time series analysis**.
    
- Uses queries for: alerting, dashboards, debugging.
    
- Supports:
    
    - Arithmetic between time series.
        
    - Functions (like `rate()`, `avg()`).
        
    - Aggregations.
        

### 🔹 Examples

- Select error requests:
    
    `http_requests_total{status="500"}`
    
- Rate of increase over 5 minutes:
    
    `rate(http_requests_total{status="500"}[5m])`
    
- Aggregate by path:
    
    `sum by (path) (rate(http_requests_total[5m]))`
    
- Find paths with error rate > 5%:
    
    `(rate(http_requests_total{status="500"}[5m]) / rate(http_requests_total[5m])) * 100 > 5`
    
### **Integrated Alerting**

- Prometheus uses **PromQL for alerting rules**.
    
- Alert rules stored in YAML files.
    
- Rule =
    
    - Alert name.
        
    - PromQL expression (condition).
        
    - Metadata (severity, tolerance, annotations).
        
- If condition true → Prometheus → **Alertmanager** → notifications (Slack, email, etc.).
  
  ## **Service Discovery**

- Since Prometheus scrapes targets, it must **know what to scrape**.
    
- Targets can be:
    
    - Static (manual config).
        
    - Dynamic (service discovery).
        
- Dynamic discovery useful in **cloud-native environments** (Kubernetes, Consul, DNS).
    
- Prometheus updates its list of targets automatically when new services appear/disappear.
  
  ## **Summary**

- Prometheus = monitoring system for **time-series metrics**.
    
- Pull-based architecture with **targets, exporters, service discovery**.
    
- Stores data in **TSDB**.
    
- Offers **PromQL** for queries, **Alertmanager** for alerts.
    
- Key strengths:
    
    - Dimensional data model.
        
    - Flexible querying.
        
    - Easy integrations (Grafana, Kubernetes, etc.).
      
## What is a Gauge in Prometheus?

- A **Gauge** is like a **live meter** that shows the **current value** of something.
    
- Example:
    
    - A thermometer 🌡️ → shows current temperature.
        
    - A weighing scale ⚖️ → shows current weight.
        
- The important thing:  
    👉 The number can **go up** or **go down** anytime.
    

---

#### 🔧 How do we instrument (use) a Gauge?

When you add a Gauge in your code (called **instrumentation**), you’re telling Prometheus:  
“Hey, I want to track this value as it changes over time.”

You can interact with a Gauge in 3 main ways:

1. **Set(value)**
    
    - Directly tell the gauge what the value should be.
        
    - Example:
        
        `temperature_gauge.set(25.3)`
        
        → “Temperature is exactly 25.3°C right now.”
        
2. **Inc()**
    
    - Increase the current value by 1.
        
    - Example:
        
        `active_users.inc()`
        
        → A new user logged in → counter goes up.
        
3. **Dec()**
    
    - Decrease the current value by 1.
        
    - Example:
        
        `active_users.dec()`
        
        → A user logged out → counter goes down.
        

---

#### 📊 Real-world Examples of Gauges

- **CPU usage %** → can go up or down.
    
- **Memory usage (in MB)** → changes over time.
    
- **Number of active users in an app** → goes up when people join, down when they leave.
    
- **Temperature sensor value** → can rise or fall.

## Data Selection in PromQL (Step by Step)

Before doing **math, transformations, or alerts**, you first need to **pick the right data**.  
PromQL gives you two main tools for this:

---

### 1️⃣ Instant Vector Selectors

- Think of these as:  
    👉 "Give me the **latest value** for each time series at a single point in time."
    

### Example

`demo_memory_usage_bytes`

This fetches the most recent memory usage sample for every time series that has that metric name.

📌 Key points:

- Returns **one sample per series**, all aligned to the same timestamp.
    
- Timestamp = query evaluation time (usually "now" unless you change it).
    
- In **graph mode**, this is run many times → once for each point in your graph.
    

---

###  2️⃣ Label Matchers

Labels let you **filter** the series you want.

`demo_memory_usage_bytes{type="buffers"}`

- Only series where `type="buffers"` is returned.
    

Types of matchers:

- `=` → equal
    
- `!=` → not equal
    
- `=~` → regex match
    
- `!~` → regex NOT match
    

You can combine multiple filters with commas:

`demo_memory_usage_bytes{type!="free", instance="srv1"}`

---

### 3️⃣ Lookback Delta (5 minutes rule)

When Prometheus tries to fetch the **latest sample**, what if the last sample is old?

- By default, Prometheus will **look back up to 5 minutes**.
    
- If there’s no data in that window → series is dropped.
    

This prevents dead targets from showing stale values.

---

### 4️⃣ Staleness Handling

Prometheus can detect when a series **dies**:

- If a scrape target disappears or stops reporting → Prometheus writes a **staleness marker** (❌).
    
- That series immediately disappears from results (no waiting 5 minutes).
    
- If the series reappears later → it comes back into results.
    

---

### 5️⃣ Range Vector Selectors

Sometimes you don’t just want the latest value — you want a **window of samples**.

👉 Add a time range in `[]`:

`http_requests_total[5m]`

- This fetches **all raw samples from the last 5 minutes**.
    

But ⚠️ → You can’t directly graph this (too many samples).  
So you use a **function** (like `rate()` or `avg_over_time()`) to reduce it back to a single value per step.

Example:

`rate(http_requests_total[5m])`

= per-second request rate over the last 5 minutes.

---

### 6️⃣ Offset Modifier

Shifts the query **into the past**.

`demo_memory_usage_bytes offset 2m`

- Instead of "now", this looks at "2 minutes ago."
    
- Useful for **comparisons** (e.g., memory now vs memory a week ago).
    

---

### 7️⃣ Absolute Timestamps (@ modifier)

Instead of shifting relatively, you can **pin a query to an exact timestamp**.

`demo_memory_usage_bytes @ 1724862000`

- Always fetches values **at that Unix timestamp**.
    

Common trick:

`topk(5, http_requests_total @ end())`

= Top 5 request series **anchored to the end of the graph range** (useful for stable top K charts).

---

### 8️⃣ Order of Modifiers

When combining:

1. **Metric + labels**
    
2. **Range** (`[5m]`)
    
3. **Offset** (`offset 1h`)
    
4. **Absolute timestamp** (`@ 1724862000`)
    

Example:

`demo_memory_usage_bytes{instance="srv1"}[1m] offset 1h @ 1724862000`

---

### 🎯 TL;DR

- **Instant vector** → latest value.
    
- **Range vector** → many samples in a window.
    
- **Label matchers** → filter which series you want.
    
- **Lookback delta** → max 5 min tolerance for freshness.
    
- **Staleness markers** → remove dead series faster.
    
- **Offset** → relative time shift.
    
- **@** → absolute time anchor.

## Counters & Why We Need Rates

- A **counter metric** is like the odometer in a car → it only goes **up** (except when it resets to 0).
    
- Example: `http_requests_total` → keeps counting total requests since start.
    

Problem:  
If it says `1050` … is that fast? slow? We don’t know!  
We care about **how quickly** it’s going up right now.

That’s where the three functions come in.

---

### ⚡ The Three Functions

#### 1. `rate(counter[time])`

- Calculates the **average speed** (per second) of the counter over a chosen time window.
    
- Example:
    
    `rate(http_requests_total[5m])`
    
    → “On average, how many requests per second over the last 5 minutes?”
    
- Smooth → good for dashboards & alerts. ✅
    

---

#### 2. `increase(counter[time])`

- Same math as `rate()`, **but shows the total increase** in the window instead of per second.
    
- Example:
    
    `increase(http_requests_total[5m])`
    
    → “How many total requests in the last 5 minutes?”
    
- Units = raw counts, not per second.
    

---

### 3. `irate(counter[time])`

- Instant rate → only looks at the **last 2 data points**.
    
- Very spiky ⚡ — reacts super fast.
    
- Example:
    
    `irate(http_requests_total[5m])`
    
    → “What’s the rate right this second?”
    
- Great for **zoomed-in graphs**, bad for alerts (too noisy).
    

---

### 🛠 Handling Resets

- Counters sometimes reset to 0 (like when a service restarts).
    
- Prometheus is smart → if a number drops, it assumes a reset, not a decrease.
    
- It "fixes" the math so you don’t get weird negative rates.
    

---

### 📐 Extrapolation (the tricky bit)

- Samples don’t usually line up perfectly with your 5m window.
    
- Prometheus "pretends" (extrapolates) what the value would have been at the exact start and end → so numbers look more accurate.
    
- This can sometimes make results look fractional or confusing for **slow counters** (like a metric that only goes up once every few hours).
    

---

### ✅ Which One Should You Use?

- **`rate()` → use 90% of the time** (stable, per second, great for alerts/dashboards).
    
- **`increase()` → use when you care about total counts** (e.g., total requests in last X mins).
    
- **`irate()` → only for detailed, zoomed-in graphs** (not alerts).
    

---

### 🎯 TL;DR

- `rate()` = average speed (per second).
    
- `increase()` = total distance (raw increase).
    
- `irate()` = instant speed (spiky).
    

---

## Prometheus auto-generated (synthetic) metrics
Normally, Prometheus scrapes (collects) metrics from your apps or servers.  
But even if your target (server/app) **doesn’t expose any metrics at all**, Prometheus itself still creates some “synthetic” (auto-generated) metrics.

It’s like Prometheus saying:

> “Even if you don’t tell me anything, I’ll at least tell you if you’re alive and how the scraping went.”

---

### 🛠 The Famous Synthetic Metrics

#### 1. **`up`**

- Value = **1** → target was scraped successfully.
    
- Value = **0** → scrape failed (target down, network issue, timeout, etc.).  
    👉 This is the **most basic health check** in Prometheus.
    

---

#### 2. **`scrape_duration_seconds`**

- How long it took Prometheus to scrape that target.
    
- Helps you spot **slow endpoints**.
    

---

#### 3. **`scrape_samples_scraped`**

- How many **raw metrics** Prometheus got in that scrape.
    
- Tells you which targets expose **huge amounts of data**.
    

---

#### 4. **`scrape_samples_post_metric_relabeling`**

- After Prometheus applies **filters/relabeling rules**, how many metrics are left.
    
- Useful for checking if your config is actually **dropping unnecessary data**.
    

---

#### 5. **`scrape_series_added`**

- How many **new time series** appeared since the last scrape.
    
- High values = lots of “churn” (targets keep creating new series), which can be **expensive** for Prometheus to handle.
    

---

### 🧩 Labels on These Metrics

- Synthetic metrics still get the same labels as the target (`job`, `instance`, etc.).
    
- So if your config changes labels, they’ll reflect here too.
    

---

### 🎯 Why Are These Useful?

- `up` → quick alert: “is my service up?”
    
- `scrape_duration_seconds` → detect slow scrapes.
    
- `scrape_samples_*` → monitor data volume and efficiency.
    
- `scrape_series_added` → detect churn (new time series flood).
    

---

✅ So in short:  
Prometheus doesn’t just collect what your app gives — it also **generates its own helper metrics** so you can monitor the scraping process itself.

## What is a Histogram?

A **histogram** in Prometheus helps you measure the **distribution** of numbers.  
Instead of just knowing a single value (like the last request duration), it tells you **how many events fell into different ranges (buckets)**.

👉 Example use: request duration (latency).

- If 100 requests were served,
    
    - 50 finished in **0–100ms**,
        
    - 30 in **100–250ms**,
        
    - 20 in **>250ms**,  
        then you know not just the average, but how requests are spread across durations.
        

---

### 2. Why Not Just Use Other Metric Types?

- **Gauge** → only shows the latest value (loses past requests).
    
- **Summary** → can calculate percentiles, but **not aggregatable across instances** (bad for multi-service setups).
    
- **Histogram** → stores distributions into buckets → **can aggregate across instances & labels**.
    

---

### 3. How Prometheus Stores Histograms

Each histogram creates **3 types of series**:

1. **Buckets** (`_bucket`) → cumulative counters with label `le="x"` (less or equal to x).  
    Example:
    
    `http_request_duration_seconds_bucket{le="0.5"}  200 http_request_duration_seconds_bucket{le="1"}    350 http_request_duration_seconds_bucket{le="+Inf"} 400`
    
    → means:
    
    - 200 requests ≤ 0.5s
        
    - 150 requests between 0.5–1s
        
    - 50 requests > 1s
        
2. **Count** (`_count`) → total number of requests observed.
    
3. **Sum** (`_sum`) → total accumulated duration of all requests.
    

---

### 4. How to Add Histograms in Code

- Define buckets → e.g. `[0.05, 0.1, 0.25, 0.5, 1, 2, 5]`.
    
- Use **Observe(value)** when recording a request duration.
    
- Buckets auto-increment depending on which range the value falls into.
    
- Can add labels (`method="GET"`, `path="/api"`, etc.) for breakdowns.
    

---

### 5. Querying Histograms in PromQL

#### a) Percentiles (most common!)

Use `histogram_quantile()`:

`histogram_quantile(0.9, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))`

- `0.9` → 90th percentile (90% of requests finished faster).
    
- `rate(...[5m])` → look at last 5 minutes.
    
- `sum by (le)` → aggregate across all instances/services.
    

Result → tells you "90% of requests complete under X seconds".

---

#### b) Average Request Duration

`rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])`

---

#### c) Request Rate (RPS)

`rate(http_request_duration_seconds_count[5m])`

---

#### d) Heatmaps

- Show histogram buckets over time as a colored grid.
    
- Lets you **see latency spikes** visually.
    
- Works in Prometheus UI (`Graph → Heatmap`) or Grafana.
    

---

### 6. Tradeoffs

- More buckets = more precision ✅, but more time series to store ❌.
    
- Choose buckets carefully based on your **latency SLOs**.
    
    - e.g., web API might use `[0.05, 0.1, 0.25, 0.5, 1, 2, 5]`.
        
    - background jobs might use `[1, 5, 10, 30, 60]`.
        

---

### 7. Key Takeaways

- Use **histograms** for latency, sizes, or any distribution.
    
- They are **aggregatable**, unlike summaries.
    
- Always pair with `histogram_quantile()` + `rate()` in queries.
    
- Balance between **bucket precision vs storage cost**.
    
- Great for **SLAs/SLOs** (like “99% of requests < 200ms”).


## Prometheus "WAL"(Write Ahead Log)

### 🔹 Meaning in Simple Words

Think of the WAL as Prometheus’s **notebook**:

- Every time Prometheus scrapes some metrics, it **first writes them into the WAL** (a file on disk).
    
- Only later, it compresses & stores them into long-term blocks (TSDB = Time Series Database).
    

So WAL = **temporary raw storage** for the latest data.

---

### 🔹 Why do we need WAL?

1. **Crash recovery** 🛠️  
    If Prometheus crashes or the server restarts, it can replay the WAL and not lose recent data.
    
2. **Fast writes** ⚡  
    Writing to WAL is much faster than directly writing to the database.
    
3. **Durability** 🔒  
    Data is safe on disk as soon as it’s scraped, even before being compacted into blocks.
    

---

### 🔹 WAL Lifecycle

1. Metrics scraped → written to WAL.
    
2. WAL keeps data for a few hours (by default ~2 hours).
    
3. After compaction → old WAL segments get deleted, and data lives in block files.
    

---

✅ **In short:**  
The WAL in Prometheus is a **temporary diary of raw metrics**, kept so that you don’t lose recent data if Prometheus crashes before saving it permanently.




## EXPLANATION OF WHAT IS GOING ON IN CST-ALERTS REPOSITORY 
```
[AWS EC2 Instance]
   │
   ▼
[Telegraf/Exporter exposes /metrics with AWS tags as labels]
   │
   ▼
[Prometheus (scrape_configs) discovers instances using ec2_sd_configs and tags]
   │
   ▼
[Prometheus scrapes metrics, relabels tags to labels]
   │
   ▼
[Prometheus loads rule files, matches rules to metrics using labels]
   │
   ▼
[If rule triggers, alert is fired with all labels]
   │
   ▼
[Alertmanager notifies team]
   │
   ▼
[You view everything in Prometheus portal, filter by instance/tag]



```


## What is this file?

This file is a list of “alert rules” for Prometheus. Each rule is like a health check for your servers, cloud resources, or applications. If something goes wrong (like a server is down, disk is full, or CPU is too high), Prometheus will send an alert to your team.

---

## Main Sections and What They Do

### 1. Disk Usage Alerts

- **Checks if your servers’ disks are getting full.**
- If disk usage goes above 80%, 91%, 95%, or 98% (depending on the rule), you get an alert.
- Why? If a disk gets full, your apps can crash or stop working.

### 2. CPU Usage Alerts

- **Checks if your servers’ CPUs are working too hard.**
- If CPU usage is above certain thresholds (like 70%, 95%), you get an alert.
- Why? High CPU can mean your server is overloaded and might slow down or crash.

### 3. Memory and Swap Alerts

- **Checks if your servers are running out of memory (RAM) or using too much swap (slow disk memory).**
- If memory is low or swap is high, you get an alert.
- Why? Low memory can cause apps to crash or become very slow.

### 4. System Load Alerts

- **Checks if your servers are handling too many tasks at once.**
- If the system load is too high for too long, you get an alert.
- Why? High load means your server is struggling to keep up.

### 5. Network and Service Health

- **Checks if important services or network ports are up and responding.**
- If a service is down or a port is not responding, you get an alert.
- Why? If a service is down, users might not be able to access your app.

### 6. Kubernetes and Container Alerts

- **Checks the health of your Kubernetes pods and containers.**
- Alerts if a pod is restarting too much, not ready, or if deployments/statefulsets/daemonsets are not healthy.
- Why? Problems in Kubernetes can cause outages for your apps.

### 7. Cloud-Specific Alerts (AWS, Azure, GCP)

- **Checks the health of resources in different clouds.**
- For AWS: Checks EC2 instances, Redis, Elasticsearch, etc.
- For Azure: Checks CPU, disk, and instance health.
- For GCP: Checks if specific instances or services are up and healthy.

### 8. Special Service Alerts

- **Checks for specific services like SIP, Elasticsearch, etc.**
- Alerts if these services are down or unhealthy.

---

## How does it work in practice?

- Prometheus collects data (metrics) from all your servers and cloud resources.
- It checks these rules every few seconds or minutes.
- If a rule’s condition is true (like “disk is over 95% full for 5 minutes”), Prometheus fires an alert.
- The alert includes details like which server, what the problem is, and how bad it is.
- Your team gets notified (by email, Slack, PagerDuty, etc.) so you can fix the problem before it affects users.

