variable "cloud_id" {
  description = "ID вашего облака"
  type        = string
}

variable "folder_id" {
  description = "ID вашей папки"
  type        = string
}

variable "subnet_id" {
  description = "ID подсети, в которой будет создана ВМ"
  type        = string
}

variable "ssh_public_key" {
  description = "Ваш публичный SSH-ключ для доступа к ВМ"
  type        = string
}

variable "service_account_id" {
  description = "ID сервисного аккаунта с ролью monitoring.editor"
  type        = string
}

variable "service_account_key_file" {
  description = "Путь к файлу закрытого ключа сервисного аккаунта (PEM)"
  type        = string
  sensitive   = true
}

variable "notification_channel_id" {
  description = "ID канала уведомлений для алертов"
  type        = string
}
