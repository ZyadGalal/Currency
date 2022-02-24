//
//  DetailsRepository.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData

class DetailsRepository {
    let networkClient: NetworkClient

    init (networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getHistoricalData(at date: String) -> Observable<CurrencyModel> {
        Observable<CurrencyModel>.create { [weak self] (item) -> Disposable in
            if self!.checkIfExist(date: date) {
                if let rates = self?.fetchStoredData(with: date) {
                    DispatchQueue.main.async {
                        item.onNext(rates)
                        item.onCompleted()
                    }
                }
            }
            else {
                self?.fetchHistoricalRatesFromAPI(date: date) {[weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let response):
                        if response.success == true {
                            if let _ = self.createRateEntityFrom(date: date, dictionary: response.rates!) {
                                self.saveInCoreData()
                                item.onNext(response)
                            } else {
                                item.onError(CustomError.APIError(message: "can't save data"))
                            }
                        } else {
                            if response.error?.code == 104 {
                                self.networkClient.cancelRequests()
                            }
                            item.onError(CustomError.APIError(message: (response.error?.info)!))
                        }
                    case .failure(let error):
                        item.onError(error)
                    }
                }
            }
                return Disposables.create()
        }
        
    }
    
    private func fetchHistoricalRatesFromAPI (date: String, completion: @escaping ((Result<CurrencyModel, Error>) -> Void)) {
        networkClient.performRequest(CurrencyModel.self, router: .historicalRates(date: date), completion: completion)
    }
    
    private func checkIfExist(date: String) -> Bool{
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoricalRates")
        fetchRequest.predicate = NSPredicate(format: "date CONTAINS[cd] %@", date)
        fetchRequest.fetchLimit = 1
        
        let res = try! context.fetch(fetchRequest)
        
        return res.count > 0 ? true : false
    }

    private func fetchStoredData(with date: String) -> CurrencyModel? {
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
    
    private func createRateEntityFrom(date: String, dictionary: [String: Double]) -> NSManagedObject? {
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
    private func saveInCoreData() {
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

}
