# cspace-tenant-recycler

Setup:

```bash
sudo apt-get install libpq-dev
bundle install
```

Edit `config.yml` if necessary.

Setup a CollectionSpace database. The quickest way is to use [cspace-deployment](https://github.com/collectionspace/cspace-deployment.git).

```bash
cd docker/db/
docker build -t collectionspace:db .

cd docker/demo/
docker-compose build
docker-compose up -d db
docker-compose run --rm app /create_db.sh
docker-compose up
```

This creates a `cspace_collectionspace` database and user for the import step.

For export dump and restore an existing database. This example supposes a dump
was created called `cspace_gsd.sql`:

```bash
sed -i.bak 's/cspace_gsd/cspace_collectionspace/' cspace_gsd.sql
dropdb -U csadmin -h localhost cspace_gsd || true
createdb -U csadmin -h localhost -O cspace_collectionspace -T template1 cspace_gsd
psql -U csadmin -h localhost -d cspace_gsd -f cspace_gsd.sql
```

Run an export:

```bash
./exporter.rb
```
