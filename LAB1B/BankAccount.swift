import Foundation

class BankAccount {

    // Private variable
    private var balance: Double

    // Public read-only transaction history
    public private(set) var history: [String] = []

    // Internal variable
    internal let bankName = "SBI Bank"

    // Constructor
    init(initialBalance: Double) {

        if initialBalance < 0 {
            balance = 0
            print("Invalid Account Balance")
        }
        else {
            balance = initialBalance
        }
    }

    // Public deposit function
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

    // Public withdraw function
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

    // Public function to show balance
    public func showBalance() {
        print("Current Balance:", balance)
    }

    // Fileprivate function
    fileprivate func showBank() {
        print("Bank Name:", bankName)
    }
}

// Accessing fileprivate function in same file
func showDetails(account: BankAccount) {
    account.showBank()
}
