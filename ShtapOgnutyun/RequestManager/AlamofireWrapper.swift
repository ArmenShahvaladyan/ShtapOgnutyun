//
//  AlamofireWrapper.swift
//  ShtapOgnutyun
//
//  Created by My Mac on 5/29/18.
//  Copyright © 2018 SixelIT. All rights reserved.
//

import Alamofire
import Foundation

final class AlamofireWrapper: NSObject {


    static let sessionManager = Alamofire.SessionManager.default

    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    class func getRequest(_ strURL: String, params : [String : Any]?, headers: HTTPHeaders?, success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {

        if !AlamofireWrapper.isConnectedToInternet() {
            failure(Constant.kSINotInternetConectionError)
            return
        }

//        SILoadingMotionView.sharedInstance.showActivityIndicator()

        sessionManager.request(Constant.baseUrl + strURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in

//            SILoadingMotionView.sharedInstance.hideActivityIndicator()

            if response.result.isSuccess {
                if let json = response.result.value {
                    success(json)
                }
            }

            if response.result.isFailure {

                if let data = response.data {
                    do {
                        let errorData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        failure(errorData!)
                    } catch {
                        debugPrint("response.error?.localizedDescription!")
                    }
                }
            }
        }
    }

    class func postRequest(_ strURL: String?, params : [String : Any]?, headers: HTTPHeaders? = nil, success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {

        if !AlamofireWrapper.isConnectedToInternet() {
            failure(Constant.kSINotInternetConectionError)
            return
        }

//        SILoadingMotionView.sharedInstance.showActivityIndicator()

        sessionManager.request(Constant.baseUrl + strURL!, method: .post, parameters: params, encoding: JSONEncoding.default , headers: headers).validate().responseJSON { (response) in
            debugPrint(response)

//            SILoadingMotionView.sharedInstance.hideActivityIndicator()

            if response.result.isSuccess {
                if let json = response.result.value {
                    success(json)
                }
            }

            if response.result.isFailure {
                if let data = response.data {
                    do {
                        let errorData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        let errorData = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                        failure(errorData!)
                    } catch {
                        debugPrint("response.error?.localizedDescription!")
                    }
                }
            }
        }
    }

    class func postRequesta(_ strURL: String?, params : [String : Any]?, headers: HTTPHeaders? = nil, success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {

        if !AlamofireWrapper.isConnectedToInternet() {
            failure(Constant.kSINotInternetConectionError)
            return
        }

//        SILoadingMotionView.sharedInstance.showActivityIndicator()

        sessionManager.request(Constant.baseUrl + strURL!, method: .post, parameters: params, encoding: JSONEncoding.default , headers: headers).responseJSON { (response) in
            debugPrint(response)

//            SILoadingMotionView.sharedInstance.hideActivityIndicator()

            if response.result.isSuccess {
                if let json = response.result.value {
                    success(json)
                }
            }

            if response.result.isFailure {

                if let data = response.data {
                    do {
                        let errorData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        failure(errorData!)
                    } catch {
                        debugPrint("response.error?.localizedDescription!")
                    }
                }
            }
        }
    }

    class func putRequest(_ strURL: String, params : [String : Any]?, headers: HTTPHeaders? = nil, success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {

        if !AlamofireWrapper.isConnectedToInternet() {
            failure(Constant.kSINotInternetConectionError)
            return
        }

//        SILoadingMotionView.sharedInstance.showActivityIndicator()

        sessionManager.request(Constant.baseUrl + strURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in

//            SILoadingMotionView.sharedInstance.hideActivityIndicator()

            if response.result.isSuccess {
                if let json = response.result.value {
                    success(json)
                }
            }

            if response.result.isFailure {

                if let data = response.data {
                    do {
                        let errorData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        failure(errorData!)
                    } catch {
                        debugPrint("response.error?.localizedDescription!")
                    }
                }
            }
        }
    }

    class func deleteRequest(_ strURL: String, params : [String : Any]?, headers: HTTPHeaders? = nil, success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {

        if !AlamofireWrapper.isConnectedToInternet() {
            failure(Constant.kSINotInternetConectionError)
            return
        }

//        SILoadingMotionView.sharedInstance.showActivityIndicator()

        sessionManager.request(Constant.baseUrl + strURL, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in

//            SILoadingMotionView.sharedInstance.hideActivityIndicator()

            if response.result.isSuccess {
                if let json = response.result.value {
                    success(json)
                }
            }

            if response.result.isFailure {

                if let data = response.data {
                    do {
                        let errorData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        failure(errorData!)
                    } catch {
                        debugPrint("response.error?.localizedDescription!")
                    }
                }
            }

        }
    }

    class func uploadRequest(_ strURL: String,imageData: Data?, params : [String : Any]?, headers: HTTPHeaders? = nil, success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {

        if !AlamofireWrapper.isConnectedToInternet() {
            failure(Constant.kSINotInternetConectionError)
            return
        }

//        SILoadingMotionView.sharedInstance.showActivityIndicator()

        sessionManager.upload(multipartFormData: { (multipartFormData) in


            for (key, value) in params! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }

            if let data = imageData{
                multipartFormData.append(data, withName: "avatar", fileName: "image.png", mimeType: "image/png")
            }

        }, usingThreshold: UInt64.init(), to: Constant.baseUrl + strURL, method: .post, headers: headers) { (result) in

            switch result{

            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let err = response.error{
                        failure(err)
                        return
                    }
                    do {
                        let succsesDataa = try JSONSerialization.jsonObject(with: response.data!, options: [])
                        if let responceDict = succsesDataa as? [String:Any] {
                            if responceDict["code"] as? Int == 202 || responceDict["code"] as? Int == 200   {
                                success(responceDict)
                            }else {
                                failure(responceDict)
                            }
                        }
                    } catch {
                        debugPrint("response.error?.localizedDescription!")
                    }

                }
            case .failure(let error):
//                SILoadingMotionView.sharedInstance.hideActivityIndicator()
                debugPrint("Error in upload: \(error.localizedDescription)")
                failure(error)
            }
        }
    }

}
