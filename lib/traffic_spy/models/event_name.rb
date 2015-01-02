module TrafficSpy
  class EventName

    def self.table
      DB.from(:event_names)
    end

    def self.get_id(incoming_event_name)
      table.where(:event_name => incoming_event_name).to_a[0][:id]
    end

    def self.event_names_table(incoming_event_name)
      if table.select(:event_name).to_a.any? {|item| item[:event_name] == incoming_event_name }
        event_name_id = table .select(:id)
                              .where(:event_name => incoming_event_name)
                              .to_a[0][:id]
        puts "We found event name"
      else
        puts "we didn't find event name"
        table.insert(:event_name => incoming_event_name)
        event_name_id = table .where(:event_name => incoming_event_name)
                              .to_a[0][:id]
      end
      event_name_id
    end
  end
end
