//
//  HImageTextViewTests.swift
//  HSwiftProjectTests
//

import Testing
import UIKit
@testable import HSwiftProject

@Suite
struct HImageTextViewTests {

    @Test @MainActor func testTextAndImageAssignment() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        view.text = "标题"
        view.setImage(UIImage())
        #expect(view.text == "标题")
        #expect(view.image != nil)
    }

    @Test @MainActor func testSetImageNilClearsImage() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImage(UIImage())
        #expect(view.image != nil)
        view.setImage(nil)
        #expect(view.image == nil)
    }

    @Test @MainActor func testTapDoesNotToggleSelectionByDefault() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        var tapped = false
        view.pressed = { _, _ in tapped = true }
        #expect(view.togglesSelectionOnTap == false)
        #expect(view.state == .normal)
        #expect(view.accessibilityActivate())
        #expect(tapped)
        #expect(view.state == .normal)
    }

    @Test @MainActor func testCornerRadiusWritesLayerDirectly() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        _ = view.cornerRadius(8)
        #expect(view.viewCornerRadius == 8)
        #expect(view.layer.cornerRadius == 8)
    }

    @Test @MainActor func testLeadingTopIsALayoutCase() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        view.imagePosition = .leadingTop
        #expect(view.imagePosition == .leadingTop)
    }

    @Test @MainActor func testResetForReuseClearsContentAndCallbacks() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        view.text = "旧文案"
        view.setImage(UIImage())
        view.pressed = { _, _ in }
        view.imageSize = CGSize(width: 20, height: 20)
        view.imagePosition = .top
        view.useFadeAnimation = true
        view.gradientBackgroundColors = [.red, .blue]
        view.resetForReuse()
        #expect(view.text == nil)
        #expect(view.image == nil)
        #expect(view.pressed == nil)
        #expect(view.imageSize == .zero)
        #expect(view.imagePosition == .left)
        #expect(view.useFadeAnimation == false)
        #expect(view.gradientBackgroundColors == nil)
        #expect(view.state == .normal)
        #expect(view.isUserInteractionEnabled == false)
    }

    @Test @MainActor func testEmptyTextIsRemovedFromStack() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        view.setImage(UIImage())
        view.text = "标题"
        view.layoutIfNeeded()
        view.text = nil
        view.layoutIfNeeded()
        let stack = view.subviews.first { $0 is UIStackView } as? UIStackView
        #expect(stack?.arrangedSubviews.count == 1)
    }

    @Test @MainActor func testReuseResetsTapDebounce() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        var count = 0
        view.pressed = { _, _ in count += 1 }
        #expect(view.accessibilityActivate())
        view.resetForReuse()
        view.pressed = { _, _ in count += 1 }
        #expect(view.accessibilityActivate())
        #expect(count == 2)
    }

    @Test @MainActor func testRemoteURLDetection() {
        #expect(HImageTextLoader.isRemoteURL("https://example.com/a.png"))
        #expect(HImageTextLoader.isRemoteURL("HTTP://EXAMPLE.COM/A"))
        #expect(!HImageTextLoader.isRemoteURL("icon_home"))
    }

    @Test @MainActor func testOverlayDisablesHostAccessibilityElement() {
        let host = HImageTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        host.setImage(UIImage())
        #expect(host.isAccessibilityElement)
        host.addSubview(UIView())
        #expect(!host.isAccessibilityElement)
    }

    @Test @MainActor func testMissingAssetReportsFailure() {
        let view = HImageTextView(frame: .zero)
        var status: HImageLoadStatus?
        view.imageLoadStatus = { _, next, _ in status = next }
        view.setImageUrlString("definitely_not_an_asset_name_xyz")
        #expect(status == .failure)
        #expect(view.image == nil)
    }

    @Test @MainActor func testChainAPIReturnsSameInstance() {
        let view = HImageTextView(frame: .zero)
        let chained = view.text("A").textColor(.red).imageSize(CGSize(width: 24, height: 24))
        #expect(chained === view)
        #expect(view.text == "A")
    }

    @Test @MainActor func testDefaultDoesNotStealTouches() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        #expect(view.isUserInteractionEnabled == false)
        #expect(!view.accessibilityTraits.contains(.button))
        #expect(view.accessibilityActivate() == false)
    }

    @Test @MainActor func testPressedEnablesInteractionAndButtonTrait() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.pressed = { _, _ in }
        #expect(view.isUserInteractionEnabled)
        #expect(view.accessibilityTraits.contains(.button))
    }

    @Test @MainActor func testContentModeForwardsToInnerImageView() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.contentMode = .scaleAspectFit
        view.setImage(UIImage())
        #expect(view.imageView.contentMode == .scaleAspectFit)
        view.contentMode = .center
        #expect(view.imageView.contentMode == .center)
    }

    @Test @MainActor func testContentStackStaysBelowExternalOverlays() {
        let host = HImageTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let overlay = UIView()
        host.addSubview(overlay)
        host.setImage(UIImage())
        host.layoutIfNeeded()
        let stack = host.subviews.first { $0 is UIStackView }
        #expect(stack != nil)
        let stackIndex = host.subviews.firstIndex(of: stack!)
        let overlayIndex = host.subviews.firstIndex(of: overlay)
        #expect(stackIndex != nil && overlayIndex != nil)
        #expect(stackIndex! < overlayIndex!)
    }

    @Test @MainActor func testSetImageUrlStringDoesNotCreateSpinner() {
        let view = HImageTextView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.setImageUrlString("")
        #expect(!view.subviews.contains { $0 is UIActivityIndicatorView })
    }
}
