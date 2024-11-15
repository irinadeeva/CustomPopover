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
            popoverPresentationController.sourceRect = sender.bounds
            popoverPresentationController.sourceView = sender

            popoverPresentationController.delegate = self
        }

        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

final class CustomPopoverController: UIViewController, UIAdaptivePresentationControllerDelegate {
    private enum PopoverSize {
        static let fullHeight: CGFloat = 280
        static let compactHeight: CGFloat = 150
    }

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["280pt", "150pt"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(changePopoverHeight(_:)),
                                   for: .valueChanged)

        return segmentedControl
    }()

    private lazy var closeButtonView: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self,
                         action: #selector(dismissPopover),
                         for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray5
        view.addSubview(segmentedControl)
        view.addSubview(closeButtonView)

        self.presentationController?.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        segmentedControl.sizeToFit()
        segmentedControl.center.x = view.frame.width / 2
        segmentedControl.frame.origin.y = view.safeAreaInsets.top +  5

        closeButtonView.sizeToFit()
        closeButtonView.frame.origin.x = view.frame.width - closeButtonView.frame.width
        closeButtonView.frame.origin.y = view.safeAreaInsets.top +  5
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }

    @objc private func changePopoverHeight(_ sender: UISegmentedControl) {
        preferredContentSize.height = sender.selectedSegmentIndex == 0 ? PopoverSize.fullHeight : PopoverSize.compactHeight
    }

    @objc private func dismissPopover() {
        dismiss(animated: true, completion: nil)
    }
}
