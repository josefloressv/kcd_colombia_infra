output "alb_http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_https_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main.zone_id
}