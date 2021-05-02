
variable "svc_prefix" {}

locals {
  uspool      = format("%s_user_pool", var.svc_prefix)
  uspoolc     = format("%s_user_pool_client", var.svc_prefix)
  idpool      = format("%s_identity_pool", var.svc_prefix)
  idpoolauth  = format("%s_identitypool_authenticated", var.svc_prefix)
  idpoolauthp = format("%s_identitypool_authenticated_policy", var.svc_prefix)
  grname      = format("%s_group", var.svc_prefix)
  grpoli      = format("%s_group_policy", var.svc_prefix)
  usname      = format("%s_user", var.svc_prefix)
}

