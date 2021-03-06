module MarketTown
  module Checkout
    # Handles delivery method and application of delivery promotions.
    #
    # Dependencies:
    #
    # - {Contracts::Fulfilments#can_fulfil_shipments?}
    # - {Contracts::Fulfilments#apply_shipment_costs}
    # - {Contracts::Promotions#apply_delivery_promotions}
    # - {Contracts::Finish#delivery_step}
    #
    class DeliveryStep < Step
      class InvalidDeliveryAddressError < Error; end
      class CannotFulfilShipmentsError < Error; end

      steps :validate_delivery_address,
            :validate_shipments,
            :apply_shipment_costs,
            :apply_delivery_promotions,
            :load_default_payment_method,
            :finish_delivery_step

      protected

      # @raise [InvalidDeliveryAddressError]
      #
      def validate_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddressError.new(e.data)
      end

      # Tries to validate shipments
      #
      # @raise [CannotFulfilShipmentsError]
      #
      def validate_shipments(state)
        unless deps.fulfilments.can_fulfil_shipments?(state)
          raise CannotFulfilShipmentsError.new(state[:shipments])
        end
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_validate_shipments)
      end

      # Tries to apply shipment costs to delivery address ready to be confirmed at
      # payment step.
      #
      def apply_shipment_costs(state)
        deps.fulfilments.apply_shipment_costs(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_apply_shipment_costs)
      end

      # Tries to apply delivery promotions
      #
      def apply_delivery_promotions(state)
        deps.promotions.apply_delivery_promotions(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_apply_delivery_promotions)
      end

      # Tries to load default payment method
      #
      def load_default_payment_method(state)
        deps.payments.load_default_payment_method(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_load_default_payment_method)
      end

      # Finish delivery step
      #
      def finish_delivery_step(state)
        deps.finish.delivery_step(state)
      end
    end
  end
end
