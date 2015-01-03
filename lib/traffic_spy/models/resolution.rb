module TrafficSpy
  class Resolution
    def self.table
      DB.from(:resolutions)
    end

    def self.find_resolution_id(resolution_width, resolution_height)
      if table.select(:width, :height)
              .to_a.any? {|item| item[:width] == resolution_width \
                              && item[:height] == resolution_height}
        resolution_id = table.select(:id).where(:width => resolution_width)
                             .where(:height => resolution_height).to_a[0][:id]
        puts "We found resolution"
      else
        puts "we didn't find resolution"
        table.insert(:width => resolution_width, :height => resolution_height)
        resolution_id = table.where(:width => resolution_width,
                                    :height => resolution_height).to_a[0][:id]
      end
      resolution_id
    end

    def self.display_resolution(identifier_id)
      resolution = DB.from(:payloads)
                     .select(:resolution_id)
                     .where(:identifier_id => identifier_id)
                     .join(:resolutions, :id => :resolution_id)
                     .select(:width, :height).to_a
                     .map {|entry| [entry[:width], entry[:height]] }.uniq
      puts resolution.inspect
      resolution
    end
  end

end
