require "spec_helper"

RSpec.describe Helog::GoogleDriveUploader do
  describe '#max_num_of_files' do
    context 'ファイルがない時' do
      it 'return num of max' do
        uploader = Helog::GoogleDriveUploader.new(nil)
        allow(uploader).to receive(:log_files) do
          []
        end
        expect(uploader.max_num_of_files).to eq(0)
      end
    end
    context 'ファイル名の末尾が0のとき' do
      it do
        struct = Struct.new(:title)
        file = struct.new('01-0.log')
        uploader = Helog::GoogleDriveUploader.new(nil)
        allow(uploader).to receive(:log_files) do
          [ file,
          ]
        end
        expect(uploader.max_num_of_files).to eq(1)
      end
    end
    context 'ファイル名の末尾が5のとき' do
      it do
        struct = Struct.new(:title)
        file = struct.new('01-5.log')
        uploader = Helog::GoogleDriveUploader.new(nil)
        allow(uploader).to receive(:log_files) do
          [ file,
          ]
        end
        expect(uploader.max_num_of_files).to eq(6)
      end
    end
  end
end
