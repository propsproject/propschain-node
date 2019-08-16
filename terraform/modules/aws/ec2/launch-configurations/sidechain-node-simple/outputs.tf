output "node_ip" {
  value = "${aws_eip.sidechain_eip.*.public_ip}"
}
