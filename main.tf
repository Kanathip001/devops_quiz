terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Pull Node.js image
resource "docker_image" "node_app" {
  name         = "node:16"  # ใช้ Node.js version 16
  keep_locally = false
}

# Create container
resource "docker_container" "web_app" {
  image = docker_image.node_app.name
  name  = "web-app-container"
  
  ports {
    internal = 3000
    external = 3000
  }

  # Mount volume เพื่อ copy code เข้าไปใน container
  volumes {
    host_path      = "${path.cwd}/"  # path ปัจจุบันที่มี source code
    container_path = "/app"
  }

  # คำสั่งเริ่มต้น container
  command = ["npm", "start"]

  # Working directory
  working_dir = "/app"
}