//
//  CoreDataFunctionalityProtocol.swift
//  Currency
//
//  Created by Zyad Galal on 26/02/2022.
//

import Foundation
import CoreData

protocol CoreDataFunctionality {
    func checkIfExist(date: String) -> Bool
    func fetchStoredData(with date: String) -> CurrencyModel?
    func createRateEntityFrom(date: String, dictionary: [String: Double]) -> NSManagedObject?
    func saveInCoreData()
}

extension CoreDataFunctionality {
    func checkIfExist(date: String) -> Bool{
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoricalRates")
        fetchRequest.predicate = NSPredicate(format: "date CONTAINS[cd] %@", date)
        fetchRequest.fetchLimit = 1
        
        let res = try! context.fetch(fetchRequest)
        
        return res.count > 0 ? true : false
    }
    

    func fetchStoredData(with date: String) -> CurrencyModel? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let predicate = NSPredicate(format: "date CONTAINS[cd] %@", date)
        let request: NSFetchRequest<HistoricalRates> = HistoricalRates.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do{
            let fetchedData = try context.fetch(request)
            guard let fetchedRate = fetchedData.first?.rate else {return nil}
            guard let data = try? JSONDecoder().decode([String: Double].self, from: fetchedRate) else {return nil}
            let rates = CurrencyModel(success: true, timestamp: nil, base: "EUR", date: date, rates: data, error: nil)
            return rates
        } catch {
            let rates = CurrencyModel(success: false, timestamp: nil, base: nil, date: nil, rates: nil, error: ErrorModel(code: nil, info: error.localizedDescription))
            return rates
        }
    }
    
    func createRateEntityFrom(date: String, dictionary: [String: Double]) -> NSManagedObject? {
        if checkIfExist(date: date) {
            print("sorry cant add it right now")
            return nil
        }
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let rateEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoricalRates", into: context) as? HistoricalRates {
            guard let rate = try? JSONEncoder().encode(dictionary)  else {return nil}
            rateEntity.date = date
            rateEntity.rate = rate
        
            return rateEntity
        }
        return nil
    }
    func saveInCoreData() {
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}
