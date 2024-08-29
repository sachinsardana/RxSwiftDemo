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
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configuePostCell(post:PostModel) {
        self.title.text = post.title
        self.body.text = post.body
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
