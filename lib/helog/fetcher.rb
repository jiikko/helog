require 'date'

module Helog
  class Fetcher
    attr_accessor :dates_to_s
    def initialize(dates: )
      self.dates_to_s = dates
    end

    def run
      if dates_to_s.empty?
        puts('empty argv!!')
        return false
      end
      if dates_to_s.size > 2
        puts('too many argv!!')
        return false
      end

      dates.each do |date|
        fetch(date)
      end
      return true
    end

    def dates
      valid_dates = dates_to_s.map { |d| Date.parse(d) }
      (valid_dates.first..valid_dates.last).to_a
    end

    private

    def fetch(date)
    end
  end
end
