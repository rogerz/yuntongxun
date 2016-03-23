require "yuntongxun/version"

require 'json'
require 'digest'
require 'base64'
require 'net/http'
require 'net/https'

module YunTongXun
  # Your code goes here...
  class RestClient
    # http://www.yuntongxun.com/activity/smsDevelop#tiyan
    VERSION = '2013-12-26'

    def initialize(api:, version: '2013-12-26', account_sid:, auth_token:)
      @api = api
      @version = version
      @account_sid = account_sid
      @auth_token = auth_token
    end

    def url
      # URL格式：/2013-12-26/Accounts/{accountSid}/SMS/TemplateSMS?sig={SigParameter}
      "#{@api}/#{@version}/Accounts/#{@account_sid}/SMS/TemplateSMS?sig=#{sign}"
    end

    def sign
      # REST API 验证参数，生成规则如下
      # 1.使用MD5加密（账户Id + 账户授权令牌 + 时间戳）。其中账户Id和账户授权令牌根据url的验证级别对应主账户。
      # 时间戳是当前系统时间，格式"yyyyMMddHHmmss"。时间戳有效时间为24小时，如：20140416142030
      # 2.SigParameter参数需要大写，如不能写成sig=abcdefg而应该写成sig=ABCDEFG
      Digest::MD5.hexdigest(@account_sid + @auth_token + timestamp).upcase
    end

    def headers
      # Accept String	必选	客户端响应接收数据格式：application/xml、application/json
      # Content-Type String	必选	类型：application/xml;charset=utf-8、application/json;charset=utf-8
      # Content-Length String	必选	Content-Length
      # Authorization String 必选 验证信息，生成规则详见下方说明
      # 1.使用Base64编码（账户Id + 冒号 + 时间戳）其中账户Id根据url的验证级别对应主账户
      # 2.冒号为英文冒号
      # 3.时间戳是当前系统时间，格式"yyyyMMddHHmmss"，需与SigParameter中时间戳相同。
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json;charset=utf-8',
        'Authorization' => Base64.strict_encode64(@account_sid + ':' + timestamp)
      }
    end

    def timestamp
      Time.now.strftime("%Y%m%d%H%M%S")
    end

    def config(app_id:, template_id:)
      @app_id = app_id
      @template_id = template_id
    end

    def json_content(to:, data: [])
      # to	String	必选	短信接收端手机号码集合，用英文逗号分开，每批发送的手机号数量不得超过100个
      # appId String	必选	应用Id
      # templateId	String	必选	模板Id
      # datas	String	必选	内容数据外层节点
      # data String 可选  内容数据，用于替换模板中{序号}
      fail 'app_id and template_id must be set' unless @app_id && @template_id
      to = [to] unless to.is_a? Array
      data = [data] unless data.is_a? Array
      {
        :to => to.join(','),
        :appId => @app_id,
        :templateId => @template_id,
        :datas => data
      }.to_json
    end

    def send_sms(to:, data: [])
      uri = URI.parse(url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url, headers)
      request.body = json_content(to: to, data: data)
      https.request(request)
    end
  end
end
