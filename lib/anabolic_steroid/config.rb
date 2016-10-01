require 'yaml'

module AnabolicSteroid
  class Config
    attr_accessor :entry_date_xpath, :next_page_xpath

    def initialize(path)
      yaml = YAML.load_file(path)
      @entry_date_xpath = yaml['xpath']['entry_date']
      @entry_link_xpath = yaml['xpath']['entry_link']
      @next_page_link_xpath = yaml['xpath']['next_page_link']
    end
  end
end
