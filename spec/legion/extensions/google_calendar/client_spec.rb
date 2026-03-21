# frozen_string_literal: true

RSpec.describe Legion::Extensions::GoogleCalendar::Client do
  subject(:client) { described_class.new(token: 'ya29.test-token') }

  describe '#initialize' do
    it 'stores token in opts' do
      expect(client.opts[:token]).to eq('ya29.test-token')
    end
  end

  describe '#settings' do
    it 'returns a hash with options key' do
      expect(client.settings).to eq({ options: client.opts })
    end
  end

  describe '#connection' do
    it 'returns a Faraday connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end

    it 'targets the Google Calendar v3 base URL' do
      conn = client.connection
      expect(conn.url_prefix.to_s).to eq('https://www.googleapis.com/calendar/v3')
    end

    it 'sets Bearer authorization header when token is present' do
      conn = client.connection
      expect(conn.headers['Authorization']).to eq('Bearer ya29.test-token')
    end
  end
end
