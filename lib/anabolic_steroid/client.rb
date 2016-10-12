require 'anabolic_steroid/config'
require 'mechanize'

module AnabolicSteroid
  class Client
    attr_accessor :config_file

    def initialize(url, config)
      @url = url
      @agent = Mechanize.new
      @config = config
      @next_url = @url
    end

    def each(*args, &block)
      while @next_url
        @agent.get(@next_url) do |page|
          retrieve_date(page, block, *args)
          hit = page.parser.xpath(@config.next_page_link_xpath)
          if hit.empty?
            @next_url = nil
          else
            link = page.link_with(hit[0])
            absolute_link = page.uri.merge(link.uri).to_s
            @next_url = absolute_link
          end
        end
      end
    end

  private

    def retrieve_date(page, block, *args)
      unless @config.entry_link_xpath.nil?
        hit = page.parser.xpath(@config.entry_link_xpath)
        hit.each do |entry|
          link = page.link_with(entry)
          absolute_link = page.uri.merge(link.uri).to_s
          @agent.get(absolute_link) do |entry_page|
            date_str = entry_page.parser.xpath(@config.entry_date_xpath).first.to_s
            block.call(to_date(date_str))
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
