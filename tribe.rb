order = "10 IMG 15 FLAC 13 VID"
# order = "13 VID"

PRODUCTS = [{ name: "Image5", format_code: "IMG", bundle_count: 5, price: 450 },
            { name: "Image10", format_code: "IMG", bundle_count: 10, price: 800 },
            { name: "Audio3", format_code: "FLAC", bundle_count: 3, price: 427.5 },
            { name: "Audio6", format_code: "FLAC", bundle_count: 6, price: 810 },
            { name: "Audio9", format_code: "FLAC", bundle_count: 9, price: 1147.5 },
            { name: "Video3", format_code: "VID", bundle_count: 3, price: 570 },
            { name: "Video5", format_code: "VID", bundle_count: 5, price: 900 },
            { name: "Video9", format_code: "VID", bundle_count: 9, price: 1530 }]

LOOKUP_PRODUCTS = {
  "VID" => {
    "3" => { name: "Video3", format_code: "VID", bundle_count: 3, price: 570 },
    "5" => { name: "Video5", format_code: "VID", bundle_count: 5, price: 900 },
    "9" => { name: "Video9", format_code: "VID", bundle_count: 9, price: 1530 },
  },

  "FLAC" => {
      "3" => { name: "Audio3", format_code: "FLAC", bundle_count: 3, price: 427.5 },
      "5" => { name: "Audio6", format_code: "FLAC", bundle_count: 6, price: 810 },
      "9" => { name: "Audio9", format_code: "FLAC", bundle_count: 9, price: 1147.5 },
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

# {:name=>"Image10", :format_code=>"IMG", :bundle_count=>10, :price=>800}
# {:name=>"Image5", :format_code=>"IMG", :bundle_count=>5, :price=>450}
# {:name=>"Audio6", :format_code=>"FLAC", :bundle_count=>9, :price=>1147.5}
# {:name=>"Audio6", :format_code=>"FLAC", :bundle_count=>6, :price=>810}
# {:name=>"Audio3", :format_code=>"FLAC", :bundle_count=>3, :price=>427.5}
# {:name=>"Video9", :format_code=>"VID", :bundle_count=>9, :price=>1530}
# {:name=>"Video5", :format_code=>"VID", :bundle_count=>5, :price=>900}
# {:name=>"Video3", :format_code=>"VID", :bundle_count=>3, :price=>570}

# [9,5,3].repeated_permutation(3).to_a.select { |p| p.inject(:+) % 13 == 0 }



orders_array.each do |order|
  puts order

  required_products = []

  product_candidates = PRODUCTS.select { |p| p[:format_code] == order[:format_code] }.map { |m| m[:bundle_count] }
  possible_permutations = product_candidates.repeated_permutation(product_candidates.length).to_a.select { |p| (p.inject(:+) % order[:quantity].to_i) == 0 }

  # error if there are no possible permutations

  possible_permutations[0].each do |possible_bundle|
    required_products << LOOKUP_PRODUCTS[order[:format_code]][possible_bundle.to_s]
  end

  running_total = required_products.map{|product| product[:price]}.inject(:+)
  puts running_total

end
