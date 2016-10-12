require 'mechanize'

module AnabolicSteroid
  class Client
    include Enumerable
    attr_accessor :config_file

    def initialize(url, config)
      @url = url
      @agent = Mechanize.new
      @config = config
      @next_url = @url
    end

    def each(*args, &block)
      if !block_given?
        Enumerator.new do |yielder|
          block = proc { |entry_page|
            yielder << entry_page
          }
          loop(block)
        end
      else
        loop(block)
        self
      end
    end

    def loop(block)
      while @next_url
        @agent.get(@next_url) do |page|
          retrieve(page, block)
          hit = match(page, :next_page_link)
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

    def retrieve(page, block)
      hit = match(page, :entry_link)
      hit.each do |entry|
        link = page.link_with(entry)
        absolute_link = page.uri.merge(link.uri).to_s
        @agent.get(absolute_link) do |entry_page|
          block.call(entry_page)
        end
      end
    end

    def match(page, key)
      pattern = @config[key]
      case pattern[:type]
      when :xpath
        page.parser.xpath(pattern[:matcher])
      when :css_selector
        page.search(pattern[:matcher])
      end
    end
  end
end
