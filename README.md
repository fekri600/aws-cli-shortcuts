Got it — you renamed the installer to **`aws-shortcuts-install.sh`**.

Here’s the **updated `README.md`** with the correct script name reflected everywhere:

---

```markdown
# AWS CLI Shortcuts

A simple set of **Bash shortcuts (aliases)** to make working with the AWS CLI faster and easier.  
Instead of typing long `aws ec2 describe-instances` commands with complex `--query` filters every time, you can now use:

- `ec2ls` – List all EC2 instances (Instance ID, State, Availability Zone, ASG name)
- `ec2run` – List only running EC2 instances
- `ssmcon <instance-id>` – Connect to an instance via AWS SSM Session Manager

Example output of `ec2ls`:

```

---

\|                                          DescribeInstances                                         |
+------------------------------------------------+-------------+----------------------+--------------+
\|                       ASG                      |     AZ      |     InstanceId       |    State     |
+------------------------------------------------+-------------+----------------------+--------------+
\|  CodeDeploy\_i2507bluegreen-demo-dg\_d-D77YEWY5E |  us-east-1b |  i-0207b2c4b38407fda |  running     |
\|  terraform-2025072901182320100000000d          |  us-east-1b |  i-0e07f67a9354a6a29 |  terminated  |
\|  terraform-2025072901182320100000000d          |  us-east-1a |  i-05e41ad4e036cc379 |  terminated  |
\|  CodeDeploy\_i2507bluegreen-demo-dg\_d-D77YEWY5E |  us-east-1a |  i-00f03e615fd3d49fe |  running     |
+------------------------------------------------+-------------+----------------------+--------------+

```

Example output of `ec2run`:

```

---

\|                                        DescribeInstances                                        |
+------------------------------------------------+-------------+----------------------+-----------+
\|                       ASG                      |     AZ      |     InstanceId       |   State   |
+------------------------------------------------+-------------+----------------------+-----------+
\|  CodeDeploy\_i2507bluegreen-demo-dg\_d-D77YEWY5E |  us-east-1b |  i-0207b2c4b38407fda |  running  |
\|  CodeDeploy\_i2507bluegreen-demo-dg\_d-D77YEWY5E |  us-east-1a |  i-00f03e615fd3d49fe |  running  |
+------------------------------------------------+-------------+----------------------+-----------+

```

And connecting to SSM:
```

ssmcon i-0207b2c4b38407fda

Starting session with SessionId: terraform\_user-g23dkpd7oy8axeo9gz3ku4toz4
sh-4.2\$

````

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

or for running instances only:

```bash
ec2run
```

---

## Prerequisites

1. **AWS CLI** installed and configured:

   * [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   * Run `aws configure` to set your credentials.

2. **AWS SSM Session Manager Plugin**
   (Required for `ssmcon <instance-id>`)

### MacBook (tested)

```bash
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```

Verify:

```bash
session-manager-plugin
```

### Windows (not tested by me)

Follow the official AWS guide:
[SSM Plugin for Windows Installation](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#windows-install)

---

## Installation

Clone this repo and run the installer:

```bash
git clone https://github.com/<your-username>/aws-cli-shortcuts.git
cd aws-cli-shortcuts
chmod +x aws-shortcuts-install.sh
./aws-shortcuts-install.sh
```

This will:

* Create `~/aws-shortcuts.sh` with the aliases.
* Add `source ~/aws-shortcuts.sh` to your `~/.bashrc` (if not already present).
* Reload your shell so the shortcuts are immediately available.

---

## Usage

* List **all EC2 instances** (Instance ID, State, AZ, ASG):

  ```bash
  ec2ls
  ```
* List **running EC2 instances**:

  ```bash
  ec2run
  ```
* Connect to a server via **SSM Session Manager**:

  ```bash
  ssmcon <instance-id>
  ```

---

## Updating Shortcuts

To update your shortcuts, edit `aws-shortcuts-install.sh` (or add new aliases there) and re-run:

```bash
./aws-shortcuts-install.sh
```

---

## License

MIT License. Free to use and share.

```

---

Would you like me to now:  
1. **Write the full `aws-shortcuts-install.sh` (with the updated ASG-enabled aliases)** so you can commit both files?  
2. Or also **generate the `.gitignore` and a minimal `Makefile`** so your repo is fully polished?  
3. Or **package the entire repo as a zip (ready to push to GitHub)**?  

Which do you prefer? Or **all three**?
```
