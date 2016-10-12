module AnabolicSteroid
  class Application
    def initialize(config = nil)
      @config = config || AnabolicSteroid::Config.new
    end

    def config(*args, &block)
      self.instance_eval(&block)
    end

    def url(input_url)
      @url = input_url
    end

    def xpath(key, value)
      case key
      when :entry_link
        @config.entry_link_xpath = value
      when :next_page_link
        @config.next_page_link_xpath = value
      else
        throw "Unknown key for set_xpath: #{key}"
      end
    end

    def entry(*args, &block)
      @entry_proc = block
    end

    def run
      @as = AnabolicSteroid::Client.new(@url, @config)
      @as.each(&@entry_proc)
    end
  end
end
