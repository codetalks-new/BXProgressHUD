import UIKit
import PinAuto

/**
 * Displays a simple HUD window containing a progress indicator and two optional labels for short messages.
 *
 * This is a simple drop-in class for displaying a progress HUD view similar to Apple's private UIProgressHUD class.
 * The BXProgressHUD window spans over the entire space given to it by the initWithFrame constructor and catches all
 * user input on this region, thereby preventing the user operations on components below the view. The HUD itself is
 * drawn centered as a rounded semi-transparent view which resizes depending on the user specified content.
 *
 * This view supports four modes of operation:
 * - BXProgressHUDModeIndeterminate - shows a UIActivityIndicatorView
 * - BXProgressHUDModeDeterminate - shows a custom round progress indicator
 * - BXProgressHUDModeAnnularDeterminate - shows a custom annular progress indicator
 * - BXProgressHUDModeCustomView - shows an arbitrary, user specified view (@see customView)
 *
 * All three modes can have optional labels assigned:
 * - If the labelText property is set and non-empty then a label containing the provided content is placed below the
 *   indicator view.
 * - If also the detailsLabelText property is set then another label is placed below the first label.
 */
open class BXProgressHUD : UIView {
  /**
   * A block that gets called after the HUD was completely hidden.
   */
  open var completionBlock: BXProgressHUDCompletionBlock?
  
  /**
   * BXProgressHUD operation mode. The default is BXProgressHUDModeIndeterminate.
   *
   * @see BXProgressHUDMode
   */
  open var mode: BXProgressHUDMode = .indeterminate{
    didSet{
      if !isIniting{
        shouldUpdateIndicators()
      }
    }
  }
  
  /**
   * The animation type that should be used when the HUD is shown and hidden.
   *
   * @see BXProgressHUDAnimation
   */
  open var animationType: BXProgressHUDAnimation  = .fade
  
  
  /**
   * The UIView (e.g., a UIImageView) to be shown when the HUD is in BXProgressHUDModeCustomView.
   * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
   */
  open var customView: UIView?{
    didSet{
      shouldUpdateIndicators()
    }
    
  }
  
  /**
   * The HUD delegate object.
   *
   * @see BXProgressHUDDelegate
   */
  weak open var delegate: BXProgressHUDDelegate?
  


  
  /**
   * The x-axis offset of the HUD relative to the centre of the superview.
   */
  open var xOffset: CGFloat = 0.0
  
  /**
   * The y-axis offset of the HUD relative to the centre of the superview.
   */
  open var yOffset: CGFloat = 0.0
  
  /**
   * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
   * Defaults to 24.0
   */
  open var margin: CGFloat = 24.0
  
  /**
   * The corner radius for the HUD
   * Defaults to 10.0
   */
  open var cornerRadius: CGFloat = 10{
    didSet{
      containerView.backgroundView.layer.cornerRadius = cornerRadius
      containerView.backgroundView.clipsToBounds = true
    }
  }
  
  /**
   * Cover the HUD background view with a radial gradient.
   */
  open var dimBackground: Bool = false
  
  /*
  * Grace period is the time (in seconds) that the invoked method may be run without
  * showing the HUD. If the task finishes before the grace time runs out, the HUD will
  * not be shown at all.
  * This may be used to prevent HUD display for very short tasks.
  * Defaults to 0 (no grace time).
  * Grace time functionality is only supported when the task status is known!
  * @see taskInProgress
  */
  open var graceTime: TimeInterval = 0.0
  
  /**
   * The minimum time (in seconds) that the HUD is shown.
   * This avoids the problem of the HUD being shown and than instantly hidden.
   * Defaults to 0 (no minimum show time).
   */
  open var minShowTime: TimeInterval = 0.0
  
  /**
   * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
   * If you don't set a graceTime (different than 0.0) this does nothing.
   * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
   * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
   * you need to set this property when your task starts and completes in order to have normal graceTime
   * functionality.
   */
  open var taskInProgress: Bool = false
  
  /**
   * Removes the HUD from its parent view when hidden.
   * Defaults to NO.
   */
  open var removeFromSuperViewOnHide: Bool = false
  
  
  open let label :UILabel =  UILabel(frame: CGRect.zero)
  
  open let detailsLabel :UILabel =  UILabel(frame: CGRect.zero)
 
  open var checkmarkImage:UIImage?
 
  open var padding:CGFloat = 20
  

  
  
  open var blurStyle : UIBlurEffectStyle = .dark{
    didSet{
      containerView.backgroundView.effect = UIBlurEffect(style: blurStyle)
    }
  }
 
  
  /**
   * The color of the activity indicator. Defaults to [UIColor whiteColor]
   * Does nothing on pre iOS 5.
   */
  open var activityIndicatorColor: UIColor = .white{
    didSet{
      if let activityIndicator = indicator as? UIActivityIndicatorView{
        activityIndicator.color = activityIndicatorColor
      }
    }
    
  }
  
  /**
   * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
   */
  open var progress: CGFloat = 1.0{
    didSet{
      if let pg = indicator as? BXBaseProgressView{
        pg.progress = progress
      }
    }
  }
  
  fileprivate var indicator:UIView?{
    if let indicatorContainer = containerView as? BXHUDIndicatorContainerView{
      return indicatorContainer.indicator
    }
    return nil
  }

  /**
   * Force the HUD dimensions to be equal if possible.
   */
  open var square: Bool = false
  
  var useAnimation = false
  
  var isFinished = false
  var rotationTransform = CGAffineTransform.identity
  
  var showStarted:Date?
  
  fileprivate var containerView:BXHUDContainerView = BXHUDIndicatorContainerView()
  fileprivate var isIniting = false
  
  public init(mode:BXHUDMode = BXHUDMode.indeterminate){
    isIniting = true
    self.mode = mode
    super.init(frame: CGRect.zero)
    self.containerView = self.containerViewOfMode(mode)
    commonInit()
    isIniting = false
  }
  
  
  open func attachTo(_ view:UIView){
    self.removeFromSuperview()
    frame = view.bounds
    view.addSubview(self)
  }
 
  @nonobjc
  open func attachTo(_ window:UIWindow){
    self.attachTo(window as UIView)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
  func commonInit(){
    // Transparent background
    backgroundColor = .clear
    isOpaque = false
    // Make it invisible for now
    alpha = 0.0
    shouldUpdateIndicators()
    setupAttrs()
    
    registerForNotifications()
  }
  
  
  
  // MARK: UI


  
  func indicatorOfMode(_ mode:BXHUDMode) -> UIView?{
    switch mode{
    case .indeterminate:
      let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
      indicator.color = activityIndicatorColor
      indicator.startAnimating()
      return indicator
    case .checkmark:
      if let image = checkmarkImage{
        return UIImageView(image: image)
      }
      return nil
    case .determinateHorizontalBar:
      return  BXBarProgressView()
    case .determinate,.annularDeterminate:
      let indicator = BXRoundProgressView()
      indicator.annular = mode == .annularDeterminate
      return indicator
    case .customView:
      return customView
    case .text:
      return nil
    }
  }
  
  func containerViewOfMode(_ mode:BXHUDMode) -> BXHUDContainerView{
    if let indicator = indicatorOfMode(mode){
      return BXHUDIndicatorContainerView(mode: mode, indicator: indicator, titleLabel: label)
    }else{
      return BXHUDTextContainerView(mode: mode, titleLabel: label, detailsLabel: detailsLabel)
    }
  }
  

  func setupAttrs(){
//    containerView.layer.cornerRadius = cornerRadius
    
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: BXProgressOptions.labelFontSize)
    
    detailsLabel.textColor = .white
    detailsLabel.numberOfLines = 1
    detailsLabel.font = UIFont.boldSystemFont(ofSize: BXProgressOptions.detailsLabelFontSize)
    
    
    for l in [label,detailsLabel]{
      l.adjustsFontSizeToFitWidth = false
      l.textAlignment = .center
      l.isOpaque = false
      l.backgroundColor = .clear
    }
    
  }
  
  func shouldUpdateIndicators(){
    containerView.removeFromSuperview()
    containerView = containerViewOfMode(mode)
    
    containerView.backgroundView.effect = UIBlurEffect(style: blurStyle)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    if cornerRadius > 0.1{
      // see http://stackoverflow.com/questions/29029335/corner-radius-on-uivisualeffectview
      let blurView = containerView.backgroundView
      blurView.layer.cornerRadius = cornerRadius
      blurView.clipsToBounds = true
    }
    
    addSubview(containerView)
    
    installConstraints()
  }
  
  func installConstraints(){
    
    containerView.pa_centerX.offset(xOffset).install()
    containerView.pa_centerY.offset(yOffset).install()
  }
  
  open override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    #if DEBUG
      NSLog("\(#function)")
    #endif
    if let superView  = newSuperview{
      frame = superView.bounds
    }
  }
  
 
  func imageByName(_ name:String) -> UIImage?{
    let bundleOfThis = Bundle(for: BXProgressHUD.self)
    guard let bundleURL = bundleOfThis.url(forResource: "BXProgressHUD", withExtension: "bundle") else{
      NSLog("Resources bundle not found")
      return nil
    }
    
    guard let bundle = Bundle(url: bundleURL) else{
      NSLog("Could not load Resources Bundle \(bundleURL)")
      return nil
    }
    if let imagePath = bundle.path(forResource: name, ofType: "png"){
      return UIImage(contentsOfFile: imagePath)
    }else{
      return nil
    }
    
  }
  
  deinit{
    NotificationCenter.default.removeObserver(self)
  }
  
  
}



extension BXProgressHUD{
  
  
  
  
}



extension BXProgressHUD{
  
  public static func showHUDAddedTo(_ view:UIView, animated:Bool = true) -> BXProgressHUD{
    let hud = BXProgressHUD(mode: BXHUDMode.indeterminate)
    hud.removeFromSuperViewOnHide = true
    view.addSubview(hud)
    hud.show(animated)
    return hud
  }
  
  public static func HUDForView(_ view:UIView) -> BXProgressHUD? {
    return view.subviews.reversed().filter{ $0 is BXProgressHUD }.first as? BXProgressHUD
  }
  
  public static func allHUDsForView(_ view:UIView) -> [BXProgressHUD]{
    var huds = [BXProgressHUD]()
    view.subviews.forEach{ subview in
      if let hud = subview as? BXProgressHUD{
        huds.append(hud)
      }
    }
    return huds
  }
  
  public static func hideHUDForView(_ view:UIView,animated:Bool = true) -> Bool{
    if let hud = HUDForView(view){
      hud.removeFromSuperViewOnHide = true
      hud.hide()
      return true
    }else{
      return false
    }
  }
  
  public static func hideAllHUDsForView(_ view:UIView, animated:Bool = true) -> Int {
    let huds = allHUDsForView(view)
    huds.forEach{ hud in
      hud.removeFromSuperViewOnHide = true
      hud.hide(animated)
    }
    return huds.count
  }
}

extension BXProgressHUD{
  // MARK: Thread  block
  public func showAnimated(_ animated:Bool,
    whileExecutingBlock block:@escaping ()->(),
    onQueue queue:DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default),
    completionBlock completion:BXProgressHUDCompletionBlock? = nil){
      taskInProgress = true
      completionBlock = completion
      queue.async{
        block()
        DispatchQueue.main.async{
          self.hide(animated)
          self.completionBlock = nil
        }
      }
      self.show(animated)
  }
  
  func delay(_ delay:TimeInterval,closure:@escaping ()-> Void){
    let when = DispatchTime.now() + Double(Int64(delay * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: when , execute: closure)
  }
}

extension BXProgressHUD{
  
  func registerForNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(forName: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil, queue: nil) { (notif) -> Void in
      if self.superview != nil{
        self.updateForCurrentOrientationAnimated()
      }
    }
  }
  
  func updateForCurrentOrientationAnimated(_ animated:Bool = true){
    if let superview = self.superview{
      bounds = superview.bounds
    }
  }
}

extension BXProgressHUD{
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    updateForCurrentOrientationAnimated(false)
  }
  
  
}


extension BXProgressHUD{
  
  // MARK: Show & hide
  
  public func show(_ animated:Bool = true){
    useAnimation = animated
    if graceTime > 0.0{
      delay(graceTime){
        // Show the HUD only if the task is still running
        if self.taskInProgress{
          self.showUsingAnimation(self.useAnimation)
        }
      }
    }else{
      showUsingAnimation(useAnimation)
    }
  }
  
  public func hide(_ animated:Bool = true){
    useAnimation = animated
    // If the minShow time is set, calculate how long the hud shown
    // and pospone the hiding operation if necessary
    if let started = showStarted , minShowTime > 0.0{
      let interval = Date().timeIntervalSince(started)
      if interval < minShowTime{
        delay(minShowTime - interval){
          if self.taskInProgress{
            self.hideUsingAnimation(self.useAnimation)
          }
        }
        return
      }
      
    }else{
      hideUsingAnimation(animated)
    }
  }
  
  public func hide(_ animated:Bool = true,afterDelay seconds:TimeInterval){
    delay(seconds){
      self.hide(animated)
    }
  }
  
  
  
  // MARK: Internal show & hide operations
  
  func showUsingAnimation(_ animated:Bool){
    // Cancel any scheduled hideDeplayed: calls
    NSObject.cancelPreviousPerformRequests(withTarget: self)
    setNeedsDisplay()
    if animated{
      if animationType == .zoomIn{
        transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
      }else if animationType == .ZoomOut{
        transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5))
      }
    }
    showStarted = Date()
    
    if animated{
      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(0.3)
      self.alpha = 1.0
      if animationType == .zoomIn || animationType == .ZoomOut{
        self.transform = rotationTransform
      }
      UIView.commitAnimations()
    }else{
      self.alpha = 1.0
    }
    
  }
  
  func hideUsingAnimation(_ animated:Bool){
    if animated && showStarted != nil{
      UIView.animate(withDuration: 0.3, animations: {
        self.alpha = 0.02
        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden in the done method
        if self.animationType == .zoomIn{
          self.transform = self.rotationTransform.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5))
        }else if self.animationType == .ZoomOut{
          self.transform = self.rotationTransform.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
        }
        
        }, completion: { (finished) -> Void in
          if finished{ // since iOS 8 there is no need to check this
            self.done()
          }
      })
    }else{
      done()
    }
    
    showStarted = nil
  }
  
  func done(){
    NSObject.cancelPreviousPerformRequests(withTarget: self)
    isFinished = true
    alpha =  0.0
    setNeedsDisplay()
    if removeFromSuperViewOnHide{
      removeFromSuperview()
    }
    completionBlock?()
    completionBlock = nil
    delegate?.hudWasHidden(self)
  }
  
}
