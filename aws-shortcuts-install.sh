#!/usr/bin/env bash
set -euo pipefail

SHORTCUTS_FILE="$HOME/aws-shortcuts.sh"

cat > "$SHORTCUTS_FILE" <<'EOF'
# AWS CLI Shortcuts

# List all EC2 instances with InstanceId, State, AZ, and ASG
alias ec2ls='aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].{InstanceId:InstanceId,State:State.Name,AZ:Placement.AvailabilityZone,ASG:Tags[?Key==\`aws:autoscaling:groupName\`]|[0].Value}" \
  --output table'

# List only running EC2 instances
alias ec2run='aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].{InstanceId:InstanceId,State:State.Name,AZ:Placement.AvailabilityZone,ASG:Tags[?Key==\`aws:autoscaling:groupName\`]|[0].Value}" \
  --output table'

# Start an SSM session (pass instance ID as argument)
alias ssmcon='aws ssm start-session --target '

# CloudWatch Agent helpers (require agent installed)
alias cw-status='sudo systemctl status amazon-cloudwatch-agent'
alias cw-restart='sudo systemctl restart amazon-cloudwatch-agent && sudo systemctl status amazon-cloudwatch-agent'
alias cw-logs='sudo tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log'
alias cw-ctl='sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status'
alias cw-config='sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -s'

# Metrics in CWAgent namespace (set your region)
alias cw-metrics='aws cloudwatch list-metrics --namespace CWAgent --region REGION_HERE'

ssmput() {
  local param_type=""
  case "$3" in
    "sec")
      param_type="SecureString"
      ;;
    "str")
      param_type="String"
      ;;
    "lst")
      param_type="StringList"
      ;;
    *)
      echo "Error: Invalid type. Please use 'sec', 'str', or 'lst'." >&2
      return 1
      ;;
  esac

  aws ssm put-parameter --name "$1" --value "$2" --type "$param_type"
}

alias ssmls='aws ssm describe-parameters --query "Parameters[*].{Name:Name,Type:Type,CreatedDate:LastModifiedDate}" --output table'
EOF

chmod 644 "$SHORTCUTS_FILE"

add_source_line() {
  local rc="$1"
  local line="source \"$SHORTCUTS_FILE\""
  # create rc if missing
  [[ -f "$rc" ]] || touch "$rc"
  # add only if not present
  if ! grep -Fq "$line" "$rc"; then
    {
      echo ""
      echo "# Load custom AWS CLI shortcuts"
      echo "$line"
    } >> "$rc"
    echo "Added shortcuts to $rc"
  else
    echo "Shortcuts already present in $rc"
  fi
}

# Always configure both rc files so whichever shell you open has the aliases
add_source_line "$HOME/.zshrc"
add_source_line "$HOME/.bashrc"

# Detect current interactive shell
CURRENT_SHELL=""
if [[ -n "${ZSH_VERSION-}" ]]; then
  CURRENT_SHELL="zsh"
elif [[ -n "${BASH_VERSION-}" ]]; then
  CURRENT_SHELL="bash"
else
  # Fallback to process name (e.g., "-zsh" or "bash")
  CURRENT_SHELL="$(ps -p $$ -o comm= | sed 's/^-//')"
fi

echo "$CURRENT_SHELL"
# Source the appropriate rc file in the current session, if interactive
case "$CURRENT_SHELL" in
  zsh)  # shellcheck disable=SC1090
        source "$HOME/.zshrc" || true ;;
  bash) # shellcheck disable=SC1090
        source "$HOME/.bashrc" || true ;;
  *)    echo "Unknown current shell ($CURRENT_SHELL). Open a new terminal to load aliases." ;;
esac

echo "✅ AWS CLI shortcuts installed." 
echo "Open a new terminal or run:"
echo ""
echo "exec $CURRENT_SHELL -l"
echo ""
echo "to ensure they load in login shells."
echo "ℹ️ Reminder: edit $SHORTCUTS_FILE to set the correct AWS region for 'cw-metrics'."
