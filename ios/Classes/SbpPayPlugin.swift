import Flutter
import UIKit
import SBPWidget

public class SbpPayPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sbp_pay", binaryMessenger: registrar.messenger())
        let instance = SbpPayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        // Запрашиваем при инициализации доступность SDK на iOS
        case "init":
            // Заглушка, инициализация для iOS не требуется.
            if #available(iOS 12.0, *) {
              result(true)
            } else {
              result(false)
            }
        case "showPaymentModal":
            if #available(iOS 12.0, *) {
                if let topController = getTopViewController() {
                    do {
                        try SBPWidgetSDK.shared.presentBankListViewController(paymentURL: call.arguments as! String, parentViewController: topController)
                        result(true)
                    } catch {
                        result(FlutterError(code: "PluginError", message: error.localizedDescription, details: nil)) // Перехват ошибок плагина
                    }
                } else {
                    result(FlutterError(code: "PluginError", message: "SBP: Failed to implement controller", details: nil))
                }
            } else {
                result(false)
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @available(iOS 12.0, *)
    private func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }
}
