module TrafficSpy
  class ReferredBy
    def self.referred_by_table(incoming_referred_by)
      if DB.from(:referred_bys).select(:referred_by).to_a.any? {|item| item[:referred_by] == incoming_referred_by }
        referred_by_id = DB.from(:referred_bys).select(:id).where(:referred_by => incoming_referred_by).to_a[0][:id]
        puts "We found referred by"
      else
        puts "we didn't find referred by"
        DB.from(:referred_bys).insert(:referred_by => incoming_referred_by)
        referred_by_id = DB.from(:referred_bys).where(:referred_by => incoming_referred_by).to_a[0][:id]
      end
      referred_by_id
    end
  end

end
