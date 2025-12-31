terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_network" "devops_lab" {
  name = "devops-lab-net"
}

resource "docker_image" "jenkins" {
  name         = "jenkins/jenkins:lts-jdk11"
  keep_locally = false
}

resource "docker_image" "grafana" {
  name         = "grafana/grafana:latest"
  keep_locally = false
}

resource "docker_container" "jenkins_master" {
  image = docker_image.jenkins.image_id
  name  = "jenkins-master"
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  networks_advanced {
    name = docker_network.devops_lab.name
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  volumes {
    host_path      = "${path.cwd}/jenkins_home"
    container_path = "/var/jenkins_home"
  }
}

resource "docker_container" "grafana_server" {
  image = docker_image.grafana.image_id
  name  = "grafana-server"
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = docker_network.devops_lab.name
  }
  volumes {
    host_path      = "${path.cwd}/grafana_data"
    container_path = "/var/lib/grafana"
  }
  volumes {
    host_path = "${abspath(path.cwd)}/grafana-datasource.yml"
    container_path = "/etc/grafana/provisioning/datasources/datasource.yml"
    read_only = true
  }
}
