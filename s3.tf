
resource "aws_s3_bucket" "ssm_session_logs" {
  bucket = "${var.frontend_prefix}-ssm-s3-bucket"

  force_destroy = true
  tags = {
    Name        = "${var.frontend_prefix}-ssm-s3-bucket"
    environment = "${var.frontend_environment}"
  }
}

resource "aws_ssm_document" "session_manager_prefs" {
  name          = "SSM-SessionManagerRunShell"
  document_type = "Session"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Session Manager Preferences"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName       = aws_s3_bucket.ssm_session_logs.bucket
      s3KeyPrefix        = "ssm-logs"
      idleSessionTimeout = "20"
      maxSessionDuration = "60"
    }
  })
  lifecycle {
    prevent_destroy = false
  }
}


#terraform import aws_ssm_document.session_manager_prefs SSM-SessionManagerRunShell
