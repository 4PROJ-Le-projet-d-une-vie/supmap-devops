YQ ?= yq
VALUES ?= values.yml
ENV_DIR ?= env

# List of the services to generate a .env for
# Add new services here
SERVICES = supmap-gis supmap-redis

.PHONY: generate-envs clean-envs deploy

# Generate all .env files
generate-envs: $(patsubst %, $(ENV_DIR)/%.env, $(SERVICES))

# Generate a .env file for each service in the YAML
$(ENV_DIR)/%.env: $(VALUES)
	@mkdir -p $(ENV_DIR)
	@echo "# Auto-generated from $(VALUES) for $*" > $@
	@$(YQ) eval -o=props ".$*" $(VALUES) \
	| awk -F= '{gsub(/^[ \t]+|[ \t]+$$/, "", $$1); gsub(/^[ \t]+|[ \t]+$$/, "", $$2); print toupper($$1)"="$$2}' >> $@
	@echo "Generated $@"

# Clean generated .env files
clean-envs:
	rm -f $(ENV_DIR)/*.env

# Check if yq is installed, fail if not
ifeq (, $(shell command -v $(YQ)))
$(error "yq is not installed. Please install yq: https://github.com/mikefarah/yq/?tab=readme-ov-file#install")
endif

deploy: generate-envs
	@ENV_FILES="$$(find $(ENV_DIR) -name '*.env' -printf '--env-file %p ')" && \
	docker compose -f ./compose/compose.yml $$ENV_FILES up -d
