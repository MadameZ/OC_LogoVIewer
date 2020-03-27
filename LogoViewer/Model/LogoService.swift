//
//  LogoService.swift
//  LogoViewer
//
//  Created by Ambroise COLLON on 24/04/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//

import Foundation

class LogoService {
    static let shared = LogoService()
    private init() {}

    private let baseUrl = "https://logo.clearbit.com/"
    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }

    func getLogo(domain: String, callback: @escaping (Bool, Data?) -> Void) {
        guard let url = URL(string: baseUrl + domain) else {
            callback(false, nil)
            return
        }

        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                    let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        return
                }

                callback(true, data)
            }
        }
        task?.resume()
    }
}
