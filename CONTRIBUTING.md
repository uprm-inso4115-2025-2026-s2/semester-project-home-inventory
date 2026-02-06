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
This guide outlines the complete workflow for contributing to the Home Inventory project. All team members must follow these processes to ensure smooth collaboration and high-quality deliverables.

---

## 🔄 Workflow Summary

```
1. Create Issue → 2. Create Branch → 3. Work → 4. Commit → 5. Create PR → 6. Team Lead Review → 7. Manager Review
```

**Step-by-Step:**
1. **Create Issue** - Use template, tag manager, add labels
2. **Create Branch** - From issue page, branch from team's sub-branch
3. **Work** - Code + AsciiDoc documentation
4. **Commit** - Include issue number in message
5. **Create PR** - Target team's sub-branch, use template
6. **Team Lead Review** - Merge to team branch
7. **Manager Review** - Merge to main, close issue

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
2. **Click "Create a branch"** on the right side of the issue page
   - This automatically links your branch to the issue
2. **Branch from your team's sub-branch**:
   - Documentation Team: `documentation/issue-XX`
   - Research Team: `research/issue-XX`
   - Design Team: `design/issue-XX`
   - Tech Stack Team: `tech-stack/issue-XX`
4. **Pull the branch to your local machine or use VSCode linked feature**
   ```powershell
   git fetch origin
   git checkout <branch-name>
   ```

### During Development
- Write code following the `STYLE_GUIDE.md`
- Update AsciiDoc files in `/docs` folder
- Test your changes thoroughly
- Keep commits small and focused

---

## 🌳 Branch Strategy

### Branch Structure
```
main (protected - manager only)
├── documentation/
│   ├── documentation/issue-42
│   └── documentation/domain-sketch
├── research/
│   ├── research/issue-28
│   └── research/api-evaluation
├── design/
│   ├── design/issue-89
│   └── design/ui-mockups
└── tech-stack/
    ├── tech-stack/issue-15
    └── tech-stack/database-evaluation
```

### Branch Naming Convention
**Format:** `<team>/<issue-number>` or `<team>/<descriptive-name>`

**Examples:**
- `documentation/issue-42`
- `research/api-evaluation`
- `design/notification-ui`
- `tech-stack/database-schema`

**Rules:**
- Always branch from your team's sub-branch
- Use lowercase and hyphens
- Include issue number when possible
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

```
research(api): evaluate ZXing barcode library (#28)

Completed evaluation of ZXing for barcode scanning capabilities.
Results documented in /docs/research/barcode-apis.adoc

Fixes #28
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
   - **IMPORTANT:** Set base branch to your team's sub-branch (NOT main)
     - Example: `documentation/issue-42` → `documentation`

3. **Fill out the PR template**
   - [ ] Link to issue: `Closes #XX`
   - [ ] Describe what changed
   - [ ] Explain why change was necessary
   - [ ] Complete checklist items:
     - [ ] Code follows project style guidelines
     - [ ] Self-review completed
     - [ ] Documentation updated (if applicable)
     - [ ] Branch is up to date with base branch
   - [ ] Add testing information (if applicable)
   - [ ] Add screenshots/videos (if applicable)

4. **Tag your team lead** for review

### PR Requirements
- All checklist items must be completed
- Feature implementation complete (if applicable)
- AsciiDoc documentation updated
- No merge conflicts
- Descriptive title and description
- Link to relevant rubrics/requirements

---

## 👁️ Code Review

### For Team Members (PR Authors)
**Before Requesting Review:**
- [ ] Self-review your changes
- [ ] Run any available tests
- [ ] Check for console errors
- [ ] Verify documentation is complete
- [ ] Ensure code follows style guide

**During Review:**
- Respond to feedback promptly
- Be open to suggestions
- Ask questions if feedback is unclear
- Make requested changes in new commits
- Request re-review after changes

### For Team Leads
**Review Responsibilities:**
1. **Code Quality**
   - [ ] Follows Google style guidelines
   - [ ] Logic is correct and efficient
   - [ ] Error handling is appropriate
   - [ ] No security vulnerabilities

2. **Documentation**
   - [ ] AsciiDoc files updated in `/docs`
   - [ ] Code comments are clear
   - [ ] Changes align with rubric requirements

3. **Testing**
   - [ ] Tests pass (if applicable)
   - [ ] Manual testing completed

4. **Process**
   - [ ] PR template completed
   - [ ] Issue is properly linked
   - [ ] No merge conflicts

**After Approval:**
1. Merge PR to team's sub-branch
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

**After Approval:**
1. Merge to `main` (protected branch)
2. Delete team's feature branch
3. Close related issue
4. Update project board

### Review Guidelines
- **Be respectful and constructive**
- **Explain reasoning** behind suggestions
- **Focus on logic**, not personal preferences
- **Approve when code meets standards**
- **Use GitHub's review features** (comment, request changes, approve)

---

## 📚 Documentation Requirements

### AsciiDoc Standards
- **Format:** All documentation in AsciiDoc (`.adoc`)
- **Location:** `/docs` folder
- **Structure:**
  - Informative: Current situation and needs analysis
  - Descriptive: Domain sketch and system overview
  - Analytic: Concept analysis and technical details

### When to Update Documentation
Update `/docs` files when making changes that affect:
- Requirements or user stories
- System architecture
- APIs or interfaces
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
