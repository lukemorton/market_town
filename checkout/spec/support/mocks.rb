module Mocks
  def mock_address
    { name: 'Luke Morton',
      address_1: '21 Cool St',
      locality: 'London',
      postal_code: '35005',
      country: 'US',
      phone_number: '111' }
  end
end

RSpec.configure do |config|
  config.include Mocks
end
