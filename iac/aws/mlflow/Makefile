start:
	terraform apply -target=module.container_repository.aws_ecr_repository.mlflow_container_repository
	bash docker_push.sh
	terraform apply

update_container:
	terraform destroy -target=module.task_deployment.aws_ecs_service.service
	bash docker_push.sh
	terraform apply