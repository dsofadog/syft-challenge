require_relative "../lib/checkout.rb"

describe "Checkout" do
    it "should fail" do
        expect(true).to be_truthy 
    end

    it "product database should retain products" do
        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)
        expect(catalogue.count).to eq(3)
    end

    it "product catalougue should be able get products products" do
        catalogue = Catalogue.new
        product = Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "001", item: product
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)
        expect(catalogue.get(code: "001")).to eq(product)
    end

    it "should be able to scan items in the checkout and get totals" do
        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)

        promotional_rules = []
        co = Checkout.new(rules:promotional_rules,catalougue: catalogue)
        co.scan(code: "001")
        price = co.total
        expect(price).to eq(925)
    end


    it "should be able to scan items in the checkout and get totals for two items" do
        catalogue = Catalogue.new

        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)

        promotional_rules = []
        co = Checkout.new(rules:promotional_rules,catalougue: catalogue)
        co.scan(code: "001")
        co.scan(code: "002")
        price = co.total
        expect(price).to eq(5425)
    end

    it "Orders over 60 get 10% discount" do
        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)

        promotional_rules = []
        promotional_rules << TenPercentPromotionalRule

        co = Checkout.new(rules:promotional_rules,catalougue: catalogue)
        co.scan(code: "001")
        co.scan(code: "002")
        co.scan(code: "003")
        price = co.total
        expect(price).to eq(6678)
    end

    it "lavender hearts promotion" do

        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "
            Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)

        promotional_rules = []
        promotional_rules << TenPercentPromotionalRule
        promotional_rules << LavenderHeartsPromotionalRule

        co = Checkout.new(rules:promotional_rules,catalougue: catalogue)
        co.scan(code: "001")
        co.scan(code: "003")
        co.scan(code: "001")
        price = co.total
        expect(price).to eq(3695)
    end

    it "lavender hearts promotion with 3 items" do

       
        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "
            Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)

        promotional_rules = []
        promotional_rules << TenPercentPromotionalRule
        promotional_rules << LavenderHeartsPromotionalRule

        co = Checkout.new(rules:promotional_rules,catalougue: catalogue)
        co.scan(code: "001")
        co.scan(code: "003")
        co.scan(code: "001")
        co.scan(code: "001")
        price = co.total
        expect(price).to eq(4545)
    end

    it "lavender hearts promotion with 10 percent discount " do

        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "
            Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)

        promotional_rules = []
        promotional_rules << LavenderHeartsPromotionalRule
        promotional_rules << TenPercentPromotionalRule
        

        co = Checkout.new(rules:promotional_rules,catalougue: catalogue)
        co.scan(code: "001")
        co.scan(code: "002")
        co.scan(code: "001")
        co.scan(code: "003")
        price = co.total
        expect(price).to eq(7376)
    end


    
    
    
end