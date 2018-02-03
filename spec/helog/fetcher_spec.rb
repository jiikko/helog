require "spec_helper"

RSpec.describe Helog::Fetcher do
  context 'when empty ARGV' do
    subject { Helog.fetch(dates: []) }
    it 'raise RuntimeError' do
      expect(subject).to eq(false)
    end
  end
  context 'when 3 ARGV' do
    subject { Helog.fetch(dates: [1, 2, 3]) }
    it 'raise RuntimeError' do
      expect(subject).to eq(false)
    end
  end
end
