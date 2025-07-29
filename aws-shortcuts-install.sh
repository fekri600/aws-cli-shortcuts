#!/bin/bash
# install.sh - Installs AWS CLI shortcuts automatically

set -e

# Location for the shortcuts script
SHORTCUTS_FILE="$HOME/aws-shortcuts.sh"

# Create the shortcuts file (overwrite if it exists)
cat > "$SHORTCUTS_FILE" <<'EOF'
# AWS CLI Shortcuts

# List all EC2 instances with InstanceId, State, AZ, and ASG
alias ec2ls='aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].{InstanceId:InstanceId,State:State.Name,AZ:Placement.AvailabilityZone,ASG:Tags[?Key==\`aws:autoscaling:groupName\`]|[0].Value}" \
  --output table'

# List only running EC2 instances with InstanceId, State, AZ, and ASG
alias ec2run='aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].{InstanceId:InstanceId,State:State.Name,AZ:Placement.AvailabilityZone,ASG:Tags[?Key==\`aws:autoscaling:groupName\`]|[0].Value}" \
  --output table'

# Start an SSM session (pass instance ID as argument)
alias ssmcon='aws ssm start-session --target '

EOF

# Make it executable
chmod +x "$SHORTCUTS_FILE"

# Add to .bashrc if not already present
if ! grep -q "source $SHORTCUTS_FILE" "$HOME/.bashrc"; then
    echo "source $SHORTCUTS_FILE" >> "$HOME/.bashrc"
    echo "Added to ~/.bashrc"
fi

# Reload the shell so aliases are active now
source "$HOME/.bashrc"

echo "✅ AWS CLI shortcuts installed. Try running 'ec2ls' or 'ec2run'."
