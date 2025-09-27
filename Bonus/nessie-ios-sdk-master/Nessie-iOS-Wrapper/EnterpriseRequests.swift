//
//  EnterpriseRequests.swift
//  Nessie-iOS-Wrapper
//
//  Created by Lopez Vargas, Victor R. on 9/15/16.
//  Copyright (c) 2016 Nessie. All rights reserved.
//

import Foundation

protocol Enterprise {
    var id: String? { get }
    var urlName: String { get }
    func buildRequestUrl() -> String
}

extension Enterprise {
    func buildRequestUrl() -> String {
        var requestString = "\(baseEnterpriseString)\(urlName)"
        if let id = id {
            requestString += "/\(id)"
        }
        requestString += "?key=\(NSEClient.sharedInstance.getKey())"
        return requestString
    }
}

public struct EnterpriseAccountResponse: Decodable {
    public var results: [Account]
}

public struct EnterpriseAccountRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "accounts"
    
    public init () {}
    
    public func getAccounts() async throws -> EnterpriseAccountResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseAccountResponse = try JSONDecoder().decode(EnterpriseAccountResponse.self, from: data)
        return enterpriseAccountResponse
    }
    
    public mutating func getAccount(_ accountId: String) async throws -> Account? {
        self.id = accountId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let account = try JSONDecoder().decode(Account.self, from: data)
        return account
    }
}

public struct EnterpriseBillResponse: Decodable {
    public var results: [Bill]
}

public struct EnterpriseBillRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "bills"
    
    public init () {}
    
    public func getBills() async throws -> EnterpriseBillResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseBillResponse = try JSONDecoder().decode(EnterpriseBillResponse.self, from: data)
        return enterpriseBillResponse
    }
    
    public mutating func getBill(_ bilId: String) async throws -> Bill? {
        self.id = bilId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let bill = try JSONDecoder().decode(Bill.self, from: data)
        return bill
    }
}

public struct EnterpriseCustomerResponse: Decodable {
    public var results: [Customer]
}

public struct EnterpriseCustomerRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "customers"
    
    public init () {}
    
    public func getCustomers() async throws -> EnterpriseCustomerResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseCustomerRequest = try JSONDecoder().decode(EnterpriseCustomerResponse.self, from: data)
        return enterpriseCustomerRequest
    }
    
    public mutating func getCustomer(_ customerId: String) async throws -> Customer? {
        self.id = customerId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let customer = try JSONDecoder().decode(Customer.self, from: data)
        return customer
    }
}

public struct EnterpriseDepositResponse: Decodable {
    public var results: [Deposit]
}

public struct EnterpriseDepositRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "deposits"
    
    public init () {}
    
    public func getDeposits() async throws -> EnterpriseDepositResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseDepositRequest = try JSONDecoder().decode(EnterpriseDepositResponse.self, from: data)
        return enterpriseDepositRequest
    }
    
    public mutating func getDeposit(_ depositId: String) async throws -> Deposit? {
        self.id = depositId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let deposit = try JSONDecoder().decode(Deposit.self, from: data)
        return deposit
    }
}

public struct EnterpriseMerchantResponse: Decodable {
    public var results: [Merchant]
}

public struct EnterpriseMerchantRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "merchants"
    
    public init () {}
    
    public func getMerchants() async throws -> EnterpriseMerchantResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseMerchantResponse = try JSONDecoder().decode(EnterpriseMerchantResponse.self, from: data)
        return enterpriseMerchantResponse
    }
    
    public mutating func getMerchant(_ merchantId: String) async throws -> Merchant? {
        self.id = merchantId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let merchant = try JSONDecoder().decode(Merchant.self, from: data)
        return merchant
    }
}

public struct EnterpriseTransferResponse: Decodable {
    public var results: [Transfer]
}

public struct EnterpriseTransferRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "transfers"
    
    public init () {}
    
    public func getTransfers() async throws -> EnterpriseTransferResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseTransferResponse = try JSONDecoder().decode(EnterpriseTransferResponse.self, from: data)
        return enterpriseTransferResponse
    }
    
    public mutating func getTransfer(_ transferId: String) async throws -> Transfer? {
        self.id = transferId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let transfer = try JSONDecoder().decode(Transfer.self, from: data)
        return transfer
    }
}

public struct EnterpriseWithdrawalResponse: Decodable {
    public var results: [Withdrawal]
}

public struct EnterpriseWithdrawalRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "withdrawals"
    
    public init () {}
    
    public func getWithdrawals() async throws -> EnterpriseWithdrawalResponse? {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let enterpriseWithdrawalResponse = try JSONDecoder().decode(EnterpriseWithdrawalResponse.self, from: data)
        return enterpriseWithdrawalResponse
    }
    
    public mutating func getWithdrawal(_ withdrawalId: String) async throws -> Withdrawal? {
        self.id = withdrawalId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        guard let data = try await nseClient.loadDataFromURL(request) else { return nil }
        let withdrawal = try JSONDecoder().decode(Withdrawal.self, from: data)
        return withdrawal
    }
}
