import Foundation

// Creating bank account
let account = BankAccount(initialBalance: 1000)

print("----- BANK ACCOUNT -----")

// Showing bank name
print("Bank:", account.bankName)

// Deposit money
account.deposit(amount: 500)

// Withdraw money
account.withdraw(amount: 200)

// Invalid deposit
account.deposit(amount: -100)

// Invalid withdrawal
account.withdraw(amount: 2000)

// Show current balance
account.showBalance()

// Show bank details
showDetails(account: account)

// Show transaction history
print("Transaction History:")

for item in account.history {
    print(item)
}

// Invalid account test
let account2 = BankAccount(initialBalance: -500)
