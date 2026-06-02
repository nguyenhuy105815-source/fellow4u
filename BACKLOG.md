# Backlog Workflow

This repository uses GitHub Issues as the product backlog.

## Status Flow

- `todo`: work has not started
- `in-progress`: work is actively being implemented
- `done`: completed and merged

## Priority Guide

- `P0`: must fix now
- `P1`: high value and should be in current sprint
- `P2`: normal priority
- `P3`: nice to have

## Recommended Labels

- type: `story`, `task`, `bug`
- flow: `todo`, `in-progress`, `done`
- planning: `backlog`

## Board Setup (GitHub Projects)

Create a project board with 3 columns:

1. `To do`
2. `In progress`
3. `Done`

Then add issue filters:

- To do: `label:todo`
- In progress: `label:in-progress`
- Done: `label:done`

## Sprint Routine

1. Create issues using templates: Story, Task, Bug.
2. Add `priority` and `type` labels.
3. Move selected items to sprint by assigning milestone.
4. Update status label daily.
5. Close issue only after merged PR and verification.
