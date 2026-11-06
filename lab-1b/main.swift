import Foundation

// create acc
let account = BankAccount(initialBalance: 1000)

print("       BANK ACCOUNT    ")

// show bank
print("Bank:", account.bankName)

// deposit
account.deposit(amount: 500)

// withdraw
account.withdraw(amount: 200)

// invalid depo
account.deposit(amount: -100)

// invalid withdrawal
account.withdraw(amount: 2000)

// show balance
account.showBalance()

// show bank deats
showDetails(account: account)

// show trans his
print("Transaction History:")

for item in account.history {
    print(item)
}

// invalid acc test
let account2 = BankAccount(initialBalance: -500)
