require_relative 'lib/market_town/checkout/version'

Gem::Specification.new do |s|
  s.name     = 'market_town-checkout'
  s.version  = MarketTown::Checkout::VERSION
  s.licenses = ['MIT']
  s.summary  = 'Business logic for e-commerce checkouts'
  s.authors  = ['Luke Morton']
  s.email    = 'lukemorton.dev@gmail.com'
  s.files    = Dir['lib/**/*.rb'] + ['README']
  s.homepage = 'https://github.com/lukemorton/market_town'

  s.add_dependency 'activemodel'
  s.add_dependency 'countries'

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
