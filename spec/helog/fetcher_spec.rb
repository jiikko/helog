require "spec_helper"

RSpec.describe Helog::Fetcher do
  context 'when empty ARGV' do
    subject { Helog.fetch(dates: []) }
    it 'return false' do
      expect(subject).to eq(false)
    end
  end
  context 'when 1 ARGV' do
    subject { Helog.fetch(dates: ['1011-11-11']) }
    it 'return true' do
      expect(subject).to eq(true)
    end
  end
  context 'when 2 ARGV' do
    subject { Helog.fetch(dates: ['1011-11-11', '1011-11-11']) }
    it 'return true' do
      expect(subject).to eq(true)
    end
  end
  context 'when 3 ARGV' do
    subject { Helog.fetch(dates: [1, 2, 3]) }
    it 'return false' do
      expect(subject).to eq(false)
    end
  end
end
