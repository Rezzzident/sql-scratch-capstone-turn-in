--1. How many campaigns and sources, and how are they related

SELECT COUNT(DISTINCT utm_source) AS 'Sources'
FROM page_visits;


SELECT COUNT(DISTINCT utm_campaign) AS 'Campaigns'
FROM page_visits;


SELECT DISTINCT utm_source AS 'Sources',
	utm_campaign AS 'Campaigns'
FROM page_visits;



--What pages are on their website

SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;

--2. What is the user journey
--How many first touches is each campaign responsible for?
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as 'first_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source AS 'Source',
    pv.utm_campaign AS 'Campaign',
    COUNT(utm_campaign) AS 'No.'
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;


--How many last touches is each campaign responsible for?
WITH last_touch AS (
            SELECT user_id,
            MAX(timestamp) AS 'last_touch_at'
            FROM page_visits
            GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--How many visitors make a purchase?
SELECT COUNT(DISTINCT user_id) AS 'Buyers'
FROM page_visits
    WHERE page_name = '4 - purchase';


--How many last touches on the purchase page is each campaign responsible for?
WITH last_touch AS (
      SELECT user_id,
      MAX(timestamp) AS 'last_touch_at'
      FROM page_visits
  WHERE page_name = '4 - purchase'
      GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
      lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'No.'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
