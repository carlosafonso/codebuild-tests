#!/bin/bash

aws codepipeline get-pipeline --name=${CAFONSOP_PIPELINE_STACK} > /dev/null

if [ $? -ne 0 ]; then
	echo "Pipeline does not exist, so it will be created now"
	aws cloudformation create-stack \
		--stack-name=${CAFONSOP_PIPELINE_STACK} \
		--template-body=file://$PWD/pipeline.yaml
else
	echo "Pipeline exists, so it will be updated"
	aws cloudformation update-stack \
		--stack-name=${CAFONSOP_PIPELINE_STACK} \
		--template-body=file://$PWD/pipeline.yaml
fi

echo "All done"
