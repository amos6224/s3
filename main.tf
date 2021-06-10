resource "aws_kms_key" "key" {
    description = "key to encrypt bucket"
    policy      = jsonencode(
      {
        Id      = "key-default-1"
        Statement = [
          {
            Action: [
             "kms:Encrypt", 
             "kms:Decrypt",
             "kms:ReEncrypt*",
             "kms:GenerateDataKey",
             "kms:GenerateDataKey*",
             "kms:DescribeKey"
            ],
          }
        ]
      }
    )
}

resource "aws_s3_bucket" "bucket" {
    bucket      = var.name
    acl         = var.acl

    versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.key.arn
        sse_algorithm = "aws:kms"
      }
    }
  }
}
