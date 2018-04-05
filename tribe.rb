require "pry"
require_relative "products"
require_relative "errors"

class Tribe
  attr_accessor :order_string

  def initialize(order_string)
    @order_string = order_string
    @order = nil

    parse_order_string
  end

  def orders
    orders_array = []
    order_tokens = @order_string.split(" ")
    
    order_tokens.each_with_index do |x,i|
      if i%2 == 0
        raise OrderQuantityInvalid, "#{order_tokens[i]} is not a valid quantity. Valid quantity should be > 0" if order_tokens[i].to_i <= 0
        raise ProductInvalid, "#{order_tokens[i+1]} is not a valid product." unless PRODUCTS.keys.include?(order_tokens[i+1])

        order_hash = Hash.new
        order_hash[:quantity] = order_tokens[i]
        order_hash[:format_code] = order_tokens[i+1]

        orders_array << order_hash
      end
    end

    orders_array
  end

  def calculate_final
    final_invoice = {}
    invoices = calculate_invoice

    invoices.each do |invoice|
      if invoice.has_key?(:error)
        final_invoice[invoice[:format_code]] = invoice
      else
        final_invoice[invoice[:format_code]] = {}
        final_invoice[invoice[:format_code]][:bundles] = []
        final_invoice[invoice[:format_code]][:total] = 0
        final_invoice[invoice[:format_code]][:total_quantity] = 0

        invoice.each do |key, value|
          next if key.to_s == "format_code"

          price_value = PRODUCTS[invoice[:format_code]][key.to_s][:price] * value

          final_invoice[invoice[:format_code]][:total] += price_value
          final_invoice[invoice[:format_code]][:total_quantity] += key * value
          final_invoice[invoice[:format_code]][:bundles] << { bundle_count: key, quantity: value, price: PRODUCTS[invoice[:format_code]][key.to_s][:price] * value}
        end
      end
    end

    final_invoice
  end

  def calculate_invoice
    invoices = []

    orders.each do |order|
      @order = order

      begin
        perm = best_permutation
        invoice = Hash.new(0)
        invoice[:format_code] = @order[:format_code]

        perm.each do |p|
          invoice[p] += 1
        end

        invoices << invoice
      rescue NoPossibleMatches => e
        error_hash = {}
        error_hash[:total_quantity] = @order[:quantity]
        error_hash[:format_code] = @order[:format_code]
        error_hash[:error] = "No possible matches for this order."
        invoices << error_hash
      end
    end

    invoices
  end

  def parse_order_string
    order_tokens = @order_string.split(" ")

    raise OrderStringParseError, "There was an error in the order string. Please ensure that a quantity is followed by a format code. (e.g '15 IMG')" if order_tokens.length % 2 != 0
  end


  private

  def best_permutation
    totals = product_totals

    index =  totals.index(totals.min)

    get_permutations[index].sort.reverse!
  end

  def product_totals
    totals = []
    possible_permutations = get_permutations

    possible_permutations.each do |permutation|
      required_products = []
      permutation.each do |possible_bundle|
        required_products << PRODUCTS[@order[:format_code]][possible_bundle.to_s]
      end

      totals << required_products.map{|product_set| product_set[:price]}.inject(:+)
    end

    totals
  end

  def get_permutations
    candidates = product_candidates
    possible_permutations = []

    (1..candidates.length).each do |permutation_count|
      possible_permutations += candidates.repeated_permutation(permutation_count).to_a.select { |p| (p.inject(:+) % @order[:quantity].to_i) == 0 && p.inject(:+) <= @order[:quantity].to_i }
    end

    raise NoPossibleMatches, "No possible matches for this order." if possible_permutations.empty?

    possible_permutations
  end

  def product_candidates
    raise ProductInvalid, "No product matches for #{@order[:format_code]}" unless PRODUCTS[@order[:format_code]]

    PRODUCTS[@order[:format_code]].map{|key, value| value[:bundle_count]}
  end
end