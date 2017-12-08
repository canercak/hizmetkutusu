require 'spec_helper'

describe FacebookTimelinePublisher do
  describe '.perform' do
    let(:user) { FactoryGirl.create :user, oauth_token: 'test', facebook_permissions: { "publish_stream" => 1 } }
    let(:quote) { FactoryGirl.create :quote, user: user }

    it "publishes quote on facebook timeline" do
      stub_http_request(:post, /graph.facebook.com\/me/).to_return body: 123
      expect(FacebookTimelinePublisher.perform quote.id).to_not be_nil
    end

    it "publishes quote on facebook group in restricted mode" do
      APP_CONFIG.facebook.set :restricted_group_id, '10'
      stub_http_request(:post, /graph.facebook.com\/10/).to_return body: 123456
      expect(FacebookTimelinePublisher.perform quote.id).to_not be_nil
      APP_CONFIG.facebook.set :restricted_group_id, nil
    end

    it "does not fail to publish quote if user has no publish stream permission" do
      user.facebook_permissions = {}
      expect(FacebookTimelinePublisher.perform quote.id).to be_nil
    end
  end
end
