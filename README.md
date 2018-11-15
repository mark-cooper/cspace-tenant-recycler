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
pgcli -h localhost -U csadmin cspace_collectionspace
```

Create the empty database to restore into:

```sql
DROP DATABASE IF EXISTS cspace_gsd;
CREATE DATABASE cspace_gsd OWNER cspace_collectionspace;
```

Perform the restore:

```bash
psql -U csadmin -d cspace_gsd -f cspace_gsd.sql
```

Run an export:

```bash
./exporter.rb
```
