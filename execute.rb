require_relative "tribe"

tribe = Tribe.new(ARGV[0])

invoice = tribe.calculate_final

invoice.each do |key, value|
  if value[:error]
    puts "#{value[:total_quantity]} #{key} $0"
    puts "  #{value[:error]}"
  else
    puts "#{value[:total_quantity]} #{key} $#{value[:total]}"
    value[:bundles].each do |bundle|
      puts "  #{bundle[:quantity]} x #{bundle[:bundle_count]} $#{bundle[:price]}"
    end
  end
end
