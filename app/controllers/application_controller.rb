class ApplicationController < ActionController::Base
  include Pagy::Backend

  def lookup_by_purl(purl_string)
    purl_param = purl_string.gsub('npm/@', 'npm/%40')
    purl = PackageURL.parse(purl_param)
    if purl.type == 'docker' && purl.namespace.nil?
      namespace = 'library'
    else
      namespace = purl.namespace
    end
    if purl.type == 'github'
      repository_url = "https://github.com/#{purl.namespace}/#{purl.name}"
      scope = Package.repository_url(repository_url)
    else
      name = [namespace, purl.name].compact.join(Ecosystem::Base.purl_type_to_namespace_seperator(purl.type))
      ecosystem = Ecosystem::Base.purl_type_to_ecosystem(purl.type) 
      Package.where(name: name, ecosystem: ecosystem)
    end
  end
end
