-- Synthetic portal sign-ins. All timestamps are UTC on the same date.
WITH events(id, utc, account, source_ip, result) AS (
    VALUES
        ( 1, '2026-11-12 08:47:00', 'lab.alex', '192.0.2.12', 'failure'),
        ( 2, '2026-11-12 09:00:00', 'lab.alex', '192.0.2.12', 'failure'),
        ( 3, '2026-11-12 09:00:25', 'lab.beth', '192.0.2.12', 'failure'),
        ( 4, '2026-11-12 09:01:10', 'lab.alex', '192.0.2.12', 'failure'),
        ( 5, '2026-11-12 09:01:25', 'lab.alex', '198.51.100.4', 'failure'),
        ( 6, '2026-11-12 09:02:00', 'lab.alex', '192.0.2.12', 'failure'),
        ( 7, '2026-11-12 09:02:20', 'lab.beth', '192.0.2.12', 'success'),
        ( 8, '2026-11-12 09:02:40', 'lab.alex', '192.0.2.12', 'success'),
        ( 9, '2026-11-12 09:03:00', 'lab.alex', '192.0.2.12', 'success')
)
SELECT s.id AS success_id, s.account, s.source_ip, COUNT(*) AS failures,
       MIN(f.utc) AS first_failure_utc, s.utc AS success_utc
FROM events AS s
JOIN events AS f ON f.account = s.account AND f.source_ip = s.source_ip
WHERE s.result = 'success' AND f.result = 'failure'
  AND f.utc >= datetime(s.utc, '-10 minutes') AND f.utc < s.utc
  AND NOT EXISTS (
      SELECT 1 FROM events AS prior
      WHERE prior.account = s.account AND prior.source_ip = s.source_ip
        AND prior.result = 'success' AND prior.utc > f.utc AND prior.utc < s.utc
  )
GROUP BY s.id, s.account, s.source_ip, s.utc
HAVING COUNT(*) >= 3
ORDER BY s.utc;
