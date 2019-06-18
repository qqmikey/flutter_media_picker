import Flutter
import UIKit
import AVKit

enum PickerMethod: String {
    case getMediaFromGallery = "getMediaFromGallery"
}

public class SwiftFlutterMediaPickerPlugin: NSObject, FlutterPlugin {
    var imagePicker: ImagePicker!
    var methodChannelResult: FlutterResult!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_media_picker", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMediaPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case PickerMethod.getMediaFromGallery.rawValue:
            guard let rootController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            self.methodChannelResult = result
            guard let mediaTypes: [String] = getArgument("mediaTypes", from: call.arguments) else {
                return
            }
            
            guard let _source: Int = getArgument("source", from: call.arguments), let source = UIImagePickerController.SourceType(rawValue: _source) else {
                return
            }
            
            self.imagePicker = ImagePicker(presentationController: rootController, delegate: self, mediaTypes: mediaTypes)
            self.imagePicker.present(source: source)
            break
        default:
            return result(FlutterMethodNotImplemented)
        }
        
    }
    
    private func getArgument<T>(_ name: String, from arguments: Any?) -> T? {
        guard let arguments = arguments as? [String: Any] else { return nil }
        return arguments[name] as? T
    }
}


extension SwiftFlutterMediaPickerPlugin: ImagePickerDelegate {
    public func didSelect(movie: URL?) {
        guard let videoURL = movie else {
            return
        }
        do {
            let asset = AVURLAsset(url: videoURL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            if let thumbnailPath = saveImage(image: thumbnail) {
                let data:[String: Any?] = [
                    "type": "public.movie",
                    "path": videoURL.absoluteString,
                    "thumbnail": thumbnailPath
                ]
                self.methodChannelResult(data)
            }
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
    }
    
    public func didSelect(image: UIImage?) {
        if let _image = image {
            if let path = saveImage(image: _image) {
                let data:[String: Any?] = [
                    "type": "public.image",
                    "path": path,
                    "thumbnail": path
                ]
                self.methodChannelResult(data)
            }
        }
    }
}

func saveImage(image: UIImage) -> String? {
    guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
        return nil
    }
    
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return nil
    }
    
    do {
        let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
        let path = directory.appendingPathComponent("media_picker_\(currentTimeStamp).png")
        try data.write(to: path!)
        return path?.absoluteString
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
