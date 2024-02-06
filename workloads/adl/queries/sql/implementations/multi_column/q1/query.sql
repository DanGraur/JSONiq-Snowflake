SELECT
  HistogramBin(MET:pt, 0, 2000, 100) AS x,
  COUNT(*) AS y
FROM adl
GROUP BY x
ORDER BY x;