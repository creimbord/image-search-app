//
//  PlaceholderView.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

final class PlaceholderView: UIView {
    
    // MARK: - Properties
    private(set) var text: String
    private(set) var imageTintColor: UIColor
    private(set) var placeholderImage: UIImage?
    
    enum PlaceholderImage: String {
        case empty = "photo.on.rectangle"
        case warning = "exclamationmark.triangle"
    }
    
    // MARK: - Constants
    private enum Constants {
        static let labelTopOffest = CGFloat(10)
        static let placeholderImageSize = CGSize(width: 50, height: 50)
    }
    
    // MARK: - Views
    private lazy var placeholerImageView: UIImageView = {
        let imageView = UIImageView(image: tintedPlaceholderImage)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.preferredSymbolConfiguration = .init(scale: .large)
        return imageView
    }()
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = text
        label.textColor = .systemGray
        label.backgroundColor = .white
        return label
    }()
    
    // MARK: - Init
    init(text: String, image: PlaceholderImage, imageTintColor: UIColor) {
        self.text = text
        self.imageTintColor = imageTintColor
        self.placeholderImage = UIImage(systemName: image.rawValue)
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }
}

// MARK: - Methods
extension PlaceholderView {
    func update(text: String, image: PlaceholderImage, imageTintColor: UIColor) {
        placeholderLabel.text = text
        self.imageTintColor = imageTintColor
        placeholderImage = UIImage(systemName: image.rawValue)
        placeholerImageView.image = tintedPlaceholderImage
    }
}

// MARK: - Computed properties
private extension PlaceholderView {
    var tintedPlaceholderImage: UIImage? {
        placeholderImage?.withTintColor(
            imageTintColor,
            renderingMode: .alwaysOriginal
        )
    }
    
    var labelSize: CGSize {
        placeholderLabel.intrinsicContentSize
    }
    
    var imageHeight: CGFloat {
        placeholerImageView.frame.size.height
    }
    
    var imageYPosition: CGFloat {
        placeholerImageView.frame.origin.y
    }
}

// MARK: - Setup views
private extension PlaceholderView {
    func setupViews() {
        addSubviews()
        backgroundColor = .white
    }
    
    func addSubviews() {
        addSubview(placeholerImageView)
        addSubview(placeholderLabel)
    }
    
    func setupFrames() {
        placeholerImageView.frame.size = Constants.placeholderImageSize
        placeholerImageView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        placeholderLabel.frame.origin.x = (frame.width - labelSize.width) / 2
        placeholderLabel.frame.origin.y = imageYPosition + imageHeight + Constants.labelTopOffest
        placeholderLabel.frame.size = labelSize
    }
}
