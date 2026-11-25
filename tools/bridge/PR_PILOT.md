# Bridge v0.4 pilot

Draft implementation, not verified on Windows. Only a disposable root file is permitted. The approved base must be the current development branch head at clone time. The bridge checks exact scope and content, commits and pushes a unique branch, opens a draft PR, and reports cleanup. Never merge the pilot PR. No application code changes. A failed PR creation can leave a published branch; inspect result. Git authentication and commit hooks remain environmental dependencies. Negative tests and full isolation remain unverified. No unattended execution.
