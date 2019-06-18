//
//  ImagePicker.swift
//  flutter_media_picker
//
//  Created by Mikhail Rymarev on 18/06/2019.
//

import Foundation

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
    func didSelect(movie: URL?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, mediaTypes: [String]) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = mediaTypes
    }
    
    
    public func present(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            return
        }
        self.pickerController.sourceType = source
        self.presentationController?.present(self.pickerController, animated: true)
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        switch info[UIImagePickerControllerMediaType] as! String {
        case "public.image":
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                picker.dismiss(animated: true, completion: nil)
                self.delegate?.didSelect(image: image)
            }
            break
        case "public.movie":
            if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
                picker.dismiss(animated: true, completion: nil)
                self.delegate?.didSelect(movie: videoURL)
            }
            break
        default:
            print("unresolved media type")
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
