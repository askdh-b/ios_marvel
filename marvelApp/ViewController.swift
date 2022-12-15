//
//  ViewController.swift
//  marvelApp
//
//  Created by user225687 on 12/14/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var canvasView: UIImageView!
    var characters = [Character(name: "Spider Man", image:  "spider_man.jpeg", color: Color(hex: 0xC13238)),
                      Character(name: "Captain America", image: "captain_america.jpeg", color: Color(hex: 0xE9EDEE)),
                      Character(name: "Loki", image: "loki.jpeg", color: Color(hex: 0xE89F30)),
                      Character(name: "Daredevil", image: "daredevil.jpeg", color: Color(hex: 0xA30F0F)),
                      Character(name: "Shang Chi", image: "shang_chi.jpeg", color: Color(hex: 0x5E0B15))]

    private var position = 0;
    private func changePosition(position: Int) {
        self.position = position
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(Color(hex: 0x2A272B, alpha: 0))
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        UIGraphicsBeginImageContext(CGSize.init(width: canvasView.bounds.width, height: canvasView.bounds.height))
        let c = UIGraphicsGetCurrentContext()
        c?.beginPath()
        c?.move(to: CGPoint.init(x: canvasView.bounds.width, y: 0))
        c?.addLine(to: CGPoint.init(x: canvasView.bounds.width, y: canvasView.bounds.height))
        c?.addLine(to: CGPoint.init(x: 0, y: canvasView.bounds.height))
        c?.closePath()
        c?.setFillColor(UIColor(characters[position].color).cgColor)
        c?.drawPath(using: CGPathDrawingMode.eoFill)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        canvasView.image = image
    }
}

struct Character {
    var name: String
    var image: String
    var color: Color
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! CharacterCollectionViewCell
        cell.photoView.image = UIImage(named: self.characters[indexPath.item].image)
        cell.nameView.text = self.characters[indexPath.item].name
        return cell
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = collectionView.frame
        return CGSize(width: screenSize.width - 12, height: screenSize.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            changePosition(position: indexPath?.item ?? 0)
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 08) & 0xFF) / 255,
                  blue: Double((hex >> 00) & 0xFF) / 255,
                  opacity: alpha)
    }
}
