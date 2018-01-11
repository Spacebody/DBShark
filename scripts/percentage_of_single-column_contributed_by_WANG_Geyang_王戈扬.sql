--
-- Query contributed by 王戈扬 (WANG Geyang)
--
--Percentage of single-column indexes
SELECT round(100 * indnatts_count.num / (SELECT count(*) AS total
                                         FROM pg_index), 0) AS percentage
FROM (
       SELECT
         indnatts,
         COUNT(*) AS num
       FROM pg_index
       GROUP BY indnatts) AS indnatts_count
WHERE indnatts = 1;
