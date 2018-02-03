require "spec_helper"

RSpec.describe Helog::Fetcher do
  context 'when empty ARGV' do
    subject { Helog.fetch(dates: []) }
    it 'raise RuntimeError' do
      expect{ subject }.to raise_error(RuntimeError)
    end
  end
end
