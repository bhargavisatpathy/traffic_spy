module TrafficSpy
  class ReferredBy

    def self.table
      DB.from(:referred_bys)
    end

    def self.get_id(incoming_referred_by)
      table.where(:referred_by => incoming_referred_by).to_a[0][:id]
    end

    def self.referred_by_table(incoming_referred_by)
      if table.select(:referred_by)
              .to_a.any? {|item| item[:referred_by] == incoming_referred_by }
        referred_by_id = table.select(:id)
                              .where(:referred_by => incoming_referred_by)
                              .to_a[0][:id]
        puts "We found referred by"
      else
        puts "we didn't find referred by"
        table.insert(:referred_by => incoming_referred_by)
        referred_by_id = table.where(:referred_by => incoming_referred_by)
                              .to_a[0][:id]
      end
      referred_by_id
    end
  end

end
