module TrafficSpy
  class Ip

    def self.table
      DB.from(:ips)
    end

    def self.find(incoming_ip)
      table.where(:ip => incoming_ip).first
    end
    def self.exists?(incoming_ip)
      !table.where(:ip => incoming_ip).empty?
    end

    def self.find_or_create(incoming_ip)
      if exists?(incoming_ip)
        ip_id = table .select(:id)
                      .where(:ip => incoming_ip)
                      .first[:id]
      else
        table.insert(:ip => incoming_ip)
        ip_id = table.where(:ip => incoming_ip).first[:id]
      end
      ip_id
    end
  end
end
