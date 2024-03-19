# frozen_string_literal: true

require_relative 'lib/tenablesc_client/version'
Gem::Specification.new do |spec|
  spec.name           = 'tenablesc_client'
  spec.author         = 'Rafael Machado'
  spec.platform       = Gem::Platform::RUBY
  spec.version        = TenablescClient::VERSION
  spec.date           = '2024-02-05'
  spec.summary        = %{
    Usable, fast, simple Ruby gem for Tenable Security Center for version v6.2.1.
  }
  spec.licenses       = ['MIT']
  spec.description    = %{
    Usable, fast, simple Ruby gem for Tenable Security Center for version v6.2.1.
    TenablescClient was designed to be simple, fast and performant through communication with Nessus
    over REST interface.
  }
  spec.email          = 'eu@rafael.org'
  spec.homepage       = 'https://github.com/rnm2wrk/tenablesc_client'
  spec.metadata['yard.run'] = 'yri'
  spec.metadata = {
    'documentation_uri' => 'https://rubydoc.info/github/rnm2wrk/tenablesc_client',
    'source_code_uri' => 'https://github.com/rnm2wrk/tenablesc_client'
  }
  spec.extra_rdoc_files = ['README.md', 'CONTRIBUTING.md']
  spec.files          = Dir['lib/**/*.rb']
  spec.require_paths  = ['lib']
  spec.required_ruby_version = '>= 2.5.1'

  spec.add_dependency 'excon', '>= 0.73.0'
  spec.add_dependency 'oj', '~> 3.7'

  spec.add_development_dependency 'bundler', '>= 2.2.33'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'regexp-examples', '>= 1.5.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
