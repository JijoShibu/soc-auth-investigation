# Three failed sign-ins and a successful login

[Try the 15-minute investigation](challenge.md) before reading the worked answer below.

**Triage decision: verify the session with the account owner.** In this synthetic SOC exercise, `lab.alex` signed in successfully from `192.0.2.12` after three failures from that address in 2 minutes and 40 seconds. The events justify a follow-up. They do not identify the person who signed in.

## Evidence

All nine events are visible at the top of the [SQLite query](investigate.sql). The accounts are fictional and the addresses are reserved for documentation. All times below are UTC on 12 November 2026.

| Time | Event | Why it matters |
| --- | --- | --- |
| 08:47:00 | Alex, failed sign-in | Outside the ten-minute window for the later success. |
| 09:00:00, 09:01:10, 09:02:00 | Alex, three failures from 192.0.2.12 | These three events match both the account and the source of the successful sign-in. |
| 09:00:25–09:02:20 | Beth used the same address. Alex also had a failure from another address. | Counting by address alone would mix users. Counting by account alone would mix sources. |
| 09:02:40 | Alex, successful sign-in from 192.0.2.12 | Event 8 is the first success after the three matching failures. |
| 09:03:00 | Alex, another success from the same address | The earlier success closes the sequence. Reusing the same failures would create a duplicate alert. |

## Reproduce the result

Download [investigate.sql](investigate.sql). Open it in DB Browser for SQLite and run it in the **Execute SQL** tab of an open database. Alternatively, run the following in a directory containing the file with the SQLite CLI installed. The query reads inline data and creates no tables.

```sh
sqlite3 -header -column ":memory:" ".read investigate.sql"
```

The rule selects a success with at least three failures from the same account and source in the preceding ten minutes, after their last success. The threshold is an exercise assumption. Expected output is one row.

| success_id | account | source_ip | failures | first_failure_utc | success_utc |
| --- | --- | --- | ---: | --- | --- |
| 8 | lab.alex | 192.0.2.12 | 3 | 2026-11-12 09:00:00 | 2026-11-12 09:02:40 |

## What would change the decision?

A user correcting a mistyped password could produce this sequence. Two accounts also share one source address in the sample, as users behind an office gateway might. The log has no device identity, MFA result, or record of what happened after the sign-in.

In a live investigation, check the identity provider's MFA and device records for event 8 and contact the user through a known channel. A familiar device and a confirmed retry support closing the alert with that evidence. If the user denies the sign-in, escalate through the incident process, review subsequent activity, and request session revocation. The exercise ends with the session awaiting verification.
