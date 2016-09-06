//
//  NewNoteViewController.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 7/21/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class NewNoteViewController: UIViewController {
    
    lazy var eventStore: EKEventStore = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.eventStore
    }()
    
    var lastAttrbutes: [String: AnyObject]?
    var lastRange: NSRange?
    

    @IBOutlet weak var keyboardButton: KeyboardButton!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var textView: NoteTextView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var subjectTextFieldView: UIView!
    @IBOutlet weak var notebookButton: UIButton!
    @IBOutlet weak var reminderButton: NewNoteReminderButton!
    
    @IBOutlet weak var toolBarLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var datePickerBackView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerDetailLabel: UILabel!
    @IBOutlet weak var datePickerCancelControl: UIControl!
    @IBOutlet weak var datePickerDoneControl: UIControl!
    @IBOutlet weak var datePickerContentView: UIView!
    
    
    
    let alignLeftButton = FontSettingButton(image: UIImage(named: "AlignLeft"), highlightedImage: UIImage(named: "AlignLeftHighlight"))
    let alignCenterButton = FontSettingButton(image: UIImage(named: "AlignCenter"), highlightedImage: UIImage(named: "AlignCenterHighlight"))
    let alignRightButton = FontSettingButton(image: UIImage(named: "AlignRight"), highlightedImage: UIImage(named: "AlignRightHighlight"))
    let textBackgroundColorButton = FontSettingButton(image: UIImage(named: "TextBackgroundColor"), highlightedImage: UIImage(named: "TextBackgroundColorHighlight"))
    let fontStrikethroughButton = FontSettingButton(image: UIImage(named: "FontStrikethrough"), highlightedImage: UIImage(named: "FontStrikethroughHighlight"))
    let fontUnderlineButton = FontSettingButton(image: UIImage(named: "FontUnderline"), highlightedImage: UIImage(named: "FontUnderlineHighlight"))
    let fontItalicButton = FontSettingButton(image: UIImage(named: "FontItalic"), highlightedImage: UIImage(named: "FontItalicHighlight"))
    let fontBoldButton = FontSettingButton(image: UIImage(named: "FontBold"), highlightedImage: UIImage(named: "FontBoldHighlight"))
    
    let bulletedListButton = FontSettingButton(image: UIImage(named: "BulletedList"), highlightedImage: UIImage(named: "BulletedListHighlight"))
    let todoListButton = FontSettingButton(image: UIImage(named: "TodoList"), highlightedImage: UIImage(named: "TodoListHighlight"))
    let numberedListButton = FontSettingButton(image: UIImage(named: "NumberedList"), highlightedImage: UIImage(named: "NumberedListHighlight"))
    
    
    var fontSettingButtons: [UIButton] {
        get {
            return [alignLeftButton, alignCenterButton, alignRightButton, textBackgroundColorButton, fontStrikethroughButton, fontUnderlineButton, fontItalicButton, fontBoldButton]
        }
    }
    
    var listSettingButtons: [UIButton] {
        get {
            return [bulletedListButton, numberedListButton, todoListButton]
        }
    }
    
    let geocoder: CLGeocoder = CLGeocoder()
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        _locationManager.distanceFilter = kCLLocationAccuracyKilometer
        return _locationManager
    }()
    
    var note: Note?
    var notebook: Notebook! {
        didSet {
            notebookButton.setTitle(" \(notebook.name!)", forState: .Normal)
        }
    }
    
    var location: CLLocation! {
        didSet {
            if locationName == nil {
                geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) in
                    self.locationName = placemarks?.first?.name
                })
            }
        }
    }
    
    var locationName: String? {
        didSet {
            if let locationName = locationName {
                subjectTextField.placeholder = "Note from \(locationName)"
            }
        }
    }
    
    var createdDate: NSDate?
    var updateDate: NSDate?
    var reminderDate: NSDate? {
        didSet {
            reminderButton.isSet = (reminderDate != nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupDatePicker()
        
        locationManager.requestWhenInUseAuthorization()
        
        setupNote()
        
        subjectTextFieldView.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        toolBarView.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        toolBarView.setupTopDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewNoteViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewNoteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewNoteViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func setupDatePicker() {
        datePickerBackView.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
        datePicker.setupTopDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePickerContentView.setupTopDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePicker.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePickerCancelControl.setupRightDividingLine(lineWidth: 0.25, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePickerDoneControl.setupLeftDividingLine(lineWidth: 0.25, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePickerCancelControl.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePickerDoneControl.setupButtomDividingLine(lineWidth: 0.5, lineColor: UIColor(white: 0.6, alpha: 1).CGColor)
        datePickerBackView.hidden = true
        
    }
    
    func setupNote() {
        if note == nil {
            notebook = Notebook.getAllNoteBooks().first!
            locationManager.startUpdatingLocation()
        } else {
            notebook = note?.notebook!
            locationName = note?.locationName
            location = CLLocation(latitude: (note?.latitude)!.doubleValue, longitude: (note?.longitude)!.doubleValue)
            createdDate = note?.createdDate
            updateDate = note?.updateDate
            reminderDate = note?.reminderDate
            textView.attributedText = note?.text
            subjectTextField.text = note?.subject
            
        }
    }
    
    func saveNote() {
        let subject: String
        if let sbj = subjectTextField.text?.removeHeadAndTailSpacePro where sbj != "" {
            subject = sbj
        } else {
            subject = subjectTextField.placeholder!
        }
        let date = NSDate()
        
        Note.saveNote(note, subject: subject, notebook: notebook, createdDate: createdDate ?? date, updateDate: date, reminderDate: reminderDate, location: location, locationName: locationName, text: textView.attributedText)
        if let reminderDate = self.reminderDate {
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = subject
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            let dueDateComponents = reminderDate.dateComponent()
            reminder.dueDateComponents = dueDateComponents
            let alerm = EKAlarm(absoluteDate: reminderDate)
            reminder.addAlarm(alerm)
            do {
                try eventStore.saveReminder(reminder, commit: true)
                (UIApplication.sharedApplication().delegate as! AppDelegate).getAllReminders()
            } catch {}
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            
            
            self.toolBarLayoutConstraint.constant = CGRectGetHeight(intersection)
            
            UIView.animateWithDuration(duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve), animations: {
                                        _ in
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardButton.isTyping = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardButton.isTyping = false
    }
    
    @IBAction func keyboardButtonPressed(sender: KeyboardButton) {
        if sender.isTyping {
            subjectTextField.resignFirstResponder()
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        if let control = sender as? UIControl {
            control.resignFirstResponder()
        }
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.dismissViewControllerAnimated(flag, completion: completion)
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        subjectTextField.resignFirstResponder()
        textView.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionDeleteDraft = UIAlertAction(title: "Delete Draft", style: UIAlertActionStyle.Destructive) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionSaveDraft = UIAlertAction(title: "Save Draft", style: UIAlertActionStyle.Default) { (_) in
            self.saveNote()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) in
            return
        }
        alert.addAction(actionDeleteDraft)
        alert.addAction(actionSaveDraft)
        alert.addAction(actionCancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        subjectTextField.resignFirstResponder()
        textView.resignFirstResponder()
        saveNote()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func fontButtonPressed(sender: AnyObject) {
        let popOver = ZZPopOver(sender: sender as! UIButton, holder: self, paddingFromSender: 5, style: ZZPopOverSpecialStyle.AlignHorizontalCenter(padding: 10, fromTop: false, height: self.view.frame.width / 10))
        popOver.showPopOver(animated: true, contents: fontSettingButtons, contentsStyle: ZZPopOverContentsStyle.ResizeToSameSize)
       
    }
    
    @IBAction func listButtonPressed(sender: AnyObject) {
        let popOver = ZZPopOver(sender: sender as! UIButton, holder: self, size: CGSize(width: (self.view.frame.width / 17) * 7, height: self.view.frame.width / 10), direction: ZZPopOverDirection.FromButtom(padding: 5), triangleAlignStyle: ZZPopOverTriangleAlignStyle.AlignCustom(factor: 0.3))
        popOver.showPopOver(animated: true, contents: listSettingButtons, contentsStyle: ZZPopOverContentsStyle.ResizeToSameSize)
    }
    
    @IBAction func pictureButtonPressed(sender: AnyObject) {
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        presentViewController(imageTakerController, animated: true, completion: nil)
    }
    
    @IBAction func reminderButtonPressed(sender: AnyObject) {
        subjectTextField.resignFirstResponder()
        textView.resignFirstResponder()
        if let reminderDate = self.reminderDate {
            datePicker.date = reminderDate
            datePickerDetailLabel.text = datePicker.date.toReminderDateStringNoTime()
        } else {
            datePicker.date = NSDate()
            datePickerDetailLabel.text = datePicker.date.toReminderDateStringNoTime()
        }
        self.datePickerBackView.transform = CGAffineTransformMakeScale(1.1, 1.1)
        self.datePickerBackView.alpha = 0
        self.datePickerBackView.hidden = false
        UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: {
            self.datePickerBackView.transform = CGAffineTransformIdentity
            self.datePickerBackView.alpha = 1
            }, completion: nil)
    }

    @IBAction func PickerCancelPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: {
            self.datePickerBackView.alpha = 0
            }, completion: { (finished) in
                self.datePickerBackView.hidden = true
            })
    }
    
    @IBAction func PickerDonePressed(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState, animations: {
            self.datePickerBackView.alpha = 0
            }, completion: { (finished) in
                self.datePickerBackView.hidden = true
                self.reminderDate = self.datePicker.date
        })
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        datePickerDetailLabel.text = sender.date.toReminderDateStringNoTime()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToMoveNoteVC" {
            let vc = segue.destinationViewController as! MoveNoteViewController
            vc.selectedNotebook = notebook
            vc.block = { (selectedNotebook: Notebook) in
                self.notebook = selectedNotebook
            }
        } else if segue.identifier == "ToNewNoteDetailVC" {
            let vc = segue.destinationViewController as! NewNoteDetailsViewController
            var subject = subjectTextField.text ?? "New Note"
            subject = (subject == "") ? "New Note" : subject
            vc.setInformation(subject: subject, location: location, locationName: locationName, createdDate: createdDate, updateDate: updateDate)
            vc.block = { (location: CLLocation, locationName: String?) in
                self.locationName = locationName
                self.location = location
            }
        }
    }

}

extension NewNoteViewController {
    
    func setupButtons() {
        alignLeftButton.selected = true
        alignLeftButton.addTarget(self, action: #selector(NewNoteViewController.textAlignLeft(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        alignCenterButton.addTarget(self, action: #selector(NewNoteViewController.textAlignCenter(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        alignRightButton.addTarget(self, action: #selector(NewNoteViewController.textAlignRight(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        textBackgroundColorButton.addTarget(self, action: #selector(NewNoteViewController.textBackgroundColor(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        fontStrikethroughButton.addTarget(self, action: #selector(NewNoteViewController.fontStrikethrough(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        fontUnderlineButton.addTarget(self, action: #selector(NewNoteViewController.fontUnderline(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        fontItalicButton.addTarget(self, action: #selector(NewNoteViewController.fontItalic(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        fontBoldButton.addTarget(self, action: #selector(NewNoteViewController.fontBold(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func textAlign(align: NSTextAlignment) {
        let style =  NSMutableParagraphStyle()
        style.alignment = align
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let selectedRange = textView.selectedRange
        let searchRange = NSRange(location: 0, length: selectedRange.length + selectedRange.location)
        var range = NSString(string: string.string).rangeOfString("\n", options: NSStringCompareOptions.BackwardsSearch, range: searchRange)
        if range.location == NSNotFound {
            range = NSRange(location: 0, length: 1)
        } else {
            range = NSRange(location: range.location + 1, length: 1)
        }
        if range.length + range.location >= string.length {
            textView.typingAttributes[NSParagraphStyleAttributeName] = style
            return
        }
        string.addAttribute(NSParagraphStyleAttributeName, value:  style, range: range)
        textView.attributedText = string
        textView.selectedRange = selectedRange
    }
    
    func textAddAttrbute(attrbute: (String, AnyObject)) {
        if textView.selectedRange.length > 0 {
            let range = textView.selectedRange
            let string = NSMutableAttributedString(attributedString: textView.attributedText)
            string.addAttribute(attrbute.0, value:  attrbute.1, range: range)
            textView.attributedText = string
            textView.selectedRange = range
        } else {
            textView.typingAttributes[attrbute.0] = attrbute.1
        }
    }
    
    func textRemoveAttrbute(attrbuteName: String) {
        if textView.selectedRange.length > 0 {
            let range = textView.selectedRange
            let string = NSMutableAttributedString(attributedString: textView.attributedText)
            string.removeAttribute(attrbuteName, range: range)
            textView.attributedText = string
            textView.selectedRange = range
        } else {
            textView.typingAttributes[attrbuteName] = nil
        }
    }
    
    @objc
    func textAlignLeft(sender: FontSettingButton) {
        if !sender.selected {
            textAlign(.Left)
            alignLeftButton.selected = true
            alignCenterButton.selected = false
            alignRightButton.selected = false
        }
    }
    
    @objc
    func textAlignCenter(sender: FontSettingButton) {
        if sender.selected {
            textAlign(.Left)
            alignLeftButton.selected = true
            alignCenterButton.selected = false
            alignRightButton.selected = false
            return
        }
        textAlign(.Center)
        alignLeftButton.selected = false
        alignCenterButton.selected = true
        alignRightButton.selected = false
    }
    
    @objc
    func textAlignRight(sender: FontSettingButton) {
        if sender.selected {
            textAlign(.Left)
            alignLeftButton.selected = true
            alignCenterButton.selected = false
            alignRightButton.selected = false
            return
        }
        textAlign(.Right)
        alignLeftButton.selected = false
        alignCenterButton.selected = false
        alignRightButton.selected = true
    }
    
    @objc
    func textBackgroundColor(sender: FontSettingButton) {
        if sender.selected {
            textRemoveAttrbute(NSBackgroundColorAttributeName)
        } else {
            textAddAttrbute((NSBackgroundColorAttributeName, UIColor.yellowColor()))
        }
        sender.selected = !sender.selected
    }
    
    @objc
    func fontStrikethrough(sender: FontSettingButton) {
        if sender.selected {
            textRemoveAttrbute(NSStrikethroughStyleAttributeName)
        } else {
            textAddAttrbute((NSStrikethroughStyleAttributeName, 1))
        }
        sender.selected = !sender.selected
    }
    
    @objc
    func fontUnderline(sender: FontSettingButton) {
        if sender.selected {
            textRemoveAttrbute(NSUnderlineStyleAttributeName)
        } else {
            textAddAttrbute((NSUnderlineStyleAttributeName, 1))
        }
        sender.selected = !sender.selected
    }
    
    @objc
    func fontItalic(sender: FontSettingButton) {
        if sender.selected {
            textAddAttrbute((NSFontAttributeName, UIFont.systemFontOfSize(14)))
        } else {
            textAddAttrbute((NSFontAttributeName, UIFont.italicSystemFontOfSize(14)))
        }
        sender.selected = !sender.selected
        fontBoldButton.selected = false
    }
    
    @objc
    func fontBold(sender: FontSettingButton) {
        if sender.selected {
            textAddAttrbute((NSFontAttributeName, UIFont.systemFontOfSize(14)))
        } else {
            textAddAttrbute((NSFontAttributeName, UIFont.boldSystemFontOfSize(14)))
        }
        sender.selected = !sender.selected
        fontItalicButton.selected = false
    }
    
    func updateButtonsAndTyping(attributes attributes: [String : AnyObject]) {
        fontSettingButtons.forEach({ (button) in
            button.selected = false
        })
        alignLeftButton.selected = true
        attributes.forEach({ (name, attribute) in
            switch name {
            case NSFontAttributeName:
                if let font = attribute as? UIFont {
                    switch font {
                    case UIFont.boldSystemFontOfSize(14):
                        fontBoldButton.selected = true
                    case UIFont.italicSystemFontOfSize(14):
                        fontItalicButton.selected = true
                    default:
                        break
                    }
                }
            case NSUnderlineStyleAttributeName:
                fontUnderlineButton.selected = true
            case NSStrikethroughStyleAttributeName:
                fontStrikethroughButton.selected = true
            case NSParagraphStyleAttributeName:
                if let style = attribute as? NSMutableParagraphStyle {
                    switch style.alignment {
                    case .Center:
                        alignCenterButton.selected = true
                        alignLeftButton.selected = false
                    case .Right:
                        alignRightButton.selected = true
                        alignLeftButton.selected = false
                    default:
                        break
                    }
                }
            default:
                break
            }
        })
        textView.typingAttributes = attributes
    }
}

extension NewNoteViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            self.locationManager.stopUpdatingLocation()
        }
    }
    
}


extension NewNoteViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(textView: UITextView) {
        guard let oldRange = lastRange where (oldRange.location + 1 == textView.selectedRange.location) && oldRange.length == 0 && textView.selectedRange.length == 0 else {
            if lastAttrbutes != nil {
                updateButtonsAndTyping(attributes: lastAttrbutes!)
                lastAttrbutes = nil
                return
            }
            if textView.selectedRange.length > 0 {
                updateButtonsAndTyping(attributes: textView.attributedText.attributesAtIndex(textView.selectedRange.location + 1, effectiveRange: nil))
            } else if textView.selectedRange.location > 0 {
                updateButtonsAndTyping(attributes: textView.attributedText.attributesAtIndex(textView.selectedRange.location - 1, effectiveRange: nil))
            }
            lastRange = textView.selectedRange
            return
        }
        lastRange = textView.selectedRange
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            lastAttrbutes = textView.typingAttributes
            textView.typingAttributes = [:]
        }

        return true
    }
}

extension NewNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePickerController: UIImagePickerController {
        get {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            return imagePicker
        }
    }
    
    var imageTakerController: UIImagePickerController {
        get {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            return imagePicker
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let attachment = NSTextAttachment()
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        attachment.image = image
        let bounds: CGRect
        if image?.size.width <= screenWidth - 7 * 2 {
            bounds = CGRect(x: 0, y: 0, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
        } else {
            bounds = CGRect(x: 0, y: 0, width: screenWidth - 7 * 2, height: (image?.size.height ?? 0) * (screenWidth - 7 * 2) / (image?.size.width ?? 0))
        }
        attachment.bounds = bounds
        let attributeStr = NSAttributedString(attachment: attachment)
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableStr.insertAttributedString(attributeStr, atIndex: textView.selectedRange.location)
        textView.attributedText = mutableStr
        textView.selectedRange = NSRange(location: textView.selectedRange.location + 1, length: 0)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}






















