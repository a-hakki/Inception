all:
	mkdir -p /home/ahakki/data/mariadb
	mkdir -p /home/ahakki/data/wordpress
	docker compose up --build -d -y

clean:
	docker compose down

re: clean all