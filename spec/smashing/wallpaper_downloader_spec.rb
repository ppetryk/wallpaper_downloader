require_relative '../../lib/smashing/wallpaper_downloader'

describe Smashing::WallpaperDownloader do
  let(:object) { Smashing::WallpaperDownloader.new(month: month, resolution: resolution) }
  let(:month) { '072023' }
  let(:resolution) { '1920x1200' }

  describe '#perform' do
    subject { object.perform }

    let(:fake_html) do
      <<-HTML
      <html>
        <head></head>
        <body>
          <a href="1.jpg">Menu</a>
          <a href="2.jpg">1920x1080</a>
          <a href="3.jpg">1920x1200</a>
          <a>Content</a>
          <a href="5.jpg">1920x1200</a>
          <a href="6.jpg">Footer</a>
        </body>
      </html>
      HTML
    end

    let(:response) { double(:response, code: 200, body: fake_html) }

    before do
      allow_any_instance_of(Logger).to receive(:info)
      allow(HTTParty).to receive(:get).and_return response
    end

    context 'when args missing' do
      context 'when month missing' do
        let(:month) { nil }

        it 'handles exception' do
          expect_any_instance_of(Logger).to receive(:fatal).with 'Wallpapers failed to be downloaded'
          subject
        end
      end

      context 'when resolution missing' do
        let(:resolution) { nil }

        it 'handles exception' do
          expect_any_instance_of(Logger).to receive(:fatal).with 'Wallpapers failed to be downloaded'
          subject
        end
      end
    end

    context 'when args passed' do
      let(:page_url) { 'http://example.com/' }
      before { allow(object).to receive(:month_page).and_return page_url }

      context 'when page not found' do
        let(:response) { double(:response, code: 404) }

        it 'displays correct message' do
          expect_any_instance_of(Logger).to receive(:error).with "Page #{page_url} failed to be found"
          subject
        end
      end

      context 'when page detected' do
        it 'succeeds' do
          expect(File).to receive(:write).twice
          expect_any_instance_of(Logger).to receive(:info).with 'Wallpaper 3.jpg has been downloaded'
          expect_any_instance_of(Logger).to receive(:info).with 'Wallpaper 5.jpg has been downloaded'
          subject
        end
      end
    end
  end

  describe '#month_page' do
    subject { object.month_page month }

    it 'renders page url' do
      expect(subject).to include '/2023/06', 'july-2023'
    end

    context 'when start of the year' do
      let(:month) { '012023' }

      it 'renders page url' do
        expect(subject).to include '/2022/12', 'january-2023'
      end
    end
  end
end
