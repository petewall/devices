SHELL := /bin/bash

.PHONY: set-pipeline

set-pipeline: ci/pipeline.yaml
	fly -t wallhouse set-pipeline --pipeline devices --config ci/pipeline.yaml
