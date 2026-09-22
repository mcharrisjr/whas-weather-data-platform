resource "aws_sfn_state_machine" "daily" {
  name     = "${var.project_name}-daily"
  role_arn = aws_iam_role.step_function.arn

  definition = jsonencode({
    StartAt = "ScrapeDailyForecast"

    States = {
      ScrapeDailyForecast = {
        Type     = "Task"
        Resource = "arn:aws:states:::ecs:runTask.sync"

        Parameters = {
          Cluster        = aws_ecs_cluster.main.arn
          TaskDefinition = aws_ecs_task_definition.daily_forecasted_weather.arn
          LaunchType     = "FARGATE"

          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = [aws_subnet.public.id]
              SecurityGroups = [aws_security_group.ecs_task.id]
              AssignPublicIp = "ENABLED"
            }
          }
        }

        Next = "DbtBuild"
      }

      DbtBuild = {
        Type     = "Task"
        Resource = "arn:aws:states:::ecs:runTask.sync"

        Parameters = {
          Cluster        = aws_ecs_cluster.main.arn
          TaskDefinition = aws_ecs_task_definition.dbt_build.arn
          LaunchType     = "FARGATE"

          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = [aws_subnet.public.id]
              SecurityGroups = [aws_security_group.ecs_task.id]
              AssignPublicIp = "ENABLED"
            }
          }
        }

        End = true
      }
    }
  })
}

resource "aws_sfn_state_machine" "hourly" {
  name     = "${var.project_name}-daily"
  role_arn = aws_iam_role.step_function.arn

  definition = jsonencode({
    StartAt = "ScrapeInParallel"

    States = {
      ScrapeInParallel = {
        Type = "Parallel"

        Branches = [
          {
            StartAt = "ScrapeHourlyForecast"

            States = {
              ScrapeHourlyForecast = {
                Type     = "Task"
                Resource = "arn:aws:states:::ecs:runTask.sync"

                Parameters = {
                  Cluster        = aws_ecs_cluster.main.arn
                  TaskDefinition = aws_ecs_task_definition.hourly_forecasted_weather.arn
                  LaunchType     = "FARGATE"

                  NetworkConfiguration = {
                    AwsvpcConfiguration = {
                      Subnets        = [aws_subnet.public.id]
                      SecurityGroups = [aws_security_group.ecs_task.id]
                      AssignPublicIp = "ENABLED"
                    }
                  }
                }

                End = true
              }
            }
          },

          {
            StartAt = "ScrapeHourlyObservation"

            States = {
              ScrapeHourlyObservation = {
                Type     = "Task"
                Resource = "arn:aws:states:::ecs:runTask.sync"

                Parameters = {
                  Cluster        = aws_ecs_cluster.main.arn
                  TaskDefinition = aws_ecs_task_definition.hourly_observed_weather.arn
                  LaunchType     = "FARGATE"

                  NetworkConfiguration = {
                    AwsvpcConfiguration = {
                      Subnets        = [aws_subnet.public.id]
                      SecurityGroups = [aws_security_group.ecs_task.id]
                      AssignPublicIp = "ENABLED"
                    }
                  }
                }

                End = true
              }
            }
          }
        ]

        Next = "DbtBuild"
      }

      DbtBuild = {
        Type     = "Task"
        Resource = "arn:aws:states:::ecs:runTask.sync"

        Parameters = {
          Cluster        = aws_ecs_cluster.main.arn
          TaskDefinition = aws_ecs_task_definition.dbt_build.arn
          LaunchType     = "FARGATE"

          NetworkConfiguration = {
            AwsvpcConfiguration = {
              Subnets        = [aws_subnet.public.id]
              SecurityGroups = [aws_security_group.ecs_task.id]
              AssignPublicIp = "ENABLED"
            }
          }
        }

        End = true
      }
    }
  })
}
