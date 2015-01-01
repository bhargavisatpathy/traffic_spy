module TrafficSpy
  class UserAgent
    def self.user_agents_table(incoming_user_agent)
      if DB.from(:user_agents).select(:user_agent).to_a.any? {|item| item[:user_agent] == incoming_user_agent }
        DB.from(:user_agents).select(:id).where(:user_agent => incoming_user_agent).to_a[0][:id]
        puts "We found user agents"
      else
        puts "we didn't find user agents"
        DB.from(:user_agents).insert(:user_agent => incoming_user_agent)
        DB.from(:user_agents).where(:user_agent => incoming_user_agent).to_a[0][:id]
      end
    end
  end
end
