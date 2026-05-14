module "network" {
  source = "./modules/network"
}
module "computing" {
  source = "./modules/computing"
  core_internal_id  = module.network.core_internal_id
  spoke_internal_id = module.network.spoke_internal_id
}
