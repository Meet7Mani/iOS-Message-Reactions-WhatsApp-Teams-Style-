import Foundation
import UIKit

final class ReactionCapsuleView: UIView {

    var onTap: (() -> Void)?

    init(reaction: Reaction, currentUserId: Int) {
        super.init(frame: .zero)

        let label = UILabel()
        label.text = "\(reaction.emoji) \(reaction.count)"
        label.font = .systemFont(ofSize: 13, weight: .medium)

        let isSelected = reaction.isReacted(by: currentUserId)

        backgroundColor = isSelected
            ? UIColor.systemBlue.withAlphaComponent(0.2)
            : UIColor.systemGray5

        layer.cornerRadius = 14

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        onTap?()
    }

    required init?(coder: NSCoder) { fatalError() }
}

