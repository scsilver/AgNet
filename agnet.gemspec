# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agnet/version'

Gem::Specification.new do |spec|
  spec.name          = "agnet"
  spec.version       = Agnet::VERSION
  spec.authors       = ["Scott Silverstein"]
  spec.email         = ["scsilver.umd@gmail.com"]

  spec.summary       = %q{2 Layer Neural Network}
  spec.description   = %q{AgNet is a 2 Layer feed forward neural network with backpropogation for training. Can be used to approximate many functions and is useful for classification tasks such as character recognition. }
  spec.homepage      = "https://github.com/scsilver/AgNet"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.


  spec.files         = Dir["lib/agnet.rb"] + Dir["lib/agnet/train.csv"] + Dir["lib/agnet/version.rb"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/data", "lib/agnet"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
