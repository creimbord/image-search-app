//
//  PhotoCell.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 13.12.2022.
//

import UIKit

protocol PhotoDisplayLogic: AnyObject {
    func displayFetchedThumbnail(_ viewModel: PhotoModel.FetchThumbnail.ViewModel)
}

final class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    var interactor: PhotoBusinessLogic?
    
    // MARK: - Views
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .white
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        Assembly.preparePhotoScene(for: self)
        setupViews()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }
    
    // MARK: - Methods
    func configure(with photo: Photo) {        
        photoTitleLabel.text = photo.title
        interactor?.fetchThumbnail(.init(
            id: photo.id,
            server: photo.server,
            secret: photo.secret
        ))
    }
}

// MARK: - PhotoDisplayLogic
extension PhotoCell: PhotoDisplayLogic {
    func displayFetchedThumbnail(_ viewModel: PhotoModel.FetchThumbnail.ViewModel) {
        photoImageView.image = viewModel.thumbnailImage
    }
}

// MARK: - Setup views
private extension PhotoCell {
    func setupViews() {
        addSubviews()
        backgroundColor = .white
    }
    
    func addSubviews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(photoTitleLabel)
    }
    
    func setupFrames() {
        photoImageView.frame.origin = .zero
        photoImageView.frame.size = CGSize(
            width: frame.size.width,
            height: frame.size.width
        )
        
        photoTitleLabel.frame.origin.x = .zero
        photoTitleLabel.frame.origin.y = photoImageView.frame.height + 10
        photoTitleLabel.frame.size.width = photoImageView.frame.width
        photoTitleLabel.sizeToFit()
    }
}
