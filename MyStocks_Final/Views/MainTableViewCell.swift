//
//  MainTableViewCell.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: MainTableViewCell.self)
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
//        view.layer.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1).cgColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "yandex_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "YNDX"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
//        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let abbreviation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = "Yandex, LLC"
        label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold))
        imageView.tintColor = UIColor(cgColor: CGColor(red: 1, green: 0.79, blue: 0.11, alpha: 1))
        return imageView
    }()
    
    private let current_price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "4 764,6 ₽"
        label.textAlignment = .center
        label.textAlignment = .right
        return label
    }()
    
    private let percent_price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.14, green: 0.7, blue: 0.364, alpha: 1)
        label.text = "+55 ₽ (1,15%)"
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupUI()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundUIView)
        containerView.addSubview(logo)
        containerView.addSubview(name)
        containerView.addSubview(abbreviation)
        containerView.addSubview(current_price)
        containerView.addSubview(percent_price)
        containerView.addSubview(starIcon)
    }
    
    private func setupUI() {
        
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68), // greaterThanOrEqualToConstant
//            containerView.widthAnchor.constraint(equalToConstant: 328), // 328
        ]
        
        let backgroundUIViewConstraints = [
            backgroundUIView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundUIView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundUIView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundUIView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundUIView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68),
        ]
        
        let logoConstraints = [
            logo.heightAnchor.constraint(equalToConstant: 52),
            logo.widthAnchor.constraint(equalToConstant: 52),
            logo.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor, constant: 8),
            logo.topAnchor.constraint(equalTo: backgroundUIView.topAnchor, constant: 8),
            logo.bottomAnchor.constraint(lessThanOrEqualTo: backgroundUIView.bottomAnchor, constant: -8) // lessThanOrEqualTo
        ]
        
        let nameConstraints = [
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            name.topAnchor.constraint(equalTo: backgroundUIView.topAnchor, constant: 14),
            name.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor, constant: -30)
        ]
        
        let abbreviationConstraints = [
            abbreviation.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            abbreviation.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor, constant: -14),
            abbreviation.topAnchor.constraint(equalTo: backgroundUIView.topAnchor, constant: 38)
        ]
        
        let starIconConstraints = [
            starIcon.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 6),
            starIcon.topAnchor.constraint(equalTo: name.topAnchor),
            starIcon.bottomAnchor.constraint(equalTo: name.bottomAnchor),
//            starIcon.heightAnchor.constraint(equalToConstant: 18),
//            starIcon.widthAnchor.constraint(equalToConstant: 16)
        ]
        
        let current_priceConstraints = [
            current_price.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor, constant: -17),
            current_price.topAnchor.constraint(equalTo: backgroundUIView.topAnchor, constant: 14),
            current_price.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor, constant: -30),
        ]
        
        let percent_priceConstraints = [
            percent_price.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor, constant: -12),
            percent_price.topAnchor.constraint(equalTo: backgroundUIView.topAnchor, constant: 38),
            percent_price.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor, constant: -12),
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(backgroundUIViewConstraints)
        NSLayoutConstraint.activate(logoConstraints)
        NSLayoutConstraint.activate(nameConstraints)
        NSLayoutConstraint.activate(abbreviationConstraints)
        NSLayoutConstraint.activate(starIconConstraints)
        NSLayoutConstraint.activate(current_priceConstraints)
        NSLayoutConstraint.activate(percent_priceConstraints)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        
        func animateColorChange(from fromColor: CGColor, to toColor: UIColor, duration: TimeInterval = 0.2) {
            if self.containerView.layer.backgroundColor == fromColor {
                if selected {
                    UIView.animate(withDuration: duration) {
                        self.backgroundUIView.backgroundColor = toColor
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        UIView.animate(withDuration: duration) {
                            self.backgroundUIView.backgroundColor = UIColor(cgColor: fromColor)
                        }
                    }
                } else {
                    self.backgroundUIView.backgroundColor = UIColor(cgColor: fromColor)
                }
            }
        }
        
        animateColorChange(from: UIColor.myGrayColor.cgColor, to: UIColor.myDarkGrayColor)
        animateColorChange(from: UIColor.myWhiteColor.cgColor, to: UIColor.myGrayColor)
    }
    
    func configure(with indexPath: Int) {
        if indexPath % 2 == 0 {
            containerView.layer.backgroundColor = UIColor.myGrayColor.cgColor
        } else {
            containerView.layer.backgroundColor = UIColor.myWhiteColor.cgColor
        }
    }
    
}

    
fileprivate extension UIColor {
    static let myGrayColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
    static let myWhiteColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    static let myDarkGrayColor = UIColor(red: 0.8, green: 0.815, blue: 0.83, alpha: 1)
}
    