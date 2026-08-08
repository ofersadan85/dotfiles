# Return immediately if uv is not found
if (( ! ${+commands[uv]} )); then
  return
fi

alias uv="noglob uv"

alias uva='uv add'
alias uvexp='uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet'
alias uvi='uv init'
alias uvinw='uv init --no-workspace'
alias uvl='uv lock'
alias uvlr='uv lock --refresh'
alias uvlu='uv lock --upgrade'
alias uvp='uv pip'
alias uvpi='uv python install'
alias uvpl='uv python list'
alias uvpu='uv python uninstall'
alias uvpy='uv python'
alias uvpp='uv python pin'
alias uvr='uv run'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvsr='uv sync --refresh'
alias uvsu='uv sync --upgrade'
alias uvtr='uv tree'
alias uvup='uv self update'
alias uvv='uv venv'

