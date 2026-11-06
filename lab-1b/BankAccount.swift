import Foundation

class BankAccount {

    // private variable
    private var balance: Double

    // Public read-only transaction history
    public private(set) var history: [String] = []

    // internal variable
    internal let bankName = "SBI Bank"

    // constructor
    init(initialBalance: Double) {

        if initialBalance < 0 {
            balance = 0
            print("Invalid Account Balance")
        }
        else {
            balance = initialBalance
        }
    }

    // pub depos func
    public func deposit(amount: Double) {

        if amount > 0 {
            balance = balance + amount
            history.append("Deposited \(amount)")
            print("Money Deposited:", amount)
        }
        else {
            print("Invalid Deposit Amount")
        }
    }

    // Pub withdraw func
    public func withdraw(amount: Double) {

        if amount <= 0 {
            print("Invalid Withdrawal Amount")
        }
        else if amount > balance {
            print("Insufficient Balance")
        }
        else {
            balance = balance - amount
            history.append("Withdrawn \(amount)")
            print("Money Withdrawn:", amount)
        }
    }

    // pub func to show balance
    public func showBalance() {
        print("Current Balance:", balance)
    }

    // fileprivate func
    fileprivate func showBank() {
        print("Bank Name:", bankName)
    }
}

// access fileprivate func in same file
func showDetails(account: BankAccount) {
    account.showBank()
}
