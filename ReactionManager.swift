
import Foundation
import UIKit

struct Reaction {
    let emoji: String
    var userIds: Set<Int>

    var count: Int {
        return userIds.count
    }

    func isReacted(by userId: Int) -> Bool {
        return userIds.contains(userId)
    }
}

final class ReactionManager {

    static let shared = ReactionManager()

    private var overlayView: UIView?
    private var blurView: UIVisualEffectView?
    private var isShowing = false
    private init() {}

    // MARK: - SHOW OVERLAY

    func show(
        from cell: UITableViewCell,
        in parentView: UIView,
        selection: @escaping (String) -> Void
    ) {

        if isShowing { return }
        isShowing = true
        dismiss()

        // Blur
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = parentView.bounds
        blur.alpha = 0
        parentView.addSubview(blur)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        blur.addGestureRecognizer(tap)

        self.blurView = blur

        // Reaction View
        let reactionView = ReactionView()
        reactionView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(reactionView)
        reactionView.backgroundColor = .red
        self.overlayView = reactionView

        let cellFrame = cell.convert(cell.bounds, to: parentView)

        NSLayoutConstraint.activate([
            reactionView.bottomAnchor.constraint(equalTo: parentView.topAnchor, constant: cellFrame.minY - 8),
            reactionView.centerXAnchor.constraint(equalTo: parentView.leadingAnchor, constant: cellFrame.midX)
        ])

        reactionView.onSelect = { [weak self] emoji in
            selection(emoji)
            self?.dismiss()
        }

        // Animation
        reactionView.alpha = 0
        reactionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.25) {
            blur.alpha = 0.4
            reactionView.alpha = 1
            reactionView.transform = .identity
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    @objc private func handleDismiss() {
        dismiss()
    }

    func dismiss() {

        isShowing = false

        UIView.animate(withDuration: 0.2, animations: {
            self.blurView?.alpha = 0
            self.overlayView?.alpha = 0
        }) { _ in
            self.blurView?.removeFromSuperview()
            self.overlayView?.removeFromSuperview()
            self.blurView = nil
            self.overlayView = nil
        }
    }

    // MARK: - TOGGLE (FIXED)

    func toggleReaction(
        emoji: String,
        message: MessageTextModel,
        currentUserId: Int
    ) -> MessageTextModel {

        var message = message

        if message.reactions == nil {
            message.reactions = []
        }

        guard var reactions = message.reactions else { return message }

        if let index = reactions.firstIndex(where: { $0.emoji == emoji }) {

            if reactions[index].userIds.contains(currentUserId) {
                reactions[index].userIds.remove(currentUserId)

                if reactions[index].userIds.isEmpty {
                    reactions.remove(at: index)
                }
            } else {
                reactions[index].userIds.insert(currentUserId)
            }

        } else {
            reactions.append(Reaction(emoji: emoji, userIds: [currentUserId]))
        }

        message.reactions = reactions
        return message
    }
}

class ReactionListView: UIView {

    private let stackView = UIStackView()

    public var onReactionTap: ((String) -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .leading

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure( with reactions: [Reaction], currentUserId: Int) {
     
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for reaction in reactions {
            
            let capsule = ReactionCapsuleView(reaction: reaction, currentUserId: currentUserId)

            capsule.onTap = { [weak self] in
                
                self?.onReactionTap?(reaction.emoji)
            }

            stackView.addArrangedSubview(capsule)
        }

        isHidden = reactions.isEmpty
    }
}
