help:
	@echo "Voyager project"
	@echo "-------------------------------------------------"
	@echo ""
	@echo "-build builds and pushes docker distribution to docker hub"
build:
	docker build -f Dockerfile -t altmer/voyager:latest .
	docker push altmer/voyager
