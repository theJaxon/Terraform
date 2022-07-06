variable "words" {
  description = "Word pool for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(number)
  })

  validation {
    condition     = length(var.words["nouns"]) >= 12
    error_message = "At least 12 nouns must be provided"
  }

  validation {
    condition     = length(var.words["adverbs"]) >= 5
    error_message = "At least 20 adverbs must be provided"
  }
}
