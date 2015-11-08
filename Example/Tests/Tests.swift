import UIKit
import XCTest
import BXProgressHUD

class Tests: XCTestCase {
    var hud:BXProgressHUD?
    var view:UIView?
    
    override func setUp() {
        super.setUp()
        view = UIView()
        view?.bounds = UIScreen.mainScreen().bounds
        hud = BXProgressHUD.Builder(forView: view!).show()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatHUDExists() {
        XCTAssertNotNil(hud, "Should be able to create a new HUD instance")
    }

    
}
