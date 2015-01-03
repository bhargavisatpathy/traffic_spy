module TrafficSpy
  class EventName

    def self.table
      DB.from(:event_names)
    end

    def self.find(incoming_event_name)
      table.where(:event_name => incoming_event_name).first
    end

    def self.exists?(incoming_event_name)
      !table.where(:event_name => incoming_event_name).empty?
    end

    def self.find_or_create(incoming_event_name)
      if exists?(incoming_event_name)
        event_name_id = table .select(:id)
                              .where(:event_name => incoming_event_name)
                              .first[:id]
        puts "We found event name"
      else
        puts "we didn't find event name"
        table.insert(:event_name => incoming_event_name)
        event_name_id = table .where(:event_name => incoming_event_name)
                              .first[:id]
      end
      event_name_id
    end

    def self.display_events(identifier)
      event_names = Payload.by_id(identifier[:id])
                           .join(:event_names, :id => :event_name_id)
                           .group_and_count(:event_name)
                           .order(Sequel.desc(:count))
                           .to_a
                           .map{|entry| [entry[:event_name], entry[:count]]}
      puts event_names.inspect
      event_names
    end
  end
end
