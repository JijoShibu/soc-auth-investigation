# Nine sign-ins. Which one needs a follow-up?

**15 minutes · No installation needed.** You are reviewing the morning sign-in queue. Two people use the same office address. Decide which session to verify and what to ask next. All accounts and events are fictional. Times are UTC on 12 November 2026.

| ID | Time | Account | Source IP | Result |
|---:|:---|:---|:---|:---|
| 1 | 08:47:00 | lab.alex | 192.0.2.12 | Failure |
| 2 | 09:00:00 | lab.alex | 192.0.2.12 | Failure |
| 3 | 09:00:25 | lab.beth | 192.0.2.12 | Failure |
| 4 | 09:01:10 | lab.alex | 192.0.2.12 | Failure |
| 5 | 09:01:25 | lab.alex | 198.51.100.4 | Failure |
| 6 | 09:02:00 | lab.alex | 192.0.2.12 | Failure |
| 7 | 09:02:20 | lab.beth | 192.0.2.12 | Success |
| 8 | 09:02:40 | lab.alex | 192.0.2.12 | Success |
| 9 | 09:03:00 | lab.alex | 192.0.2.12 | Success |

**Queue rule.** Review a successful sign-in after at least three failures by the same account from the same address in the preceding ten minutes. Only count failures since the previous success for that account and address.

1. Which success would you review? Write its ID and the IDs of the failures you counted.
2. What would go wrong if you grouped the events by address alone? Use a row from the table to explain.
3. Which detail would you request first, and how would the answer change your next action?

[Discuss your reasoning](https://github.com/JijoShibu/soc-auth-investigation/issues/1) · [Check the worked answer and run the SQLite query](README.md#evidence)
