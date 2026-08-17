# Four vanilla cases

All questions are sent unchanged to the agent recorded in each run's `metadata.txt`. The expected outcomes are for human grading only and are never passed to the agent.

| ID | User question | Required observation | Expected result |
| --- | --- | --- | --- |
| A | 订单最多的用户是谁？他的订单完成率是多少？ | Result 1 must identify the customer; result 2 must calculate for that same customer. | Evan; 10 orders; 7/10 = 70%. |
| B | 在 2026-08-03 至 2026-08-09 和 2026-08-10 至 2026-08-16 两个固定比较周中，完成订单 GMV 下降最多的地区是哪里？再在该地区找下降最多的品类。 | The category query must be constrained by the region returned in step 1. | East; Electronics (1,300 to 100, decline 1,200). |
| C | 本周转化率下降，基于 fixture 的固定对比周分析原因。 | Diagnosis must inspect a component breakdown, not merely repeat the aggregate. | 10% to 5%; new users drive the decline (10% to 2%); returning stays 10%. |
| D | 如果转化率下降主要由新用户造成，就继续看渠道；否则分析老用户复购。 | The chosen next action must follow the observed segment result. | New-user branch; paid_social has the largest decline (10% to 1.2%). |

For every run, record `Completed`, `Correct`, `Intermediate Result Used`, `Adaptive`, `Clarified When Needed`, and a single primary failure label from `retrieval`, `planning`, `state propagation`, `execution`, `reasoning`, or `UX`.
