module TrafficSpy
  class Ip

    def self.table
      DB.from(:ips)
    end

    def self.get_id(incoming_ip)
      table.where(:ip => incoming_up).to_a[0][:id]
    end

    def self.ip_table(incoming_ip)
      if table.select(:ip).to_a.any? {|item| item[:ip] == incoming_ip }
        ip_id = table .select(:id)
                      .where(:ip => incoming_ip)
                      .to_a[0][:id]
        puts "We found ip"
      else
        puts "we didn't find ip"
        table.insert(:ip => incoming_ip)
        ip_id = table.where(:ip => incoming_ip).to_a[0][:id]
      end
      ip_id
    end
  end
end
