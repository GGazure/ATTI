import UIKit

class InstagramApi {
    
    static let shared = InstagramApi()
    
    private let instagramAppID = "" //erased
    
    private let redirectURIURLEncoded = "https%3A%2F%2Fsnstest.netlify.app%2F"
    
    private let redirectURI = "https://snstest.netlify.app/"
    
    private let app_secret = "" //erased
    
    private let boundary = "boundary=\(NSUUID().uuidString)"

    private enum BaseURL: String {
        case displayApi = "https://api.instagram.com/"
        case graphApi = "https://graph.instagram.com/"
    }
    
    private enum Method: String {
        case authorize = "oauth/authorize"
        case access_token = "oauth/access_token"
    }

    private init() {}
    
    private func getBody(_ parameters: [[String : String]], _ boundary: String) -> Data {
        var body = ""
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                var fileContent: String = ""
                do { fileContent = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)}
                catch {
                    print(error)
                }
                if (error != nil) {
                    print(error!)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        return body.data(using: .utf8)!
    }
    
    private func getTokenFromURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.starts(with: "\(redirectURI)?code=") {
            
            print("Response uri:",requestURLString)
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
    }
    
    private func getRawMedia(testUserData: InstagramTestUser, completion: @escaping (Feed) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)me/media?fields=id,caption&access_token=\(testUserData.access_token)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
            }
            do { let jsonData = try JSONDecoder().decode(Feed.self, from: data!)
                print(jsonData)
                completion(jsonData)
            }
            catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }

    func authorization(completion: @escaping (_ url: URL?) -> Void ) {
        let urlString = "\(BaseURL.displayApi.rawValue)\(Method.authorize.rawValue)?app_id=\(instagramAppID)&redirect_uri=\(redirectURIURLEncoded)&scope=user_profile,user_media&response_type=code"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
                completion(response.url)
            }
        })
        task.resume()
    }
    
    func getUserIDAndToken(request: URLRequest, completion: @escaping (InstagramTestUser) -> Void){
        
        guard let authToken = getTokenFromURL(request: request) else {
            return
        }
        
        let headers = [
            "content-type": "multipart/form-data; boundary=\(boundary)"
        ]
        let parameters = [
            [
                "name": "app_id",
                "value": instagramAppID
            ],
            [
                "name": "app_secret",
                "value": app_secret
            ],
            [
                "name": "grant_type",
                "value": "authorization_code"
            ],
            [
                "name": "redirect_uri",
                "value": redirectURI
            ],
            [
                "name": "code",
                "value": authToken
            ]
        ]
        
        var request = URLRequest(url: URL(string: BaseURL.displayApi.rawValue + Method.access_token.rawValue)!)
        
        let postData = getBody(parameters, boundary)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                do { let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data!)
                    print(jsonData)
                    completion(jsonData)
                }
                catch let error as NSError {
                    print(error)
                }
                
            }
        })
        dataTask.resume()
    }

    
    func getUser(testUserData: InstagramTestUser, completion: @escaping (InstagramUser) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)\(testUserData.user_id)?fields=id,username&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            do { let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                completion(jsonData)
            }
            catch let error as NSError {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    func getImage(testUserData: InstagramTestUser, completion: @escaping (InstagramMedia) -> Void) {
      getRawMedia(testUserData: testUserData) { (mediaFeed) in
        let urlString = "\(BaseURL.graphApi.rawValue + mediaFeed.data[0].id)?fields=id,media_type,media_url,username,timestamp&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
          if let response = response {
            print(response)
          }
          do { let jsonData = try JSONDecoder().decode(InstagramMedia.self, from: data!)
            print(jsonData)
            completion(jsonData)
          } catch let error as NSError {
             print(error)
          }
        })
        task.resume()
      }
    }
    
    func putImage(urlString: String, completion: @escaping (Data?) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
            }
            completion(data)
        })
        task.resume()
    }
   
}


