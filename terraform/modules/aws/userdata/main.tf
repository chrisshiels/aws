data "template_file" "user-data" {
  template = "${file("user-data.tpl")}"

  vars {
  }
}
