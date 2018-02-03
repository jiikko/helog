require 'date'

module Helog
  class Fetcher
    attr_accessor :dates
    def initialize(dates: )
      self.dates = dates
    end

    def run
      if @dates.empty?
        puts('empty argv!!')
        return false
      end
      if @dates.size > 2
        puts('too many argv!!')
        return false
      end

      valid_dates = @dates.map { |d| Date.parse(d).strftime('%Y-%m-%d') }
      puts @dates
      return true
    end

    def dates
    end

    private
  end
end
