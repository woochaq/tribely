-- This script will be run automatically by the MySQL image
-- on the container's first start (thanks to `docker-entrypoint-initdb.d`).

-- Step 1: Create all databases required by your database.yml
CREATE DATABASE IF NOT EXISTS `tribely_production` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `tribely_production_cache` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `tribely_production_queue` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `tribely_production_cable` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Step 2: Create the 'tribely' user (as specified in database.yml)
-- and set its password *directly* from the environment variable.
-- This is cleaner and avoids temporary passwords.
CREATE USER 'tribely'@'%' IDENTIFIED WITH mysql_native_password BY_ENV 'TRIBELY_DATABASE_PASSWORD';

-- Step 3: Grant the new user full privileges on ALL of its databases
GRANT ALL PRIVILEGES ON `tribely_production`.* TO 'tribely'@'%';
GRANT ALL PRIVILEGES ON `tribely_production_cache`.* TO 'tribely'@'%';
GRANT ALL PRIVILEGES ON `tribely_production_queue`.* TO 'tribely'@'%';
GRANT ALL PRIVILEGES ON `tribely_production_cable`.* TO 'tribely'@'%';

-- Step 4: Apply the changes
FLUSH PRIVILEGES;
