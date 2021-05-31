import UIKit
import WebKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString(helpString, baseURL: nil)
    }
    
    let helpString = """
    <li>App will show the list of bookmark location at home screen</li>
    <li>By taping on the map, location will be bookmark and store in local DB</li>
    <li>After you select the bookmark city, you will be navigate to city details screen where you can see the weather forecast.</li>
    <li>You can unbookmark the local by tapping on the delete button.</li>
    """
    
    
    // MARK: - Outlets
    
    @IBOutlet private var webView: WKWebView!
}
