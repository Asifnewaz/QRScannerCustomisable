# Customisable QR-Code Scanner

A simple qrcode scanner in ```swift5```. Scan UI and animation used in scan view is ```programatically customisable```.

## Feature

- QR Code Scan.
- Scan using camera.
- Image scan from gallery.
- Scan view is fully customisable.
- Scan view animation can be customisable.



## Usage

1. Download project file 
2. Find ```QRScanClasses```  folder & add the folder to your own project.
3. Find ```Extensions```  folder & add the folder to your own project.
4. Great !!! 👌 Now add the following code to your ```viewController```. you can add this in ```viewDidLoad``` or any clickable ```@IBAction``` .

```
let scanner = QRCodeScannerController(cameraImage: UIImage(named: "ImageIcon40"),
cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "Flash40"),
flashOffImage: UIImage(named: "Flash40"))

scanner.delegate = self
scanner.mode = .camera
self.present(scanner, animated: true, completion: nil)
```

5.  Also add this extension to your view controller. here you will get the output from scanner

```
extension ViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}

```

## To Customise View

- to change the size/color of white square shape edit ```SquareView.swift```
- to add any button/image/view or modify check ```SwiftQRScannerUIView.swift```.
- to change animation check ```LBXScanLineAnimation.swift``` .


** **
**```UIColorExtension.swift``` is used to convert hex string into UIColor.**

*Example:  to add white color in text* 

``` 
let label = UILabel()
label.textColor = UIColor.colorFrom(hexString: "FFFFFF")
``` 

**```UIViewExtension.swift``` is used to add constrain programatically.** 

** **


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
