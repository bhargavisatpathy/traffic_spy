module TrafficSpy
  class UserAgent

    def self.table
      DB.from(:user_agents)
    end

    def self.get_id(incoming_user_agent)
      table.where(:user_agent => incoming_user_agent).to_a[0][:id]
    end

    def self.user_agents_table(incoming_user_agent)
      if table.select(:user_agent)
              .to_a.any? {|item| item[:user_agent] == incoming_user_agent }
        user_agent_id = table.select(:id)
                             .where(:user_agent => incoming_user_agent)
                             .to_a[0][:id]
        puts "We found user agents"
      else
        puts "we didn't find user agents"
        browser = incoming_user_agent.split(' ')[0]
        puts browser
        os = incoming_user_agent.split(' ')[1][1..-2]
        puts os
        table.insert(:user_agent => incoming_user_agent,
                     :browser => browser,
                     :os => os)
        user_agent_id = table.from(:user_agents)
                             .where(:user_agent => incoming_user_agent)
                             .to_a[0][:id]
      end
      user_agent_id
    end

    def self.browserlist
      table.select(:browser).to_a
           .map { |item| item[:browser] }.uniq
    end

  end
end
