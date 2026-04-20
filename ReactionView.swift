
import Foundation
import UIKit

final class ReactionView: UIView {

    var onSelect: ((String) -> Void)?
    var onPlusTapped: (() -> Void)?

    private let emojis = ["👍","❤️","😂","😮","👏","+"]

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 22
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12

        emojis.forEach { emoji in
           
            let button = UIButton(type: .system)
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 26)

            button.addAction(UIAction { [weak self] _ in
                
                if emoji == "+" {
                    self?.onPlusTapped?()
                } else {
                    self?.onSelect?(emoji)
                }
            }, for: .touchUpInside)

            stack.addArrangedSubview(button)
        }

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])
    }
}

