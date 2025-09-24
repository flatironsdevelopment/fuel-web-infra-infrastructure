
# 🌍 Terraform Project: Infrastructure Setup

This Terraform project is designed to first create a centralized secret in AWS Secrets Manager, which serves as the foundation for provisioning the rest of the infrastructure.

## ✅ Prerequisites

Before you begin, ensure the following:

- [Terraform](https://www.terraform.io/downloads.html) is installed and available in your `PATH`
- AWS CLI is configured with appropriate credentials and region
- Permissions for creating the environment
   - AmazonECS_FullAccess
   - AmazonElastiCacheFullAccess
   - AmazonRDSFullAccess
   - AmazonS3FullAccess
   - AWSCloudTrail_FullAccess
   - AWSCodeBuildAdminAccess
   - AWSCodePipeline_FullAccess
   - CloudWatchFullAccessV2
   - IAMFullAccess

### 🌐 Creating an ACM Certificate for Your Domain

To deploy secure resources using the Infrastructure Automation Script, follow these steps to create an ACM certificate for your domain:

1. **Log in to AWS Console**: Sign in to your AWS Management Console using your AWS account credentials.

2. **Navigate to ACM**: Search for "ACM" in the AWS Management Console search bar and select the "AWS Certificate Manager" service.

3. **Request a Certificate**:
   - Click the "Request a certificate" button.
   - Choose "Request a public certificate" and click "Next".

4. **Add Domain Names**:
   - In the "Add domain names" section, enter your domain name (e.g., `example.com`) and any subdomains you plan to use (e.g., `*.example.com`).
   - Optionally, add additional domain names (SANs) if needed.
   - Click "Next".

5. **Validation**:
   - Choose a validation method (e.g., DNS validation) to prove domain ownership.
   - Follow the provided instructions to complete the validation process.

6. **Review and Confirm**:
   - Review the domain names and validation method you've selected.
   - Click "Confirm and request" to submit your certificate request.

7. **Certificate Issued**:
   - Once validation is successful, the certificate status will change to "Issued".

8. **Copy the ARN**:
   - Click on the issued certificate to view its details.
   - Copy the "Amazon Resource Name (ARN)" of the certificate and paste it into your `config.json` under the SSL session section.

---

### 📝 Additional Observations

- **config.json Adjustments**: If you do not have the `config.json` file, please note that there are a few parameters that need to be manually adjusted:
  - **FRONT_END_URL**: Ensure this is updated to the correct domain for your front-end application.
  - **HOST_URL**: Similarly, this URL is currently pointing to Flatirons' domain, and you will need to change it to match your own domain.
  - **ssl**: Copy the certificate arn from the previous step


### 🌱  How to Modify app.json
   
##### 1. **SSL Certificate ARN**
   - Replace the `"ssl"` field with the correct ARN for your SSL certificate, which you should have obtained through AWS Certificate Manager (ACM):
   
     ```json
     "ssl": "arn:aws:acm:========================="
     ```
##### 2. **Access IP Range**
   - Update the `"access_ip_range"` field to specify the IP range that can access your database. You can enter your IP address or any other IP range:
   
     ```json
     "access_ip_range": "73.153.163.118/32"
     ```

##### 3. **Cognito API Key Header**
   - Ensure the `"cognito_apikey_header"` field points to the header for API key authentication if you are using Cognito for authentication:
   
     ```json
     "cognito_apikey_header": "x-api-key"
     ```
##### 4. **Slack Webhook URL**
   - Provide your Slack Webhook URL to receive alarms. If you don't have one, you can use the default placeholder URL:
   
     ```json
     "slack_webhook_url": "Enter webhook URL to receive alarms or set default value https://hooks.slack.com/services/YOUR_WORKSPACE_ID/YOUR_CHANNEL_ID/YOUR_WEBHOOK_TOKEN"
     ```

##### 5. **Environment Setup**
   - Update the `"name"` field with your project name:
   
     ```json
     "name": "your-project"
     ```

   - The `"deployment"` field specifies the deployment method (ecs or eks):
   
     ```json
     "deployment": "ecs"
     ```

     Nota: This application only works with ecs

##### 6. **Application Modules Configuration**
   - Modify the `"modules"` field to set the options for the different modules you are using in your application. For instance:
   
     ```json
     "modules": "[{'name': 'auth', 'options': {'two_factor': False, 'invitation_only': False, 'remove_sign_up_phone': False}}, {'name': 'team', 'options': {'remove': True}}, {'name': 'billing', 'options': {'remove_stripe': True}}, {'name': 'e2e', 'options': {'remove': True}}]"
     ```

##### 7. **Application Configurations for API and Web**
   - Modify the application configuration under the `"apps"` section. For each app (e.g., `projectname-dev-api`, `projectname-staging-api`), update the following:
     
     - **Domain Name**: Set the domain for each app.
     - **API Keys and Secrets**: Ensure all required API keys and secrets (like Snowflake, JWT) are correctly configured.
     - **Environment Variables**: Update any specific environment variables (e.g., `HOST_URL`, `FRONT_END_URL`).

   Example for the **dev API app**:
   
   ```json
   "apps": [
     {
       "name": "projectname-dev-api",
       "technology": "nest",
       "dockerfile": "apps/nest/Dockerfile",
       "health_check_path": "/health",
       "domain": "projectname-dev-api.******.com",
       "port": 3000,
       "cognito": false,
       "postgres": false,
       "redis": false,
       "variables": {
         "NODE_TLS_REJECT_UNAUTHORIZED": 0,
         "API_KEY_HEADER": "x-api-key",
         "ENCRYPTION_PASSWORD": "xxxxxxxxxxxxxxx",
         "HOST_URL": "https://projectname-dev-api.****.com",
         "FRONT_END_URL": "https://projectname-dev.******.com",
         "APP_NAME": "AppName",
         "APP_COMPANY": "Flatirons",
         "ADMIN_JS_EMAIL": "admin@flatirons.com",
         "ADMIN_JS_PASSWORD": "xxxxxxxxxxxxxxxxx!!!"
       }
     }
   ]
   ```
---

## 🚀 Usage

### 1. Verify Terraform Installation

Make sure Terraform is correctly installed by running the following command:

```bash
terraform -v
```

### 2. Initialize and Create the Centralized Secret

To begin, initialize the project and apply the `secret-main` module to create the centralized secret. This step is required only once, unless the secret is already created.
Note: For this step the config.json file is mandatory, please request it from the project administrator and place it at the root of the project directory

Region=fill your region below (if it is different from us-east-1)
```bash
cd modules/secret-main
terraform init -backend-config="region=us-east-1"
terraform plan
terraform apply
```

### 3. Apply the Full Infrastructure

After the centralized secret is in place, proceed to initialize and apply the full infrastructure:

Region=fill your region below (if it is different from us-east-1)
```bash
terraform init -backend-config="region=us-east-1"
terraform plan
terraform apply
```

---

## 📁 Project Structure

```bash
.
├── modules/                        # ALL Terraform Modules
│   └── secret-main/        # Module for creating the centralized secret
├── main.tf                         # Main Terraform entrypoint
├── variables.tf                    # Input variable definitions
├── outputs.tf                      # Output values
├── providers.tf                    # Provider settings
├── locals.tf                    # Provider settings
└── README.md                       # Project documentation
```

---

## 🔐 Security Considerations

- **Never hardcode secrets**: Use variables and Secrets Manager for sensitive data.
- **Restrict access**: Implement AWS IAM policies to control who can access the centralized secret.
- **Remote state encryption**: Ensure remote state is encrypted, especially when using shared backends like S3.

---

## 🧹 Clean Up

To destroy all infrastructure and resources, run the following command:

```bash
terraform destroy
```

To only destroy the centralized secret:

```bash
cd modules/secret-main
terraform destroy
```
