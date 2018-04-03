# order = "10 IMG 15 FLAC 13 VID"
order = "13 VID"

PRODUCTS = [{ name: "Image5", format_code: "IMG", bundle_count: 5, price: 450 },
            { name: "Image10", format_code: "IMG", bundle_count: 10, price: 800 },
            { name: "Audio3", format_code: "FLAC", bundle_count: 3, price: 427.5 },
            { name: "Audio6", format_code: "FLAC", bundle_count: 6, price: 810 },
            { name: "Audio6", format_code: "FLAC", bundle_count: 9, price: 1147.5 },
            { name: "Video3", format_code: "VID", bundle_count: 3, price: 570 },
            { name: "Video5", format_code: "VID", bundle_count: 5, price: 900 },
            { name: "Video9", format_code: "VID", bundle_count: 9, price: 1530 }]

order_count = []
order_type = []
orders_array = []

order_tokens = order.split(" ")

order_tokens.each_with_index do |x,i|
  if i%2 == 0
    # puts [orders[i], orders[i+1]]
    # orders_array << [order_tokens[i], order_tokens[i+1]]
    orders_array << {
      quantity: order_tokens[i],
      format_code: order_tokens[i + 1]
    }
  end
end

imgs = []
audio = []
video = []

# {:name=>"Image10", :format_code=>"IMG", :bundle_count=>10, :price=>800}
# {:name=>"Image5", :format_code=>"IMG", :bundle_count=>5, :price=>450}
# {:name=>"Audio6", :format_code=>"FLAC", :bundle_count=>9, :price=>1147.5}
# {:name=>"Audio6", :format_code=>"FLAC", :bundle_count=>6, :price=>810}
# {:name=>"Audio3", :format_code=>"FLAC", :bundle_count=>3, :price=>427.5}
# {:name=>"Video9", :format_code=>"VID", :bundle_count=>9, :price=>1530}
# {:name=>"Video5", :format_code=>"VID", :bundle_count=>5, :price=>900}
# {:name=>"Video3", :format_code=>"VID", :bundle_count=>3, :price=>570}


orders_array.each do |order|

  # {:quantity=>"10", :format_code=>"IMG"}
  # {:quantity=>"15", :format_code=>"FLAC"}
  # {:quantity=>"13", :format_code=>"VID"}
  puts order

  required_products = PRODUCTS.select{|product| product[:format_code] == order[:format_code]}.sort { |a, b|
    b[:bundle_count] <=> a[:bundle_count]
  }

  puts required_products

  running_total = 0.0
  remaining = order[:quantity].to_i

  puts "----"
  puts "initial remaining #{remaining}"

  required_products.each_with_index do |required_product, i|
    puts "---"

    puts "remaining at start #{remaining}"

    puts required_product

    current_quantity = remaining / required_product[:bundle_count]
    puts "current_quantity #{current_quantity}"

    running_total += current_quantity * required_product[:price]

    remaining = remaining.to_i % required_product[:bundle_count]

    puts "running_total #{running_total}"
    puts "remaining #{remaining}"
    puts "---"

    break if remaining == 0
  end

  puts running_total

end
