module TrafficSpy
  class Ip
    def self.ip_table(incoming_ip)
      if DB.from(:ips).select(:ip).to_a.any? {|item| item[:ip] == incoming_ip }
        DB.from(:ips).select(:id).where(:ip => incoming_ip).to_a[0][:id]
        puts "We found ip"
      else
        puts "we didn't find ip"
        DB.from(:ips).insert(:ip => incoming_ip)
        DB.from(:ips).where(:ip => incoming_ip).to_a[0][:id]
      end
    end
  end
end
