//
//  TableViewController.swift
//  MovinViewsIn_Example
//
//  Created by Vanessa Petrosky on 11/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MovinViewsIn

class TableViewController: UITableViewController {
    
    private static let CellIdentifier: String = "Puppy Cell"
    private static let PuppySegue: String = "Puppy Detail Segue"
    
    private var selectedImageView: UIImageView?
    private var selectedCell: UITableViewCell?
    private var selectedPuppyFrame: CGRect?
    
    private var transitionManager: TransitionManager?
    private var contentOffset: CGPoint?
    
    let puppies: [UIImage] = [UIImage(named: "puppy1"),
                              UIImage(named: "puppy2"),
                              UIImage(named: "puppy3"),
                              UIImage(named: "puppy4"),
                              UIImage(named: "puppy5"),
                              UIImage(named: "puppy6")].compactMap({$0})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.tableFooterView = nil
        automaticallyAdjustsScrollViewInsets = false
        
        modalPresentationStyle = .custom
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TableViewController.PuppySegue,
            let modalVC = segue.destination as? ModalViewController,
            let selectedImageView = selectedImageView {
            
            transitionManager = TransitionManager(originViewController: self, destinationViewController: modalVC, transitionImageView: selectedImageView)
            modalVC.transitioningDelegate = transitionManager
            modalVC.modalDelegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puppies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.CellIdentifier, for: indexPath) as! PuppyCell
        let puppyImage = puppies[indexPath.row]
        cell.configureCell(withPuppyImage: puppyImage)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PuppyCell,
            let imageView = cell.puppyImageView else { return }
        
        selectedImageView = imageView
        selectedCell = cell
        
        /* In order to get the correct frame for the selected imageView, subtract the tableView's yOffset
         from the y-coordinate of the origin of the cell's frame */
        let cellRect = tableView.rectForRow(at: indexPath)
        let yOffset = tableView.contentOffset.y
        selectedPuppyFrame = CGRect(x: cellRect.origin.x, y: cellRect.origin.y - yOffset, width: cellRect.width, height: cellRect.height)
        
        performSegue(withIdentifier: TableViewController.PuppySegue, sender: nil)
    }
}

extension TableViewController: ImageTransitionable {
    var transitioningImageView: UIImageView {
        return selectedImageView ?? UIImageView()
    }
    
    var transitioningImageViewFrame: CGRect {
        guard let selectedPuppyFrame = selectedPuppyFrame else { return CGRect.zero }
        return selectedPuppyFrame
    }
}

extension TableViewController: ModalDelegate {
    func modalViewControllerDidClose(_ modalVC: ModalViewController) {
        dismiss(animated: true, completion: nil)
    }
}
