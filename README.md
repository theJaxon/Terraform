# Terraform
Terraform related projects

### Useful Tips
#### Cache the Provider Plugins
- Providers can be cached by using `TF_PLUGIN_CACHE_DIR` so that instead of having to download them each time you run `terraform init`, terraform will check initially if they exist in that directory and if they're there then they won't be downloaded

#### Download Plugins and use them from specific directory
- In cases of having connectivity issues you can use the variable `TF_PLUGIN_DIR` to point to some location where plugins already exist so that they can be used

#### Increase Verbosity for Debugging 
- `TF_LOG` ENV var can be set to specific verbosity level to get a better insight

---

### CLI Usage 
```bash
# Format all the files in the directory
terraform fmt -recursive

# State file related
# Remove a resource from state file
terraform state rm <id>

# import a resource into state file
terraform import

# show all deployed resources 
terraform state list 

# show specifics about a resource 
terraform state show <id>

# Move resources between different state files (Useful if we want to rename resources but don't want to destroy and re-create them)
terraform state mv

# Preview state file 
terraform state pull
```

---

### Modules
- From the book Terraform in Action
- At minimum each module should have `main.tf`, `outputs.tf` and `variables.tf`

```bash
# Root Module directory structure
variables.tf # Input variables
terraform.tfvars #variable definitions (Setting the vars)
providers.tf # provider declaration
main.tf # entrypoint
outputs.tf # outputs that can be passed to child modules 
versions.tf # for provider version locking
```

---

- From the course Developing Infrastructure as Code with Terraform (LiveLessons)

### Count Attribute
- By default Terraform creates 1 resource if no count is specified
- When **count** attribute is used, Terraform is able to create **N** Number of resources

```hcl
# Create 2 S3 buckets
resources "aws_s3_bucket" "s3_bucket" {
    count = 2
    bucket = "localstack-bucket-${count.index}"
}
```
- One use case is to also set count to zero in case you want to achieve the following behavior
  1. The resource to be ignored if its not created # Debugging
  2. The resource to be destroyed if it was created

---

### For Each (Count alternative)
- Takes a map of values and iterates over it to create a resource for each item in the map
- Insetad of ~~count~~ it provides an **each** object which has a `key/value` for each object in the map

```hcl
locals {
  buckets = {
    bucket1 = "first-bucket"
    bucket2 = "second-bucket"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  for_each = local.buckets
  bucket   = "this-is-my-${each.value}"
}
```

- For each supports also lists but you should use `toset` with for each to achieve that

```hcl
locals {
  buckets = [ "first-bucket", "second-bucket"]
}

resource "aws_s3_bucket" "s3_bucket" {
  for_each = toset(local.buckets)
  bucket   = "this-is-my-${each.key}"
}
```

---

### Conditionals
```hcl
minimum_number_of_buckets = 5
number_of_buckets = var.bucket_count > 0 ? var.bucket_count : local.minimum_number_of_buckets

# Condition
var.bucket_count > 0

# If it evaluates to true
var.bucket_count

# If it evaluates to false
local.minimum_number_of_buckets
```
- Whatever gets returned is assigned to `number_of_buckets` variable

```hcl
variable "bucket_count" {
    type = number
}

locals {
    minimum_number_of_buckets = 5
    number_of_buckets = var.bucket_count > 1 ? var.bucket_count : local.minimum_number_of_buckets 
}
```

---

### Built In Functions
```hcl
locals {
  // Returns current date and time
  // Example for returned output from invoking the function via terraform cli
  // "2022-10-11T08:51:58Z"
  timestamp     = timestamp()
  current_year  = formatdate("YYYY", local.timestamp)
  current_month = formatdate("MMMM", local.timestamp)
  tomorrow      = formatdate("DD", timeadd(local.timestamp, "24h"))
}

output "date_time" {
  value = "${local.current_year} ${local.current_month} ${local.tomorrow}"
}

```

---

### Iteration
```hcl
locals {
  my_list = ["one", "zwei", "three"]
  # Square brackets are used to return a list
  uppercase_list = [for item in local.my_list: upper(item)]
  # Curly brackets are used to return a map
  uppercase_map_convert = { for item in local.my_list: item => upper(item) } 
}

output "iterations" {
  value = local.uppercase_map_convert
}


# Filtering 
locals {
  numbers_list = [0, 1, 2, 3, 4, 5, 6]

  # return number if the condition evaluated to true
  even_numbers = [for number in local.numbers_list: number if number % 2 == 0]
}

output "even_numbers_list" {
  value = local.even_numbers
}
```

---

### Heredocs
- For outputting documentation, can be used with a similar syntax of Jinja2
- The minus sign after the double less than sign is to indicate character stripping from the lines following

```hcl
locals {
  name = ""
}

output "your_name" {
  value = <<-EOT
    This is a `heredoc` with directives
    %{if local.name == "" }
    Plase fill in the name
    %{else}
    Hi ${local.name}
    %{endif}  
  EOT
}



locals {
  numbers_list = [0, 1, 2, 3, 4, 5, 6]
}

output "even_numbers" {
  value = <<-EOT
  %{for number in local.numbers_list}
  %{if number % 2 == 0}
  ${number} is even
  %{endif}
  %{endfor}
  EOT
} 


```

---

### Backend
- A shared storage medium that stores `statefile` and can optionally support locking to prevent statefile corruption

```hcl
  backend "s3" {
    bucket = "name"
    key    = "key"
    dynamodb_table = "lock"
  }
```

---

### Workspace
- Used in case we want same configuration across multiple environments (dev, staging, prod)
- Workspaces are a **second state file** associated with the configuration

```bash
# By default we're already using a default workspace
terraform workspace list # shows default

# Create new workspace
terraform workspace new staging

# Show the current workspace
terraform workspace show

# Select default workspace instead
terraform workspace select default
```

---

### Custom resources with Python and Null Provider
