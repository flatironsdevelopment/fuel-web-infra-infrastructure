########################################################################################################################
## Creates an ECS Cluster
########################################################################################################################

resource "aws_ecs_cluster" "default" {
  name = var.project_name

  tags = {
    Name     = "${var.project_name}_ECSCluster"
    Scenario = var.scenario
  }
}
