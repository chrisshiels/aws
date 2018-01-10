data "template_file" "user-data" {
  template = "${file(format("%s/files/user-data.tpl", path.module))}"

  vars {
  }
}
