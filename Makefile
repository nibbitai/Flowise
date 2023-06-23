version := 0.2.3
environment := uat

docker-acr-login:
	az acr login --name nibbitai

docker-build: 
	docker build -t nibbitai.azurecr.io/pebbles-flowise:$(version) docker/

docker-push: docker-build docker-acr-login
	docker push nibbitai.azurecr.io/pebbles-flowise:$(version)

kube-create-manifest:
	@echo "Creating manifest for $(environment) environment version $(version)"
	kubernetes/create-deployment.sh $(version) $(environment)

kube-deploy: docker-push kube-create-manifest
	@echo "Deploying manifest for $(environment) environment version $(version)"
	kubectl apply -f kubernetes/deploy-$(version).yml

## certificate

kube-create-certificate-manifest:
	kubernetes/create-certificate.sh $(environment)

kube-deploy-certificate-manifest: kube-create-certificate-manifest
	kubectl apply -f kubernetes/deploy-certificate.yml