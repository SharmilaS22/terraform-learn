resource "aws_cloudfront_cache_policy" "sh_cache_policy" {
  name        = "sh-cache-policy"
  min_ttl     = 1 # in seconds

# optional
#   comment     = "test comment"
#   default_ttl = 50
#   max_ttl     = 100

#required
  parameters_in_cache_key_and_forwarded_to_origin {
    # Required: cookies_config, headers_config, query_strings_config
    cookies_config {
      cookie_behavior = "none" # none, whitelist, allExcept, all
    #   cookies { items = ["example"] }
    }
    headers_config {
      header_behavior = "none" # none, whitelist
    #   headers { items = ["example"] }
    }
    query_strings_config {
      query_string_behavior = "none" # none, whitelist, allExcept, all
    #   query_strings { items = ["example"] }
    }
  }
}

locals {
  s3_origin_id = "shS3Origin"
}

resource "aws_cloudfront_distribution" "sh_s3_distribution" {

  origin { # required
    domain_name              = aws_s3_bucket.sh_s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id # unique id
  }

#   Whether the distribution is enabled to accept end user requests for content.
#   required
  enabled             = true

#   is_ipv6_enabled     = true
#   comment             = "Some comment"
  default_root_object = "index.html" # optional

#   logging_config {
#     include_cookies = false
#     bucket          = "mylogs.s3.amazonaws.com"
#     prefix          = "myprefix"
#   }

# extra cnames
#   aliases = ["mysite.example.com", "yoursite.example.com"]

# required 
  default_cache_behavior {
    # either cache_policy_id(preffered) or forwarded_values(deprecated) must be set.
    # pathPatern not required

    #req
    allowed_methods  = ["DELETE", "GET", "PATCH", "POST", "PUT"] # update bucket policy to match this
    cached_methods   = ["GET"]
    target_origin_id = local.s3_origin_id


    cache_policy_id = aws_cloudfront_cache_policy.sh_cache_policy.id

    # -- alternate to cache_policy_id --
    # forwarded_values {
    #   query_string = false
    #   cookies { forward = "none" }
    # }
    # ----

# allow-all, https-only, or redirect-to-https
    viewer_protocol_policy = "allow-all" #required

    # min_ttl                = 0
    # default_ttl            = 3600
    # max_ttl                = 86400
  }

# Optional
#   ordered_cache_behavior { //one by one precedence increase (top-to-bottom)
#     same as default cache behavior but w/ path patterns
#   }

# price_class (Optional) - 
# Price class for this distribution. 
# One of PriceClass_All, PriceClass_200, PriceClass_100.
#   price_class = "PriceClass_200"

#required
  restrictions {
    geo_restriction { #both *type* and *locations* are required
      restriction_type = "whitelist" #whitelist #blacklist #none
      locations        = ["IN"] #["US", "IN", "GB", "DE"] # https://www.iso.org/iso-3166-country-codes.html
    #   for no restrictions , type = "none", locations = []
    }
  }

# req
  viewer_certificate {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#acm_certificate_arn
    cloudfront_default_certificate = true
  }
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.sh_s3_distribution.domain_name
}