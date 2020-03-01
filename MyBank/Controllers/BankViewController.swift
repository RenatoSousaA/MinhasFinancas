//
//  BankViewController.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import UIKit

class BankViewController: UIViewController {
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var ivImagem: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var banksManager = BanksManager.shared
    var bank: Bancos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBanks()
    }
    
    func loadBanks() {
        banksManager.loadBanks(with: context)
        tableView.reloadData()
    }
    
    func preencheCampos(bank: Bancos) {
        tfNome.text = bank.name
        if let image = bank.image as? UIImage {
            ivImagem.image = image
        } else {
            ivImagem.image = UIImage(named: "noBank")
        }
        
        btAddEdit.setTitle("ALTERAR BANCO", for: .normal)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    func limpar() {
        btAddEdit.setTitle("CADASTRAR BANCO", for: .normal)
        tfNome.text = ""
        ivImagem.image = UIImage(named: "noBank")
        bank = nil
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde quer escolher a imagem?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addEditBank(_ sender: UIButton) {
        if bank == nil {
            bank = Bancos(context: context)
        }
        
        bank.name = tfNome.text
        bank.image = ivImagem.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        limpar()
        self.loadBanks()
    }
    
    @IBAction func limpar(_ sender: UIButton) {
        limpar()
    }
    
}

extension BankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banksManager.banks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = banksManager.banks[indexPath.row]
        preencheCampos(bank: bank)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            banksManager.deleteBank(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BankTableViewCell

        let bank = banksManager.banks[indexPath.row]
        cell.prepare(with: bank)

        return cell
    }
}

extension BankViewController: UITableViewDelegate {
    
}

extension BankViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Erro: \(info)")
        }
        ivImagem.image = image
        dismiss(animated: true, completion: nil)
    }
}
