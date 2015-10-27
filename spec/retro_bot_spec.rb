require_relative './spec_helper'

describe 'RetroBot' do
  describe 'Sending requests to retro-bot' do
    before { post_request(text: 'retro delete') }
    after  { post_request(text: 'retro delete') }

    it 'should read, write, delete, and offer help text' do
      # Send an invalid request (request where 'retro' isn't the first word)
      post_request(text: 'first retro')

      expect(last_response.body).to eql('')

      # Send a valid request that retrobot doesn't know how to respond to.
      post_request(text: 'retro help')
      response = JSON.parse(last_response.body)
      expect(response['text']).to eql(ResponseFormatter.help_text)

      # Send a request of each retro type
      ['positive', 'negative', 'question', 'change'].each do |category|
        post_request(
          user_name: 'Test', text: "retro #{category} #{category} retro item"
        )

        response = JSON.parse(last_response.body)

        expect(response['text']).to eql(
          ResponseFormatter.write_confirmation_text(
            user:     'Test',
            item:     "#{category} retro item",
            category: category
          )
        )
      end

      # Send a request asking for previously stored items
      post_request(text: 'retro positive another item')
      post_request(text: 'retro positives')

      response = JSON.parse(last_response.body)

      expect(response['text']).to eql(
        ResponseFormatter.read_items(
          items:    ['another item', 'positive retro item'],
          category: 'positive'
        )
      )

      # Send a request to list all items
      post_request(text: 'retro all')

      response = JSON.parse(last_response.body)

      expect(response['text'].include?('positive retro item')).to eql(true)
      expect(response['text'].include?('another item')).to eql(true)
      expect(response['text'].include?('negative retro item')).to eql(true)
      expect(response['text'].include?('change retro item')).to eql(true)
      expect(response['text'].include?('question retro item')).to eql(true)

      # Send a request to delete all stored items
      post_request(text: 'retro delete')

      response = JSON.parse(last_response.body)

      expect(response['text'].include?('positive retro item')).to eql(true)
      expect(response['text'].include?('another item')).to eql(true)
      expect(response['text'].include?('negative retro item')).to eql(true)
      expect(response['text'].include?('change retro item')).to eql(true)
      expect(response['text'].include?('question retro item')).to eql(true)

      # Ensure no items are returned
      post_request(text: 'retro positives')

      response = JSON.parse(last_response.body)

      expect(!response['text'].include?('positive retro item')).to eql(true)
    end
  end
end
