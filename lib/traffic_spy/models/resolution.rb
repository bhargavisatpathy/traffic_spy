module TrafficSpy
  class Resolution
    def self.find_resolution_id(resolution_width, resolution_height)
      if DB.from(:resolutions).select(:width, :height).to_a.any? {|item| item[:width] == resolution_width && item[:height] == resolution_height}
        resolution_id = DB.from(:resolutions).select(:id).where(:width => resolution_width).where(:height => resolution_height).to_a[0][:id]
        puts "We found resolution"
      else
        puts "we didn't find resolution"
        DB.from(:resolutions).insert(:width => resolution_width, :height => resolution_height)
        resolution_id = DB.from(:resolutions).where(:width => resolution_width, :height => resolution_height).to_a[0][:id]
      end
      resolution_id
    end
  end

end
