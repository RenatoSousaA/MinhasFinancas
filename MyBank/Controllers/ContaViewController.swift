//
//  ContaViewController.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import UIKit

class ContaViewController: UIViewController {
    @IBOutlet weak var tfBanco: UITextField!
    @IBOutlet weak var scTipoConta: UISegmentedControl!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfCPF: UITextField!
    @IBOutlet weak var tfAgencia: UITextField!
    @IBOutlet weak var tfConta: UITextField!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var banksManager = BanksManager.shared
    var conta: Contas!
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfBanco.inputView = pickerView
        tfBanco.inputAccessoryView = toolbar
    }
    
    @objc func cancel() {
        tfBanco.resignFirstResponder()
    }
    
    @objc func done() {
        tfBanco.text = banksManager.banks[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        banksManager.loadBanks(with: context)
        title = "Cadastrar conta"
        loadConta()
    }
        
    func loadConta() {
        if conta != nil {
            tfNome.text = conta.nome
            tfCPF.text = conta.cpf
            tfConta.text = conta.conta
            tfAgencia.text = conta.agencia
            scTipoConta.selectedSegmentIndex = Int(conta.tipo)
            
            if let bankSelected = conta.banco, let index = banksManager.banks.firstIndex(of: bankSelected) {
                tfBanco.text = conta.banco?.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }

            title = "Alterar conta"
            btAddEdit.setTitle("ALTERAR", for: .normal)
        }
    }

    @IBAction func addEditConta(_ sender: UIButton) {
        if conta == nil {
            conta = Contas(context: context)
        }
        
        conta.nome = tfNome.text
        conta.cpf = tfCPF.text
        conta.agencia = tfAgencia.text
        conta.conta = tfConta.text
        conta.tipo = Int16(scTipoConta.selectedSegmentIndex)
        
        if !tfBanco.text!.isEmpty {
            conta.banco = banksManager.banks[pickerView.selectedRow(inComponent: 0)]
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension ContaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return banksManager.banks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let bank = banksManager.banks[row]
        return bank.name ?? ""
    }
}


