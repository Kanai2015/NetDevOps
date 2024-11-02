# This repository will detail steps required to setup Global network using Cloud WAN with automated deployment using github action. 

# Following Terraform scripts are used to deploy Global unified network using AWS Network Manager service

    *coreNetworkPolicy.tf 
    ec2.tf
    IAM.tf
    main.tf
    multivpc.tf           
    provider.tf
    variable.tf *

# *Deployment role needs to have permission with action 
# "Action": "networkmanager:*" to create segments, attachment *

```markdown
workflow_dispatch:
    inputs:
      destroy:
        type: boolean
        description: 'Destroy infrastructure'
        required: true
        default: false
```
# Workflow dispatcher has been configured in terraform.yml file . It will fecilitate destroy of entire infra from github action in default branch.
