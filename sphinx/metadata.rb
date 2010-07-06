maintainer        "Peritor GmbH"
maintainer_email  "scalarium@peritor.com"
license           "Apache 2.0"
description       "Installs and configures Sphinx"
version           "0.1"
recipe            "sphinx::client", "Installs packages required for Sphinx clients"
recipe            "sphinx::server", "Installs packages required for Sphinx servers"

supports 'ubuntu'

