//
//  ViewController.swift
//  Hotdog CoreML
//
//  Created by Amal Raju on 21/08/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = pickedImage
            print(pickedImage)
            let ciImage = CIImage(image: pickedImage)
            detect(image: ciImage!)
        }
        imagePicker.dismiss(animated: true)
//        imageView.image = pickedImage
//        let ciImage = CIImage(image: pickedImage!)
        
    }
    
    func detect(image: CIImage){
        guard let model =  try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("model failed")
        }
        let request = VNCoreMLRequest(model: model) { vnRequest, error in
            guard let results = vnRequest.results as? [VNClassificationObservation] else{
                fatalError("vn request failed")
            }
            if let result = results.first{
                print(result.identifier)
                if result.identifier.contains("Hotdog"){
                    self.navigationItem.title = "Hotdog"
                }
                else{
                    self.navigationItem.title = "Not a Hotdog"
                }
                
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
   
    }
    
    

    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
      present(imagePicker, animated: true)
    }
    
}

