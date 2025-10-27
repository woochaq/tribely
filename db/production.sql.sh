#!/bin/bash
set -e

mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
  CREATE DATABASE IF NOT EXISTS tribely_production CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS tribely_production_cache CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS tribely_production_queue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS tribely_production_cable CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

  CREATE USER 'tribely'@'%' IDENTIFIED BY '${TRIBELY_DATABASE_PASSWORD}';

  GRANT ALL PRIVILEGES ON tribely_production.* TO 'tribely'@'%';
  GRANT ALL PRIVILEGES ON tribely_production_cache.* TO 'tribely'@'%';
  GRANT ALL PRIVILEGES ON tribely_production_queue.* TO 'tribely'@'%';
  GRANT ALL PRIVILEGES ON tribely_production_cable.* TO 'tribely'@'%';

  FLUSH PRIVILEGES;
EOSQL

