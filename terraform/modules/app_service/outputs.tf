output "image_repository_uri" {
  value = length(aws_ecr_repository.app) > 0 ? aws_ecr_repository.app[0].repository_url : ""
}