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
