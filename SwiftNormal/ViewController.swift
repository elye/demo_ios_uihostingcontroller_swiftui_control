import UIKit
import SwiftUI

public let deviceBounds = UIScreen.main.bounds
public let deviceWidth = deviceBounds.size.width
public let deviceHeight = deviceBounds.size.height

var myHostVc: UIHostingController<ContentView>? = nil

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Swift UI Content")
                .frame(width: deviceWidth, height: 100)
                .background(Color.blue)
            Spacer()
        }
        .background(Color.orange)
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.height > 0 {
                            myHostVc?.dismiss(animated: true)
                        }
                    }))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

class SwiftUIController: UIHostingController<ContentView> {
    init() {
        let view = ContentView()
        super.init(rootView: view)
        myHostVc = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown))
        gesture.direction = .down
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    private func onSwipeDown() {
        print("Swipe Down")
    }
}


class NormalViewController : UIViewController {
    override func viewDidLoad() {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: 100)
        label.textAlignment = .center
        label.text = "Normal VC"
        label.backgroundColor = .green
        view.backgroundColor = .systemPink
        view.addSubview(label)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown))
        gesture.direction = .down
        view.addGestureRecognizer(gesture)
    }

    @objc
    private func onSwipeDown() {
        dismiss(animated: true)
    }
}

class ViewController : UIViewController {
    
    private var isModal = true
    
    override func viewDidLoad() {
        let normalButton = UIButton(frame: CGRect(x: 0, y: 100, width: deviceWidth, height: 45))
        normalButton.backgroundColor = .gray
        normalButton.setTitle("Normal View Controller", for: .normal)
        normalButton.addTarget(self, action: #selector(openNormal), for: .touchUpInside)
        view.addSubview(normalButton)

        let suiButton = UIButton(frame: CGRect(x: 0, y: 150, width: deviceWidth, height: 45))
        suiButton.backgroundColor = .gray
        suiButton.setTitle("UI Hosting Controller", for: .normal)
        suiButton.addTarget(self, action: #selector(openSui), for: .touchUpInside)
        view.addSubview(suiButton)
        
        setupNormalSwiftUIOptions()
    }
    
    @objc
    private func openNormal() {
        let newVC = NormalViewController()
        if !isModal { newVC.modalPresentationStyle = .fullScreen }
        self.present(newVC, animated: true)
    }
    
    @objc
    private func openSui() {
        let newVC = SwiftUIController()
        if !isModal { newVC.modalPresentationStyle = .fullScreen }
        self.present(newVC, animated: true)
    }
    
    private func setupNormalSwiftUIOptions() {
        // Initialize
        let items = ["Float Modal", "Full Screen"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.main.bounds
        customSC.frame = CGRect(
            x: frame.minX + 10,
            y: 300,
            width: frame.width - 20,
            height: 50)

        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = .gray
        customSC.tintColor = .white
        
        // Add target action method
        customSC.addTarget(self, action: #selector(chooseOption), for: .valueChanged)

        // Add this custom Segmented Control to our view
        self.view.addSubview(customSC)
    }
    
    @objc
    private func chooseOption(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            isModal = false
        default:
            isModal = true
        }
    }
}
