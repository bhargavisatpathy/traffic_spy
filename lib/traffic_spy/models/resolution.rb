module TrafficSpy
  class Resolution
    def self.table
      DB.from(:resolutions)
    end

    def self.exists?(resolution_width, resolution_height)
      !table.where(:width => resolution_width, :height => resolution_height)
            .empty?
    end

    def self.find_or_create(resolution_width, resolution_height)
      if self.exists?(resolution_width, resolution_height)
        resolution_id = table.select(:id).where(:width => resolution_width)
                             .where(:height => resolution_height).first[:id]
      else
        table.insert(:width => resolution_width, :height => resolution_height)
        resolution_id = table.where(:width => resolution_width,
                                    :height => resolution_height).first[:id]
      end
      resolution_id
    end

    def self.display_resolution(identifier)
      resolution = Payload.table
                     .select(:resolution_id)
                     .where(:identifier_id => identifier[:id])
                     .join(:resolutions, :id => :resolution_id)
                     .select(:width, :height).to_a
                     .map {|entry| [entry[:width], entry[:height]] }.uniq
      resolution
    end
  end

end
