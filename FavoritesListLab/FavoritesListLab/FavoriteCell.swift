import UIKit

final class FavoriteCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var star1: UIImageView!
    @IBOutlet private weak var star2: UIImageView!
    @IBOutlet private weak var star3: UIImageView!
    @IBOutlet private weak var star4: UIImageView!
    @IBOutlet private weak var star5: UIImageView!

    func configure(with item: FavoriteItem) {
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        for (index, imageView) in [star1, star2, star3, star4, star5].enumerated() {
            imageView?.image = UIImage(
                systemName: index < item.rating ? "star.fill" : "star"
            )
        }
    }
}
