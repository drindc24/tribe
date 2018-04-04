require "pry"

order = "10 IMG 15 FLAC 13 VID"

PRODUCTS = {
  "VID" => {
    "3" => { name: "Video3", format_code: "VID", bundle_count: 3, price: 570 },
    "5" => { name: "Video5", format_code: "VID", bundle_count: 5, price: 900 },
    "9" => { name: "Video9", format_code: "VID", bundle_count: 9, price: 1530 },
  },

  "FLAC" => {
      "3" => { name: "Audio3", format_code: "FLAC", bundle_count: 3, price: 427.50 },
      "6" => { name: "Audio6", format_code: "FLAC", bundle_count: 6, price: 810 },
      "9" => { name: "Audio9", format_code: "FLAC", bundle_count: 9, price: 1147.50 },
  },

  "IMG" => {
      "5" => { name: "Image5", format_code: "IMG", bundle_count: 5, price: 450 },
      "10" => { name: "Image10", format_code: "IMG", bundle_count: 10, price: 800 }
  }
}


orders_array = []

order_tokens = order.split(" ")

order_tokens.each_with_index do |x,i|
  if i%2 == 0
    order_hash = Hash.new
    order_hash[:quantity] = order_tokens[i]
    order_hash[:format_code] = order_tokens[i+1]

    orders_array << order_hash
  end
end

orders_array.each do |order|
  product_candidates = PRODUCTS[order[:format_code]].map{|key, value| value[:bundle_count]}
  possible_permutations = []

  (1..product_candidates.length).each do |permutation_count|
    possible_permutations += product_candidates.repeated_permutation(permutation_count).to_a.select { |p| (p.inject(:+) % order[:quantity].to_i) == 0 && p.inject(:+) <= order[:quantity].to_i }
  end

  # error if there are no possible permutations

  product_totals = []

  possible_permutations.each do |permutation|
    required_products = []

    permutation.each do |possible_bundle|
      required_products << PRODUCTS[order[:format_code]][possible_bundle.to_s]
    end

    product_totals << required_products.map{|product_set| product_set[:price]}.inject(:+)
  end

  permutation_index = product_totals.index(product_totals.min)
  best_permutation = possible_permutations[permutation_index].sort.reverse!

  bundle_counts = Hash.new(0)
  best_permutation.each{|perm| bundle_counts[perm] += 1}

  running_total = product_totals.min
  puts "#{order[:quantity]} #{order[:format_code]} $#{running_total}"
  bundle_counts.each{|key, value| puts "   #{value} x #{ key } $#{ PRODUCTS[order[:format_code]][key.to_s][:price] }"}
end
