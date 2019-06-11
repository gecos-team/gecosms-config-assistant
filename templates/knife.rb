# Configuration File For Knife
#

log_level          :info

log_location       STDOUT

chef_server_url "${chef_url}"

node_name "${chef_admin_name}"

client_key "c:\\chef\\validation.pem"

cache_type               'BasicFile'

