
/* 1 */
SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Source Count'
FROM page_visits;
  
SELECT DISTINCT utm_campaign AS 'Campaign',
	utm_source AS 'Source'
FROM page_visits
ORDER BY 2;

/* 2  */
SELECT DISTINCT page_name AS 'Page'
FROM page_visits;

/* 3 */
WITH first_touch AS (
	SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  	SELECT ft.user_id,
        ft.first_touch_at,
        pv.utm_source,
        pv.utm_campaign
  	FROM first_touch ft
  	JOIN page_visits pv
  		ON ft.user_id = pv.user_id
    	AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Source',
	ft_attr.utm_campaign AS 'Campaign',
    COUNT(*) AS 'Count'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* 4 */
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  	SELECT lt.user_id,
        lt.last_touch_at,
        pv.utm_source,
        pv.utm_campaign
  	FROM last_touch lt
  	JOIN page_visits pv
  		ON lt.user_id = pv.user_id
    	AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* 5 */
SELECT COUNT(DISTINCT user_id) AS 'Visitors with purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

/* 6 */
WITH last_touch AS (
    SELECT user_id,
    	MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  	SELECT lt.user_id,
        lt.last_touch_at,
        pv.utm_source,
        pv.utm_campaign
  	FROM last_touch lt
  	JOIN page_visits pv
    	ON lt.user_id = pv.user_id
    	AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
	lt_attr.utm_campaign AS 'Campaign',
    COUNT(*) AS 'Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

