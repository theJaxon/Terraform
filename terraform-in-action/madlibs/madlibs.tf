terraform {
  required_version = "~>1.2.2"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

locals {
  uppercase_words = { for key, value in var.words : key => [for item in value : upper(item)] }

  # Get list of template files that will be used 
  templates = tolist(fileset(path.module, "templates/*.tftpl"))
}

resource "random_shuffle" "random_nouns" {
  count = var.number_of_files
  input = local.uppercase_words["nouns"]
}

resource "random_shuffle" "random_adjectives" {
  count = var.number_of_files
  input = local.uppercase_words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
  count = var.number_of_files
  input = local.uppercase_words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
  count = var.number_of_files
  input = local.uppercase_words["adverbs"]
}

resource "random_shuffle" "random_numbers" {
  count = var.number_of_files
  input = local.uppercase_words["numbers"]
}

resource "local_file" "mad_libs" {
  count    = var.number_of_files
  filename = "madlibs/madlibs-${count.index}.txt"
  content = templatefile(element(local.templates, count.index),
    {
      nouns      = random_shuffle.random_nouns[count.index].result
      adjectives = random_shuffle.random_adjectives[count.index].result
      verbs      = random_shuffle.random_verbs[count.index].result
      adverbs    = random_shuffle.random_adverbs[count.index].result
      numbers    = random_shuffle.random_numbers[count.index].result

  })
}

data "archive_file" "mad_libs" {
  type        = "zip"
  source_dir  = "${path.module}/madlibs"
  output_path = "${path.module}/madlibs.zip"
  depends_on  = [local_file.mad_libs]
}
