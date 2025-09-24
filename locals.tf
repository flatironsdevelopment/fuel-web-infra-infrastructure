locals {
  credentials = jsondecode(
    data.aws_secretsmanager_secret_version.this.secret_string
  )
  apps = jsondecode(jsondecode(
    nonsensitive(data.aws_secretsmanager_secret_version.this.secret_string)
  ).apps)

  worker_list = flatten([for i in local.apps: [
    [for worker in try(i.workers, []): {
      app_name: i.name,
      technology: i.technology,
      dockerfile: worker.dockerfile,
      worker_name: worker.name,
      branch: i.branch,
      template_repo_branch: i.template_repo_branch,
      build_env: length(try(i.build_env, {})) > 0 ? join("\n            ", [for k, v in i.build_env : "${upper(k)}=${v}"]) : ""
    }]
  ]])

  app_list = [for i in local.apps : 
    { 
      app_name: i.name, 
      technology: i.technology, 
      port: i.port,
      domain:  i.domain,
      health_check_path: i.health_check_path,
      cognito: try(i.cognito, false),
      postgres: try(i.postgres, false),
      redis: try(i.redis, false),
      dockerfile: i.dockerfile,
      variables: try(i.variables, {}),
      branch: i.branch,
      template_repo_branch: i.template_repo_branch,
      build_env: length(try(i.build_env, {})) > 0 ? join("\n            ", [for k, v in i.build_env : "${upper(k)}=${v}"]) : ""
      build_env_map: try(i.build_env, {})

    }
  ]

  env_vars = {
    for app in local.app_list :
    app.app_name => merge(

      app.technology == "react" ? {
        NEXT_PUBLIC_API_HOST = app.build_env_map["NEXT_PUBLIC_API_HOST"]
      } : {},

      app.technology == "rails" ? {
        ENCRYPTION_PASSWORD = module.random_key.rails_encryption_password
        SECRET_KEY_BASE     = module.random_key.rails_secret_key_base
        API_KEY_HEADER      = "x-api-key"
        HOST_URL            = "https://${app.domain}"
        FRONT_END_URL       = try(app.variables.front_end_url, "")
      } : {},

      app.technology == "nest" ? {
        NODE_TLS_REJECT_UNAUTHORIZED = "0"
        API_KEY_HEADER               = "x-api-key"
        ENCRYPTION_PASSWORD          = module.random_key.nest_encryption_password
        HOST_URL                     = "https://${app.app_name}"
        FRONT_END_URL                = "https://${app.app_name}"
        APP_NAME                     = "Fuel App"
        APP_COMPANY                  = "Flatirons"
        AWS_ACCESS_KEY_ID            = var.aws_access_key_id
        AWS_SECRET_ACCESS_KEY        = var.aws_secret_access_key
      } : {},

      app.cognito == true ? {
        AWS_COGNITO_USER_POOL_ID = "${module.cognito[app.app_name].cognito_user_pool_id}"
        AWS_COGNITO_CLIENT_ID    = "${module.cognito[app.app_name].cognito_user_pool_client_id}"
        AWS_REGION               = var.aws_region
      } : {},

      app.redis == true ? {
        REDIS_URL = "redis://${module.redis[app.app_name].elasticache_cluster_hostname}:6379/0"
      } : {},

      app.postgres == true ? {
        DATABASE_PORT     = "5432"
        DATABASE_USERNAME = var.db_username
        DATABASE_PASSWORD = var.db_password
        DATABASE_NAME     = var.db_name
        DATABASE_HOST = split(":", module.database[app.app_name].db_hostname)[0]
        DATABASE_URL      = "postgresql://${var.db_username}:${var.db_password}@${module.database[app.app_name].db_hostname}/${var.db_name}"
      } : {},

      app.variables != null ? {
        for k, v in app.variables : upper(k) => v
      } : {}
    )
  }
  secret_arns = {
    for k, mod in module.secret_manager :
    k => mod.secret_arn
  }
}