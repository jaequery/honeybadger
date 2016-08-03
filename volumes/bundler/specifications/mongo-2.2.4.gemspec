# -*- encoding: utf-8 -*-
# stub: mongo 2.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "mongo"
  s.version = "2.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tyler Brock", "Emily Stolfo", "Durran Jordan"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDfDCCAmSgAwIBAgIBATANBgkqhkiG9w0BAQUFADBCMRQwEgYDVQQDDAtkcml2\nZXItcnVieTEVMBMGCgmSJomT8ixkARkWBTEwZ2VuMRMwEQYKCZImiZPyLGQBGRYD\nY29tMB4XDTE1MTIwNzE1MTcyNloXDTE2MTIwNjE1MTcyNlowQjEUMBIGA1UEAwwL\nZHJpdmVyLXJ1YnkxFTATBgoJkiaJk/IsZAEZFgUxMGdlbjETMBEGCgmSJomT8ixk\nARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANFdSAa8fRm1\nbAM9za6Z0fAH4g02bqM1NGnw8zJQrE/PFrFfY6IFCT2AsLfOwr1maVm7iU1+kdVI\nIQ+iI/9+E+ArJ+rbGV3dDPQ+SLl3mLT+vXjfjcxMqI2IW6UuVtt2U3Rxd4QU0kdT\nJxmcPYs5fDN6BgYc6XXgUjy3m+Kwha2pGctdciUOwEfOZ4RmNRlEZKCMLRHdFP8j\n4WTnJSGfXDiuoXICJb5yOPOZPuaapPSNXp93QkUdsqdKC32I+KMpKKYGBQ6yisfA\n5MyVPPCzLR1lP5qXVGJPnOqUAkvEUfCahg7EP9tI20qxiXrR6TSEraYhIFXL0EGY\nu8KAcPHm5KkCAwEAAaN9MHswCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0O\nBBYEFFt3WbF+9JpUjAoj62cQBgNb8HzXMCAGA1UdEQQZMBeBFWRyaXZlci1ydWJ5\nQDEwZ2VuLmNvbTAgBgNVHRIEGTAXgRVkcml2ZXItcnVieUAxMGdlbi5jb20wDQYJ\nKoZIhvcNAQEFBQADggEBAL/5shZXBvCGGJcJqXyD2CJieOOH4EGUt/UKvSZ58lMz\nQkW5aKG22GJbXesMq+dMm/+gzUB2ea9TzttBEE5ZM/eNvoxyf7yNUcFyLQ365S6P\nrtQOj1Ms7ud5ffrhZJn1o7ayfY2ljQU0xLI2Yoyzl9XJq8U0TztS6Vk5wYIoLwUX\nNWGRSbETPJyR4mtUEbgI5A+N7pakJPUKKK1zXzADflsx51jjP5rZJJltnoVsBBgN\nEhIn2f8suSc9QAqYt7w4T+PMtjxWTVcXs+Uy2PbDtjhtEBz6ZsP6YSsOpJbrCjCV\nwZtXjpRUvWz86V5vjhHCTE8fqfEb85aeDwUCckPzpio=\n-----END CERTIFICATE-----\n"]
  s.date = "2016-03-01"
  s.description = "A Ruby driver for MongoDB"
  s.email = "mongodb-dev@googlegroups.com"
  s.homepage = "http://www.mongodb.org"
  s.licenses = ["Apache License Version 2.0"]
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby driver for MongoDB"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bson>, ["~> 4.0"])
    else
      s.add_dependency(%q<bson>, ["~> 4.0"])
    end
  else
    s.add_dependency(%q<bson>, ["~> 4.0"])
  end
end
