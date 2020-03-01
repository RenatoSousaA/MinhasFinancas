//
//  BanksManager.swift
//  MyBank
//
//  Created by Renato Sousa on 29/02/20.
//  Copyright © 2020 Renato Sousa. All rights reserved.
//

import CoreData

class BanksManager {
    static let shared = BanksManager()
    var banks: [Bancos] = []
    
    func loadBanks(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Bancos> = Bancos.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            banks = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteBank(index: Int, context: NSManagedObjectContext) {
        let bank = banks[index]
        context.delete(bank)
        do {
            banks.remove(at: index)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}
