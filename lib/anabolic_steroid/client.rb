require 'anabolic_steroid/config'
require 'mechanize'

module AnabolicSteroid
  class Client
    attr_accessor :config_file

    def initialize(url, config_path, options = {})
      @url = url
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
      @agent = Mechanize.new
      @config = AnabolicSteroid::Config.new(config_path)
      @next_url = @url
    end

    def each(*args, &block)
      while @next_url
        @agent.get(@next_url) do |page|
          retrieve_date(block, *args)
          @next_url = page.parser.xpath(@config.next_page_xpath).to_s
        end
      end
    end

  private

    def retrieve_date(block, *args)
      unless @config.entry_link_xpath.nil?
        page.parser.xpath(@config.entry_link_xpath).each do |entry|
          @agent.get(entry.href.to_s) do |entry_page|
            block.call(to_date(entry_page.parser.xpath(@config.entry_date_xpath).first.to_s))
          end
        end
      else
        page.parser.xpath(@config.entry_date_xpath).each do |date|
          block.call(to_date(date.to_s))
        end
      end
    end

    def to_date(str)
      str.to_s
    end
  end
end
