# Get the comments from a pull request

Read this file when the user gives a PR number or a branch, but no comments. If `gh` is not logged in, ask the user to paste the open threads.

```bash
gh pr view <n> --json reviews,comments
gh api graphql --paginate -F owner='{owner}' -F name='{repo}' -F number=<n> -f query='
query($owner: String!, $name: String!, $number: Int!, $endCursor: String) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      reviewThreads(first: 100, after: $endCursor) {
        nodes {
          id isResolved isOutdated path line
          comments(last: 100) { nodes { fullDatabaseId author { login } body } }
        }
        pageInfo { hasNextPage endCursor }
      }
    }
  }
}' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)'
```

The first command gives the review bodies and the conversation comments. The second command gives the open inline threads.

Do not use these items:

- Resolved threads.
- Empty review bodies.
- Threads that you answered in an earlier round. If the reviewer wrote after your answer, use the thread.
