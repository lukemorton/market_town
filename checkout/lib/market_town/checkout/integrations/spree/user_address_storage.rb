module MarketTown
  module Checkout
    module Spree
      class UserAddressStorage
        def load_default_addresses(state)
          if state[:order].user_id?
            state[:order].bill_address = state[:order].user.bill_address.try(:clone)
            state[:order].ship_address = state[:order].user.ship_address.try(:clone)
            nil
          end
        end

        def store_billing_address(state)
          if state[:order].user_id?
            state[:order].user.bill_address_attributes = transform_address(state[:billing_address])
            state[:order].user.save!
            nil
          end
        end

        def store_delivery_address(state)
          if state[:order].user_id?
            state[:order].user.ship_address_attributes = transform_address(state[:delivery_address])
            state[:order].user.save!
            nil
          end
        end

        private

        def transform_address(address)
          AddressTransformation.new.transform(address)
        end
      end
    end
  end
end
