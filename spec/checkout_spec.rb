describe "Checkout" do
    it "should fail" do
        expect(true).to be_truthy 
    end

    it "product database should retain products" do

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end
            def count
                @items.count
            end
        end
        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        catalogue = Catalogue.new
        catalogue.add code: "001", item: Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)
        expect(catalogue.count).to eq(3)
    end

    it "product catalougue should be able get products products" do

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end
        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        catalogue = Catalogue.new
        product = Product.new(name: "Lavender heart", price: 925)
        catalogue.add code: "001", item: product
        catalogue.add code: "002", item: Product.new(name: "Personalised cufflinks", price: 4500)
        catalogue.add code: "003", item: Product.new(name: "Kids T-shirt", price: 1995)
        expect(catalogue.get(code: "001")).to eq(product)
    end

    it "should be able to scan items in the checkout and get totals" do

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end
        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        class Checkout
            def initialize(rules:[],catalougue: Catalogue.new)
                @rules = rules
                @catalougue = catalougue
                @scanned_items = []
            end
            def scan(code:)
                @scanned_items << @catalougue.get(code: code)
            end
            def total
                @scanned_items.map(&:price).sum
            end
        end

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

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end
        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        class Checkout
            def initialize(rules:[],catalougue: Catalogue.new)
                @rules = rules
                @catalougue = catalougue
                @scanned_items = []
            end
            def scan(code:)
                @scanned_items << @catalougue.get(code: code)
            end
            def total
                @scanned_items.map(&:price).sum
            end
        end

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

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end

        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        class Checkout
            def initialize(rules:[],catalougue: Catalogue.new)
                @rules = rules
                @catalougue = catalougue
                @scanned_items = []
            end
            def scan(code:)
                @scanned_items << @catalougue.get(code: code)
            end
            def total
                result = @scanned_items.map(&:price).sum
                @rules.each do |rule|
                    result = rule.new(items: @scanned_items).apply_rule_to result
                end
                result
            end
        end

        class TenPercentPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total
                if total > 6000
                    total = total - (total*0.1)
                end
                total
            end
        end

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

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end

        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        class Checkout
            def initialize(rules:[],catalougue: Catalogue.new)
                @rules = rules
                @catalougue = catalougue
                @scanned_items = []
            end
            def scan(code:)
                @scanned_items << @catalougue.get(code: code)
            end
            def total
                result = @scanned_items.map(&:price).sum
                @rules.each do |rule|
                    result = rule.new(items: @scanned_items).apply_rule_to result
                end
                result
            end
        end

        class TenPercentPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total
                if total > 6000
                    total = total - (total*0.1)
                end
                total
            end
        end
        
        class LavenderHeartsPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total

                if(@items.select{|p| p.name =="Lavender heart"}.count >=2)
                    @items.select{|p| p.name =="Lavender heart"}.each do |product|
                        product.price = 850
                    end
                end

                @items.map(&:price).sum
            end
        end

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

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end

        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        class Checkout
            def initialize(rules:[],catalougue: Catalogue.new)
                @rules = rules
                @catalougue = catalougue
                @scanned_items = []
            end
            def scan(code:)
                @scanned_items << @catalougue.get(code: code)
            end
            def total
                result = @scanned_items.map(&:price).sum
                @rules.each do |rule|
                    result = rule.new(items: @scanned_items).apply_rule_to result
                end
                result
            end
        end

        class TenPercentPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total
                if total > 6000
                    total = total - (total*0.1)
                end
                total
            end
        end
        
        class LavenderHeartsPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total

                if(@items.select{|p| p.name =="Lavender heart"}.count >=2)
                    @items.select{|p| p.name =="Lavender heart"}.each do |product|
                        product.price = 850
                    end
                end

                @items.map(&:price).sum
            end
        end

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

        # Product code  | Name                   | Price
        # ----------------------------------------------------------
        # 001           | Lavender heart         | £9.25
        # 002           | Personalised cufflinks | £45.00
        # 003           | Kids T-shirt           | £19.95        

        class Catalogue
            def initialize()
              @items = {}
            end

            def add code:,item:
                @items[code] = item 
            end

            def get(code:)
              @items[code]
            end

            def count
                @items.count
            end
        end

        class Product
            attr_accessor :name, :price
            def initialize(name:,price:)
              @name = name
              @price = price
            end
        end

        class Checkout
            def initialize(rules:[],catalougue: Catalogue.new)
                @rules = rules
                @catalougue = catalougue
                @scanned_items = []
            end
            def scan(code:)
                @scanned_items << @catalougue.get(code: code)
            end
            def total
                result = @scanned_items.map(&:price).sum
                @rules.each do |rule|
                    result = rule.new(items: @scanned_items).apply_rule_to result
                end
                result
            end
        end

        class TenPercentPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total
                if total > 6000
                    total = total - (total*0.1)
                end
                total.round
            end
        end
        
        class LavenderHeartsPromotionalRule
            def initialize(items:)
              @items = items
            end
            def apply_rule_to total

                if(@items.select{|p| p.name =="Lavender heart"}.count >=2)
                    @items.select{|p| p.name =="Lavender heart"}.each do |product|
                        product.price = 850
                    end
                end

                @items.map(&:price).sum
            end
        end

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