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
public class BXProgressHUD : UIView {
  /**
   * A block that gets called after the HUD was completely hidden.
   */
  public var completionBlock: BXProgressHUDCompletionBlock?
  
  /**
   * BXProgressHUD operation mode. The default is BXProgressHUDModeIndeterminate.
   *
   * @see BXProgressHUDMode
   */
  public var mode: BXProgressHUDMode = .Indeterminate{
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
  public var animationType: BXProgressHUDAnimation  = .Fade
  
  
  /**
   * The UIView (e.g., a UIImageView) to be shown when the HUD is in BXProgressHUDModeCustomView.
   * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
   */
  public var customView: UIView?{
    didSet{
      shouldUpdateIndicators()
    }
    
  }
  
  /**
   * The HUD delegate object.
   *
   * @see BXProgressHUDDelegate
   */
  weak public var delegate: BXProgressHUDDelegate?
  


  
  /**
   * The x-axis offset of the HUD relative to the centre of the superview.
   */
  public var xOffset: CGFloat = 0.0
  
  /**
   * The y-axis offset of the HUD relative to the centre of the superview.
   */
  public var yOffset: CGFloat = 0.0
  
  /**
   * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
   * Defaults to 24.0
   */
  public var margin: CGFloat = 24.0
  
  /**
   * The corner radius for the HUD
   * Defaults to 10.0
   */
  public var cornerRadius: CGFloat = 10{
    didSet{
      containerView.backgroundView.layer.cornerRadius = cornerRadius
      containerView.backgroundView.clipsToBounds = true
    }
  }
  
  /**
   * Cover the HUD background view with a radial gradient.
   */
  public var dimBackground: Bool = false
  
  /*
  * Grace period is the time (in seconds) that the invoked method may be run without
  * showing the HUD. If the task finishes before the grace time runs out, the HUD will
  * not be shown at all.
  * This may be used to prevent HUD display for very short tasks.
  * Defaults to 0 (no grace time).
  * Grace time functionality is only supported when the task status is known!
  * @see taskInProgress
  */
  public var graceTime: NSTimeInterval = 0.0
  
  /**
   * The minimum time (in seconds) that the HUD is shown.
   * This avoids the problem of the HUD being shown and than instantly hidden.
   * Defaults to 0 (no minimum show time).
   */
  public var minShowTime: NSTimeInterval = 0.0
  
  /**
   * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
   * If you don't set a graceTime (different than 0.0) this does nothing.
   * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
   * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
   * you need to set this property when your task starts and completes in order to have normal graceTime
   * functionality.
   */
  public var taskInProgress: Bool = false
  
  /**
   * Removes the HUD from its parent view when hidden.
   * Defaults to NO.
   */
  public var removeFromSuperViewOnHide: Bool = false
  
  
  public let label :UILabel =  UILabel(frame: CGRectZero)
  
  public let detailsLabel :UILabel =  UILabel(frame: CGRectZero)
 
  public var checkmarkImage:UIImage?
 
  public var padding:CGFloat = 20
  

  
  
  public var blurStyle : UIBlurEffectStyle = .Dark{
    didSet{
      containerView.backgroundView.effect = UIBlurEffect(style: blurStyle)
    }
  }
 
  
  /**
   * The color of the activity indicator. Defaults to [UIColor whiteColor]
   * Does nothing on pre iOS 5.
   */
  public var activityIndicatorColor: UIColor = .whiteColor(){
    didSet{
      if let activityIndicator = indicator as? UIActivityIndicatorView{
        activityIndicator.color = activityIndicatorColor
      }
    }
    
  }
  
  /**
   * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
   */
  public var progress: CGFloat = 1.0{
    didSet{
      if let pg = indicator as? BXBaseProgressView{
        pg.progress = progress
      }
    }
  }
  
  private var indicator:UIView?{
    if let indicatorContainer = containerView as? BXHUDIndicatorContainerView{
      return indicatorContainer.indicator
    }
    return nil
  }

  /**
   * Force the HUD dimensions to be equal if possible.
   */
  public var square: Bool = false
  
  var useAnimation = false
  
  var isFinished = false
  var rotationTransform = CGAffineTransformIdentity
  
  var showStarted:NSDate?
  
  private var containerView:BXHUDContainerView = BXHUDIndicatorContainerView()
  private var isIniting = false
  
  public init(mode:BXHUDMode = BXHUDMode.Indeterminate){
    isIniting = true
    self.mode = mode
    super.init(frame: CGRect.zero)
    self.containerView = self.containerViewOfMode(mode)
    commonInit()
    isIniting = false
  }
  
  
  public func attachTo(view:UIView){
    self.removeFromSuperview()
    frame = view.bounds
    view.addSubview(self)
  }
 
  @nonobjc
  public func attachTo(window:UIWindow){
    self.attachTo(window as UIView)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
  func commonInit(){
    // Transparent background
    backgroundColor = .clearColor()
    opaque = false
    // Make it invisible for now
    alpha = 0.0
    shouldUpdateIndicators()
    setupAttrs()
    
    registerForNotifications()
  }
  
  
  
  // MARK: UI


  
  func indicatorOfMode(mode:BXHUDMode) -> UIView?{
    switch mode{
    case .Indeterminate:
      let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
      indicator.color = activityIndicatorColor
      indicator.startAnimating()
      return indicator
    case .Checkmark:
      if let image = checkmarkImage{
        return UIImageView(image: image)
      }
      return nil
    case .DeterminateHorizontalBar:
      return  BXBarProgressView()
    case .Determinate,.AnnularDeterminate:
      let indicator = BXRoundProgressView()
      indicator.annular = mode == .AnnularDeterminate
      return indicator
    case .CustomView:
      return customView
    case .Text:
      return nil
    }
  }
  
  func containerViewOfMode(mode:BXHUDMode) -> BXHUDContainerView{
    if let indicator = indicatorOfMode(mode){
      return BXHUDIndicatorContainerView(mode: mode, indicator: indicator, titleLabel: label)
    }else{
      return BXHUDTextContainerView(mode: mode, titleLabel: label, detailsLabel: detailsLabel)
    }
  }
  

  func setupAttrs(){
//    containerView.layer.cornerRadius = cornerRadius
    
    label.textColor = .whiteColor()
    label.font = UIFont.boldSystemFontOfSize(BXProgressOptions.labelFontSize)
    
    detailsLabel.textColor = .whiteColor()
    detailsLabel.numberOfLines = 1
    detailsLabel.font = UIFont.boldSystemFontOfSize(BXProgressOptions.detailsLabelFontSize)
    
    
    for l in [label,detailsLabel]{
      l.adjustsFontSizeToFitWidth = false
      l.textAlignment = .Center
      l.opaque = false
      l.backgroundColor = .clearColor()
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
  
  public override func willMoveToSuperview(newSuperview: UIView?) {
    super.willMoveToSuperview(newSuperview)
    #if DEBUG
      NSLog("\(#function)")
    #endif
    if let superView  = newSuperview{
      frame = superView.bounds
    }
  }
  
 
  func imageByName(name:String) -> UIImage?{
    let bundleOfThis = NSBundle(forClass: BXProgressHUD.self)
    guard let bundleURL = bundleOfThis.URLForResource("BXProgressHUD", withExtension: "bundle") else{
      NSLog("Resources bundle not found")
      return nil
    }
    
    guard let bundle = NSBundle(URL: bundleURL) else{
      NSLog("Could not load Resources Bundle \(bundleURL)")
      return nil
    }
    if let imagePath = bundle.pathForResource(name, ofType: "png"){
      return UIImage(contentsOfFile: imagePath)
    }else{
      return nil
    }
    
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
}



extension BXProgressHUD{
  
  
  
  
}



extension BXProgressHUD{
  
  public static func showHUDAddedTo(view:UIView, animated:Bool = true) -> BXProgressHUD{
    let hud = BXProgressHUD(mode: BXHUDMode.Indeterminate)
    hud.removeFromSuperViewOnHide = true
    view.addSubview(hud)
    hud.show(animated)
    return hud
  }
  
  public static func HUDForView(view:UIView) -> BXProgressHUD? {
    return view.subviews.reverse().filter{ $0 is BXProgressHUD }.first as? BXProgressHUD
  }
  
  public static func allHUDsForView(view:UIView) -> [BXProgressHUD]{
    var huds = [BXProgressHUD]()
    view.subviews.forEach{ subview in
      if let hud = subview as? BXProgressHUD{
        huds.append(hud)
      }
    }
    return huds
  }
  
  public static func hideHUDForView(view:UIView,animated:Bool = true) -> Bool{
    if let hud = HUDForView(view){
      hud.removeFromSuperViewOnHide = true
      hud.hide()
      return true
    }else{
      return false
    }
  }
  
  public static func hideAllHUDsForView(view:UIView, animated:Bool = true) -> Int {
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
  public func showAnimated(animated:Bool,
    whileExecutingBlock block:dispatch_block_t,
    onQueue queue:dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0),
    completionBlock completion:BXProgressHUDCompletionBlock? = nil){
      taskInProgress = true
      completionBlock = completion
      dispatch_async(queue){
        block()
        dispatch_async(dispatch_get_main_queue()){
          self.hide(animated)
          self.completionBlock = nil
        }
      }
      self.show(animated)
  }
  
  func delay(delay:NSTimeInterval,closure:()-> Void){
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
    dispatch_after(when , dispatch_get_main_queue() , closure)
  }
}

extension BXProgressHUD{
  
  func registerForNotifications() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserverForName(UIApplicationDidChangeStatusBarOrientationNotification, object: nil, queue: nil) { (notif) -> Void in
      if self.superview != nil{
        self.updateForCurrentOrientationAnimated()
      }
    }
  }
  
  func updateForCurrentOrientationAnimated(animated:Bool = true){
    if let superview = self.superview{
      bounds = superview.bounds
    }
  }
}

extension BXProgressHUD{
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    updateForCurrentOrientationAnimated(false)
  }
  
  
}


extension BXProgressHUD{
  
  // MARK: Show & hide
  
  public func show(animated:Bool = true){
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
  
  public func hide(animated:Bool = true){
    useAnimation = animated
    // If the minShow time is set, calculate how long the hud shown
    // and pospone the hiding operation if necessary
    if let started = showStarted where minShowTime > 0.0{
      let interval = NSDate().timeIntervalSinceDate(started)
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
  
  public func hide(animated:Bool = true,afterDelay seconds:NSTimeInterval){
    delay(seconds){
      self.hide(animated)
    }
  }
  
  
  
  // MARK: Internal show & hide operations
  
  func showUsingAnimation(animated:Bool){
    // Cancel any scheduled hideDeplayed: calls
    NSObject.cancelPreviousPerformRequestsWithTarget(self)
    setNeedsDisplay()
    if animated{
      if animationType == .ZoomIn{
        transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5, 0.5))
      }else if animationType == .ZoomOut{
        transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5, 1.5))
      }
    }
    showStarted = NSDate()
    
    if animated{
      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(0.3)
      self.alpha = 1.0
      if animationType == .ZoomIn || animationType == .ZoomOut{
        self.transform = rotationTransform
      }
      UIView.commitAnimations()
    }else{
      self.alpha = 1.0
    }
    
  }
  
  func hideUsingAnimation(animated:Bool){
    if animated && showStarted != nil{
      UIView.animateWithDuration(0.3, animations: {
        self.alpha = 0.02
        // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden in the done method
        if self.animationType == .ZoomIn{
          self.transform = CGAffineTransformConcat(self.rotationTransform,CGAffineTransformMakeScale(1.5, 1.5))
        }else if self.animationType == .ZoomOut{
          self.transform = CGAffineTransformConcat(self.rotationTransform,CGAffineTransformMakeScale(0.5, 0.5))
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
    NSObject.cancelPreviousPerformRequestsWithTarget(self)
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