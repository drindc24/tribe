require_relative("../tribe")

describe Tribe do
  context "Initialization" do
    it "should return the correct class" do
      tribe = Tribe.new("10 IMG")

      expect(tribe).to be_a(Tribe)
    end

    it "should raise an exception when there is no order string" do
      expect{ Tribe.new }.to raise_error(ArgumentError)
    end
  end

  context "methods" do
    context "orders" do
      it "should parse the order string properly and return an array of arrays" do
        tribe = Tribe.new("5 IMG 10 FLAC 15 VID")

        expect(tribe.orders[0]).to eq({quantity: "5", format_code: "IMG"})
        expect(tribe.orders[1]).to eq({quantity: "10", format_code: "FLAC"})
        expect(tribe.orders[2]).to eq({quantity: "15", format_code: "VID"})
      end

      it "should raise an error if a valid quantity is given" do
        tribe = Tribe.new("0 IMG")

        expect{ tribe.orders }.to raise_error(OrderQuantityInvalid)
      end

      it "should raise an error if an invalid product is given" do
        tribe = Tribe.new("15 GOLD")

        expect{ tribe.orders }.to raise_error(ProductInvalid)
      end
    end

    context "parse order string" do
      it "should detect if the order string has invalid tokens" do
        expect{ Tribe.new("15 15 IMG") }.to raise_error(OrderStringParseError)
      end
    end

    context "calculate invoice" do
      let(:tribe){ Tribe.new("10 IMG") }

      it "should be an array of hashes" do
        expect(tribe.calculate_invoice).to be_a(Array)
        expect(tribe.calculate_invoice[0]).to be_a(Hash)
      end
      it "should detect if an order cannot be processed because of lack of bundles" do
        tribe = Tribe.new("1 IMG")

        expect(tribe.calculate_invoice).to eq([{:total_quantity=>"1", :format_code=>"IMG", :error=>"No possible matches for this order."}])
      end

      it "should return a hash with format_code, and bundle counts" do
        expect(tribe.calculate_invoice[0][:format_code]).to eq("IMG")
        expect(tribe.calculate_invoice[0][10]).to eq(1)
      end
    end

    context "calculate final" do
      let(:tribe){ Tribe.new("10 IMG") }
      let(:product){ PRODUCTS["IMG"]["10"] }

      it "should return a hash" do
        expect(tribe.calculate_final).to be_a(Hash)
      end

      it "should return a hash complete with all necessary details" do
        expect(tribe.calculate_final.keys.first).to eq("IMG")
        expect(tribe.calculate_final["IMG"][:total_quantity]).to eq(10)
        expect(tribe.calculate_final["IMG"][:total]).to eq(800)
      end
    end
  end
end
