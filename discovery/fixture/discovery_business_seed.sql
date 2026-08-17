-- Deterministic business-only seed for a standalone H2 datasource.
-- prior = 2026-08-03..2026-08-09; current = 2026-08-10..2026-08-16.

INSERT INTO discovery.customers (customer_id, customer_name, signup_date, region) VALUES
  (1, 'Evan', DATE '2026-01-02', 'East'),
  (2, 'Lina', DATE '2026-02-14', 'East'),
  (3, 'Ming', DATE '2026-03-21', 'North'),
  (4, 'Noah', DATE '2026-04-11', 'South'),
  (5, 'Rita', DATE '2026-05-07', 'West');

INSERT INTO discovery.orders (order_id, customer_id, order_date, region, category, total_amount, status) VALUES
  (1, 1, DATE '2026-08-03', 'East', 'Electronics', 100.00, 'completed'),
  (2, 1, DATE '2026-08-04', 'East', 'Electronics', 100.00, 'completed'),
  (3, 1, DATE '2026-08-05', 'East', 'Home', 80.00, 'completed'),
  (4, 1, DATE '2026-08-06', 'East', 'Home', 80.00, 'completed'),
  (5, 1, DATE '2026-08-07', 'East', 'Beauty', 60.00, 'completed'),
  (6, 1, DATE '2026-08-08', 'East', 'Beauty', 60.00, 'completed'),
  (7, 1, DATE '2026-08-09', 'East', 'Electronics', 100.00, 'completed'),
  (8, 1, DATE '2026-08-10', 'East', 'Electronics', 100.00, 'pending'),
  (9, 1, DATE '2026-08-11', 'East', 'Home', 80.00, 'cancelled'),
  (10, 1, DATE '2026-08-12', 'East', 'Beauty', 60.00, 'pending'),
  (11, 2, DATE '2026-08-03', 'East', 'Electronics', 500.00, 'completed'),
  (12, 2, DATE '2026-08-04', 'East', 'Electronics', 500.00, 'completed'),
  (13, 2, DATE '2026-08-05', 'East', 'Home', 300.00, 'completed'),
  (14, 2, DATE '2026-08-10', 'East', 'Electronics', 100.00, 'completed'),
  (15, 2, DATE '2026-08-11', 'East', 'Home', 250.00, 'completed'),
  (16, 3, DATE '2026-08-03', 'North', 'Electronics', 600.00, 'completed'),
  (17, 3, DATE '2026-08-10', 'North', 'Electronics', 650.00, 'completed'),
  (18, 4, DATE '2026-08-03', 'South', 'Home', 400.00, 'completed'),
  (19, 4, DATE '2026-08-10', 'South', 'Home', 450.00, 'completed'),
  (20, 5, DATE '2026-08-03', 'West', 'Beauty', 350.00, 'completed'),
  (21, 5, DATE '2026-08-10', 'West', 'Beauty', 360.00, 'completed');

INSERT INTO discovery.daily_funnel_metrics (metric_date, region, user_segment, channel, visits, conversions) VALUES
  (DATE '2026-08-03', 'East', 'new', 'paid_social', 250, 25),
  (DATE '2026-08-03', 'East', 'new', 'organic_search', 250, 25),
  (DATE '2026-08-03', 'East', 'returning', 'email', 150, 15),
  (DATE '2026-08-03', 'East', 'returning', 'direct', 150, 15),
  (DATE '2026-08-10', 'East', 'new', 'paid_social', 250, 3),
  (DATE '2026-08-10', 'East', 'new', 'organic_search', 250, 7),
  (DATE '2026-08-10', 'East', 'returning', 'email', 150, 15),
  (DATE '2026-08-10', 'East', 'returning', 'direct', 150, 15);
