require_relative "tribe"

tribe = Tribe.new("10 IMG 15 FLAC 13 VID")

invoice = tribe.calculate_final

invoice.each do |key, value|
  puts "#{value[:total_quantity]} #{key} $#{value[:total]}"
    value[:bundles].each do |bundle|
      puts "  #{bundle[:quantity]} x #{bundle[:bundle_count]} $#{bundle[:price]}"
    end
end
