resource "aws_route53_record" "record" {
  count = "${var.r53_records_len}"
  zone_id = "${var.r53_zone_id}"
  name =
    "${element(split(":", element(var.r53_records, count.index)),
               0)}.${var.name}"
  ttl =
    "${element(split(":", element(var.r53_records, count.index)),
               1)}"
  type =
    "${element(split(":", element(var.r53_records, count.index)),
               2)}"
  records = [
    "${element(split(":", element(var.r53_records, count.index)),
               3)}"
  ]
}
