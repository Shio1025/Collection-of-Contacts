//
//  ViewController.swift
//  Project5
//
//  Created by shio birbichadze on 1/14/22.
//  Copyright © 2022 shio birbichadze. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var collectionView:UICollectionView!
    
    var context=DBManager.shared.persistentContainer.viewContext
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
        
        
    }()
    
    
    var contacts = [Contact]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UINib(nibName: "ContactInfo", bundle: nil), forCellWithReuseIdentifier: "ContactInfo")
        
        collectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress)
            )
        )
        
        fetchPeople()
    }
    
    func fetchPeople(){
        let request=Contact.fetchRequest() as NSFetchRequest<Contact>
        
        do{
            contacts = try context.fetch(request)
            collectionView.reloadData()
        }catch{
            fatalError("Failed to fetch contacts: \(error)")
        }
    }
    
    
    
    @IBAction func add(){
        let alert = UIAlertController(title: "Add Contact", message: nil, preferredStyle: .alert)
        
        var name:UITextField?
        var num:UITextField?
        alert.addTextField{ textField in
            textField.placeholder="Contact Name"
            name=textField
        }
        
        alert.addTextField{textField in
            textField.placeholder="Contact Number"
            textField.keyboardType = .phonePad
            num=textField
            
        }
        alert.addAction(
            UIAlertAction(title: "Cancel",
                          style: .cancel,
                          handler: nil)
        )
        alert.addAction(
            UIAlertAction(title: "Save",
                          style: .default,
                          handler: {  [self] _ in
                            
                            guard let name = name?.text else { return }
                            guard let num = num?.text else { return }
                            
                            let p=Contact(context: self.context)
                            p.name=name
                            p.number=num
                            
                            do{
                                try self.context.save()
                                self.fetchPeople()
                            }catch{}
            })
        )
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        
        
        let location=gesture.location(in: collectionView)
        if let indexPath=collectionView.indexPathForItem(at: location){
            if collectionView.cellForItem(at: indexPath) != nil{
                self.delete(indexPath:indexPath)
            }
        
        }
    }
    
    func delete(indexPath:IndexPath){
        
        let person=contacts[indexPath.row]

        let alert = UIAlertController(title: "Delete Contact?", message: "Contact "+person.name!+" will be deleted", preferredStyle: .alert)
        
        
        
        alert.addAction(
            UIAlertAction(title: "Cancel",
                          style: .cancel,
                          handler: nil)
        )
        alert.addAction(
            UIAlertAction(title: "Delete",
                          style: .destructive,
                          handler: {  [self] _ in
                            
                            self.context.delete(person)
//                            self.collectionView.deleteItems(at: [indexPath] )
                            
                            
                            do{
                                try self.context.save()
                                self.fetchPeople()
                            }catch{}
            })
        )
        
        present(alert, animated: true, completion: nil)
        
        
        
    }


}

extension ViewController: UICollectionViewDelegate{
    

    
}

extension ViewController:UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let cell=cell as?ContactInfo{
//            cell.content.layer.borderColor = UIColor.gray.cgColor
//            cell.content.layer.cornerRadius=cell.content.bounds.width/12
//            cell.content.layer.masksToBounds=true
//            cell.content.layer.borderWidth = 0.5
//
//            cell.circle.layer.cornerRadius=cell.circle.bounds.width/2
//            cell.circle.layer.masksToBounds=true
//        }
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactInfo", for: indexPath)
        if let ContactInfo=cell as? ContactInfo{
            let p = contacts[indexPath.row]
            ContactInfo.content.layer.borderColor = UIColor.gray.cgColor
            ContactInfo.content.layer.borderWidth = 0.5
            
            ContactInfo.circle.backgroundColor = .random
            
            ContactInfo.number.text=p.number
            
            let f=p.name!.uppercased()
            var t1:String=""
            var t2:String=""
            var space=100
            for (index, char) in f.enumerated() {
                if index==0{
                    t1=String(char)
                }
                if char==" "{
                    space=index
                }
                if(index==space+1){
                    t2=String(char)
                    break
                }
                
                
            }
            var name=""
            for (_, char) in p.name!.enumerated() {
                if char==" "{
                    break
                }
                name=name+String(char)
                
                
            }
            
            ContactInfo.title.text!=t1+t2
            ContactInfo.name.text!=name
                    
                
            
        }
        
        return cell
    }
    
    
    
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left:self.view.bounds.size.width*0.04 , bottom: 0, right: self.view.bounds.size.width*0.04)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width*0.28, height: self.view.bounds.size.height*0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    
}

extension UIColor {
    
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
    
}
