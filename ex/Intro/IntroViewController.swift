//
//  IntroViewController.swift
//  ex
//
//  Created by David Cornelius on 26/08/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: Asset.curhat_image.image,
                           title: "Curhat",
                           description: "Share your story and listen to others",
                           pageIcon: Asset.indicator_curhat_icon.image,
                           color: #colorLiteral(red: 1, green: 0.8202130198, blue: 0.4282061458, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.rebound_image.image,
                           title: "Hangout",
                           description: "Find new friends to meet and hangout",
                           pageIcon: Asset.indicator_rebound_icon.image,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),

        OnboardingItemInfo(informationImage: Asset.tradein_image.image,
                           title: "Take & Give",
                           description: "Get more advice and give others your opinion about their story ",
                           pageIcon: Asset.indicator_tradein_icon.image,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        skipButton.isHidden = true
        
        setupPaperOnboardingView()
        
        view.bringSubview(toFront: skipButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension IntroViewController {
    @IBAction func skipButtonTapped(_: UIButton) {
        print(#function)
        print("button skip")
    
        //Pergi ke menu utama
        performSegue(withIdentifier: "gotomainmenu", sender: nil)
    }
}

// MARK: PaperOnboardingDelegate

extension IntroViewController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension IntroViewController: PaperOnboardingDataSource {
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}


//MARK: Constants
extension IntroViewController {
    private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}
