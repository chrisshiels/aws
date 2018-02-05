# 'Makefile'.


TARGETS = terraform_0.11.3_linux_amd64.zip \
	  terraform


all: $(TARGETS)


terraform_0.11.3_linux_amd64.zip:
	curl -L -O https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip


terraform: terraform_0.11.3_linux_amd64.zip
	unzip -DD terraform_0.11.3_linux_amd64.zip


clean:
	rm -vf $(TARGETS)
