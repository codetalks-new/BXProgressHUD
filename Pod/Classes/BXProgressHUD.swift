

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
            shouldUpdateIndicators()
        }
    }
    
    /**
     * The animation type that should be used when the HUD is shown and hidden.
     *
     * @see BXProgressHUDAnimation
     */
    public var animationType: BXProgressHUDAnimation  = .Fade{
        didSet{
            shouldUpdateIndicators()
        }
    }
    
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
     * The opacity of the HUD window. Defaults to 0.8 (80% opacity).
     */
    public var opacity: CGFloat = 0.8
    
    /**
     * The color of the HUD window. Defaults to black. If this property is set, color is set using
     * this UIColor and the opacity property is not used.  using retain because performing copy on
     * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
     */
    public var color: UIColor?
    
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
     * Defaults to 20.0
     */
    public var margin: CGFloat = 20.0
    
    /**
     * The corner radius for the HUD
     * Defaults to 10.0
     */
    public var cornerRadius: CGFloat = 10.0
    
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
    
    /**
     * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
     * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
     * set to @"", then no message is displayed.
     */
    public var labelText: String?{
        didSet{
            label?.text = labelText
            shouldUpdateUI()
        }
    }
    
    /**
     * An optional details message displayed below the labelText message. This message is displayed only if the labelText
     * property is also set and is different from an empty string (@""). The details text can span multiple lines.
     */
    public var detailsLabelText: String?{
        didSet{
            detailsLabel?.text = detailsLabelText
            shouldUpdateUI()
        }
    }
    
    /**
     * Font to be used for the main label. Set this property if the default is not adequate.
     */
    public var labelFont = UIFont.boldSystemFontOfSize(BXProgressOptions.labelFontSize){
        didSet{
            label?.font = labelFont
            shouldUpdateUI()
        }
    }
    
    /**
     * Color to be used for the main label. Set this property if the default is not adequate.
     */
    public var labelColor: UIColor = .whiteColor(){
        didSet{
            label?.textColor = labelColor
            shouldUpdateUI()
        }
    }
    
    /**
     * Font to be used for the details label. Set this property if the default is not adequate.
     */
    public var detailsLabelFont = UIFont.boldSystemFontOfSize(BXProgressOptions.detailsLabelFontSize){
        didSet{
            detailsLabel?.font = detailsLabelFont
            shouldUpdateUI()
        }
    }
    
    /**
     * Color to be used for the details label. Set this property if the default is not adequate.
     */
    public var detailsLabelColor = UIColor.whiteColor(){
        didSet{
            detailsLabel?.textColor = detailsLabelColor
            shouldUpdateUI()
        }
    }
    
    /**
     * The color of the activity indicator. Defaults to [UIColor whiteColor]
     * Does nothing on pre iOS 5.
     */
    public var activityIndicatorColor: UIColor = .whiteColor(){
        didSet{
            shouldUpdateIndicators()
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
    
    /**
     * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
     */
    public var minSize: CGSize = CGSizeZero
    
    /**
     * The actual size of the HUD bezel.
     * You can use this to limit touch handling on the bezel aria only.
     * @see https://github.com/jdg/BXProgressHUD/pull/200
     */
    
     var hudSize = CGSizeZero
    
     public var size: CGSize {
            return hudSize
     }
     
     /**
     * Force the HUD dimensions to be equal if possible.
     */
    public var square: Bool = false
    
    var useAnimation = false
    var label:UILabel?
    var detailsLabel:UILabel?
    var isFinished = false
    var rotationTransform = CGAffineTransformIdentity
    
    var indicator:UIView?
    var showStarted:NSDate?
    
   
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .Center
        autoresizingMask = [ .FlexibleTopMargin,.FlexibleBottomMargin,.FlexibleLeftMargin,.FlexibleRightMargin]
        
        // Transparent background
        backgroundColor = .clearColor()
        opaque = false
        // Make it invisible for now
        alpha = 0.0
        setupLabels()
        updateIndicators()
        registerForNotifications()
        setNeedsUpdateConstraints()
    }
    
    
    public convenience init(view:UIView){
        self.init(frame:view.bounds)
    }
    
    public convenience init(window:UIWindow){
        self.init(view:window)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _hasInstalledConstraints = false
    private var _prevModeConstraints:[NSLayoutConstraint] = []
    func  installConstraints() {
        if _hasInstalledConstraints{
            return
        }
        _hasInstalledConstraints = true
        _prevModeConstraints.removeAll()
        #if DEBUG
        NSLog("\(__FUNCTION__)")
        #endif
        hudSize = measure()
        let yPos = bounds.midY - size.height * 0.5 + yOffset + margin
        let allViews:[UIView?] = [ indicator,label,detailsLabel ]
        let padding = BXProgressOptions.padding
        var prevView:UIView?
        for view in allViews{
            if let view  = view{
                view.translatesAutoresizingMaskIntoConstraints = false
                let cx = view.pinCenterX(xOffset)
                _prevModeConstraints.append(cx)
                if let prevView = prevView{
                   let cb = view.pinBelowSibling(prevView, margin: padding)
                    _prevModeConstraints.append(cb)
                    
                }else{
                    let ct = view.pinTop(yPos)
                    _prevModeConstraints.append(ct)
                }
                prevView = view
            }
        }
        
    }
    
    
    
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(ctx!)
        
        if dimBackground{
            // Draw radial gradient
            // Gradient colors
            let gradLocationsNum = 2
            let gradLocations : [CGFloat] = [0.0,1.0]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            // two color RGBA
            let gradColors :[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.75]
            let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum)
            let gradCenter = CGPoint(x: bounds.midX, y: bounds.midY)
            let gradRadius = min(bounds.width,bounds.height)
            CGContextDrawRadialGradient(ctx, gradient, gradCenter, 0, gradCenter, gradRadius, .DrawsAfterEndLocation)
            
        }
        
        if let color = color{
            color.setFill()
        }else{
            CGContextSetGrayFillColor(ctx, 0.0, self.opacity)
        }
        
        // Draw rounded HUD background rect
        let boxRect = CGRect(x: bounds.midX - size.width * 0.5 + xOffset, y: bounds.midY - size.height * 0.5 + yOffset, width: size.width, height: size.height)
        let roundPath = UIBezierPath(roundedRect: boxRect, cornerRadius: cornerRadius)
        roundPath.fill()
        
        UIGraphicsPopContext()
    }
    
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

}

extension BXProgressHUD{
    // MARK: KVO
    func shouldUpdateIndicators(){
        updateIndicators()
        shouldUpdateConstraints()
    }
    
    func shouldUpdateConstraints(){
        removeConstraints(_prevModeConstraints)
        _hasInstalledConstraints  = false
        setNeedsUpdateConstraints()
    }
    
    
    func shouldUpdateUI(){
        setNeedsLayout()
        setNeedsDisplay()
    }
    
}

extension UIView{
    // Code Taken from PinAutoLayout
    
    func pinCenterX(offset:CGFloat=0) -> NSLayoutConstraint{
        let c = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview!, attribute: .CenterX, multiplier: 1.0, constant: offset)
        superview?.addConstraint(c)
        return c
    }
    
    func pinCenterY(offset:CGFloat=0) -> NSLayoutConstraint{
        let c = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview!, attribute: .CenterY, multiplier: 1.0, constant: offset)
        superview?.addConstraint(c)
        return c
    }
    
    func pinBelowSibling(sibling:UIView,margin:CGFloat = 8) -> NSLayoutConstraint{
        let c = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: sibling, attribute: .Bottom, multiplier: 1.0, constant: margin)
        superview?.addConstraint(c)
        return c
    }
    
    func pinTop(margin:CGFloat = 8) -> NSLayoutConstraint{
        let c = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview!, attribute: .Top, multiplier: 1.0, constant: margin)
        superview?.addConstraint(c)
        return c
    }
    
}

extension BXProgressHUD{
    // MARK: UI
    func setupLabels(){
       let label = UILabel(frame: bounds)
        label.textColor = self.labelColor
        label.font = self.labelFont
        label.text = self.labelText
        addSubview(label)
        self.label = label
        
        let detailsLabel = UILabel(frame: bounds)
        detailsLabel.textColor = detailsLabelColor
        detailsLabel.numberOfLines = 1
        detailsLabel.font = detailsLabelFont
        detailsLabel.text = detailsLabelText
        
        addSubview(detailsLabel)
        self.detailsLabel = detailsLabel
        
        for label in [label,detailsLabel]{
            label.adjustsFontSizeToFitWidth = false
            label.textAlignment = .Center
            label.opaque = false
            label.backgroundColor = .clearColor()
        }
    }
    
    func updateIndicators(){
        
        #if DEBUG
        NSLog("\(__FUNCTION__)")
        #endif
        let newIndicator:UIView?
        switch mode{
        case .Indeterminate:
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            indicator.color = activityIndicatorColor
            indicator.startAnimating()
            newIndicator = indicator
        case .Checkmark:
            let bundleOfThis = NSBundle(forClass: BXProgressHUD.self)
            
            guard let bundleURL = bundleOfThis.URLForResource("BXProgressHUD", withExtension: "bundle") else{
                NSLog("Resources bundle not found")
                return
            }
            
            guard let bundle = NSBundle(URL: bundleURL) else{
                NSLog("Could not load Resources Bundle \(bundleURL)")
                return
            }
            let imagePath = bundle.pathForResource("BX_37x-Checkmark@2x", ofType: "png")
            newIndicator = UIImageView(image: UIImage(contentsOfFile: imagePath!))
        case .DeterminateHorizontalBar:
           newIndicator = BXBarProgressView()
        case .Determinate,.AnnularDeterminate:
            let indicator = BXRoundProgressView()
            indicator.annular = mode == .AnnularDeterminate
            newIndicator = indicator
        case .CustomView:
            newIndicator = customView
        case .Text:
            indicator?.removeFromSuperview()
            indicator = nil
            newIndicator = nil
        
        }
        
        if let indicator = newIndicator {
            self.indicator?.removeFromSuperview()
            self.indicator = indicator
            addSubview(indicator)
        }
    }
    
    

    public override func layoutSubviews() {
        super.layoutSubviews()
        #if DEBUG
        NSLog("\(__FUNCTION__)")
        #endif
    }
    
    public override func updateConstraints() {
        #if DEBUG
        NSLog("\(__FUNCTION__)")
        #endif
        installConstraints()
        super.updateConstraints() // Call [super updateConstraints] as the final step in your implementation.
    }
    
    
   


    
    func measure() -> CGSize{
        if let p = superview{
            self.frame = p.bounds
        }
        let bounds = self.bounds
        let maxWidth = bounds.width - 4 * margin
        // Determine the total width and height needed
        var measuredWidth :CGFloat = 0
        var measuredHeight :CGFloat = 0
        
        // indicator
        let indicatorSize = indicator?.bounds.size ?? CGSizeZero
        measuredWidth = max(measuredWidth,min(indicatorSize.width,maxWidth))
        measuredHeight += indicatorSize.height
        
        // label
        let labelSize = textSizeForLabel(label, withFont: labelFont)
        measuredWidth = max(measuredWidth,min(labelSize.width, maxWidth))
        measuredHeight += labelSize.height
        
        if labelSize.height > 0 && indicatorSize.height > 0 {
            measuredHeight += BXProgressOptions.padding
        }
        
        
        let remainingHeight = bounds.height - measuredHeight - BXProgressOptions.padding - 4 * margin
        let maxSize = CGSize(width: maxWidth, height: remainingHeight)
        let detailLabelSize = multilineTextSizeForLabel(detailsLabel, font: detailsLabelFont, maxSize: maxSize)
        
        measuredWidth = max(measuredWidth,detailLabelSize.width)
        measuredHeight += detailLabelSize.height
        
        if detailLabelSize.height > 0 && (indicatorSize.height > 0 || labelSize.height > 0){
            measuredHeight += BXProgressOptions.padding
        }
        
        measuredWidth += margin * 2
        measuredHeight += margin * 2
        
        return  CGSize(width: measuredWidth, height: measuredHeight)
    }
    
    
    func textSizeForLabel(label:UILabel?,withFont font:UIFont) -> CGSize{
        if let text = label?.text where !text.isEmpty{
            let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName:font])
            return attributedText.size()
        }else{
            return CGSizeZero
        }
    }
    
    func multilineTextSizeForLabel(label:UILabel?,font:UIFont,maxSize:CGSize) -> CGSize{
        if let text = label?.text where !text.isEmpty{
            let nsstring = text  as NSString
            return nsstring.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
        }else{
            return CGSizeZero
        }
    }
}



extension BXProgressHUD{
    
    public static func showHUDAddedTo(view:UIView, animated:Bool = true) -> BXProgressHUD{
        let hud = BXProgressHUD(view: view)
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
            setNeedsDisplay()
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
            self.alpha = 1.0 // show inmediate
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
        hidden = true
        if removeFromSuperViewOnHide{
            removeFromSuperview()
        }
        completionBlock?()
        completionBlock = nil
        delegate?.hudWasHidden(self)
    }
    
}