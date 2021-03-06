module AnabolicSteroid
  class Application
    def initialize
      @config = {}
    end

    def config(*args, &block)
      self.instance_eval(&block)
    end

    def url(input_url)
      @url = input_url
    end

    def xpath(key, value)
      case key
      when :entry_link, :next_page_link
        @config[key] = { type: :xpath, matcher: value }
      else
        throw "Unknown key for set_xpath: #{key}"
      end
    end

    def css_selector(key, value)
      case key
      when :entry_link, :next_page_link
        @config[key] = { type: :css_selector, matcher: value }
      else
        throw "Unknown key for css_selector: #{key}"
      end
    end

    def entry(*args, &block)
      @entry_proc = block
    end

    def post_process(*args, &block)
      @post_process_proc = block
    end

    def run
      @as = AnabolicSteroid::Client.new(@url, @config)
      @as.each(&@entry_proc) unless @entry_proc.nil?
      @post_process_proc.call unless @post_process_proc.nil?
    end
  end
end
