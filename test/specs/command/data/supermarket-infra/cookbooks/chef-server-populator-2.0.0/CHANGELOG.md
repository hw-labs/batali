## v2.0.0
* Support chef-server 4.x versions
* Make chef-server constraint tighter to prevent breakage
* Remove resource notifications to resources outside our recipes
* Refactor configuration setup to support hash style attribute and auto-convert to string

## v1.2.2
* Adds test for user key
* Fixes org recipe user key in 12.1.x

## v1.2.0
* Adds support for both 12.0.x and 12.1.x versions, client key
  commands got a new flag which broke things.
* Prevents randomly generated passwords from starting with a '-' which
  will register as a flag and cause an error.
* Fixes backup recipe when using remote backups
* Fixes backup recipe when running as cron
* Updates and extends the integration tests to cover backups

## v1.1.4
* Fixes all users created as admins
* Updates user creation to require explicit enabled setting
* Updates client admin to default to false

## v1.1.2
* Adds myriad unit tests.
* Fixes issue #23 where users were not assigned to orgs.
* Fixes issue #22 where client recipe failed if no chef_server hash set.

## v1.1.0
* Fixes and loosens idempotency tests to account for Chef Server
version differences
* Updates Client recipe to create orgs, then users, then clients
* Fixes non-existent org attribute in solo recipe
* Fixes missing user keys in test suite
* Moves common org/user/client creation specs to the spec helper
* Refactors Backup/Restore to work with Chef 12. Uses Miasma rather
than Fog.

## v1.0.2
* Org recipe only included for solo run, since client run expects data
bag items.

## v1.0.0
* Updates to support Chef 12
* Removes support for Chef 11
* Adds support for organization creation in solo and client contexts
* Updates backup/restore recipes for new psql path and new table &
field names. (Not fully tested)
* Replaces many knife and psql commands with native chef-server-clt
management commands

## v0.4.0
* Allow for creation of clients, users, or both
* Store backup configuration in separate JSON file
* Provide proper retries to account for temporary server unavailability
* Include full server restart on restore from backup
* Provide 'latest' backup files along with named files
* Convert backup script from template to cookbook file
* Make service restarts more consistent

## v0.3.2
* Add client creation retries to stabilize initial bootstrap
* Updates to example bootstrap script
* Add support for backup/restore (thanks @luckymike!)

## v0.3.0
* Include chef-server dependency
* Update configuration overrides for chef-server
* Use `:endpoint` attribute for custom hostname/ip

## v0.2.0
* Provide distinct solo vs. client recipes
* Client recipe configures dna.json and uses ctl for reconfigure
