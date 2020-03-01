//
//  ContasTableViewController.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import UIKit
import CoreData

class ContasTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Contas>!
    var label = UILabel()
    var productSelected: NSFetchRequest<Contas> = Contas.fetchRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Nenhuma conta cadastrada!"
        label.textAlignment = .center
        loadContas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        loadContas()
    }
    
    func loadContas() {
        let fetchRequest: NSFetchRequest<Contas> = Contas.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "addConta" {
            let vc = segue.destination as! ContaViewController
            if let conta = fetchedResultController.fetchedObjects {
                vc.conta = conta[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        tableView.separatorStyle = count == 0 ? .none : .singleLine
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContasTableViewCell
        
        guard let conta = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: conta)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let contaSelected = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(contaSelected)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let conta = fetchedResultController.fetchedObjects?[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Compartilhar", handler: { (action, view, completionHandler) in
            let tipo = conta?.tipo == 0 ? "Conta corrente" : "Conta poupança"
            
            let text = "Conta do banco \(conta?.banco?.name ?? "")\nNome: \(conta?.nome ?? "")\nCPF: \(conta?.cpf ?? "")\nAg: \(conta?.agencia ?? "")\nCc: \(conta?.conta ?? "")\nTipo: \(tipo)"

            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view

            self.present(activityViewController, animated: true, completion: nil)
        })
        action.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

}

extension ContasTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                break
            default:
                tableView.reloadData()
        }
    }
}
