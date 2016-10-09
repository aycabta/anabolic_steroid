require 'yaml'

module AnabolicSteroid
  class Config
    attr_accessor :entry_date_xpath, :entry_link_xpath, :next_page_link_xpath

    def initialize(path)
      if File.exists?(path)
        yaml = YAML.load_file(path)
        @entry_date_xpath = yaml['xpath']['entry_date']
        @entry_link_xpath = yaml['xpath']['entry_link']
        @next_page_link_xpath = yaml['xpath']['next_page_link']
      else
        raise "Configuration file not found: #{path}"
      end
    end
  end
end
