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

        Next = "RepairDailyForecast"
      }

      RepairDailyForecast = {
        Type = "Task"
        Resource = "arn:aws:states:::athena:startQueryExecution.sync"

        Arguments = {
          QueryString = "MSCK REPAIR TABLE ${aws_glue_catalog_database.raw.name}.${aws_glue_catalog_table.raw_daily_forecast.name}"
          WorkGroup = "primary"

          ResultsConfiguration = {
            OutputLocation = "s3://${aws_s3_bucket.athena_query_results.id}/"
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
  name     = "${var.project_name}-hourly"
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

        Next = "RepairInParallel"
      }

      RepairInParallel = {
        Type = "Parallel"

        Branches = [
          {
            StartAt = "RepairHourlyForecast"

            States = {
              RepairDailyForecast = {
                Type = "Task"
                Resource = "arn:aws:states:::athena:startQueryExecution.sync"

                Arguments = {
                  QueryString = "MSCK REPAIR TABLE ${aws_glue_catalog_database.raw.name}.${aws_glue_catalog_table.raw_hourly_forecast.name}"
                  WorkGroup = "primary"

                  ResultsConfiguration = {
                    OutputLocation = "s3://${aws_s3_bucket.athena_query_results.id}/"
                  }
                }

                End = true
              }
            }
          },

          {
            StartAt = "RepairHourlyObservation"

            States = {
              RepairHourlyObservation = {
                Type = "Task"
                Resource = "arn:aws:states:::athena:startQueryExecution.sync"

                Arguments = {
                  QueryString = "MSCK REPAIR TABLE ${aws_glue_catalog_database.raw.name}.${aws_glue_catalog_table.raw_hourly_observation.name}"
                  WorkGroup = "primary"

                  ResultsConfiguration = {
                    OutputLocation = "s3://${aws_s3_bucket.athena_query_results.id}/"
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
