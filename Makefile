NAME = inception

all:
	@printf "Creating data directories...\n"
	@mkdir -p /home/hdargui/data/mariadb
	@mkdir -p /home/hdargui/data/wordpress
	@printf "Building and starting containers...\n"
	@docker compose -f srcs/docker-compose.yml up --build -d

down:
	@printf "Stopping containers...\n"
	@docker compose -f srcs/docker-compose.yml down

re: fclean all

clean: down
	@printf "Cleaning unused images and networks...\n"
	@docker system prune -a -f

# Had l-command hiya l-important: kat-msa7 kolchi d-shiy
fclean:
	@printf "Deep cleaning: removing volumes and host data...\n"
	@docker compose -f srcs/docker-compose.yml down -v
	@docker system prune -a --volumes -f
	@sudo rm -rf /home/hdargui/data/mariadb/*
	@sudo rm -rf /home/hdargui/data/wordpress/*

.PHONY: all down re clean fclean