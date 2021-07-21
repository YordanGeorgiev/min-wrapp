# Makefile
# usage: run the "make" command in the root, than make <<cmd>> ...
#
# TODO: define proj and product_name
SHELL = bash
default: help

.PHONY: help  ## @-> show this help  the default action
help:
	@clear
	@fgrep -h "##" $(MAKEFILE_LIST)|fgrep -v fgrep|sed -e 's/^\.PHONY: //'|sed -e 's/^\(.*\)##/\1/'|column -t -s $$'@'

.PHONY: install ## @-> setup the whole environment to run this proj
install: do_build_devops_docker_img do_create_devops_container

.PHONY: install_no_cache ## @-> setup the whole environment to run this proj, do NOT use docker cache
install_no_cache: do_build_devops_docker_img_no_cache do_create_container

.PHONY: run ## @-> run some function , in this case hello world
run:
	./run -a do_run_hello_world

.PHONY: do_run ## @-> run some function , in this case hello world via the running docker container
do_run: demand_var-ENV
	docker exec -e ENV=$$ENV -it proj-devops-con /opt/min-wrapp/run -a do_run_hello_world

.PHONY: do_build_devops_docker_img ## @-> build the devops docker image
do_build_devops_docker_img:
	docker build . -t proj-img --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

.PHONY: do_build_devops_docker_img_no_cache ## @-> build the devops docker image
do_build_devops_docker_img_no_cache:
	docker build . -t proj-img --no-cache --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile


.PHONY: do_create_devops_container ## @-> create a new container our of the build img
do_create_devops_container: do_stop_devops_container
	docker run -d \
		-v $$(pwd):/opt/min-wrapp\
		-v $$HOME/.aws:/home/appuser/.aws \
   	-v $$HOME/.ssh:/home/appuser/.ssh \
		--name proj-devops-con proj-devops-img ;
	@echo -e to attach run: "\ndocker exec -it proj-devops-con /bin/bash"
	@echo -e to get help run: "\ndocker exec -it proj-devops-con ./run --help"

.PHONY: do_stop_devops_container ## @-> stop the devops running container
do_stop_devops_container:
	-@docker container stop $$(docker ps -aqf "name=proj-devops-con") 2> /dev/null
	-@docker container rm $$(docker ps -aqf "name=proj-devops-con") 2> /dev/null

.PHONY: do_prune_docker_system ## @-> stop & completely wipe out all the docker caches for ALL IMAGES !!!
do_prune_docker_system:
	-docker kill $$(docker ps -q)
	-docker rm $$(docker ps -aq)
	docker builder prune -f --all
	docker system prune -f

.PHONY: zip_me ## @-> zip the whole project without the .git dir
zip_me:
	-rm -v ../min-wrapp.zip ; zip -r ../min-wrapp.zip  . -x '*.git*'

demand_var-%:
	@if [ "${${*}}" = "" ]; then \
		echo "the var \"$*\" is not set, do set it by: export $*='value'"; \
		exit 1; \
	fi

.PHONY: task-which-requires-a-var ## @-> test shell variable is set enforcemnt
task-which-requires-a-var: demand_var-ENV
	@clear
	@echo the required variable ENV\'s value was: ${ENV}

.PHONY: spawn_tgt_project ## @-> spawn a new target project
spawn_tgt_project: demand_var-TGT_PROJ demand_var-ENV zip_me
	-rm -r $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ) 2>/dev/null
	unzip -o ../min-wrapp.zip -d $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	ENV=dev to_srch=min-wrapp to_repl=$(shell echo $$TGT_PROJ) dir_to_morph=$(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ) ./run -a do_morph_dir
