module TrafficSpy
  class Agent

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
        user_agent = UserAgent.parse(incoming_user_agent)
        browser = user_agent.browser
        # browser = incoming_user_agent.split('/')[0]
        puts browser
        os = user_agent.platform
        # os = incoming_user_agent.split(' ')[1][1..-2]
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

    def self.rank_browser(identifier_id)
      DB.from(:payloads)
        .select(:browser, :count)
        .where(:identifier_id => identifier_id)
        .join(:user_agents, :id => :user_agent_id)
        .group_and_count(:browser)
        .order(Sequel.desc(:count)).to_a
    end

    def self.rank_os(identifier_id)
      DB.from(:payloads)
        .select(:os, :count)
        .where(:identifier_id => identifier_id)
        .join(:user_agents, :id => :user_agent_id)
        .group_and_count(:os)
        .order(Sequel.desc(:count)).to_a
    end

  end
end
