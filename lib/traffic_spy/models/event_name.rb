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

    def self.display_events(identifier_id)
      event_names = Payload.by_id(identifier_id[:id])
                           .join(:event_names, :id => :event_name_id)
                           .group_and_count(:event_name)
                           .order(Sequel.desc(:count))
                           .to_a
                           .map{|entry| [entry[:event_name], entry[:count]]}
      puts event_names.inspect
      event_names
    end

    def self.event_details(identifier_id, event_name)
      event_details = Payload.by_id(identifier_id[:id])
                             .join(:event_names, :id => :event_name_id)
                             .select(:event_name, :requested_at)
                             .where(:event_name => event_name)
                             .group_and_count(:requested_at)
                             .to_a
                             .map{|entry| [entry[:requested_at], entry[:count]]}
      puts event_details.inspect
                            #  .group_and_count(:requested_at)
      event_details
    end

    def self.hour_by_hour(event_details)
      event_by_hour = event_details.map do |item|
        time = []
        if time_24(item[0]) == 12
          time << ["12pm", item[1]]
        elsif time_24(item[0]) == 0
          time << ["12am", item[1]]
        elsif time_24(item[0]) > 12
          time << ["#{time_12(item[0])}pm", item[1]]
        else
          time << ["#{time_12(item[0])}am", item[1]]
        end
        puts time.inspect
        time.flatten
      end
      puts event_by_hour.inspect
      event_by_hour
    end

    def self.total_count(event_details)
      event_details.map do |item|
        total = []
        total << item[1]
      end.flatten.reduce(:+)
    end

    def self.time_24(time)
      Time.parse(time).strftime("%H").to_i
    end

    def self.time_12(time)
      Time.parse(time).strftime("%I").to_i
    end
  end
end
