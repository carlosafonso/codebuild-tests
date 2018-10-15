#!/bin/bash

echo "Creating/Updating pipeline..."

aws codepipeline get-pipeline --name=$CAFONSOP_PIPELINE_STACK > /dev/null

if [ $? -ne 0 ]; then
	echo "Pipeline does not exist, so it will be created now"
	aws cloudformation create-stack \
		--stack-name=$CAFONSOP_PIPELINE_STACK \
		--template-body=file://$PWD/pipeline.yaml \
		--capabilities=CAPABILITY_IAM \
		--parameters="[
			{\"ParameterKey\": \"PipelineName\", \"ParameterValue\": \"$CAFONSOP_PIPELINE_STACK\"},
			{\"ParameterKey\": \"GitHubUser\", \"ParameterValue\": \"$CAFONSOP_GITHUB_USER\"},
			{\"ParameterKey\": \"GitHubRepo\", \"ParameterValue\": \"$CAFONSOP_GITHUB_REPO\"},
			{\"ParameterKey\": \"GitHubBranch\", \"ParameterValue\": \"$CAFONSOP_PIPELINE_STACK\"},
			{\"ParameterKey\": \"GitHubToken\", \"ParameterValue\": \"$CAFONSOP_GITHUB_TOKEN\"},
			{\"ParameterKey\": \"Cluster\", \"ParameterValue\": \"$CAFONSOP_ECS_CLUSTER\"},
			{\"ParameterKey\": \"Service\", \"ParameterValue\": \"$CAFONSOP_ECS_SERVICE\"}
		]"

	echo "Pipeline creation initiated, will be automatically run upon completion"
else
	echo "Pipeline exists, so it will be updated"
	aws cloudformation update-stack \
		--stack-name=$CAFONSOP_PIPELINE_STACK \
		--template-body=file://$PWD/pipeline.yaml \
		--capabilities=CAPABILITY_IAM \
		--parameters="[
			{\"ParameterKey\": \"PipelineName\", \"ParameterValue\": \"$CAFONSOP_PIPELINE_STACK\"},
			{\"ParameterKey\": \"GitHubUser\", \"ParameterValue\": \"$CAFONSOP_GITHUB_USER\"},
			{\"ParameterKey\": \"GitHubRepo\", \"ParameterValue\": \"$CAFONSOP_GITHUB_REPO\"},
			{\"ParameterKey\": \"GitHubBranch\", \"ParameterValue\": \"$CAFONSOP_PIPELINE_STACK\"},
			{\"ParameterKey\": \"GitHubToken\", \"ParameterValue\": \"$CAFONSOP_GITHUB_TOKEN\"},
			{\"ParameterKey\": \"Cluster\", \"ParameterValue\": \"$CAFONSOP_ECS_CLUSTER\"},
			{\"ParameterKey\": \"Service\", \"ParameterValue\": \"$CAFONSOP_ECS_SERVICE\"}
		]"

	echo "Waiting for update to pipeline stack to complete"
	aws cloudformation wait stack-update-complete --stack-name=$CAFONSOP_PIPELINE_STACK

	echo "Stack updated, running pipeline"
	aws codepipeline start-pipeline-execution --name=$CAFONSOP_PIPELINE_STACK
fi

echo "All done"
