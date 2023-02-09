//
//  ViewController.swift
//  Demo App
//
//  Created by Nicolas Dedual on 9/29/20.
//

import UIKit
import DeviceRisk

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var uploadButton:UIButton?
    @IBOutlet weak var deviceAssessmentButton:UIButton?
    @IBOutlet weak var resultsTextView:UITextView?
   
    var deviceSessionID: String?

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultsTextView?.text = "Results will be shown here."
    
        deviceAssessmentButton?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        deviceAssessmentButton?.setBackgroundColor(UIColor.systemRed, for: .disabled)
        deviceAssessmentButton?.setBackgroundColor(UIColor.systemGreen.withAlphaComponent(0.2), for: .selected)
        deviceAssessmentButton?.setBackgroundColor(UIColor.systemGreen, for: .normal)
    }

    @IBAction func uploadData(sender:UIButton) {
        let SDKKey = "Socure_SDK_Key" //TODO: Add Socure SDK key
        
        let config = SocureSigmaDeviceConfig(SDKKey: SDKKey)
        let options = SocureFingerprintOptions(omitLocationData: false, advertisingID: nil, context: .homepage)
        SocureSigmaDevice.fingerprint(config: config, options: options) { result, error in
            guard let error = error else {
                self.resultsTextView?.text = "UUID is \(result?.deviceSessionID ?? "not generated")"
                self.deviceSessionID = result?.deviceSessionID
                self.deviceAssessmentButton?.isEnabled = true
                return
            }

            switch error {
            case .unknownError, .dataFetchError:
                self.resultsTextView?.text = "unknown error"
            case .dataUploadError(let code, let message):
                self.resultsTextView?.text = "\(code ?? 0): \(message ?? "")"
            case .networkConnectionError(let nsUrlError):
                self.resultsTextView?.text = "\(nsUrlError)"
            default:
                self.resultsTextView?.text = "unknown error"
            }
        }
    }
    
    @IBAction func getDeviceAssessment(sender:UIButton) {
        deviceAssessmentButton?.isEnabled = false

        guard deviceSessionID != nil else {
            return
        }
        
    }
}
