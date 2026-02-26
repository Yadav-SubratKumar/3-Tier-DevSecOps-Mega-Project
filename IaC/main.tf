module "my_vm" {
  source                 = "./modules/vm"   # Path to the module folder
  resource_group_name    = "myResourceGroup"     # Pass required variables
  resource_group_location = "eastus"
  username               = "azureadmin"
  publicKey              = file("${path.module}/james_key.pub")
   # Pass the public key content
}
