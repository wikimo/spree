require_dependency 'spree/calculator'

module Spree
  class Calculator::FlatWithProducts < Calculator
    preference :amount, :decimal, default: 0
    preference :currency, :string, default: ->{ Spree::Config[:currency] }

    def self.description
      Spree.t(:flat_with_products)
    end

    def compute(object=nil)
      if object && preferred_currency.upcase == object.currency.upcase

        # get promotion and related products
        promotion = Spree::Promotion.find_by_description '1A/1B'
        promotion_products =  promotion.products

        # check line_items if exist in promotion
        product_nums = []
        promotion_products.each do |check_product|
          object.line_items.each do |item|
            if item.variant_id == check_product.id
              product_nums << item.quantity
            end
          end
        end

        return product_nums.min * preferred_amount if product_nums.size > 0
      end

      0
    end
  end
end
