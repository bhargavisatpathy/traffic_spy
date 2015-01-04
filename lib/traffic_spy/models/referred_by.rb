module TrafficSpy
  class ReferredBy

    def self.table
      DB.from(:referred_bys)
    end

    def self.find(incoming_referred_by)
      table.where(:referred_by => incoming_referred_by).first
    end

    def self.exists?(incoming_referred_by)
      !table.where(:referred_by => incoming_referred_by).empty?
    end

    def self.find_or_create(incoming_referred_by)
      if exists?(incoming_referred_by)
        referred_by_id = table.select(:id)
                              .where(:referred_by => incoming_referred_by)
                              .first[:id]
        puts "We found referred by"
      else
        puts "we didn't find referred by"
        table.insert(:referred_by => incoming_referred_by)
        referred_by_id = table.where(:referred_by => incoming_referred_by)
                              .first[:id]
      end
      referred_by_id
    end
  end

end
