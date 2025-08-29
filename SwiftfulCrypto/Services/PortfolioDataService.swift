//
//  PortfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/12/25.
//

//This file does all the logic for getting a user's portfolio data
//The difference between this data service and the other services is that
//the other service files' endpoint is going to an API. This one goes
//to CoreData
import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    //name of the container we set up as an entity...
    //see PortfolioContainer on the Project Navigator
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    public func updatePortfolio(coin: CoinModel, amount: Double) {
        //check if coin is already in portfolio, if it exists and amount
        //is nonzero, update it. If coin exists in portfolio but amount is 0,
        //then delete it
        if let entity = savedEntities.first(where: { (savedEntity) -> Bool in
            return savedEntity.coinID == coin.id
        }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            }
            else {
                //amount is 0 so delete entity
                delete(entity: entity)
            }
            
        } else {
            //no coin in portfolio entity, add the coin to the entity
            add(coin: coin, amount: amount)
        }
    }
        
    // MARK: PRIVATE
    
    private func getPortfolio() {
        //if we don't specify a specific result type, we get a compiler error:
        //Generic parameter 'ResultType' could not be inferred
        //so need to add <AddTypeTryingToFetch>
        //create a fetch request
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
        
    }
    
    //this add coin creates a new entity every time
    private func add(coin: CoinModel, amount: Double) {
        //create a PortfolioEntity
        
        //after we add the entity to the view context
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    //but what if we had an entity already, then just update the entity
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()//save the portfolio entity into the viewContext
        getPortfolio()//fetch back the updated portfolio entities
    }
    
    
}
