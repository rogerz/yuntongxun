# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yuntongxun/version'

Gem::Specification.new do |spec|
  spec.name          = "yuntongxun"
  spec.version       = YunTongXun::VERSION
  spec.authors       = ["Rogerz Zhang"]
  spec.email         = ["rogerz.zhang@gmail.com"]

  spec.summary       = %q{Ruby SDK for www.yuntongxun.com}
  spec.description   = %q{Ruby SDK for www.yuntongxun.com}
  spec.homepage      = "https://github.com/rogerz/yuntongxun."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
