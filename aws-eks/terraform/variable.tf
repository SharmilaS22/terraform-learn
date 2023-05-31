variable "sg_ports" {
  type    = list(number)
  default = [22, 80, 443]
}