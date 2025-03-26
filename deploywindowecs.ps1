# Configuration
$AWS_REGION = "ap-southeast-2"
$ECR_REPO = "324037283653.dkr.ecr.us-west-2.amazonaws.com/express-eks"
$CLUSTER_NAME = "nodejs-app-cluster"
$SERVICE_NAME = "ecs-service-new"
$TASK_DEFINITION = "nodejs-app"
$DOCKERFILE_PATH = ".\Dockerfile"

# Login to ECR
$loginCommand = (aws ecr get-login-password --region $AWS_REGION) | docker login --username AWS --password-stdin $ECR_REPO
Write-Host "ECR Login: $loginCommand"

# Build and push image
docker build -t ${ECR_REPO}:latest -f $DOCKERFILE_PATH .
docker tag ${ECR_REPO}:latest ${ECR_REPO}:$(git rev-parse --short HEAD)
docker push "${ECR_REPO}:latest"
docker push "${ECR_REPO}:$(git rev-parse --short HEAD)"

# Update ECS service
Write-Host "Starting deployment..."
aws ecs update-service `
  --cluster $CLUSTER_NAME `
  --service $SERVICE_NAME `
  --task-definition $TASK_DEFINITION `
  --force-new-deployment `
  --region $AWS_REGION

# Wait for completion
Write-Host "Waiting for deployment to stabilize..."
aws ecs wait services-stable `
  --cluster $CLUSTER_NAME `
  --services $SERVICE_NAME `
  --region $AWS_REGION

Write-Host "Deployment complete!"