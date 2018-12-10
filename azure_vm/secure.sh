# Define this per team and stage for use with azure
export TF_VAR_product=ac
export TF_VAR_env=d

# Define secrets elsewhere
#export ARM_CLIENT_ID=
#export ARM_CLIENT_SECRET=
#export ARM_SUBSCRIPTION_ID=
#export ARM_TENNANT_ID=

# The same but now for Terraform
export TF_VAR_azurerm_subscription_id=${ARM_SUBSCRIPTION_ID}
export TF_VAR_azurerm_client_id=${ARM_CLIENT_ID}
export TF_VAR_azurerm_client_secret=${ARM_CLIENT_SECRET}
export TF_VAR_azurerm_tenant_id=${ARM_TENNANT_ID}
export TF_VAR_organization=bas
export TF_VAR_resource_group_name=${TF_VAR_organization}-${TF_VAR_product}-${TF_VAR_env}

