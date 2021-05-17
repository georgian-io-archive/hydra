destroy:
	terraform destroy -target=module.batch.aws_batch_job_queue.batch_job_queue
	terraform destroy -target=module.batch.aws_batch_compute_environment.batch_compute_environment
	terraform destroy

build_lambda:
	pip3 install pymysql sqlalchemy -t ./modules/lambda/function
	cd ./modules/lambda/function; zip -r batch_lambda.zip .; cd ../../..