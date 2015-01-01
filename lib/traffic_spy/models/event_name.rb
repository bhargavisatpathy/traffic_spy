module TrafficSpy
  class EventName
    def self.event_names_table(incoming_event_name)
      if DB.from(:event_names).select(:event_name).to_a.any? {|item| item[:event_name] == incoming_event_name }
        DB.from(:event_names).select(:id).where(:event_name => incoming_event_name).to_a[0][:id]
        puts "We found event name"
      else
        puts "we didn't find event name"
        DB.from(:event_names).insert(:event_name => incoming_event_name)
        DB.from(:event_names).where(:event_name => incoming_event_name).to_a[0][:id]
      end
    end
  end
end
