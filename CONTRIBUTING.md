# Contributing Guide

## 📋 Table of Contents
- [Overview](#overview)
- [Workflow Summary](#workflow-summary)
- [Creating an Issue](#creating-an-issue)
- [Working on an Issue](#working-on-an-issue)
- [Branch Strategy](#branch-strategy)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Code Review](#code-review)
- [Documentation Requirements](#documentation-requirements)

---

## 🎯 Overview
This guide outlines the complete workflow for contributing to the Home Inventory project. We follow **Agile development principles** with feature-based teams working in parallel. All team members must follow these processes to ensure smooth collaboration and high-quality deliverables.

---

## 🔄 Workflow Summary

```
1. Create Issue → 2. Create Branch → 3. Work → 4. Commit → 5. PR to Team Branch → 6. Resolve Conflicts → 7. Team Lead Approval → 8. PR to Main → 9. Manager Approval → 10. Merge to Main
```

**Step-by-Step:**
1. **Create Issue** - Use template, tag managers (@LuisJCruz or @Kay9876), add labels
2. **Work on Branch** - From issue page, work from your team's branch
3. **Work** - Code + AsciiDoc documentation
4. **Commit** - Include issue number in message
5. **PR to Team Branch** - Create pull request targeting your team's branch
6. **Resolve Conflicts** - You resolve your own merge conflicts with team branch
7. **Team Lead Approval** - Team lead reviews and approves your PR to team branch
8. **PR to Main** - Team lead creates PR from team branch to main
9. **Manager Approval** - Manager (@LuisJCruz or @Kay9876) reviews and approves
10. **Merge to Main** - Manager merges the approved PR to main

---

## 📝 Creating an Issue

### Requirements
- Minimum **1 issue per sprint**
- Minimum **1 lecture topic task per milestone**

### Process
1. **Use the issue template** in `.github/ISSUE_TEMPLATE/`
   - Choose the template
2. **Fill out all required sections**
   - Clear title with prefix: `[Feature]:`, `[Bug]:`, `[Docs]:`, etc.
   - Complete description
   - Success criteria
   - Urgency and difficulty ratings
3. **Tag the manager** (@manager-username) for approval/assignment
4. **Add appropriate labels**:
   - `enhancement` - New features
   - `bug` - Bug fixes
   - `documentation` - Documentation updates
   - `research` - Research tasks
   - `design` - Design work
   - Priority labels: `high-priority`, `medium-priority`, `low-priority`
5. **Wait for approval** before starting work

---

## 🛠️ Working on an Issue

### Starting Work
1. **Navigate to the approved issue**
2. **Pull the latest version of your team's branch**
   ```powershell
   git checkout <team-branch>
   git pull origin <team-branch>
   ```
   Examples:
   - Documentation Team: `git checkout documentation`
   - Design Team: `git checkout design`
   - Feature Teams: `git checkout feature-team-1`

3. **Work directly on your team's branch**
   - All developers on the same team work on the same branch
   - Make changes and commit with issue number linked

### During Development
- Write code following the `STYLE_GUIDE.md`
- **Document your work in AsciiDoc** format in `/docs` folder
- Test your changes thoroughly
- Keep commits small and focused
- **Always link commits to your issue** in commit messages

---

## 🌳 Branch Strategy

### Branch Structure
```
main (protected)
├── documentation/
├── design/
├── feature-team-1/
├── feature-team-2/
└── feature-team-3/
```

**How it works:**
- Each team has ONE shared branch
- All team members work directly on their team's branch
- Developers commit to team branch and create PRs for team lead review
- Team leads approve PRs to merge commits into team branch
- Team leads create PRs from team branch → main for manager approval

### Team Branches
- **documentation** - Documentation Team's shared branch
- **design** - Design Team's shared branch  
- **feature-team-X** - Feature teams' shared branches (names TBD)

**Note:** No individual developer branches - everyone works on their team's branch directly.le
- Keep names short and descriptive

---

## 💬 Commit Guidelines

### Commit Message Format
Follow the **conventional commits** format and **include issue number**:

```
type(scope): brief description (#issue-number)

Detailed explanation (if needed)

Fixes #issue-number
```

### Commit Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style/formatting (no logic change)
- `refactor` - Code restructuring (no feature change)
- `test` - Adding or updating tests
- `chore` - Maintenance tasks
- `research` - Research findings or analysis

### Examples
```
feat(inventory): add barcode scanning feature (#42)

Implemented barcode scanning using ZXing library to allow users
to quickly add items to their inventory.

Fixes #42
```

```
docs(requirements): update user stories document (#55)

Added 3 new user stories for notification preferences.

Fixes #55
```

### Commit Best Practices
- Make atomic commits (one logical change per commit)
- Commit frequently
- Write clear, descriptive messages
- Always reference the issue number

---

## 🔀 Pull Request Process

### Creating a Pull Request

1. **Push your branch to GitHub**
   ```powershell
   git push origin <branch-name>
   ```

2. **Create PR from GitHub**
   - Go to your repository on GitHub
   - Click "Compare & pull request"
   - **IMPORTANT:** Set base branch to `main` (NOT your team's branch)
     - Example: `feature-team-1/issue-42` → `main`

3. **Fill out the PR template**
   - [ ] Link to issue: `Closes #XX`
   - [ ] Describe what changed
   - [ ] Explain why change was necessary
   - [ ] Complete checklist items:
     - [ ] Code follows project style guidelines
     - [ ] Self-review completed
     - [ ] Documentation updated (if applicable)
     - [ ] Branch is up to date with main branch
   - [ ] Add testing information (if applicable)
   - [ ] Add screenshots/videos (if applicable)

4. **Request review** from team lead or peers

### Handling Merge Conflicts

**YOU are responsible for resolving your own merge conflicts.**

1. **Pull latest changes from main**
   ```powershell
## 👁️ Code Review

### For Developers (PR Authors)
**Before Requesting Review:**
- [ ] Self-review your changes
- [ ] Run any available tests
- [ ] Check for console errors
- [ ] **AsciiDoc documentation created/updated for your work**
- [ ] Ensure code follows style guide
- [ ] **Resolve all merge conflicts with your team branch**
- [ ] **Issue number linked in commit and PR**

**During Review:**
- Respond to feedback promptly
- Be open to suggestions
- Ask questions if feedback is unclear
- Make requested changes in new commits
- **Resolve any new conflicts that arise with team branch**
- Request re-review after changes

**After Team Lead Approval:**
- Team lead merges your commit to team branch
- All team members pull latest team branch to stay updated
- Team lead handles PR from team branch to main

### For Team Leads
**Review Responsibilities for Team Branch PRs:**
1. **Code Quality**
   - [ ] Follows Google style guidelines
   - [ ] Logic is correct and efficient
   - [ ] Error handling is appropriate
   - [ ] No security vulnerabilities

2. **Documentation**
   - [ ] **AsciiDoc documentation created/updated**
   - [ ] Code comments are clear
   - [ ] Changes align with feature requirements

3. **Testing**
   - [ ] Tests pass (if applicable)
   - [ ] Manual testing completed

4. **Process**
   - [ ] PR template completed
   - [ ] Issue is properly linked
   - [ ] **No merge conflicts present with team branch**

**After Approval:**
1. Merge developer's commit to your team branch
2. Ensure team branch is up to date
3. When ready, create a new PR from your team branch → main
4. Tag managers (@LuisJCruz or @Kay9876) for review
5. Wait for manager approval
6. Manager will merge to main

### For Managers (@LuisJCruz, @Kay9876)
**Review Responsibilities for Main PRs:**
- [ ] Verify team lead approval and review
- [ ] Check overall project alignment
- [ ] Confirm milestone requirements met
- [ ] Ensure no conflicts with main branch
- [ ] Verify feature completeness
- [ ] Check that documentation content was provided

**After Approval:**
1. Approve the PR
2. Merge team branch to main
3. Close related issue (if fully complete)
4. Update project board

### Review Guidelines
- **Be respectful and constructive**
- **Explain reasoning** behind suggestions
- **Focus on logic**, not personal preferences
- **Approve when code meets standards**
- **Use GitHub's review features** (comment, request changes, approve)
- **Managers do not merge their own PRs** - Wait for the other manager
- **Focus on logic**, not personal preferences
- **Approve when code meets standards**
- **Use GitHub's review features** (comment, request changes, approve)
- **Do not merge** - Let the author merge their own PR
2. Delete the feature branch
3. Create new PR from team branch → `main`
4. Tag manager for final review

### For Manager
**Review Responsibilities:**
- [ ] Verify team lead approval
- [ ] Check overall project alignment
- [ ] Confirm milestone requirements met
- [ ] Ensure no conflicts with other teams' work
- [ ] Verify documentation completeness
## 📚 Documentation Requirements

### AsciiDoc Standards
- **Format:** All documentation in AsciiDoc (`.adoc`)
- **Location:** `/docs` folder
- **Managed by:** Documentation Team

### Documentation Team Responsibilities
- Set up and maintain AsciiDoc environment
- Follow project documentation rubric
- Integrate documentation content from all teams
- Manage documentation automation workflow
- Ensure all teams have access to updated documentation

### For Feature Teams
When working on features, provide documentation content to the Documentation Team:
- Feature descriptions and requirements
- Implementation details
- Usage instructions
- Any necessary diagrams or visuals

### When to Provide Documentation
Provide documentation content when:
- Creating new features
- Changing existing functionality
- Updating user workflows
- Making design decisions

### Documentation Workflow
1. **Feature teams create content** - Write documentation in Markdown or text
2. **Submit to Documentation Team** - Through issue or PR description
3. **Documentation Team integrates** - Converts to AsciiDoc and integrates into structure
4. **Automated updates** - Documentation Team manages automation for distributionsystem overview
  - Analytic: Concept analysis and technical details

### When to Update Documentation
Update `/docs` files when making changes that affect:
- Requirements or user stories
- System architecture
- User workflows
- Design decisions

### Documentation Checklist
- [ ] AsciiDoc syntax is correct
- [ ] Images stored in `/docs/images/`
- [ ] Cross-references are valid
- [ ] Table of contents updated (if needed)
- [ ] Linked to rubric requirements

---

## 🛠️ Tools

### Required Tools
- **GitHub Issues** - Task tracking
- **GitHub Projects** - Sprint planning and milestone tracking
- **GitHub Discussions** - Team communication and decisions
- **GitHub Pull Requests** - Code review and integration

### Recommended Tools
- Git client (command line, GitHub Desktop, etc.)
- Code editor with linter support
- AsciiDoc preview extension

---

## ❓ Questions or Problems?

- **Process questions**: Ask in GitHub Discussions
- **Technical issues**: Create an issue with `question` label
- **Urgent matters**: Contact your team lead or manager

---

**Last Updated:** February 6, 2026
