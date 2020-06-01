#
# Checking DB Connection Info ...
alias startPHD='phd stop && phd restart'
alias setPHDTrace='config set phd.trace true'
alias setPHDUser='config set phd.user www-data'
alias setPHDVerbose='config set phd.verbose true'
alias setFilePath='config set storage.local-disk.path /var/files'
alias showConfig='cat /var/www/phabricator/conf/local/local.json'
alias setRepoPath='config set repository.default-local-path  /var/repo'
alias setRepositorySelfHosting='config set diffusion.allow-http-auth true'
alias setDBHost='[ -z "$DB_HOST" ] && echo "Host not Provided ..." || config set mysql.host $DB_HOST'
alias setDBPort='[ -z "$DB_PORT" ] && echo "Port not Provided ..." || config set mysql.port $DB_PORT'
alias setDBUser='[ -z "$DB_USER" ] && echo "User not Provided ..." || config set mysql.user $DB_USER'
alias setDBPass='[ -z "$DB_PASS" ] && echo "Pass not Provided ..." || config set mysql.pass $DB_PASS'
alias setBaseURI='[ -z "$BASE_URI" ] && echo "BaseURI not Provided ..." || config set phabricator.base-uri $BASE_URI'
alias storageUpgrade='([ -z "$DB_HOST" ] && [ -z "$DB_PORT" ] && [ -z "$DB_USER" ] && [ -z "$DB_PASS" ]) && echo "Db Configuration not Provided ..." || storage upgrade --force'

#
# User Password Recover ...
alias recoverPassword='auth recover'

#
#  && storageUpgrade && apache2-foreground
alias startup='setDBHost && \
setDBPort && \
setDBUser && \
setDBPass && \
setFilePath && \
setRepoPath && \
setBaseURI && \
setRepositorySelfHosting && \
setPHDUser && \
showConfig && \
storageUpgrade && \
startPHD && \
apache2-foreground'

startup
