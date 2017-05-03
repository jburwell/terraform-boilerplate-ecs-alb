/**
 * Root zone for route53
 */
resource "aws_route53_zone" "primary" {
    name       = "${var.project_zone}"
    comment    = "Zone for ${var.project}"

    tags {
        name = "${var.project_zone}"
        Group = "${var.project_zone}"
    }
}

/**
 * NS Records
 */
resource "aws_route53_record" "ns" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.project_zone}"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.primary.name_servers.0}",
        "${aws_route53_zone.primary.name_servers.1}",
        "${aws_route53_zone.primary.name_servers.2}",
        "${aws_route53_zone.primary.name_servers.3}"
    ]
}

/**
 * Route53 record (apex)
 */
resource "aws_route53_record" "apex" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "${var.project_zone}"
    type = "A"
    alias {
        name = "${aws_alb.front.dns_name}"
        zone_id = "${aws_alb.front.zone_id}"
        evaluate_target_health = true
    }
}

/**
 * Route53 record (api)
 */
resource "aws_route53_record" "api" {
    zone_id = "${aws_route53_zone.primary.zone_id}"
    name = "api.${var.project_zone}"
    type = "A"
    alias {
        name = "${aws_alb.front.dns_name}"
        zone_id = "${aws_alb.front.zone_id}"
        evaluate_target_health = true
    }
}

