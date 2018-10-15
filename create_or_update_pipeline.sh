#!/bin/bash

aws codepipeline get-pipeline --name=$CAFONSOP_PIPELINE_STACK > /dev/null

echo
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
fi

echo "All done"
