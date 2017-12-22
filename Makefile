help:
	@echo "Voyager project"
	@echo "-------------------------------------------------"
	@echo ""
	@echo "-start builds and starts docker stack locally"
	@echo "-stop stops docker stack"
start:
	docker-compose up -d
stop:
	docker-compose stop
