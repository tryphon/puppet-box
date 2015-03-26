Box::Config::Persister.files.add path: "/var/etc/go-broadcast/config.json", owner: "boxdaemon", storage_path: "data/go-broadcast.json"

require 'uri'
require 'net/http'

Box::Config::Persister.before_persist do
  Box.logger.info "Save go-broadcast config"
  Net::HTTP.post_form URI('http://localhost:9000/config/save.json'), {}
end
