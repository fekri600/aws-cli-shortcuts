
# AWS CLI Shortcuts

A simple set of **Bash shortcuts (aliases)** to make working with the AWS CLI faster and easier.  
Instead of typing long `aws ec2 describe-instances` commands with complex `--query` filters every time, you can now use:

- `ec2ls` – List all EC2 instances (Instance ID, State, Availability Zone, ASG name)
- `ec2run` – List only running EC2 instances
- `ssmcon <instance-id>` – Connect to an instance via AWS SSM Session Manager

---

## Why Use This?

Instead of typing:
```bash
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].{InstanceId:InstanceId,State:State.Name,AZ:Placement.AvailabilityZone,ASG:Tags[?Key==\`aws:autoscaling:groupName\`]|[0].Value}" \
  --output table
````

You can just run:

```bash
ec2ls
```

Or for running instances only:

```bash
ec2run
```

To connect to a server via SSM:

```bash
ssmcon <instance-id>
```

---

## Example Outputs

### `ec2ls`

```text
------------------------------------------------------------------------------------------------------
|                                          DescribeInstances                                         |
+------------------------------------------------+-------------+----------------------+--------------+
|                       ASG                      |     AZ      |     InstanceId       |    State     |
+------------------------------------------------+-------------+----------------------+--------------+
|  CodeDeploy_i2507bluegreen-demo-dg_d-D77YEWY5E |  us-east-1b |  i-0207b2c4b38407fda |  running     |
|  terraform-2025072901182320100000000d          |  us-east-1b |  i-0e07f67a9354a6a29 |  terminated  |
|  terraform-2025072901182320100000000d          |  us-east-1a |  i-05e41ad4e036cc379 |  terminated  |
|  CodeDeploy_i2507bluegreen-demo-dg_d-D77YEWY5E |  us-east-1a |  i-00f03e615fd3d49fe |  running     |
+------------------------------------------------+-------------+----------------------+--------------+
```

### `ec2run`

```text
---------------------------------------------------------------------------------------------------
|                                        DescribeInstances                                        |
+------------------------------------------------+-------------+----------------------+-----------+
|                       ASG                      |     AZ      |     InstanceId       |   State   |
+------------------------------------------------+-------------+----------------------+-----------+
|  CodeDeploy_i2507bluegreen-demo-dg_d-D77YEWY5E |  us-east-1b |  i-0207b2c4b38407fda |  running  |
|  CodeDeploy_i2507bluegreen-demo-dg_d-D77YEWY5E |  us-east-1a |  i-00f03e615fd3d49fe |  running  |
+------------------------------------------------+-------------+----------------------+-----------+
```

### `ssmcon`

```text
ssmcon i-0207b2c4b38407fda

Starting session with SessionId: terraform_user-g23dkpd7oy8axeo9gz3ku4toz4
sh-4.2$
```

---

## Installation

1. Clone this repo:

```bash
git clone https://github.com/<your-username>/aws-cli-shortcuts.git
cd aws-cli-shortcuts
```

2. Run the installer:

```bash
chmod +x aws-shortcuts-install.sh
./aws-shortcuts-install.sh
```

This will:

* Create `~/aws-shortcuts.sh` with the aliases.
* Add `source ~/aws-shortcuts.sh` to your `~/.bashrc` (if not already present).
* Reload your shell so the shortcuts are available immediately.

---

## Prerequisites

1. **AWS CLI** – [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   Configure it using:

   ```bash
   aws configure
   ```

2. **SSM Session Manager Plugin** – required for `ssmcon`

### Mac (tested)

```bash
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```

Verify:

```bash
session-manager-plugin
```

### Windows (not tested)

Follow AWS official guide:
[SSM Plugin for Windows](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#windows-install)

---

## Updating Shortcuts

If you add new aliases, edit `aws-shortcuts-install.sh` and re-run:

```bash
./aws-shortcuts-install.sh
```

---

## License

MIT License. Free to use and share.

```

---

Would you like me to also **provide the same for the `aws-shortcuts-install.sh` file** (so you can copy/paste without breaking formatting)?  
Or **bundle both (README + script) in one clean block so you can just paste them into your repo directly**? Which do you prefer?
```
