json.extract! version, :number, :published_at, :licenses, :integrity, :status, :download_url, :registry_url, :documentation_url, :install_command, :metadata, :created_at, :updated_at, :purl, :related_tag

json.dependencies version.dependencies do |dependency|
  json.extract! dependency, :ecosystem, :package_name, :requirements, :kind, :optional
end