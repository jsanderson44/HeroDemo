//
//  NetworkResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// An enum representing the HTTP Method
public enum HTTPMethod: String {
  case get
  case post
  case patch
  case delete
  case head
  case put

  public var rawValue: String {
    return "\(self)".uppercased()
  }
}

/// Defines a resource that can be fetched from a network
public protocol NetworkResourceType {
  /// The URL of the resource
  var url: URL { get }

  /// The HTTP method used to fetch this resource
  var httpRequestMethod: HTTPMethod { get }

  /// The HTTP header fields used to fetch this resource
  var httpHeaderFields: [String: String]? { get }

  /// The HTTP body as JSON used to fetch this resource
  var jsonBody: Any? { get }

  /// The query items to be added to the url to fetch this resource
  var queryItems: [URLQueryItem]? { get }

  /**
   Convenience function that builds a URLRequest for this resource

   - returns: A URLRequest or nil if the construction of the request failed
   */
  func urlRequest() -> URLRequest?
}

// MARK: - NetworkJSONResource defaults
public extension NetworkResourceType {

  public var httpRequestMethod: HTTPMethod { return .get }
  public var httpHeaderFields: [String: String]? { return [:] }
  public var jsonBody: Any? { return nil }
  public var queryItems: [URLQueryItem]? { return nil }

  public func urlRequest() -> URLRequest? {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = allQueryItems()

    guard let urlFromComponents = urlComponents?.url else { return nil }

    var request = URLRequest(url: urlFromComponents)
    request.allHTTPHeaderFields = httpHeaderFields
    request.httpMethod = httpRequestMethod.rawValue

    if let body = jsonBody {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
    }

    return request
  }

  private func allQueryItems() -> [URLQueryItem] {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    var allQueryItems = [URLQueryItem]()

    if let componentsQueryItems = urlComponents?.queryItems {
      allQueryItems.append(contentsOf: componentsQueryItems)
    }

    if let queryItems = queryItems {
      allQueryItems.append(contentsOf: queryItems)
    }

    return allQueryItems
  }
}

public protocol NetworkImageResourceType: NetworkResourceType, ImageResourceType {}
