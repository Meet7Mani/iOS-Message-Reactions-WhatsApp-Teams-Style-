import UIKit
class EmojiPickerView: UIView {

    var onEmojiSelected: ((String) -> Void)?

    private let emojis = ["😀","😂","😍","🥹","😎","🔥","👏","👍","❤️","😢","😮","🎉"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {

        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
extension EmojiPickerView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
        cell.label.text = emojis[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.row]
        onEmojiSelected?(emoji)
    }
}


class EmojiCell: UICollectionViewCell {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .center

        contentView.addSubview(label)
        label.frame = contentView.bounds
    }

    required init?(coder: NSCoder) { fatalError() }
}
