//
//  ViewController.swift
//  CustomSheet
//
//  Created by Irina Deeva on 14/11/24.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var buttonView: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Present", for: .normal)
        button.addTarget(self,
                         action: #selector(showPopover(_:)),
                         for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(buttonView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        buttonView.sizeToFit()
        buttonView.center.x = view.frame.width / 2
        buttonView.frame.origin.y = view.safeAreaInsets.top
    }

    @objc private func showPopover(_ sender: UIButton) {
        let vc = CustomPopoverController()

        vc.preferredContentSize = .init(width: 300, height: 280)
        vc.modalPresentationStyle = .popover

        if let popoverPresentationController = vc.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            // Set the source rect (the bounds of the button)
            popoverPresentationController.sourceRect = sender.bounds
            // Set the source view (the button)
            popoverPresentationController.sourceView = sender

            popoverPresentationController.delegate = self
        }

        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection)-> UIModalPresentationStyle {
        return .none
    }


//    func presentationController(_ controller: UIPresentationController,
//                                    viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//            if let navController = controller.presentedViewController as? UINavigationController {
//                navController.children.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(didTapClose(_:)))
//    }
//    return controller.presentedViewController
//    }
//
//
//    func presentationController(_ presentationController: UIPresentationController,
//                                    willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
//                                    transitionCoordinator: UIViewControllerTransitionCoordinator?) {
//            if let navController = presentationController.presentedViewController as? UINavigationController, style == .none {
//                navController.children.first?.navigationItem.rightBarButtonItem = nil
//    }
//    }
//
//    @objc private func didTapClose(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
}

final class CustomPopoverController: UIViewController {
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["280pt", "150pt"])
        segmentedControl.addTarget(self,
                                   action: #selector(changePopoverHeight(_:)),
                                   for: .valueChanged)

        return segmentedControl
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        view.addSubview(segmentedControl)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        segmentedControl.sizeToFit()
        segmentedControl.center.x = view.frame.width / 2
        segmentedControl.frame.origin.y = view.safeAreaInsets.top +  5
    }

    @objc private func changePopoverHeight(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex


        if selectedIndex == 0 {
            self.preferredContentSize.height = 280
        } else {
            self.preferredContentSize.height = 150
        }
    }
}
