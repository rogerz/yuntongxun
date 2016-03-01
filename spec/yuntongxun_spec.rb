require 'spec_helper'

describe YunTongXun do
  it 'has a version number' do
    expect(YunTongXun::VERSION).not_to be nil
  end

  it 'send sms' do
    ytx = YunTongXun::RestClient.new(
        api: ENV['YTX_API_SERVER'],
        version: '2013-12-26',
        account_sid: ENV['YTX_ACCOUNT_SID'],
        auth_token: ENV['YTX_AUTH_TOKEN']
      )
    ytx.config(app_id: ENV['YTX_APP_ID'], template_id: 1)
    response = ytx.send_sms(to: ENV['YTX_TEST_TO'], data: ['2016', 1])
    expect(JSON.parse(response.body)).to have_key 'statusCode'
  end
end
