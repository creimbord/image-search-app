//
//  LoadingFooter.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 14.12.2022.
//

import UIKit

final class LoadingFooter: UICollectionReusableView {
    
    // MARK: - Views
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let loader = UIActivityIndicatorView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footerView)
        footerView.addSubview(loader)
        loader.startAnimating()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        footerView.frame = frame
        loader.center = footerView.center
    }
}
