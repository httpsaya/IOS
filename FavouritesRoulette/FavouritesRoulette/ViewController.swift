
import UIKit

struct Favorite {
    let title: String
    let description: String
    let image: String
}

let favorites: [Favorite] = [
    Favorite(
        title: "Alice in Wonderland",
        description: "A girl falls into a fantastical world.",
        image: "aliceinwonderland"),
    
    Favorite(
        title: "Anne with an E",
        description: "An orphan girl with a big imagination.",
        image: "annewith2e"),
    
    Favorite(
        title: "The Hunger Games",
        description: "A fight for survival in a deadly arena.",
        image: "hungergames"),
    
    Favorite(
        title: "La La Land",
        description: "A romantic musical story.",
        image: "lalaland"),
    
    Favorite(
        title: "The Maze Runner",
        description: "Teens must escape a deadly maze.",
        image: "mazerunner"),
    
    Favorite(
        title: "Me Before You",
        description: "A love story that changes two lives.",
        image: "mebeforeyou"),
    
    Favorite(
        title: "Mr. & Mrs. Smith",
        description: "A married couple of secret assassins.",
        image: "mrandmrssmith"),
    
    Favorite(
        title: "The Queen's Gambit",
        description: "A chess prodigy's rise and struggles.",
        image: "queensgambit"),
    
    Favorite(
        title: "The Last of Us",
        description: "Survival in a post-apocalyptic world.",
        image: "thelastofus"),
    
    Favorite(
        title: "Twilight",
        description: "A girl falls for a vampire.",
        image: "twilight")
]

class ViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var previousIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        posterImageView.contentMode = .scaleAspectFit
        descriptionLabel.numberOfLines = 0

        showFavorite(at: Int.random(in: 0..<favorites.count))
    }

    @IBAction func spinTapped(_ sender: UIButton) {
        guard favorites.count > 1 else { return }

        var newIndex = Int.random(in: 0..<favorites.count)

        while newIndex == previousIndex {
            newIndex = Int.random(in: 0..<favorites.count)
        }

        showFavorite(at: newIndex)
    }

    private func showFavorite(at index: Int) {
        let favorite = favorites[index]

        posterImageView.image = UIImage(named: favorite.image)
        titleLabel.text = favorite.title
        descriptionLabel.text = favorite.description

        previousIndex = index
    }
}
