maintainer        "Red Davis"
maintainer_email  "red@railslove.com"
license           "Apache 2.0"
description       "Runs astrails-safe backups"
long_description  "Uses http://github.com/astrails/safe to run backups"
version           "0.1"
recipe            "safe_backup::setup_cron", "Deploys the cron job to run the back"

supports 'ubuntu'