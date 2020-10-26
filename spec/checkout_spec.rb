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
                raise NotImplementedError
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


    
    
end