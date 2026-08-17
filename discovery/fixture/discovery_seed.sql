-- Deterministic synthetic fixture. The two comparison weeks are fixed:
-- prior = 2026-08-03..2026-08-09; current = 2026-08-10..2026-08-16.

INSERT INTO discovery.customers (customer_id, customer_name, signup_date, region) VALUES
  (1, 'Evan', DATE '2026-01-02', 'East'),
  (2, 'Lina', DATE '2026-02-14', 'East'),
  (3, 'Ming', DATE '2026-03-21', 'North'),
  (4, 'Noah', DATE '2026-04-11', 'South'),
  (5, 'Rita', DATE '2026-05-07', 'West');

-- Evan has the most orders (10), with 7 completed: completion rate = 70%.
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

-- Current-week conversion drops from 10% to 5%. Returning users stay at 10%; new
-- users fall to 2%, concentrated in paid_social (10% -> 1%).
INSERT INTO discovery.daily_funnel_metrics (metric_date, region, user_segment, channel, visits, conversions) VALUES
  (DATE '2026-08-03', 'East', 'new', 'paid_social', 250, 25),
  (DATE '2026-08-03', 'East', 'new', 'organic_search', 250, 25),
  (DATE '2026-08-03', 'East', 'returning', 'email', 150, 15),
  (DATE '2026-08-03', 'East', 'returning', 'direct', 150, 15),
  (DATE '2026-08-10', 'East', 'new', 'paid_social', 250, 3),
  (DATE '2026-08-10', 'East', 'new', 'organic_search', 250, 7),
  (DATE '2026-08-10', 'East', 'returning', 'email', 150, 15),
  (DATE '2026-08-10', 'East', 'returning', 'direct', 150, 15);

-- Discovery-only agent and its same-process H2 business data source.
INSERT INTO agent (id, name, description, avatar, status, api_key, api_key_enabled, prompt, category, admin_id, tags, create_time, update_time) VALUES
  (101, 'Discovery E-commerce Analyst', 'Deterministic fixture for multi-step investigation behavior.', NULL, 'published', NULL, 0,
   'You are evaluating a synthetic e-commerce fixture. Use only discovery.customers, discovery.orders, and discovery.daily_funnel_metrics. State the fixed comparison periods explicitly. Do not invent data. When a next step depends on a prior result, cite that result and continue only with the matching branch.',
   'Product discovery', 1, 'discovery,fixture,ecommerce', NOW(), NOW());

INSERT INTO datasource (id, name, type, host, port, database_name, username, password, connection_url, status, test_status, description, creator_id, create_time, update_time) VALUES
  (101, 'Discovery H2 Fixture', 'h2', 'nl2sql_database', 0, 'discovery', 'root', 'root',
   'jdbc:h2:mem:nl2sql_database;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=true;MODE=MySQL;DB_CLOSE_ON_EXIT=FALSE',
   'active', 'unknown', 'Same-process deterministic product-discovery fixture.', 1, NOW(), NOW());

INSERT INTO agent_datasource (id, agent_id, datasource_id, is_active, create_time, update_time) VALUES
  (101, 101, 101, 1, NOW(), NOW());

INSERT INTO agent_datasource_tables (id, agent_datasource_id, table_name, create_time, update_time) VALUES
  (101, 101, 'orders', NOW(), NOW()),
  (102, 101, 'customers', NOW(), NOW()),
  (103, 101, 'daily_funnel_metrics', NOW(), NOW());

INSERT INTO business_knowledge (id, business_term, description, synonyms, is_recall, agent_id, created_time, updated_time) VALUES
  (101, 'completed GMV', 'Sum discovery.orders.total_amount where status is completed.', 'GMV, sales amount, revenue', 1, 101, NOW(), NOW()),
  (102, 'order completion rate', 'Completed order count divided by all order count for the same customer and scope.', 'completion rate, completed percentage', 1, 101, NOW(), NOW()),
  (103, 'conversion rate', 'Sum conversions divided by sum visits in discovery.daily_funnel_metrics for the queried period.', 'CVR, conversion', 1, 101, NOW(), NOW()),
  (104, 'comparison weeks', 'Prior week is 2026-08-03 through 2026-08-09; current week is 2026-08-10 through 2026-08-16.', 'this week, last week', 1, 101, NOW(), NOW());

INSERT INTO semantic_model (id, agent_id, datasource_id, table_name, column_name, business_name, synonyms, business_description, column_comment, data_type, created_time, updated_time, status) VALUES
  (101, 101, 101, 'discovery.orders', 'customer_id', 'order customer', 'user, customer', 'Join to discovery.customers.customer_id.', 'customer foreign key', 'int', NOW(), NOW(), 1),
  (102, 101, 101, 'discovery.orders', 'order_date', 'order date', 'date', 'Fixed date used for weekly comparisons.', 'order day', 'date', NOW(), NOW(), 1),
  (103, 101, 101, 'discovery.orders', 'region', 'sales region', 'region', 'Region for GMV drill-down.', 'region', 'varchar', NOW(), NOW(), 1),
  (104, 101, 101, 'discovery.orders', 'category', 'product category', 'category', 'Category for regional GMV drill-down.', 'category', 'varchar', NOW(), NOW(), 1),
  (105, 101, 101, 'discovery.orders', 'total_amount', 'order amount', 'GMV, revenue', 'Order monetary value.', 'amount', 'decimal', NOW(), NOW(), 1),
  (106, 101, 101, 'discovery.orders', 'status', 'order status', 'completed, pending, cancelled', 'Use completed for completed GMV.', 'status', 'varchar', NOW(), NOW(), 1),
  (107, 101, 101, 'discovery.daily_funnel_metrics', 'user_segment', 'user segment', 'new, returning', 'New and returning user split.', 'segment', 'varchar', NOW(), NOW(), 1),
  (108, 101, 101, 'discovery.daily_funnel_metrics', 'channel', 'acquisition channel', 'source, channel', 'Traffic channel.', 'channel', 'varchar', NOW(), NOW(), 1),
  (109, 101, 101, 'discovery.daily_funnel_metrics', 'visits', 'visits', 'traffic', 'Conversion rate denominator.', 'visits', 'int', NOW(), NOW(), 1),
  (110, 101, 101, 'discovery.daily_funnel_metrics', 'conversions', 'conversions', 'orders, converted visits', 'Conversion rate numerator.', 'conversions', 'int', NOW(), NOW(), 1);
