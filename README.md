# GitHowTo - Practical Git Learning Project

## Project Description
The objective of this project was to complete the **GitHowTo** practical exercises and master the fundamentals of the **Git** version control system and its standard workflow. During this project, a local repository was initialized, changes were tracked, branches were managed, and the repository was synchronized with GitHub.

---

## What I Learned
Through this project, I gained hands-on experience with core Git commands, learned to manage file states (*untracked, staged, committed*), and practiced fundamental branching and merging workflows.

### Topics Covered:
* Initializing repositories and tracking files
* Saving changes via commits and inspecting history
* Creating, switching, and merging branches
* Connecting local repositories to remote hosts (GitHub) and using `push`/`pull` operations

---

## Essential Git Commands

The primary commands utilized throughout the workflow include:

* `git status` — Checks the current state of files in the working directory and staging area.
* `git add` — Adds changes to the staging area.
* `git commit` — Saves staged changes to the repository history with a descriptive message.
* `git log` — Displays the commit history log.
* `git branch` — Lists, creates, or deletes branches.
* `git switch` — Switches to a specified branch (alternative to `git checkout`).
* `git merge` — Merges specified branch history into the currently active branch.

### Example Standard Git Workflow:

```bash
# 1. Check current repository status
git status

# 2. Stage updated files
git add .

# 3. Commit staged changes with a descriptive message
git commit -m "Updated README.md documentation"

# 4. Push local changes to the remote GitHub repository
git push origin main
