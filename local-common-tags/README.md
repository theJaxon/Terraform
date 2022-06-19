### local-common-tags 
- To have some standard tags across all resources that will be created via Terraform, one of the approaches is to define a locals block with the desired tags and use it across the resources by referencing it in the tags sections 

```hcl
locals {
  common_tags = {
    Name        = "Test-Instance"
    Environment = "dev"
  }
}

resource "aws_instance" "web" {
  tags          = local.common_tags
}
```

- Another approach is to use [default tags feature of terraform](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider) by specifying the tags once at the provider block