# claude

Shared skills and global policy for Claude Code. This folder is part of the dotfiles repo.

## Setup

Run `install.sh` from the repo root. It symlinks:
- `claude/CLAUDE.md` to `~/.claude/CLAUDE.md`
- each `claude/skills/<name>/` to `~/.claude/skills/<name>`
- `claude/statusline-command.sh` to `~/.claude/statusline-command.sh`

`claude/settings.json` is not linked. `install.sh` merges it into `~/.claude/settings.json`:
- The repo copy holds only settings that are safe to share and work on any machine.
- The live file keeps keys for this machine only, such as `autoMode`. Claude Code writes `autoMode` from a scan of your machine. This repo is public, so that key must never be in it.
- To share a new setting, add it to `claude/settings.json` and run `install.sh` again.

Edits in this folder are live right away. You do not need to run the install again, except after you add a new skill.

The install script moves an existing real skill folder to `~/.claude/skills-backup/` before it links. It does not touch skills from other sources.

## Structure

```
CLAUDE.md                   Global policy: language rules, hard constraint, execution rule
skills/<name>/SKILL.md      One skill. Loaded when its description matches the task.
skills/<name>/references/   Long detail that SKILL.md links to. Loaded only when needed.
skills/<name>/evals/        Trigger evals for the skill. Claude does not load them.
scripts/check_skills.py     Checks that every skill follows the rules below.
```

Skills:
- `workflow`: understand, plan, implement, verify, and PR discipline
- `make-a-branch`: branch naming and the single-purpose rule
- `make-a-commit`: small, valid commits with plain messages
- `make-a-code-comment`: plain comments, bug references, and HACK labels
- `debugging`: reproduce, find the root cause, then fix
- `writing-skills`: repo rules for adding and tuning skills
- `tdd`: test-first loop of red, green, refactor
- `testing`: what good tests look like and the PR test rule
- `code-review`: strict maintainability review with a review record
- `deslop`: remove AI-generated slop from a diff
- `shipping`: the pre-PR gate, PR size, and the preflight checklist
- `create-a-pr`: PR title and description format
- `fix-merge-conflicts`: resolve conflicts and confirm the build
- `verify-this`: prove a claim with baseline and treatment evidence

`CLAUDE.md` is short. It holds only rules that must apply in every session. Everything else lives in skills.

## Skill rules

- The folder name and the `name` field are the same.
- The `description` says when to use the skill. It names the requests that should load it.
- `SKILL.md` is at most 150 lines. Move long detail to `references/` and link to it.
- Each skill has `evals/triggers.json` with at least 5 prompts that should trigger it and 5 that should not.

Run the check and its tests before you open a PR:

```bash
cd claude
python3 scripts/check_skills.py
python3 -m unittest discover -s tests
```

## Adding a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter.
2. Write `skills/<name>/evals/triggers.json`. Use realistic prompts. Make the should-not-trigger prompts near misses.
3. Run the trigger evals and tune the description. See below.
4. Run `python3 scripts/check_skills.py`.
5. Run `../install.sh` to link the new skill.

## Evals

Each `triggers.json` is a list of `{"query": "...", "should_trigger": true|false}`. It tests one thing. The skill description must make Claude load the skill for the right prompts and ignore the wrong ones.

Run the evals with the `skill-creator` scripts. Run them from a folder that has a `.claude/` directory. The runner writes a temporary command file there.

```bash
SC=<path to the skill-creator skill>
PYTHONPATH=$SC python3 $SC/scripts/run_eval.py \
  --eval-set skills/<name>/evals/triggers.json \
  --skill-path skills/<name> \
  --runs-per-query 3 --verbose
```

To tune the description, use `$SC/scripts/run_loop.py` with the same arguments plus `--model <model-id>`. It splits the prompts into train and test sets and proposes better descriptions. Apply the best description by hand and run the check again.

The skill you test is usually also installed in `~/.claude/skills`. The installed copy can load instead of the test copy, and the stock runner then reports 0 triggers. Count a trigger on the real skill name to avoid this. See `skills/writing-skills/SKILL.md` for cost rules and tips.

These runs are real model runs and cost tokens.
