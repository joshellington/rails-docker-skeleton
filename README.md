# rails-docker-skeleton

To generate/build a new Rails/Docker env: `./docker-boot.sh`

Make sure to update `config/database.yml` after with the PG credentials listed in `docker-compose.yml`. And then run `docker-compose up`, and in another shell: `docker-compose run web rails db:prepare`
