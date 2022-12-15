//
//  RecentQueryCell.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import UIKit

final class RecentQueryCell: UITableViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let leftOffset: CGFloat = 16
        static let rightOffset: CGFloat = 16
    }
    
    // MARK: - Views
    private lazy var recentImageView = createImageView(with: "clock.arrow.circlepath")
    private lazy var arrowImageView = createImageView(with: "arrow.up.backward")
    private let recentQueryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
extension RecentQueryCell {
    func configure(with query: String) {
        recentQueryLabel.text = query
    }
    
    private func createImageView(with sfSymbol: String) -> UIImageView {
        let image = UIImage(systemName: sfSymbol)?.withTintColor(
            .black,
            renderingMode: .alwaysOriginal
        )
        
        let imageView = UIImageView(image: image)
        imageView.preferredSymbolConfiguration = .init(weight: .light)
        
        return imageView
    }
}

// MARK: - Setup views
private extension RecentQueryCell {
    func setupViews() {
        addSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(recentImageView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(recentQueryLabel)
    }
    
    func setupFrames() {
        recentImageView.sizeToFit()
        recentImageView.frame.origin = .init(
            x: Constants.leftOffset,
            y: (frame.height - recentImageView.frame.height) / 2
        )
        
        arrowImageView.sizeToFit()
        arrowImageView.frame.origin = .init(
            x: frame.width - arrowImageView.frame.width - Constants.rightOffset,
            y: (frame.height - arrowImageView.frame.height) / 2
        )
        
        let imageWidth = recentImageView.frame.width + (Constants.rightOffset * 2)
        recentQueryLabel.frame.size.width = frame.width - (imageWidth * 2)
        recentQueryLabel.sizeToFit()
        recentQueryLabel.frame.origin.x = imageWidth
        recentQueryLabel.frame.origin.y = (frame.height - recentQueryLabel.frame.height) / 2
    }
}
