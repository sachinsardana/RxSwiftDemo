//
//  PostTableViewCell.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import UIKit
import RxSwift

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.favoriteButton.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configuePostCell(post:PostModel) {
        self.title.text = post.title.capitalizingFirstLetter
        self.body.text = post.body.capitalizingFirstLetter
    }
    
    func updateFavoriteState(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
