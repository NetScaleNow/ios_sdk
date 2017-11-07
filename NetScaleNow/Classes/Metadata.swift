//
//  Metadata.swift
//  Pods
//
//  Created by Jonas Stubenrauch on 19.05.17.
//
//

import Foundation

/// Container to store different metadata about the user
public class Metadata {
  
  
  /// The gender of the user
  ///
  /// - male: male
  /// - female: female
  public enum Gender: String {
    case male = "male"
    case female = "female"
  }
  
  /// The email of the user, will be prefilled in the UI but can be changed by the user.
  public var email: String?
  
  
  /// The gender of the user.
  public var gender: Gender?
  
  
  /// The zip code of the user
  public var zipCode: String?
  
  /// The first name of the user
  public var firstName: String?
  
  /// The last name of the user
  public var lastName: String?
    
  /// The birthday of the user
  public var birthday: Date?
  
  /// Create a new Metadata container
  ///
  /// - Parameters:
  ///   - email: The email of the user
  ///   - gender: The gender of the user
  ///   - zipCode: The zip code of the user
  ///   - birthday: The birthday of the user
  public init(email: String? = nil, gender: Gender? = nil, zipCode: String? = nil, firstName: String? = nil, lastName: String? = nil, birthday: Date? = nil) {
    self.email = email
    self.gender = gender
    self.zipCode = zipCode
    self.firstName = firstName
    self.lastName = lastName
    self.birthday = birthday;
  }
  
  private static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter();
    formatter.dateFormat = "yy-MM-dd";
    return formatter;
  }()
  
  internal var newsletter: Bool = false
  internal var numberOfRequestedVouchers = 0
  
  internal var queryItems: [URLQueryItem] {
    var items = [URLQueryItem]();
    
    if let email = email {
      items.append(URLQueryItem(name: "email", value: email))
    }
    
    if let gender = gender {
      items.append(URLQueryItem(name: "gender", value: gender.rawValue))
    }
    
    if let zipCode = zipCode {
      items.append(URLQueryItem(name: "zipCode", value: zipCode))
    }
    
    if let firstName = firstName {
      items.append(URLQueryItem(name: "firstName", value: firstName))
    }
    
    if let lastName = lastName {
      items.append(URLQueryItem(name: "lastName", value: lastName))
    }
    
    if let birthday = birthday {
      items.append(URLQueryItem(name: "birthday", value: Metadata.dateFormatter.string(from: birthday)))
    }
    
    return items
  }
}
