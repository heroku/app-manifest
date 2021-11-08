# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'app_manifest/version'

Gem::Specification.new do |spec|
  spec.name          = 'app_manifest'
  spec.version       = AppManifest::VERSION
  spec.authors       = ['Owen Jacobson', 'Josh W Lewis']
  spec.email         = ['ojacobson@heroku.com', 'jlewis@heroku.com']

  spec.summary       = 'A library for parsing Heroku app manifests'
  spec.description   = 'Parse app manifests used by Heroku Button, Heroku ' \
                       'Review Apps, and Heroku CI.'
  spec.homepage      = 'https://devcenter.heroku.com/articles/app-json-schema'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "multi_json", "~> 1.0"
  spec.add_dependency "virtus", "~> 1.0"
end
