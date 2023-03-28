provider "aws" {
  region = var.aws_region
}


resource "aws_s3_bucket" "raw" {
  bucket = var.raw_bucket_name
}

resource "aws_s3_bucket" "processed" {
  bucket = var.processed_bucket_name
}

resource "aws_s3_bucket" "code" {
  bucket = var.code_bucket_name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/../lambda.zip"
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.code.bucket
  key    = "lambda.zip"
  source = data.archive_file.lambda.output_path

  # Version the object by its MD5 hash
  etag = filemd5(data.archive_file.lambda.output_path)
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.code.bucket
  s3_key    = aws_s3_object.lambda_code.key

  runtime = "python3.8"
  handler = "main.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}