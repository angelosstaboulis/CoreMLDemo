//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Angelos Staboulis on 7/12/23.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController {
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var foundLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewController()
        // Do any additional setup after loading the view.
    }


}
extension ViewController{
    func initialViewController(){
        self.navigationItem.title = "Image Detection"
        mainImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickImage(sender:)))
        gesture.numberOfTapsRequired = 1
        mainImage.addGestureRecognizer(gesture)
    }
    func imageRequest(){
        do{
            let configuration = MLModelConfiguration()
            let model = try Inceptionv3(configuration: configuration)
            let coreModel = try VNCoreMLModel(for: model.model)
            let request = VNCoreMLRequest(model: coreModel) { request, error in
                if let objectsArray = request.results as? [VNClassificationObservation]{
                    DispatchQueue.main.async{
                        self.foundLabel.text = objectsArray[0].identifier
                    }
                }
            }
            request.usesCPUOnly = true
            let imageHandle = VNImageRequestHandler(cgImage: mainImage.image!.cgImage!)
            try imageHandle.perform([request])
        }catch{
            debugPrint("something went wrong!!!")
        }
    }
    @objc func clickImage(sender:UITapGestureRecognizer){
        imageRequest()
    }
}
