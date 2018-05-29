//
//  ScreenCaptureUtility.swift
//  AguantAR
//
//  Created by Jesus M Martínez de Juan on 28/5/18.
//  Copyright © 2018 CHECHU. All rights reserved.
//

import ReplayKit

class ScreenCaptureUtility : NSObject {
    
    static var shared : ScreenCaptureUtility = {
        return ScreenCaptureUtility()
    }()
    
    var available : Bool {
        get {
            return RPScreenRecorder.shared().isAvailable
        }
    }
    
    var isRecording = false
    
    func toggleRecording(){
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording(){
        guard RPScreenRecorder.shared().isAvailable else {
            presentAlert(title: "Grabación de Pantalla no disponible", message: "Comprueba que tienes permisos y vuelve a intentarlo", completion: nil)
            return
        }
        
        presentAlert(title: "Grabación de Pantalla comenzada", message: "La app grabará su pantalla. Una vez que termine la podrá compartir.") {
            RPScreenRecorder.shared().startRecording(handler: { (error) in
                if error == nil { // Grabación de Pantalla comenzada
                    print("Grabación de Pantalla comenzada")
                    self.isRecording = true
                } else {
                    print("Error al comenzar a grabar: \(error!.localizedDescription)")
                    // Manejo de errores
                }
            })
        }
    }
    
    private func stopRecording(){
        RPScreenRecorder.shared().stopRecording(handler: { (previewController, error) in
            guard error == nil else { print("Error al detener la grabación: \(error!.localizedDescription)"); return}
            guard let previewController = previewController else { print("Preview Controller is nil"); return}
            print("Grabación detenida con éxito")
            self.isRecording = false
            previewController.previewControllerDelegate = self
            self.topViewController?.present(previewController, animated: true, completion: nil)
        })
    }
    
    func presentAlert(title: String, message: String, completion: (() -> Void)? ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            completion?()
        }))
        topViewController?.present(alert, animated: true, completion: nil)
    }
    
    var topViewController : UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        print("No se ha encontrado el Top View Controller")
        return nil
    }
}

extension ScreenCaptureUtility : RPPreviewViewControllerDelegate{
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        topViewController?.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        topViewController?.dismiss(animated: true, completion: nil)
    }
}

