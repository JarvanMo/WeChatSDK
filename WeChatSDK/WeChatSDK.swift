//
//  WeChatSDK.swift
//  WeChatSDK
//
//  Created by Xin Hong on 16/4/25.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

// The functions in "WXApi" must be called in this framework at least once, otherwise the framework will not work outside this module.
// So most of the functions in class "WXApi" are encapsulated to struct "WeChatSDK", although it seems like redundant.
// Therefore, you can regard this struct as a convenient way to use WeChat apis.
public struct WeChatSDK {
    /// 检查用户是否安装微信，微信已安装为true，未安装为false
    public static var isWeChatInstalled: Bool {
        return WXApi.isWXAppInstalled()
    }

    /// 判断当前微信的版本是否支持OpenApi，支持为true，不支持为false
    public static var isWeChatSupport: Bool {
        return WXApi.isWXAppSupport()
    }

    /// 微信的itunes安装地址
    public static var weChatInstallUrl: String {
        return WXApi.getWXAppInstallUrl()
    }

    /// 当前微信SDK的版本号
    public static var version: String {
        return WXApi.getVersion()
    }

    /**
     向微信终端程序注册第三方应用

     需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现，默认开启MTA数据上报。iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。

     请保证在主线程中调用此函数

     - parameter appID: 微信开发者ID

     - returns: 成功返回true，失败返回false
     */
    @discardableResult
    public static func registerApp(_ appID: String) -> Bool {
        return WXApi.registerApp(appID)
    }

    /**
     向微信终端程序注册第三方应用。

     需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。

     请保证在主线程中调用此函数

     - parameter appID:       微信开发者ID
     - parameter isEnableMTA: 是否支持MTA数据上报

     - returns: 成功返回true，失败返回false
     */
    @discardableResult
    public static func registerApp(_ appID: String, enableMTA isEnableMTA: Bool) -> Bool {
        return WXApi.registerApp(appID, enableMTA: isEnableMTA)
    }

    /**
     向微信终端程序注册应用支持打开的文件类型。

     需要在每次启动第三方应用程序时调用。调用后并第一次成功分享数据到微信后，会在微信的可用应用列表中出现。

     - parameter typeFlag: 应用支持打开的数据类型, enAppSupportContentFlag枚举类型 “|” 操作后结果
     */
    public static func registerAppSupportContentFlag(_ typeFlag: UInt64) {
        WXApi.registerAppSupportContentFlag(typeFlag)
    }

    /**
     接受微信的log信息（byBlock）

     注意1: SDK会强引用这个block，注意不要导致内存泄漏

     注意2: 调用过一次startLog by block之后，如果再调用一次任意方式的startLoad，会释放上一次logBlock，不再回调上一个logBlock

     - parameter level:    打印log的级别
     - parameter logBlock: 打印log的回调block
     */
    public static func startLog(by level: WXLogLevel, logBlock: @escaping WXLogBolock) {
        WXApi.startLog(by: level, logBlock: logBlock)
    }

    /**
     接受微信的log信息（byDelegate）

     注意1: SDK会弱引用这个delegate，这里可加任意对象为代理，不需要与WXApiDelegate同一个对象

     注意2: 调用过一次startLog by delegate之后，再调用一次任意方式的startLoad，不会再回调上一个logDelegate对象

     - parameter level:       打印log的级别
     - parameter logDelegate: 打印log的回调代理
     */
    public static func startLog(by level: WXLogLevel, logDelegate: WXApiLogDelegate) {
        WXApi.startLog(by: level, logDelegate: logDelegate)
    }

    /**
     停止打印log，会清理block或者delegate为空，释放block
     */
    public static func stopLog() {
        WXApi.stopLog()
    }

    /**
     打开微信

     - returns: 成功返回true，失败返回false
     */
    @discardableResult
    public static func openWeChat() -> Bool {
        return WXApi.openWXApp()
    }

    /**
     处理微信通过URL启动App时传递的数据

     需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。

     - parameter url:      微信启动第三方应用时传递过来的URL
     - parameter delegate: WXApiDelegate对象，用来接收微信触发的消息

     - returns: 成功返回true，失败返回false
     */
    public static func handleOpen(_ url: URL, delegate: WXApiDelegate) -> Bool {
        return WXApi.handleOpen(url, delegate: delegate)
    }

    /**
     发送请求到微信，等待微信返回onResp

     函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型 SendAuthReq、SendMessageToWXReq、PayReq等。

     - parameter req: 具体的发送请求，在调用函数后，请自己释放

     - returns: 成功返回true，失败返回false
     */
    @discardableResult
    public static func send(_ req: BaseReq) -> Bool {
        return WXApi.send(req)
    }

    /**
     发送Auth请求到微信，支持用户没安装微信，等待微信返回onResp

     函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持SendAuthReq类型。

     - parameter req:            具体的发送请求，在调用函数后，请自己释放
     - parameter viewController: 当前界面对象
     - parameter delegate:       WXApiDelegate对象，用来接收微信触发的消息

     - returns: 成功返回true，失败返回false
     */
    @discardableResult
    public static func sendAuthReq(_ req: SendAuthReq, viewController: UIViewController, delegate: WXApiDelegate) -> Bool {
        return WXApi.sendAuthReq(req, viewController: viewController, delegate: delegate)
    }

    /**
     收到微信onReq的请求，发送对应的应答给微信，并切换到微信界面

     函数调用后，会切换到微信的界面。第三方应用程序收到微信onReq的请求，异步处理该请求，完成后必须调用该函数。可能发送的相应有 GetMessageFromWXResp、ShowMessageFromWXResp等。

     - parameter resp: 具体的应答内容，调用函数后，请自己释放

     - returns: 成功返回true，失败返回false
     */
    @discardableResult
    public static func send(_ resp: BaseResp) -> Bool {
        return WXApi.send(resp)
    }
}
