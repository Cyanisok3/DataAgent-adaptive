CREATE SCHEMA IF NOT EXISTS discovery;

CREATE TABLE discovery.customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(80) NOT NULL,
  signup_date DATE NOT NULL,
  region VARCHAR(40) NOT NULL
);

CREATE TABLE discovery.orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date DATE NOT NULL,
  region VARCHAR(40) NOT NULL,
  category VARCHAR(40) NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES discovery.customers(customer_id)
);

CREATE TABLE discovery.daily_funnel_metrics (
  metric_date DATE NOT NULL,
  region VARCHAR(40) NOT NULL,
  user_segment VARCHAR(20) NOT NULL,
  channel VARCHAR(40) NOT NULL,
  visits INT NOT NULL,
  conversions INT NOT NULL,
  PRIMARY KEY (metric_date, region, user_segment, channel)
);
