# Milestone Data

## Date Generated: 2026-02-10
| Developer | Points Closed | Percent Contribution | Indivudal Grade | Milestone Grade | Lecture Topic Tasks |
| --------- | ------------- | -------------------- | --------------- | --------------- | ------------------- |
| Total | 0 | /100% | /100% | /100% | 0 |


## Sprint Task Completion

| Developer | Sprint 1<br>2026/02/10, 03:14 AM<br>2026/02/10, 03:14 AM | Sprint 2<br>2026/02/10, 03:14 AM<br>2026/02/10, 03:14 AM |
|---|---|---|

## Weekly Discussion Participation

| Developer | Week #1 | Week #2 | Week #3 | Week #4 | Penalty |
|---|---|---|---|---|---|

## Point Percent by Label

# Metrics Generation Logs

| Message |
| ------- |
| WARNING: list index out of range |
| ERROR: Error executing query: [{'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 6, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'title' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}, {'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 7, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'number' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}, {'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 8, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'public' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}, {'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 9, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'url' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}] |
| Traceback (most recent call last): |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateMilestoneMetricsForActions.py", line 100, in generateMetricsFromV2Config |
|     team_metrics = getTeamMetricsForMilestone( |
|                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^ |
|   File "/opt/hostedtoolcache/Python/3.11.14/x64/lib/python3.11/concurrent/futures/thread.py", line 58, in run |
|     result = self.fn(*self.args, **self.kwargs) |
|              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 301, in getLectureTopicTaskMetricsFromIssues |
|     for issue in issues: |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 376, in queueIteratorNext |
|     raise value |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 477, in getTeamMetricsForMilestone |
|     for issue in getIteratorFromQueue(issueMetricsQueue): |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 376, in queueIteratorNext |
|     raise value |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 358, in iteratorSplitter |
|     for item in iterator: |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 234, in fetchProcessedIssues |
|     for issue_dict in fetchIssuesFromGithub(org=org, team=team, logger=logger): |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/generateTeamMetrics.py", line 174, in fetchIssuesFromGithub |
|     project = getProject(organization=org, project_name=team) |
|               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/getProject.py", line 29, in getProject |
|     response: dict = runGraphqlQuery(query=get_projects_query, variables=params) |
|                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ |
|   File "/home/runner/work/semester-project-home-inventory/semester-project-home-inventory/inso-gh-query-metrics/src/utils/queryRunner.py", line 68, in runGraphqlQuery |
|     raise ConnectionError(f"Error executing query: {response_dict['errors']}") |
| ConnectionError: Error executing query: [{'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 6, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'title' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}, {'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 7, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'number' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}, {'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 8, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'public' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}, {'type': 'INSUFFICIENT_SCOPES', 'locations': [{'line': 9, 'column': 17}], 'message': "Your token has not been granted the required scopes to execute this query. The 'url' field requires one of the following scopes: ['read:project'], but your token has only been granted the: ['read:org', 'repo'] scopes. Please modify your token's scopes at: https://github.com/settings/tokens."}] |
