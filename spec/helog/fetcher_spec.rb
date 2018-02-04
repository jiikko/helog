require "spec_helper"
require "parallel"

RSpec.describe Helog::Fetcher do
  describe '#run' do
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

  describe '#dates' do
    context '1011-11-11~1011-11-12の時' do
      subject { Helog::Fetcher.new(dates: ['1011-11-11', '1011-11-13']).dates }
      it 'return 3 size of list' do
        expect(subject.size).to eq(3)
      end
    end
  end
  context '日付の開始と終了が入れ替わっている時' do
    subject { Helog::Fetcher.new(dates: ['1011-11-11', '1011-11-01']).dates }
    it 'return empty list' do
      expect(subject).to eq([])
    end
  end
end
