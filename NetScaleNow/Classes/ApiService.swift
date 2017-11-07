import Foundation

protocol ApiService {
  typealias SubscribeCallback = (Bool, Error?) -> Void
  typealias VoucherCallback = (Voucher?, Error?) -> Void
  typealias CampaignsCallback = ([Campaign]?, Error?) -> Void
  typealias CampaignCallback = (Campaign?, Error?) -> Void
  func campaigns(metadata: Metadata, callback: @escaping CampaignsCallback)
  func campaign(metadata: Metadata, campaign: Campaign, callback: @escaping CampaignCallback)
  func requestVoucher(metadata: Metadata, campaign: Campaign, callback: @escaping VoucherCallback)
  func subscribeToNewsletter(metadata: Metadata, callback: @escaping SubscribeCallback)
}

class ApiServiceImpl: ApiService {
  
  static let shared = ApiServiceImpl()
  
  private init() {}

  private let baseUrl = URL(string:"https://my.netscalenow.de/api")!
  
  private var configuration = URLSessionConfiguration.default
  private var session : URLSession {
    return URLSession(configuration: configuration)
  }
  
  func campaigns(metadata: Metadata, callback: @escaping CampaignsCallback ) {
  
    updateToken {
      let request = self.campaignsRequest(with: metadata)
      self.session.dataTask(with: request, completionHandler: { (data, response, error) in
        
        guard !self.shouldRetry(response: response) else {
          self.campaigns(metadata: metadata, callback: callback)
          return
        }
        
        guard
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil
        else {
            DispatchQueue.main.async {
              callback(nil, error)
            }
            return
        }
        
        self.parseCampaignData(data: data, callback: callback)
        
      }).resume()
    }
  }
  
  func campaign(metadata: Metadata, campaign: Campaign, callback: @escaping CampaignCallback) {
    
    updateToken {
      let request = self.campaignRequest(for: campaign, metadata: metadata)
      self.session.dataTask(with: request, completionHandler: { (data, response, error) in
        
        guard !self.shouldRetry(response: response) else {
          self.campaign(metadata: metadata, campaign: campaign, callback: callback)
          return
        }
        
        guard
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil
          else {
            DispatchQueue.main.async {
              callback(nil, error)
            }
            return
        }
        
        let decoder = JSONDecoder()
        do {
          let campaign = try decoder.decode(Campaign.self, from: data)
          DispatchQueue.main.async {
            callback(campaign, nil)
          }
        } catch {
          debugPrint(error)
          callback(nil, error)
        }
        
      }).resume()
    }
  }
  
  func requestVoucher(metadata: Metadata, campaign: Campaign, callback: @escaping VoucherCallback) {
    updateToken {
      
      let request = self.voucherRequest(for: campaign, metadata: metadata)
      
      self.session.dataTask(with: request, completionHandler: { (data, response, error) in
        
        guard !self.shouldRetry(response: response) else {
          self.requestVoucher(metadata: metadata, campaign: campaign, callback: callback)
          return
        }
        
        guard
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil
        else {
          DispatchQueue.main.async {
            callback(nil, error)
          }
          return
        }
        
        self.parseVoucherData(data: data, campaign: campaign, callback: callback)
        
      }).resume()
    }
  }
  
  func subscribeToNewsletter(metadata: Metadata, callback: @escaping SubscribeCallback) {
    updateToken {
      
      let request = self.subscribeToNewsletterRequest(with: metadata)
      self.session.dataTask(with: request, completionHandler: { (data, response, error) in
        
        guard !self.shouldRetry(response: response) else {
          self.subscribeToNewsletter(metadata: metadata, callback: callback)
          return
        }
        
        guard
          let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil
          else {
            DispatchQueue.main.async {
              callback(false, error)
            }
            return
        }
        
        DispatchQueue.main.async {
          callback(true, nil)
        }
        
        
      }).resume()
    }
  }
  
  
  private var retryCount = 0
  private var maxRetryCount = 1
  private func shouldRetry(response: URLResponse?) -> Bool{
    // handle 401 error
    if let response = response as? HTTPURLResponse,
      response.statusCode == 401,
      retryCount < maxRetryCount {
    
        resetToken()
        retryCount += 1
        return true
    }
    
    retryCount = 0
    return false
  }
  
  private func campaignsRequest(with metadata: Metadata) -> URLRequest {
    var url = baseUrl.appendingPathComponent("campaigns").appendingPathComponent("container")
    url = add(metadata: metadata, to: url)
    
    return URLRequest(url: url)
  }
  
  private func campaignRequest(for campaign:Campaign, metadata: Metadata) -> URLRequest {
    var url = baseUrl.appendingPathComponent("campaigns").appendingPathComponent(campaign.id.description)
    url = add(metadata: metadata, to: url)
    
    return URLRequest(url: url)
  }
  
  private func voucherRequest(for campaign:Campaign, metadata: Metadata) -> URLRequest {
    var url = baseUrl.appendingPathComponent("campaigns").appendingPathComponent(campaign.id.description).appendingPathComponent("voucher")
    url = add(metadata: metadata, to: url)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
    
  }
  
  private func subscribeToNewsletterRequest(with metadata: Metadata) -> URLRequest {
    var url = baseUrl.appendingPathComponent("newsletter").appendingPathComponent("subscribe")
    url = add(metadata: metadata, to: url)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
  }
  
  private func add(metadata: Metadata, to url:URL) -> URL {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = metadata.queryItems
    return urlComponents.url!
  }
  
  
  fileprivate func parseCampaignData(data: Data, callback: @escaping CampaignsCallback) {
    
    let decoder = JSONDecoder()
    
    do {
      let container = try decoder.decode(Container.self, from: data)
      Config.groupConfig = container.groupConfig
      DispatchQueue.main.async {
        callback(container.campaigns, nil)
      }
    } catch {
      debugPrint(error)
      callback(nil, error)
    }
  }
  
  fileprivate func parseVoucherData(data: Data, campaign: Campaign, callback: @escaping VoucherCallback) {
    
    let decoder = JSONDecoder()
    
    do {
      var voucher = try decoder.decode(Voucher.self, from: data)
      voucher.campaign = campaign
      
      DispatchQueue.main.async {
        callback(voucher, nil)
      }
    } catch {
      debugPrint(error)
      callback(nil, error)
    }
  }
  
  typealias TokenCallback = () -> Void
  private var token: Token?
  
  private func resetToken() {
    token = nil

  }
  
  private func updateToken(callback: @escaping TokenCallback) {
    
    
    
    if (token?.tokenIsValid ?? false) {
      callback()
    } else if (token?.refreshTokenIsValid ?? false) {
      refreshToken(refreshToken: token!.refreshToken, callback: callback)
    } else {
      requestToken(callback: callback)
    }
  }
  
  private func requestToken(callback: @escaping TokenCallback) {
    guard let apiKey = Config.apiKey, let apiSecret = Config.apiSecret else {
      print("Configuration Error: Please specify apiKey and apiSecret")
      return
    }
    
    let url = self.baseUrl.appendingPathComponent("token")
  
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let data = [
      "clientId": "ios-sdk",
      "username": apiKey,
      "password": apiSecret
    ]
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: [])
    
    performTokenRequest(request: request, callback: callback)
  }
  
  private func refreshToken(refreshToken: String, callback:@escaping  TokenCallback) {
    
    let url = self.baseUrl.appendingPathComponent("token/refresh")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let data = [
      "clientId": "ios-sdk",
      "refreshToken": refreshToken
    ]
    request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: [])
    
    performTokenRequest(request: request, callback: callback)
  }
  
  private func performTokenRequest(request: URLRequest, callback: @escaping TokenCallback) {
    
    configuration.httpAdditionalHeaders?.removeValue(forKey: "Authorization")
    
    session.dataTask(with: request) { (jsonData, response, error) in
      guard let jsonData = jsonData else { return }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .custom { d in
        let seconds = try d.singleValueContainer().decode(Double.self)
        return Date(timeIntervalSinceNow: seconds)
      }
      
      do {
        self.token = try decoder.decode(Token.self, from: jsonData)
        self.configuration.httpAdditionalHeaders = ["Authorization": "bearer \(self.token!.accessToken)"]
        callback()
      } catch {
        debugPrint(error)
      }
      
      
      }.resume()
  }
  
}
